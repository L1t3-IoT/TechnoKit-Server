import type { FastifyPluginAsync } from 'fastify';
import { and, asc, desc, eq, getTableColumns, gte, ilike, lte, or, sql, count } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../db/index.js';
import { categories, drones, products } from '../db/schema.js';

const query = z.object({
  category: z.string().optional(),
  q: z.string().trim().max(100).optional(),
  brand: z.string().trim().max(60).optional(),
  propInch: z.coerce.number().min(1).max(15).optional(), // розмір пропелера/рами, напр. 5
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
      p.brand ? ilike(products.brand, p.brand) : undefined,
      p.propInch !== undefined
        ? or(
            sql`(${products.specs} ->> 'diameter_inch')::float between ${p.propInch - 0.5} and ${p.propInch + 0.5}`,
            sql`(${products.specs} ->> 'max_prop_inch')::float between ${p.propInch} and ${p.propInch + 0.5}`,
            sql`${products.specs} -> 'prop_inch_range' @> ${JSON.stringify(p.propInch)}::jsonb`,
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
      db.select({ ...getTableColumns(products), categorySlug: categories.slug }).from(products)
        .innerJoin(categories, eq(categories.id, products.categoryId))
        .where(where).orderBy(order).limit(p.limit).offset((p.page - 1) * p.limit),
      db.select({ total: count() }).from(products).where(where),
    ]);

    return { items, total, page: p.page, limit: p.limit };
  });

  app.get('/products/:id', async (req, reply) => {
    const id = z.coerce.number().int().safeParse((req.params as { id: string }).id);
    if (!id.success) return reply.code(400).send({ error: 'Некоректний id' });
    const [row] = await db.select({ ...getTableColumns(products), categorySlug: categories.slug }).from(products)
      .innerJoin(categories, eq(categories.id, products.categoryId)).where(eq(products.id, id.data));
    if (!row) return reply.code(404).send({ error: 'Деталь не знайдено' });
    return row;
  });

  app.get('/brands', async () => {
    const rows = await db.selectDistinct({ brand: products.brand }).from(products).orderBy(asc(products.brand));
    return { items: rows.map((r) => r.brand).filter(Boolean) };
  });

  // Лічильники для головної сторінки
  app.get('/stats', async () => {
    const [[{ n }], [{ c }], [{ d }], cellRows] = await Promise.all([
      db.select({ n: count() }).from(products),
      db.select({ c: count() }).from(categories),
      db.select({ d: count() }).from(drones),
      db.execute(sql`select count(distinct v)::int as n from products, jsonb_array_elements_text(specs -> 'cells') v where category_id = (select id from categories where slug = 'batteries')`),
    ]);
    return { products: n, categories: c, drones: d, voltages: (cellRows.rows[0] as { n: number }).n };
  });
};
