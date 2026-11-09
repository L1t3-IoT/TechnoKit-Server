import type { FastifyPluginAsync } from 'fastify';
import { and, asc, eq, getTableColumns, sql } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../db/index.js';
import { categories, droneParts, drones, products } from '../db/schema.js';
import { checkBuild } from '../lib/compat.js';

export const droneRoutes: FastifyPluginAsync = async (app) => {
  app.get('/drones', async (req) => {
    const q = z.object({ segment: z.string().optional(), kind: z.enum(['model', 'reference']).optional() }).parse(req.query);
    const rows = await db.select({
      ...getTableColumns(drones),
      partCount: sql<number>`(select count(*)::int from drone_parts dp where dp.drone_id = drones.id)`,
      totalCents: sql<number>`coalesce((select sum(dp.quantity * p.price_cents)::int from drone_parts dp join products p on p.id = dp.product_id where dp.drone_id = drones.id), 0)`,
    }).from(drones)
      .where(and(q.segment ? eq(drones.segment, q.segment) : undefined, q.kind ? eq(drones.kind, q.kind) : undefined))
      .orderBy(asc(drones.sortOrder));
    return { items: rows };
  });

  app.get('/drones/:slug', async (req, reply) => {
    const { slug } = z.object({ slug: z.string().max(100) }).parse(req.params);
    const [drone] = await db.select().from(drones).where(eq(drones.slug, slug));
    if (!drone) return reply.code(404).send({ error: 'Дрон не знайдено' });
    const parts = await db.select({ quantity: droneParts.quantity, product: { ...getTableColumns(products), categorySlug: categories.slug } })
      .from(droneParts).innerJoin(products, eq(products.id, droneParts.productId))
      .innerJoin(categories, eq(categories.id, products.categoryId)).where(eq(droneParts.droneId, drone.id));
    const report = parts.length
      ? checkBuild(parts.map((p) => ({ id: p.product.id, sku: p.product.sku, name: p.product.name, brand: p.product.brand, category: p.product.categorySlug, priceCents: p.product.priceCents, quantity: p.quantity, specs: p.product.specs })))
      : null;
    return { ...drone, items: parts, report };
  });
};
