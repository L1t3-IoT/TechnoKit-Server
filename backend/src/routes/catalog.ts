import type { FastifyPluginAsync } from 'fastify';
import { and, asc, desc, eq, gte, ilike, lte, or, sql, count } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../db/index.js';
import { categories, products } from '../db/schema.js';

const query = z.object({
  category: z.string().optional(),
  q: z.string().trim().max(100).optional(),
  cells: z.string().regex(/^\d{1,2}(,\d{1,2})*$/).optional(), // 4S / 6S / 8S, напр. "4,6"
  minPrice: z.coerce.number().min(0).optional(), // у гривнях/доларах, не в центах
  maxPrice: z.coerce.number().min(0).optional(),
  inStock: z.enum(['true', 'false']).optional(),
  sort: z.enum(['recommended', 'price_asc', 'price_desc', 'name']).default('recommended'),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(60).default(12),
});

export const catalogRoutes: FastifyPluginAsync = async (app) => {
  app.get('/categories', async () => {
    const rows = await db
      .select({ id: categories.id, slug: categories.slug, name: categories.name, count: count(products.id) })
      .from(categories)
      .leftJoin(products, eq(products.categoryId, categories.id))
      .groupBy(categories.id)
      .orderBy(asc(categories.sortOrder));
    return { items: rows };
  });

  app.get('/products', async (req, reply) => {
    const parsed = query.safeParse(req.query);
    if (!parsed.success) return reply.code(400).send({ error: 'Некоректні параметри', details: parsed.error.flatten() });
    const p = parsed.data;

    const where = and(
      p.category ? eq(products.categoryId, sql`(select id from categories where slug = ${p.category})`) : undefined,
      p.q
        ? or(
            ilike(products.name, `%${p.q.replace(/[%_]/g, '\\$&')}%`),
            ilike(products.sku, `%${p.q.replace(/[%_]/g, '\\$&')}%`),
            ilike(products.brand, `%${p.q.replace(/[%_]/g, '\\$&')}%`),
          )
        : undefined,
      p.cells ? or(...p.cells.split(',').map((c) => sql`${products.specs} -> 'cells' @> ${JSON.stringify(Number(c))}::jsonb`)) : undefined,
      p.minPrice !== undefined ? gte(products.priceCents, Math.round(p.minPrice * 100)) : undefined,
      p.maxPrice !== undefined ? lte(products.priceCents, Math.round(p.maxPrice * 100)) : undefined,
      p.inStock === 'true' ? eq(products.inStock, true) : undefined,
    );

    const order = {
      recommended: asc(products.id),
      price_asc: asc(products.priceCents),
      price_desc: desc(products.priceCents),
      name: asc(products.name),
    }[p.sort];

    const [items, [{ total }]] = await Promise.all([
      db.select().from(products).where(where).orderBy(order).limit(p.limit).offset((p.page - 1) * p.limit),
      db.select({ total: count() }).from(products).where(where),
    ]);

    return { items, total, page: p.page, limit: p.limit };
  });

  app.get('/products/:id', async (req, reply) => {
    const id = z.coerce.number().int().safeParse((req.params as { id: string }).id);
    if (!id.success) return reply.code(400).send({ error: 'Некоректний id' });
    const [row] = await db.select().from(products).where(eq(products.id, id.data));
    if (!row) return reply.code(404).send({ error: 'Деталь не знайдено' });
    return row;
  });
};
