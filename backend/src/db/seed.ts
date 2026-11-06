import { sql } from 'drizzle-orm';
import { db, pool } from './index.js';
import { categories, products } from './schema.js';

type NewProduct = typeof products.$inferInsert;

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

const rows = await db.select().from(categories);
const id = (slug: string) => rows.find((c) => c.slug === slug)!.id;

const items: NewProduct[] = [
  { sku: 'FR-AX5', categoryId: id('frames'), name: 'AX5 Carbon Frame', description: 'Міцна основа для 5-дюймової збірки.', priceCents: 5900,
    specs: { wheelbase_mm: 225, stack_mount: '30.5x30.5', prop_inch: 5 } },
  { sku: 'MO-V2207', categoryId: id('motors'), name: 'Vector 2207 / 1750KV', description: 'Мотор із низьким KV для платформи 6S.', priceCents: 1990,
    specs: { cells: [6], motor_mount: '16x16', kv: 1750 } },
  { sku: 'ESC-P55', categoryId: id('esc'), name: 'Pulse 55A / 4-in-1 ESC', description: 'Чотириканальний регулятор обертів.', priceCents: 6490,
    specs: { cells: [3, 4, 5, 6], continuous_a: 55, stack_mount: '30.5x30.5' } },
  { sku: 'FC-NF7', categoryId: id('flight-controllers'), name: 'Nexus F7 Controller', description: 'Польотний контролер F7 для FPV-дронів.', priceCents: 5490,
    specs: { cpu: 'F7', stack_mount: '30.5x30.5' } },
  { sku: 'PR-T51', categoryId: id('props'), name: 'Triad 5.1 × 4.3 × 3', description: 'Трилопатеві пропелери з отвором 5 мм.', priceCents: 349,
    specs: { diameter_inch: 5.1, shaft_mm: 5, prop_inch: 5 } },
  { sku: 'BA-V6S13', categoryId: id('batteries'), name: 'Volt 6S / 1300mAh', description: 'Акумулятор LiPo 6S для FPV-дронів.', priceCents: 5290,
    specs: { cells: [6], capacity_mah: 1300, c_rating: 100, nominal_v: 22.2 } },
];

await db.insert(products).values(items).onConflictDoUpdate({
  target: products.sku,
  set: {
    name: sql`excluded.name`, description: sql`excluded.description`,
    priceCents: sql`excluded.price_cents`, specs: sql`excluded.specs`,
  },
});

console.log(`Seed: ${cats.length} категорій, ${items.length} деталей`);
await pool.end();
