import type { FastifyPluginAsync } from 'fastify';
import { eq, getTableColumns, inArray } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../db/index.js';
import { categories, products } from '../db/schema.js';
import { annotate, checkBuild, defaultQuantity, suggest, WIRING_CHECKLIST } from '../lib/compat.js';
import { loadCatalog, loadParts } from '../lib/parts.js';

const items = z.array(z.object({ productId: z.number().int(), quantity: z.number().int().min(1).max(99) })).max(20);

export const compatRoutes: FastifyPluginAsync = async (app) => {
  // Повна перевірка збірки + підказки замін. Не потребує входу: збірка живе у браузері.
  app.post('/check', async (req, reply) => {
    const body = z.object({ items }).safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Некоректна збірка' });
    const parts = await loadParts(body.data.items);
    const report = checkBuild(parts);
    const needsFix = report.checks.some((c) => c.status === 'warn' || c.status === 'fail');
    const catalog = needsFix ? await loadCatalog(['batteries', 'props', 'esc', 'motors', 'frames', 'flight-controllers']) : [];
    const suggestions = needsFix ? suggest(parts, report, catalog) : suggest(parts, report, []);
    return { report, suggestions, wiringChecklist: WIRING_CHECKLIST };
  });

  // Статус сумісності для карток каталогу: як кожна деталь поводиться у поточній збірці.
  app.post('/annotate', async (req, reply) => {
    const body = z.object({ items, productIds: z.array(z.number().int()).max(60) }).safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Некоректні дані' });
    const parts = await loadParts(body.data.items);
    if (!body.data.productIds.length) return { items: {} };
    const rows = await db.select({
      id: products.id, sku: products.sku, name: products.name, brand: products.brand, priceCents: products.priceCents,
      specs: products.specs, category: categories.slug,
    }).from(products).innerJoin(categories, eq(categories.id, products.categoryId)).where(inArray(products.id, body.data.productIds));
    const out: Record<number, ReturnType<typeof annotate>> = {};
    for (const r of rows) out[r.id] = annotate(parts, { ...r, quantity: defaultQuantity(r.category, r.specs) });
    return { items: out };
  });

  // Актуальні дані деталей збірки (ціни, характеристики) за id — для відновлення збірки з localStorage.
  app.post('/hydrate', async (req, reply) => {
    const body = z.object({ items }).safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Некоректна збірка' });
    if (!body.data.items.length) return { items: [] };
    const rows = await db.select({ ...getTableColumns(products), categorySlug: categories.slug }).from(products)
      .innerJoin(categories, eq(categories.id, products.categoryId))
      .where(inArray(products.id, body.data.items.map((i) => i.productId)));
    const qty = new Map(body.data.items.map((i) => [i.productId, i.quantity]));
    return { items: rows.map((product) => ({ product, quantity: qty.get(product.id) ?? 1 })) };
  });
};
