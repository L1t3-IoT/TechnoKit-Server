/**
 * Каталог реальних FPV-деталей.
 *
 * verified: true  — характеристики звірені зі сторінкою виробника/магазину (див. url).
 * verified: false — орієнтовні дані; на сайті показується позначка «звірте з виробником».
 * Ціни — орієнтовні роздрібні в USD на момент збирання даних (листопад 2026); магазини їх змінюють.
 *
 * Додати свої деталі можна скриптом `npm run db:import <файл.csv>` (див. README).
 */
import type { SpecValue } from '../schema.js';

export type PartSeed = {
  sku: string; category: string; name: string; brand: string; description: string;
  priceUsd: number; specs: Record<string, SpecValue>; verified: boolean; url?: string; inStock?: boolean;
};

const S3_6 = [3, 4, 5, 6];
const gf = 'https://www.getfpv.com';

const frames: PartSeed[] = [
  { sku: 'FR-IF-NAZGUL5V3', category: 'frames', name: 'iFlight Nazgul5 V3 Frame Kit', brand: 'iFlight', priceUsd: 39,
    description: 'Карбонова 5″ рама для фристайлу: 5-мм промені, TPU-захист променів, місце під повнорозмірну камеру й O3.',
    specs: { wheelbase_mm: 245, max_prop_inch: 5.1, stack_mounts: ['30.5x30.5', '20x20'], motor_mounts: ['16x16'], arm_mm: 5, weight_g: 130, class: '5' },
    verified: true, url: `${gf}/iflight-nazgul5-v3-frame-kit.html` },
  { sku: 'FR-GP-MK5-PRO', category: 'frames', name: 'GEPRC Mark5 Pro 5″ Frame (GEP-MK5)', brand: 'GEPRC', priceUsd: 62,
    description: 'Фристайл-рама Squashed-X із 5-мм променями та алюмінієвими бічними панелями; мотори 16×16 або 19×19.',
    specs: { wheelbase_mm: 225, max_prop_inch: 5.1, stack_mounts: ['30.5x30.5'], motor_mounts: ['16x16', '19x19'], arm_mm: 5, weight_g: 130, class: '5' },
    verified: true, url: `${gf}/multi-rotor-frames/5-quad-frames/geprc-mark5-gep-mk5-5-freestyle-frame-black-pro-version.html` },
  { sku: 'FR-GP-MK5-O4DC', category: 'frames', name: 'GEPRC Mark5 O4 Pro DC 5″ Frame', brand: 'GEPRC', priceUsd: 58,
    description: 'Рама Deadcat 230 мм під DJI O4 Air Unit Pro; 3K-карбон, 5-мм промені.',
    specs: { wheelbase_mm: 230, max_prop_inch: 5.1, stack_mounts: ['30.5x30.5'], motor_mounts: ['16x16', '19x19'], arm_mm: 5, weight_g: 197, class: '5' },
    verified: true, url: 'https://testshop.team-blacksheep.com/product/geprc-mk5-o4-pro-dc-frame' },
  { sku: 'FR-IF-CHIMERA7V2', category: 'frames', name: 'iFlight Chimera7 Pro V2 7.5″ Frame Kit', brand: 'iFlight', priceUsd: 132,
    description: 'Рама для далекобійних польотів 7–7.5″: 6-мм промені, місце під великі LiPo/Li-ion, 30.5-й Stack.',
    specs: { wheelbase_mm: 327, max_prop_inch: 7.5, stack_mounts: ['30.5x30.5'], motor_mounts: ['16x16', '19x19'], arm_mm: 6, weight_g: 175, class: '7' },
    verified: true, url: `${gf}/iflight-chimera7-pro-v2-7-5-lr-frame-kit.html` },
];

const tm = (kv: number, cells: number[], peak: number, w: number, price: number): PartSeed => ({
  sku: `MO-TM-V2207V3-${kv}`, category: 'motors', name: `T-Motor Velox V2207 V3 ${kv}KV`, brand: 'T-Motor', priceUsd: price,
  description: `Мотор 2207 для 5″ квадрокоптерів, ${cells.join('–')}S. Піковий струм за 60 с — ${peak} А.`,
  specs: { stator: '2207', kv, cells, peak_a: peak, motor_mount: '16x16', shaft_mm: 5, weight_g: w, prop_inch_range: [5, 6] },
  verified: true, url: `${gf}/t-motor-velox-v2207-v3-motor-1500kv-1750kv-1950kv-2550kv.html`,
});

