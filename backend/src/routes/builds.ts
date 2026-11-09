import type { FastifyPluginAsync } from 'fastify';
import { and, eq, getTableColumns, sql } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../db/index.js';
import { buildItems, builds, categories, products } from '../db/schema.js';
import { requireUser } from '../lib/session.js';

const idParam = z.object({ id: z.string().uuid() });
const nameBody = z.object({ name: z.string().trim().min(1).max(80) });
const itemsBody = z.object({
  items: z.array(z.object({ productId: z.number().int(), quantity: z.number().int().min(1).max(99) })).max(50),
});

export const buildRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireUser);

  app.get('/', async (req) => {
    const rows = await db
      .select({
        id: builds.id, name: builds.name, createdAt: builds.createdAt,
        itemCount: sql<number>`coalesce(sum(${buildItems.quantity}), 0)::int`,
        totalCents: sql<number>`coalesce(sum(${buildItems.quantity} * ${products.priceCents}), 0)::int`,
      })
      .from(builds)
      .leftJoin(buildItems, eq(buildItems.buildId, builds.id))
      .leftJoin(products, eq(products.id, buildItems.productId))
      .where(eq(builds.userId, req.user!.id))
      .groupBy(builds.id)
      .orderBy(builds.createdAt);
    return { items: rows };
  });

  app.post('/', async (req, reply) => {
    const body = nameBody.safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Вкажіть назву збірки' });
    const [row] = await db.insert(builds).values({ userId: req.user!.id, name: body.data.name }).returning();
    return reply.code(201).send(row);
  });

  app.get('/:id', async (req, reply) => {
    const { id } = idParam.parse(req.params);
    const [build] = await db.select().from(builds).where(and(eq(builds.id, id), eq(builds.userId, req.user!.id)));
    if (!build) return reply.code(404).send({ error: 'Збірку не знайдено' });
    const items = await db
      .select({ quantity: buildItems.quantity, product: { ...getTableColumns(products), categorySlug: categories.slug } })
      .from(buildItems)
      .innerJoin(products, eq(products.id, buildItems.productId))
      .innerJoin(categories, eq(categories.id, products.categoryId))
      .where(eq(buildItems.buildId, id));
    return { ...build, items };
  });

  // Повна заміна складу збірки (простіше для фронтенду, ніж add/remove по одному)
  app.put('/:id/items', async (req, reply) => {
    const { id } = idParam.parse(req.params);
    const body = itemsBody.safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Некоректний список деталей' });
    const [build] = await db.select({ id: builds.id }).from(builds)
      .where(and(eq(builds.id, id), eq(builds.userId, req.user!.id)));
    if (!build) return reply.code(404).send({ error: 'Збірку не знайдено' });

    try {
      await db.transaction(async (tx) => {
        await tx.delete(buildItems).where(eq(buildItems.buildId, id));
        if (body.data.items.length) {
          await tx.insert(buildItems).values(body.data.items.map((i) => ({ ...i, buildId: id })));
        }
      });
    } catch {
      return reply.code(400).send({ error: 'Невідома деталь або дублікати у списку' });
    }
    return { ok: true };
  });

  app.patch('/:id', async (req, reply) => {
    const { id } = idParam.parse(req.params);
    const body = nameBody.safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Вкажіть назву збірки' });
    const res = await db.update(builds).set({ name: body.data.name })
      .where(and(eq(builds.id, id), eq(builds.userId, req.user!.id))).returning({ id: builds.id });
    if (!res.length) return reply.code(404).send({ error: 'Збірку не знайдено' });
    return { ok: true };
  });

  app.delete('/:id', async (req, reply) => {
    const { id } = idParam.parse(req.params);
    const res = await db.delete(builds).where(and(eq(builds.id, id), eq(builds.userId, req.user!.id))).returning({ id: builds.id });
    if (!res.length) return reply.code(404).send({ error: 'Збірку не знайдено' });
    return { ok: true };
  });
};
