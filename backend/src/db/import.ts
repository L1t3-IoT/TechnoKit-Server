/**
 * Масовий імпорт деталей з CSV:  npm run db:import -- data/parts.template.csv
 * Колонки: sku,category,name,brand,description,price_usd,verified,source_url,in_stock,specs
 * `specs` — JSON-об'єкт із характеристиками (ключі див. у README → «Характеристики деталей»).
 * Наявні SKU оновлюються, нові додаються.
 */
import { readFileSync } from 'node:fs';
import { sql } from 'drizzle-orm';
import { z } from 'zod';
import { db, pool } from './index.js';
import { categories, products } from './schema.js';
import { cardSpecs, UNIT_LABEL } from './card.js';

function parseCsv(text: string): string[][] {
  const rows: string[][] = []; let row: string[] = []; let cur = ''; let q = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (q) { if (c === '"') { if (text[i + 1] === '"') { cur += '"'; i++; } else q = false; } else cur += c; }
    else if (c === '"') q = true;
    else if (c === ',') { row.push(cur); cur = ''; }
    else if (c === '\n' || c === '\r') { if (c === '\r' && text[i + 1] === '\n') i++; row.push(cur); cur = ''; if (row.some((x) => x !== '')) rows.push(row); row = []; }
    else cur += c;
  }
  if (cur !== '' || row.length) { row.push(cur); rows.push(row); }
  return rows;
}

const file = process.argv[2];
if (!file) { console.error('Вкажіть файл: npm run db:import -- data/parts.csv'); process.exit(1); }
const [head, ...body] = parseCsv(readFileSync(file, 'utf8'));
const row = z.object({
  sku: z.string().min(1), category: z.string().min(1), name: z.string().min(1), brand: z.string().default(''),
  description: z.string().default(''), price_usd: z.coerce.number().min(0), verified: z.string().default('false'),
  source_url: z.string().default(''), in_stock: z.string().default('true'), specs: z.string().default('{}'),
});

const cats = await db.select().from(categories);
let ok = 0;
for (const [n, cells] of body.entries()) {
  const parsed = row.safeParse(Object.fromEntries(head.map((h, i) => [h.trim(), cells[i] ?? ''])));
  if (!parsed.success) { console.error(`Рядок ${n + 2}: ${parsed.error.issues[0].message}`); continue; }
  const r = parsed.data;
  const cat = cats.find((c) => c.slug === r.category);
  if (!cat) { console.error(`Рядок ${n + 2}: невідома категорія «${r.category}»`); continue; }
  let specs: Record<string, never>;
  try { specs = JSON.parse(r.specs); } catch { console.error(`Рядок ${n + 2}: specs — некоректний JSON`); continue; }
  const v = {
    sku: r.sku, categoryId: cat.id, name: r.name, brand: r.brand || null, description: r.description || null,
    priceCents: Math.round(r.price_usd * 100), inStock: r.in_stock !== 'false', unitLabel: UNIT_LABEL[r.category] ?? null,
    cardSpecs: cardSpecs(r.category, specs), specs, verified: r.verified === 'true', sourceUrl: r.source_url || null,
  };
  await db.insert(products).values(v).onConflictDoUpdate({ target: products.sku, set: { ...v, sku: sql`excluded.sku` } });
  ok++;
}
console.log(`Імпортовано: ${ok} із ${body.length}`);
await pool.end();