const motors: PartSeed[] = [
  tm(1500, [8], 33.3, 34.6, 19), tm(1750, [6], 34.6, 37.3, 19), tm(1950, [6], 45, 37.1, 19), tm(2050, [6], 49.5, 36.8, 19), tm(2550, [4], 41.8, 36.5, 19),
  { sku: 'MO-IF-XING2-2207-1855', category: 'motors', name: 'iFlight XING2 2207 1855KV', brand: 'iFlight', priceUsd: 28,
    description: 'Unibell-мотор 2207 для 6S: титановий вал 5 мм, сталий дзвін 7075.',
    specs: { stator: '2207', kv: 1855, cells: [6], peak_a: 35.08, motor_mount: '16x16', shaft_mm: 5, weight_g: 31.6, prop_inch_range: [5, 6] },
    verified: true, url: `${gf}/iflight-xing2-2207-motor-1855kv-2755kv.html` },
  { sku: 'MO-IF-XING2-2207-2755', category: 'motors', name: 'iFlight XING2 2207 2755KV', brand: 'iFlight', priceUsd: 25,
    description: 'Unibell-мотор 2207 для 4S: піковий струм 40.35 А, вал 5 мм.',
    specs: { stator: '2207', kv: 2755, cells: [4], peak_a: 40.35, motor_mount: '16x16', shaft_mm: 5, weight_g: 31.6, prop_inch_range: [5, 6] },
    verified: true, url: `${gf}/iflight-xing2-2207-motor-1855kv-2755kv.html` },
  { sku: 'MO-IF-XING-2806-1300', category: 'motors', name: 'iFlight XING 2806.5 1300KV', brand: 'iFlight', priceUsd: 41,
    description: 'Мотор для 7–8″ далекобійних збірок, 2–6S, кріплення 19×19.',
    specs: { stator: '2806.5', kv: 1300, cells: [2, 3, 4, 5, 6], peak_a: 48.33, motor_mount: '19x19', shaft_mm: 5, weight_g: 54.3, prop_inch_range: [7, 8] },
    verified: true, url: `${gf}/iflight-xing-2806-5-race-motor-1300kv-1800kv.html` },
];

const esc: PartSeed[] = [
  { sku: 'ESC-SB-BLS55', category: 'esc', name: 'SpeedyBee BLS 55A 30×30 4-in-1 ESC', brand: 'SpeedyBee', priceUsd: 48,
    description: 'Чотириканальний ESC: BLHeli_S, DShot300/600, 55 А на канал (імпульс 70 А/10 с), конденсатор у комплекті.',
    specs: { cells: S3_6, continuous_a: 55, burst_a: 70, stack_mount: '30.5x30.5', stack_family: 'speedybee-f405-v4', firmware: 'BLHeli_S', protocols: ['DShot300', 'DShot600'], weight_g: 23.5 },
    verified: true, url: `${gf}/speedybee-f405-v4-stack-f4-v4-fc-55a-blheli-s-esc-30x30.html` },
  { sku: 'ESC-IF-BLITZ-E45S', category: 'esc', name: 'iFlight BLITZ E45S 4-in-1 ESC', brand: 'iFlight', priceUsd: 45,
    description: 'ESC 45 А (імпульс 50 А), 2–6S, BLHeli_S, кріплення 30.5×30.5.',
    specs: { cells: [2, 3, 4, 5, 6], continuous_a: 45, burst_a: 50, stack_mount: '30.5x30.5', stack_family: 'iflight-blitz-f7v11', firmware: 'BLHeli_S', weight_g: 15 },
    verified: true, url: 'https://www.fpvfaster.com.au/collections/drones/products/iflight-nazgul5-v2-fpv-bnf-drone-4s-6s-frsky-r-xsr' },
  { sku: 'ESC-TM-VELOX50', category: 'esc', name: 'T-Motor Velox V50A 32-bit 4-in-1 ESC', brand: 'T-Motor', priceUsd: 75,
    description: '32-бітний ESC 50 А для Velox V3, 3–6S, кріплення 30.5×30.5.',
    specs: { cells: S3_6, continuous_a: 50, stack_mount: '30.5x30.5' },
    verified: false, url: 'https://www.onedrone.com/store/tags/X?page=13' },
];

