import { and, eq, inArray } from 'drizzle-orm';
import { db } from '../db/index.js';
import { categories, products } from '../db/schema.js';
import type { Part } from './compat.js';

const cols = {
  id: products.id, sku: products.sku, name: products.name, brand: products.brand, priceCents: products.priceCents,
  specs: products.specs, category: categories.slug,
};

/** Завантажує деталі збірки з БД з урахуванням кількості. Невідомі id ігноруються. */
export async function loadParts(items: { productId: number; quantity: number }[]): Promise<Part[]> {
  if (!items.length) return [];
  const rows = await db.select(cols).from(products).innerJoin(categories, eq(categories.id, products.categoryId))
    .where(inArray(products.id, items.map((i) => i.productId)));
  const qty = new Map(items.map((i) => [i.productId, i.quantity]));
  // одна деталь на категорію: якщо клієнт надіслав дві, лишається остання
  const byCat = new Map<string, Part>();
  for (const i of items) {
    const r = rows.find((x) => x.id === i.productId);
    if (r) byCat.set(r.category, { ...r, quantity: qty.get(r.id) ?? 1 });
  }
  return [...byCat.values()];
}

export async function loadCatalog(categorySlugs: string[]): Promise<Part[]> {
  const rows = await db.select(cols).from(products).innerJoin(categories, eq(categories.id, products.categoryId))
    .where(and(inArray(categories.slug, categorySlugs)));
  return rows.map((r) => ({ ...r, quantity: 1 }));
}
