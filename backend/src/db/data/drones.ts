/**
 * Дрони.
 *  kind: 'model'     — реальні серійні моделі (довідкові дані виробника; деталі у каталозі не прив'язані).
 *  kind: 'reference' — еталонні збірки TechnoKit із деталей каталогу. Кожну можна завантажити у «Мою збірку»
 *                      й перевірити; склад підібрано так, щоб проходити правила сумісності.
 */
import type { SpecValue } from '../schema.js';

export type DroneSeed = {
  slug: string; name: string; brand?: string; kind: 'model' | 'reference'; segment: string; propInch: number;
  cells: number[]; weightG?: number; summary: string; specs: Record<string, SpecValue>;
  verified: boolean; url?: string; parts?: { sku: string; quantity: number }[];
};

export const drones: DroneSeed[] = [
  {
    slug: 'ref-5-freestyle-6s', name: '5″ фристайл 6S — збірка зі 100% перевірених деталей', kind: 'reference', segment: '5', propInch: 5.1, cells: [6],
    summary: 'Базова збірка для фристайлу: рама Nazgul5 V3, мотори Velox 2207 1950KV, стек SpeedyBee F405 V4 + BLS 55A, пропелери Gemfan 51466 і Tattu 6S 1400.',
    specs: { class: 'Фристайл', motor: '2207 / 1950KV', esc: '55 А', battery: '6S 1400 мА·год', note: 'Без камери, VTX і приймача.' },
    verified: true,
    parts: [
      { sku: 'FR-IF-NAZGUL5V3', quantity: 1 }, { sku: 'MO-TM-V2207V3-1950', quantity: 4 }, { sku: 'ESC-SB-BLS55', quantity: 1 },
      { sku: 'FC-SB-F405V4', quantity: 1 }, { sku: 'PR-GF-51466', quantity: 1 }, { sku: 'BA-TT-RL5-6S1400', quantity: 1 },
    ],
  },
  {
    slug: 'ref-5-freestyle-4s', name: '5″ фристайл 4S — легка збірка', kind: 'reference', segment: '5', propInch: 5.1, cells: [4],
    summary: 'Збірка на 4S: GEPRC Mark5 Pro, мотори XING2 2207 2755KV, стек SpeedyBee, пропелери 51466 і Tattu 4S 1300 (легша й дешевша в експлуатації).',
    specs: { class: 'Фристайл', motor: '2207 / 2755KV', esc: '55 А', battery: '4S 1300 мА·год', note: 'Без камери, VTX і приймача.' },
    verified: true,
    parts: [
      { sku: 'FR-GP-MK5-PRO', quantity: 1 }, { sku: 'MO-IF-XING2-2207-2755', quantity: 4 }, { sku: 'ESC-SB-BLS55', quantity: 1 },
      { sku: 'FC-SB-F405V4', quantity: 1 }, { sku: 'PR-GF-51466', quantity: 1 }, { sku: 'BA-TT-RL5-4S1300', quantity: 1 },
    ],
  },
  {
    slug: 'ref-7-long-range-6s', name: '7″ далекобійний 6S', kind: 'reference', segment: '7', propInch: 7, cells: [6],
    summary: 'Рама Chimera7 Pro V2, мотори XING 2806.5 1300KV, стек SpeedyBee, пропелери Gemfan 7050 і Tattu 6S 1480 — збірка для довгих польотів.',
    specs: { class: 'Long range', motor: '2806.5 / 1300KV', esc: '55 А', battery: '6S 1480 мА·год', note: 'Для реальних далеких польотів розгляньте більші акумулятори (Li-ion).' },
    verified: true,
    parts: [
      { sku: 'FR-IF-CHIMERA7V2', quantity: 1 }, { sku: 'MO-IF-XING-2806-1300', quantity: 4 }, { sku: 'ESC-SB-BLS55', quantity: 1 },
      { sku: 'FC-SB-F405V4', quantity: 1 }, { sku: 'PR-GF-7050', quantity: 1 }, { sku: 'BA-TT-RL5-6S1480', quantity: 1 },
    ],
  },
  {
    slug: 'ref-5-learning-overcurrent', name: '5″ 6S — навчальний приклад із попередженням про струм', kind: 'reference', segment: '5', propInch: 5.1, cells: [6],
    summary: 'Навмисно «перегнана» збірка: мотори 2050KV (49.5 А пік) на акумуляторі 1300 мА·год 100C. Покажіть, як перевірка струму виявляє слабкий акумулятор, і спробуйте запропоновані заміни.',
    specs: { class: 'Навчальний приклад', motor: '2207 / 2050KV', esc: '55 А', battery: '6S 1300 мА·год 100C' },
    verified: true,
    parts: [
      { sku: 'FR-IF-NAZGUL5V3', quantity: 1 }, { sku: 'MO-TM-V2207V3-2050', quantity: 4 }, { sku: 'ESC-SB-BLS55', quantity: 1 },
      { sku: 'FC-SB-F405V4', quantity: 1 }, { sku: 'PR-GF-51466', quantity: 1 }, { sku: 'BA-TT-FF-6S1300', quantity: 1 },
    ],
  },
  {
    slug: 'iflight-nazgul5-v3-analog-6s', name: 'iFlight Nazgul5 V3 Analog 6S (BNF)', brand: 'iFlight', kind: 'model', segment: '5', propInch: 5, cells: [6], weightG: 660,
    summary: '5″ фристайл-квадрокоптер: рама 245 мм, мотори XING-E Pro 2207, FC BLITZ F722, ESC BLITZ E55S 55 А, аналоговий VTX 1.6 Вт.',
    specs: { wheelbase_mm: 245, fc: 'BLITZ F722', esc: 'BLITZ E55S 55A 4-in-1', motors: 'XING-E Pro 2207 1800KV', props: 'Nazgul 5″', dry_weight_g: 427, size_mm: '173×173×34', geometry: 'Squashed-X' },
    verified: true, url: `${'https://www.getfpv.com'}/iflight-nazgul5-v3-analog-5-fpv-freestyle-bnf-6s.html`,
  },
  {
    slug: 'iflight-nazgul5-v3-hd-o3-6s', name: 'iFlight Nazgul5 V3 HD (DJI O3) 6S', brand: 'iFlight', kind: 'model', segment: '5', propInch: 5, cells: [6], weightG: 682,
    summary: '5″ цифровий фристайл із DJI O3 Air Unit: рама 245 мм, мотори XING-E Pro 2207 1800KV, FC BLITZ F722, ESC E55S 55 А.',
    specs: { wheelbase_mm: 245, fc: 'BLITZ F722', esc: 'BLITZ E55S 55A 4-in-1', motors: 'XING-E Pro 2207 1800KV', video: 'DJI O3 Air Unit', dry_weight_g: 457, max_speed_kmh: 190, size_mm: '173×173×34' },
    verified: true, url: 'https://shop.iflight.com/Nazgul5-V3-6S-HD-Pro1891',
  },
];