const fc: PartSeed[] = [
  { sku: 'FC-SB-F405V4', category: 'flight-controllers', name: 'SpeedyBee F405 V4 30×30 Flight Controller', brand: 'SpeedyBee', priceUsd: 38,
    description: 'F405 із гіроскопом ICM42688P, Bluetooth-налаштуванням, барометром і підтримкою DJI-роз’єму; живлення 3–6S.',
    specs: { cells: S3_6, cpu: 'F405', gyro: 'ICM42688P', stack_mount: '30.5x30.5', stack_family: 'speedybee-f405-v4', betaflight_target: 'SPEEDYBEEF405V4', weight_g: 10.5 },
    verified: true, url: `${gf}/electronics/stacks/speedybee-f405-v4-stack-f4-v4-fc-55a-blheli-s-esc-30x30.html` },
  { sku: 'FC-IF-BLITZF7V11', category: 'flight-controllers', name: 'iFlight BLITZ F7 V1.1 Flight Controller', brand: 'iFlight', priceUsd: 35,
    description: 'F722 із гіроскопом MPU6000, барометром DPS310, 4 виходи DShot; кріплення 30.5×30.5.',
    specs: { cpu: 'F7', gyro: 'MPU6000', stack_mount: '30.5x30.5', stack_family: 'iflight-blitz-f7v11', betaflight_target: 'IFLIGHT_SUCCEX_E_F7', weight_g: 6.9 },
    verified: true, url: 'https://www.fpvfaster.com.au/collections/drones/products/iflight-nazgul5-v2-fpv-bnf-drone-4s-6s-frsky-r-xsr' },
];

const prop = (sku: string, name: string, d: number, pitch: number, blades: number, w: number, bore: number | undefined, price: number, verified: boolean, url: string, extra: Record<string, SpecValue> = {}): PartSeed => ({
  sku, category: 'props', name, brand: name.split(' ')[0], priceUsd: price, verified, url,
  description: `Пропелери ${d}″ × ${pitch}″, ${blades} лопаті, комплект із 4 шт. (2 CW + 2 CCW).`,
  specs: { diameter_inch: d, pitch_inch: pitch, blades, ...(bore ? { bore_mm: bore } : {}), pack_qty: 4, weight_g: w, ...extra },
});

const props: PartSeed[] = [
  prop('PR-GF-51466', 'Gemfan Hurricane 51466 3-Blade 5.1″', 5.1, 4.66, 3, 4.13, 5, 3.99, true, `${gf}/gemfan-hurricane-51466-propeller-set-of-4.html`),
  prop('PR-GF-51466V2', 'Gemfan Hurricane 51466 V2 (MCK) 5.1″', 5.1, 3.6, 3, 4.2, 5, 4.99, true, 'https://www.racedayquads.com/products/gemfan-hurricane-mck-51466-3-v2-tri-blade-5-1-prop-4-pack-choose-color'),
  prop('PR-GF-51433', 'Gemfan Hurricane 51433 3-Blade 5.1″', 5.1, 4.33, 3, 4.1, 5, 3.99, false, 'https://www.onedrone.com/store/tags/hurricane'),
  prop('PR-GF-51366', 'Gemfan Hurricane MCK ReV3 51366 5.1″', 5.1, 3.66, 3, 4.1, 5, 3.99, false, 'https://www.onedrone.com/store/tags/hurricane'),
  prop('PR-GF-5127', 'Gemfan Hurricane 5127 3-Blade 5.1″', 5.1, 2.7, 3, 4.4, 5, 3.99, true, 'https://www.onedrone.com/store/tags/hurricane'),
  prop('PR-GF-5236', 'Gemfan 5236 3-Blade 5.2″', 5.2, 3.6, 3, 3.9, 5, 3.99, true, 'https://www.onedrone.com/store/tags/cane'),
  prop('PR-GF-5536', 'Gemfan 5536 3-Blade 5.5″', 5.5, 3.6, 3, 4.9, 5, 3.99, true, 'https://www.onedrone.com/store/tags/cane'),
  prop('PR-GF-6045', 'Gemfan 6045 3-Blade 6″', 6, 4.5, 3, 7, 5, 4.99, true, 'https://www.onedrone.com/store/tags/cane'),
  prop('PR-GF-7050', 'Gemfan 7050 3-Blade 7″', 7, 5, 3, 8.9, 5, 4.99, true, 'https://www.onedrone.com/store/tags/hurricane'),
  prop('PR-HQ-7035', 'HQProp 7X3.5X3 Racing 7″', 7, 3.5, 3, 8, undefined, 5.5, false, 'https://www.fpv24.com/en/iflight/iflight-chimera7-pro-v2-frame-75-inch-kit'),
];

