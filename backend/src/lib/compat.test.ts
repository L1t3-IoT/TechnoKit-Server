/** Запуск: npm test  — перевіряє правила сумісності на реальних даних каталогу (без БД). */
import assert from 'node:assert/strict';
import { parts as seed } from '../db/data/parts.js';
import { drones } from '../db/data/drones.js';
import { annotate, checkBuild, defaultQuantity, suggest, type Part } from './compat.js';

let id = 0;
const all: Part[] = seed.map((p) => ({ id: ++id, sku: p.sku, name: p.name, brand: p.brand, category: p.category, priceCents: Math.round(p.priceUsd * 100), quantity: 1, specs: p.specs }));
const get = (sku: string, quantity?: number): Part => {
  const p = all.find((x) => x.sku === sku);
  assert.ok(p, `немає ${sku}`);
  return { ...p, quantity: quantity ?? defaultQuantity(p.category, p.specs) };
};
const build = (skus: string[]) => skus.map((s) => get(s));
const st = (r: ReturnType<typeof checkBuild>, id: string) => r.checks.find((c) => c.id === id)!.status;

// 1. Еталонні збірки мають бути без помилок; навчальна — з попередженням про струм
for (const d of drones.filter((x) => x.kind === 'reference' && x.parts)) {
  const r = checkBuild(d.parts!.map((p) => get(p.sku)));
  const expectWarn = d.slug.includes('learning');
  assert.equal(r.counts.fail, 0, `${d.slug}: помилки ${JSON.stringify(r.checks.filter((c) => c.status === 'fail'))}`);
  assert.equal(r.missing.length, 0, `${d.slug}: не вистачає ${r.missing}`);
  assert.equal(st(r, 'current'), expectWarn ? 'warn' : 'ok', `${d.slug}: current`);
  assert.equal(st(r, 'mount'), 'ok'); assert.equal(st(r, 'voltage'), 'ok'); assert.equal(st(r, 'prop'), 'ok'); assert.equal(st(r, 'wiring'), 'ok');
  console.log(`✓ ${d.slug}: ${r.headline} · ${r.weightG} г · $${(r.totalCents / 100).toFixed(2)}`);
}

// 2. Невідповідність кріплення мотора: 2806.5 (19×19) на рамі, що не має 19×19
assert.equal(st(checkBuild(build(['FR-IF-NAZGUL5V3', 'MO-IF-XING-2806-1300'])), 'mount'), 'fail');
// 3. Напруга: 4S-мотор на 6S акумуляторі — помилка; 6S-мотор на 4S — попередження
assert.equal(st(checkBuild(build(['MO-IF-XING2-2207-2755', 'BA-TT-RL5-6S1400'])), 'voltage'), 'fail');
assert.equal(st(checkBuild(build(['MO-TM-V2207V3-1950', 'BA-TT-RL5-4S1300'])), 'voltage'), 'warn');
// 4. 7″ пропелери на 5″ рамі — помилка; 5″ на 7″ — ок
assert.equal(st(checkBuild(build(['FR-IF-NAZGUL5V3', 'PR-GF-7050'])), 'prop'), 'fail');
assert.equal(st(checkBuild(build(['FR-IF-CHIMERA7V2', 'PR-GF-51466'])), 'prop'), 'ok');
// 5. Кількість: один мотор — помилка комплектності
const one = [get('FR-IF-NAZGUL5V3'), get('MO-TM-V2207V3-1950', 1)];
assert.equal(checkBuild(one).checks[0].id, 'completeness');
// 6. Невідомі розпіновки: FC і ESC з різних стеків → open; вирішується тим же стеком
const mixed = checkBuild(build(['FC-SB-F405V4', 'ESC-IF-BLITZ-E45S']));
assert.equal(st(mixed, 'wiring'), 'open');
assert.equal(st(checkBuild(build(['FC-IF-BLITZF7V11', 'ESC-IF-BLITZ-E45S'])), 'wiring'), 'ok');
// 7. Порожня збірка
assert.equal(checkBuild([]).headline, 'Збірка порожня');

// 8. Підказки: навчальна збірка має отримати заміну, що прибирає попередження
const learn = build(drones.find((d) => d.slug.includes('learning'))!.parts!.map((p) => p.sku));
const rep = checkBuild(learn);
const sug = suggest(learn, rep, all);
assert.ok(sug.length > 0 && sug.some((s) => s.product), 'є підказки');
for (const s of sug.filter((x) => x.product)) {
  const after = checkBuild([...learn.filter((p) => p.category !== s.slot), s.product!]);
  assert.ok(after.counts.warn + after.counts.fail * 2 <= rep.counts.warn + rep.counts.fail * 2, 'заміна не погіршує збірку');
  console.log(`  підказка: ${s.slot} → ${s.product!.name} (${s.spec})`);
}

// 9. Анотація каталогу
const base = build(['FR-IF-NAZGUL5V3']);
assert.equal(annotate(base, get('MO-TM-V2207V3-1950'))?.status, 'ok');
assert.equal(annotate(base, get('MO-IF-XING-2806-1300'))?.status, 'fail');
assert.equal(annotate([], get('MO-TM-V2207V3-1950')), null);
console.log('Усі тести пройдено');
