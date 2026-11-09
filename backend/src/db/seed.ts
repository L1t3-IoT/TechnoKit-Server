import { eq, inArray, sql } from 'drizzle-orm';
import { db, pool } from './index.js';
import { categories, droneParts, drones, products } from './schema.js';
import { cardSpecs, UNIT_LABEL } from './card.js';
import { parts } from './data/parts.js';
import { drones as droneSeeds } from './data/drones.js';

const cats = [
  { slug: 'frames', name: 'Рами', sortOrder: 1 },
  { slug: 'motors', name: 'Мотори', sortOrder: 2 },
  { slug: 'esc', name: 'ESC', sortOrder: 3 },
  { slug: 'flight-controllers', name: 'Польотні контролери', sortOrder: 4 },
  { slug: 'props', name: 'Пропелери', sortOrder: 5 },
  { slug: 'batteries', name: 'Акумулятори', sortOrder: 6 },
];

await db.insert(categories).values(cats).onConflictDoUpdate({
  target: categories.slug,
  set: { name: sql`excluded.name`, sortOrder: sql`excluded.sort_order` },
});
const catRows = await db.select().from(categories);
const catId = (slug: string) => catRows.find((c) => c.slug === slug)!.id;

// Прибираємо вигадані демо-товари з макета (якщо їх ніхто не додав у збірку).
const DEMO = ['FR-AX5', 'MO-V2207', 'ESC-P55', 'FC-NF7', 'PR-T51', 'BA-V6S13'];
try { await db.delete(products).where(inArray(products.sku, DEMO)); } catch { console.warn('Демо-товари залишено: вони є у чиїйсь збірці'); }

const rows = parts.map((p) => ({
  sku: p.sku, categoryId: catId(p.category), name: p.name, brand: p.brand, description: p.description,
  priceCents: Math.round(p.priceUsd * 100), inStock: p.inStock ?? true, unitLabel: UNIT_LABEL[p.category] ?? null,
  cardSpecs: cardSpecs(p.category, p.specs), statusText: null, statusNote: null,
  specs: p.specs, verified: p.verified, sourceUrl: p.url ?? null,
}));
await db.insert(products).values(rows).onConflictDoUpdate({
  target: products.sku,
  set: {
    categoryId: sql`excluded.category_id`, name: sql`excluded.name`, brand: sql`excluded.brand`, description: sql`excluded.description`,
    priceCents: sql`excluded.price_cents`, specs: sql`excluded.specs`, unitLabel: sql`excluded.unit_label`,
    cardSpecs: sql`excluded.card_specs`, statusText: sql`excluded.status_text`, statusNote: sql`excluded.status_note`,
    verified: sql`excluded.verified`, sourceUrl: sql`excluded.source_url`,
  },
});

const prodRows = await db.select({ id: products.id, sku: products.sku }).from(products);
const pid = (sku: string) => {
  const r = prodRows.find((p) => p.sku === sku);
  if (!r) throw new Error(`Невідомий SKU у дронах: ${sku}`);
  return r.id;
};

for (const [i, d] of droneSeeds.entries()) {
  const values = {
    slug: d.slug, name: d.name, brand: d.brand ?? null, kind: d.kind, segment: d.segment, propInch: d.propInch, cells: d.cells,
    weightG: d.weightG ?? null, summary: d.summary, specs: d.specs, verified: d.verified, sourceUrl: d.url ?? null, sortOrder: i,
  };
  const [row] = await db.insert(drones).values(values).onConflictDoUpdate({ target: drones.slug, set: values }).returning({ id: drones.id });
  await db.delete(droneParts).where(eq(droneParts.droneId, row.id));
  if (d.parts?.length) await db.insert(droneParts).values(d.parts.map((p) => ({ droneId: row.id, productId: pid(p.sku), quantity: p.quantity })));
}

console.log(`Seed: ${cats.length} категорій, ${rows.length} деталей, ${droneSeeds.length} дронів`);
await pool.end();