type Bat = { sku: string; name: string; brand: string; cells: number; mah: number; c: number; w?: number; dim?: string; price: number; verified: boolean; url: string; line: string };
const bat = (b: Bat): PartSeed => ({
  sku: b.sku, category: 'batteries', name: b.name, brand: b.brand, priceUsd: b.price, verified: b.verified, url: b.url,
  description: `LiPo ${b.cells}S ${b.mah} мА·год, ${b.line}, роз’єм XT60.`,
  specs: { cells: [b.cells], capacity_mah: b.mah, c_rating: b.c, nominal_v: Math.round(b.cells * 3.7 * 10) / 10, connector: 'XT60', chemistry: 'LiPo', ...(b.w ? { weight_g: b.w } : {}), ...(b.dim ? { dimensions_mm: b.dim } : {}) },
});
const tattu = 'https://www.progressiverc.com/collections/vendors/products/tattu-r-line-v5-6s-1400mah-150c';
const batteries: PartSeed[] = [
  bat({ sku: 'BA-TT-RL5-6S1400', name: 'Tattu R-Line V5 6S 1400mAh 150C', brand: 'Tattu', cells: 6, mah: 1400, c: 150, w: 222, dim: '78x39x42', price: 43, verified: true, url: tattu, line: 'вага 222 г' }),
  bat({ sku: 'BA-TT-RL5-6S1480', name: 'Tattu R-Line V5 6S 1480mAh 150C', brand: 'Tattu', cells: 6, mah: 1480, c: 150, w: 237, dim: '78x39x44', price: 45, verified: true, url: 'https://rcdrone.top/products/src-taa14806s15x6-tattu-r-line-version-5-0-1480mah-6s-150c-22-2v-lipo-battery-pack-with-xt60-plug', line: 'вага 237 г' }),
  bat({ sku: 'BA-TT-RL5-6S1800', name: 'Tattu R-Line V5 6S 1800mAh 150C', brand: 'Tattu', cells: 6, mah: 1800, c: 150, w: 287, dim: '77x38x46', price: 62, verified: true, url: 'https://www.grepow.com/fpv/drone-soccer-battery-solutions.html', line: 'вага 287 г' }),
  bat({ sku: 'BA-TT-RL3-6S1550', name: 'Tattu R-Line V3 6S 1550mAh 120C', brand: 'Tattu', cells: 6, mah: 1550, c: 120, w: 256, dim: '77x39x48', price: 50, verified: true, url: 'https://www.grepow.com/fpv/drone-soccer-battery-solutions.html', line: 'вага 256 г' }),
  bat({ sku: 'BA-TT-FF-6S1300', name: 'Tattu FunFly 6S 1300mAh 100C', brand: 'Tattu', cells: 6, mah: 1300, c: 100, w: 225, dim: '75x36x44', price: 38, verified: true, url: 'https://www.grepow.com/fpv/drone-soccer-battery-solutions.html', line: 'вага 225 г' }),
  bat({ sku: 'BA-TT-RL5-6S1050', name: 'Tattu R-Line V5 6S 1050mAh 150C', brand: 'Tattu', cells: 6, mah: 1050, c: 150, price: 70, verified: false, url: 'https://www.kiwiquads.co.nz/product/tattu-r-line-version-5-0-22-2v-150c-1400mah-6s-battery', line: 'компактний для легких збірок' }),
  bat({ sku: 'BA-TT-RL5-6S850', name: 'Tattu R-Line V5 6S 850mAh 150C', brand: 'Tattu', cells: 6, mah: 850, c: 150, price: 63, verified: false, url: 'https://www.kiwiquads.co.nz/product/tattu-r-line-version-5-0-22-2v-150c-1400mah-6s-battery', line: 'для гоночних збірок' }),
  bat({ sku: 'BA-CN-BL-6S1100', name: 'CNHL Black Series 6S 1100mAh 100C', brand: 'CNHL', cells: 6, mah: 1100, c: 100, price: 47, verified: false, url: 'https://www.kiwiquads.co.nz/product/tattu-r-line-version-5-0-22-2v-150c-1400mah-6s-battery', line: 'бюджетний варіант' }),
  bat({ sku: 'BA-TT-RL5-4S1300', name: 'Tattu R-Line V5 4S 1300mAh 150C', brand: 'Tattu', cells: 4, mah: 1300, c: 150, w: 156, dim: '75x38x27', price: 35, verified: true, url: 'https://www.progressiverc.com/products/tattu-r-line-v5-4s-1300mah-150c', line: 'вага 156 г' }),
];

export const parts: PartSeed[] = [...frames, ...motors, ...esc, ...fc, ...props, ...batteries];
