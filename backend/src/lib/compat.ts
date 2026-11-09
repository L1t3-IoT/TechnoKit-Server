/**
 * Рушій сумісності. Чисті функції без доступу до БД — їх легко тестувати.
 *
 * Принципи:
 *  - Перевіряємо лише те, що можна довести даними каталогу. Якщо даних бракує — статус `open`
 *    («не завершено»), а не вигадане «пройдено».
 *  - `idle` — перевірку ще не можна виконати, бо у збірці немає потрібних деталей.
 *  - C-рейтинг акумулятора — маркетингова оцінка, а не виміряна струмовіддача; це завжди зазначається.
 */
import type { SpecValue } from '../db/schema.js';

export type Spec = Record<string, SpecValue>;
export type Status = 'ok' | 'warn' | 'fail' | 'open' | 'idle';

export type Part = {
  id: number;
  sku: string;
  name: string;
  brand: string | null;
  category: string; // slug категорії
  priceCents: number;
  quantity: number;
  specs: Spec;
};

export type Metric = { value: string; label: string; ratio: number };
export type Check = {
  id: 'completeness' | 'mount' | 'voltage' | 'current' | 'prop' | 'wiring';
  title: string;
  status: Status;
  line: string;
  detail: string;
  slots: string[]; // категорії, яких стосується перевірка
  metrics?: Metric[];
};

export type Report = {
  checks: Check[];
  counts: { ok: number; warn: number; fail: number; open: number };
  rowStatus: Record<string, Status>; // slug категорії → стан рядка деталі
  missing: string[];                 // категорії, яких не вистачає
  headline: string;
  subline: string;
  totalCents: number;
  weightG: number;
  unitCount: number;
};

export const SLOT_NAMES: Record<string, string> = {
  frames: 'Рама', motors: 'Мотори', esc: 'ESC', 'flight-controllers': 'Польотний контролер',
  props: 'Пропелери', batteries: 'Акумулятор',
};
export const SLOT_ORDER = ['frames', 'motors', 'esc', 'flight-controllers', 'props', 'batteries'];

/* ---------- допоміжні ---------- */
const num = (s: Spec, k: string): number | undefined => (typeof s[k] === 'number' ? (s[k] as number) : undefined);
const str = (s: Spec, k: string): string | undefined => (typeof s[k] === 'string' ? (s[k] as string) : undefined);
const arr = (s: Spec, k: string): (string | number)[] => {
  const v = s[k];
  return Array.isArray(v) ? v : v === undefined || typeof v === 'boolean' ? [] : [v];
};
const fmtMount = (m: string) => `${m.replace('x', ' × ')} мм`;
const fmtA = (v: number) => `${Math.round(v * 10) / 10} А`;
const rank: Record<Status, number> = { idle: -1, ok: 0, open: 1, warn: 2, fail: 3 };
const worst = (list: Status[]): Status => list.reduce<Status>((a, b) => (rank[b] > rank[a] ? b : a), 'idle');

/** Скільки фізичних одиниць у позиції (пропелери продаються комплектом по 4). */
export const units = (p: Part) => p.quantity * (num(p.specs, 'pack_qty') ?? 1);

/** Кількість за замовчуванням, коли користувач додає деталь у збірку. */
export function defaultQuantity(category: string, specs: Spec, motorCount = 4) {
  if (category === 'motors' || category === 'props') return Math.max(1, Math.ceil(motorCount / (num(specs, 'pack_qty') ?? 1)));
  return 1;
}

/* ---------- окремі перевірки ---------- */
function checkCompleteness(parts: Part[], by: (c: string) => Part | undefined, motorCount: number) {
  const fc = by('flight-controllers');
  const aio = fc?.specs.aio === true;
  const required = SLOT_ORDER.filter((c) => !(c === 'esc' && aio));
  const missing = required.filter((c) => !by(c));
  const problems: string[] = [];
  const motors = by('motors');
  const props = by('props');
  if (motors && units(motors) < motorCount) problems.push(`потрібно ${motorCount} мотори, у збірці ${units(motors)}`);
  if (motors && units(motors) > motorCount) problems.push(`у збірці ${units(motors)} моторів, а для квадрокоптера потрібно ${motorCount}`);
  if (props && units(props) < motorCount) problems.push(`потрібно ${motorCount} пропелери (2 CW + 2 CCW), у збірці ${units(props)}`);
  if (props && motors && units(props) % 4 !== 0) problems.push('пропелери мають бути парами CW/CCW (комплект із 4 шт.)');
  const check: Check | null = problems.length
    ? { id: 'completeness', title: 'Комплектність', status: 'fail', slots: ['motors', 'props'],
        line: problems[0], detail: problems.join('; ') + '.' }
    : null;
  return { missing, check };
}

function checkMount(by: (c: string) => Part | undefined): Check {
  const frame = by('frames'), motor = by('motors'), esc = by('esc'), fc = by('flight-controllers');
  const problems: string[] = [];
  let compared = 0;
  const frameStacks = frame ? arr(frame.specs, 'stack_mounts').map(String) : [];
  const stackOf = (p?: Part) => (p ? str(p.specs, 'stack_mount') : undefined);

  for (const [label, part] of [['FC', fc], ['ESC', esc]] as const) {
    const m = stackOf(part);
    if (frame && part && m && frameStacks.length) {
      compared++;
      if (!frameStacks.includes(m)) problems.push(`${label} ${fmtMount(m)}, а рама приймає Stack ${frameStacks.map(fmtMount).join(' або ')}`);
    }
  }
  if (fc && esc && stackOf(fc) && stackOf(esc)) {
    compared++;
    if (stackOf(fc) !== stackOf(esc)) problems.push(`FC ${fmtMount(stackOf(fc)!)} і ESC ${fmtMount(stackOf(esc)!)} мають різні кріплення`);
  }
  const frameMotor = frame ? arr(frame.specs, 'motor_mounts').map(String) : [];
  const mm = motor ? str(motor.specs, 'motor_mount') : undefined;
  if (frame && motor && mm && frameMotor.length) {
    compared++;
    if (!frameMotor.includes(mm)) problems.push(`мотор ${fmtMount(mm)}, а рама приймає ${frameMotor.map(fmtMount).join(' або ')}`);
  }

  const stackTxt = stackOf(fc) ?? stackOf(esc) ?? frameStacks[0];
  const line = `${stackTxt ? `Stack ${fmtMount(stackTxt)}` : 'Stack —'} / мотори ${mm ? fmtMount(mm) : '—'}`;
  const base = { id: 'mount' as const, title: 'Схема кріплення', slots: ['frames', 'motors', 'esc', 'flight-controllers'], line };
  if (problems.length) return { ...base, status: 'fail', detail: `Не збігаються: ${problems.join('; ')}.` };
  if (!compared) return { ...base, status: 'idle', detail: 'Додайте раму та хоча б один елемент Stack або мотор, щоб звірити кріплення.' };
  return { ...base, status: 'ok', detail: 'Кріплення збігаються за даними каталогу. Перевірте довжину гвинтів і висоту Stack.' };
}

function checkVoltage(by: (c: string) => Part | undefined): Check {
  const bat = by('batteries'), motor = by('motors'), esc = by('esc'), fc = by('flight-controllers'), prop = by('props');
  const base = { id: 'voltage' as const, title: 'Діапазон напруги', slots: ['batteries', 'motors', 'esc', 'flight-controllers', 'props'] };
  const S = bat ? Number(arr(bat.specs, 'cells')[0]) : NaN;
  if (!bat || !Number.isFinite(S)) {
    return { ...base, status: 'idle', line: 'Акумулятор не обрано', detail: 'Додайте акумулятор, щоб звірити його напругу з моторами, ESC і FC.' };
  }
  const full = bat.specs.chemistry === 'LiHV' ? 4.35 : 4.2;
  const line = `Акумулятор ${S}S / ${(S * full).toFixed(1)} В за повного заряду`;
  const problems: string[] = [];
  const warns: string[] = [];
  const unknown: string[] = [];
  const supported: string[] = [];
  const parts: [string, Part | undefined, boolean][] = [['Мотори', motor, false], ['ESC', esc, true], ['FC', fc, true]];
  for (const [label, p, strictLow] of parts) {
    if (!p) continue;
    const cells = arr(p.specs, 'cells').map(Number).filter(Number.isFinite);
    if (!cells.length) { unknown.push(label); continue; }
    const lo = Math.min(...cells), hi = Math.max(...cells);
    if (S > hi) problems.push(`${label} розраховані на ${lo === hi ? `${hi}S` : `${lo}–${hi}S`}, а акумулятор ${S}S — ризик пошкодження`);
    else if (S < lo) (strictLow ? problems : warns).push(`${label} розраховані на ${lo === hi ? `${lo}S` : `${lo}–${hi}S`}; на ${S}S ${strictLow ? 'можуть не запуститися' : 'тяга буде нижчою за очікувану'}`);
    else supported.push(label);
  }
  // Евристика обертів без навантаження: kv × номінальна напруга проти межі за діаметром пропелера.
  const kv = motor ? num(motor.specs, 'kv') : undefined;
  const d = prop ? num(prop.specs, 'diameter_inch') : undefined;
  if (kv && d) {
    const rpm = kv * S * 3.7;
    const limit = 240000 / d;
    if (rpm > limit) warns.push(`оберти без навантаження ≈ ${Math.round(rpm / 1000)} тис./хв — для ${d}″ пропелера це забагато, мотор може перегріватися`);
  }
  if (problems.length) return { ...base, status: 'fail', line, detail: problems.join('; ') + '.' };
  if (warns.length) return { ...base, status: 'warn', line, detail: warns.join('; ') + '.' };
  if (unknown.length) {
    return { ...base, status: 'open', line, detail: `Для: ${unknown.join(', ')} у каталозі немає діапазону напруги — звірте його з даними виробника${supported.length ? `. ${supported.join(', ')} підтримують ${S}S` : ''}.` };
  }
  const who = supported.length ? supported.join(', ') : 'Додані деталі';
  return { ...base, status: 'ok', line, detail: `${who} підтримують ${S}S. Периферія, проводка й захист від стрибків напруги не перевірені.` };
}

function checkCurrent(by: (c: string) => Part | undefined, motorCount: number): Check {
  const bat = by('batteries'), motor = by('motors'), esc = by('esc'), fc = by('flight-controllers');
  const base = { id: 'current' as const, title: 'Струмове навантаження', slots: ['motors', 'batteries', 'esc', 'flight-controllers', 'props'] };
  const peakEach = motor ? num(motor.specs, 'peak_a') : undefined;
  if (!motor) return { ...base, status: 'idle', line: 'Мотори не обрано', detail: 'Додайте мотори й акумулятор, щоб оцінити струм.' };
  if (!peakEach) return { ...base, status: 'open', line: `${motor.name}: немає даних про піковий струм`, detail: 'Звірте піковий струм мотора з даними виробника.' };

  const totalPeak = peakEach * motorCount;
  const escSrc = esc ?? (fc?.specs.aio === true ? fc : undefined);
  const cont = escSrc ? num(escSrc.specs, 'continuous_a') : undefined;
  const burst = escSrc ? num(escSrc.specs, 'burst_a') : undefined;
  const capMah = bat ? num(bat.specs, 'capacity_mah') : undefined;
  const c = bat ? num(bat.specs, 'c_rating') : undefined;
  const batEst = capMah && c ? (capMah / 1000) * c : undefined;

  const metrics: Metric[] = [{ value: fmtA(totalPeak), label: `${motorCount} × ${fmtA(peakEach)} — піковий струм моторів`, ratio: 1 }];
  const notes: string[] = [];
  const st: Status[] = [];

  if (batEst !== undefined) {
    metrics.push({ value: fmtA(batEst), label: `${capMah! / 1000} А·год × ${c}C — за маркуванням`, ratio: Math.min(1, batEst / totalPeak) });
    const r = batEst / totalPeak;
    if (r >= 1) st.push('ok');
    else if (r >= 0.5) { st.push('warn'); notes.push(`${fmtA(totalPeak)} — на ${fmtA(totalPeak - batEst)} понад оцінку акумулятора. C-рейтинг не є виміряною струмовіддачею`); }
    else { st.push('fail'); notes.push(`оцінка акумулятора (${fmtA(batEst)}) менша за половину пікового струму моторів (${fmtA(totalPeak)})`); }
  }
  if (cont !== undefined) {
    metrics.push({ value: fmtA(cont), label: `ESC: безперервний струм на канал${burst ? `, імпульс ${fmtA(burst)}` : ''}`, ratio: Math.min(1, cont / peakEach) });
    if (cont >= peakEach) st.push('ok');
    else if ((burst !== undefined && burst >= peakEach) || cont >= peakEach * 0.8) { st.push('warn'); notes.push(`${fmtA(cont)} на канал ESC — на межі піку мотора (${fmtA(peakEach)})`); }
    else { st.push('fail'); notes.push(`ESC ${fmtA(cont)} на канал не витримає пік мотора ${fmtA(peakEach)}`); }
  }
  if (!st.length) return { ...base, status: 'idle', line: `Піковий струм моторів: ${fmtA(totalPeak)}`, detail: 'Додайте акумулятор і ESC, щоб порівняти з ними.', metrics };
  const status = worst(st);
  const line = batEst !== undefined ? `Мотори ${fmtA(totalPeak)} ↔ акумулятор ${fmtA(batEst)}` : `Мотори ${fmtA(totalPeak)} ↔ ESC ${fmtA(cont!)}`;
  const detail = status === 'ok'
    ? 'За даними каталогу запас по струму є. Це оцінка за маркуванням, а не вимір — звірте з тестами виробника.'
    : `${notes.join('; ')}.${cont ? ` ${fmtA(cont)} ESC — це ліміт на канал, а не на акумулятор.` : ''}`;
  return { ...base, status, line, detail, metrics };
}

function checkProp(by: (c: string) => Part | undefined): Check {
  const frame = by('frames'), prop = by('props'), motor = by('motors');
  const base = { id: 'prop' as const, title: 'Зазор пропелерів', slots: ['props', 'frames', 'motors'] };
  const d = prop ? num(prop.specs, 'diameter_inch') : undefined;
  if (!prop || d === undefined) return { ...base, status: 'idle', line: 'Пропелери не обрано', detail: 'Додайте пропелери, щоб звірити розмір із рамою та валом мотора.' };
  const max = frame ? num(frame.specs, 'max_prop_inch') : undefined;
  const bore = num(prop.specs, 'bore_mm');
  const shaft = motor ? num(motor.specs, 'shaft_mm') : undefined;
  const range = motor ? arr(motor.specs, 'prop_inch_range').map(Number) : [];
  const problems: string[] = [], warns: string[] = [];

  if (max !== undefined && d > max + 0.05) problems.push(`пропелер ${d}″ більший за межу рами ${max}″ — лопаті зачіпатимуть раму`);
  if (bore !== undefined && shaft !== undefined && bore !== shaft) problems.push(`посадковий отвір пропелера ${bore} мм не підходить до валу мотора ${shaft} мм`);
  if (range.length === 2 && (d < range[0] || d > range[1])) warns.push(`мотор розрахований на пропелери ${range[0]}–${range[1]}″, а обрано ${d}″`);

  const line = `Пропелер ${d}″${max !== undefined ? ` / межа рами — ${max}″` : ''}`;
  if (problems.length) return { ...base, status: 'fail', line, detail: problems.join('; ') + '.' };
  if (warns.length) return { ...base, status: 'warn', line, detail: warns.join('; ') + '.' };
  if (max === undefined && shaft === undefined) return { ...base, status: 'idle', line, detail: 'Додайте раму й мотори, щоб звірити зазор і посадку на вал.' };
  return { ...base, status: 'ok', line, detail: 'Діаметр у межах допуску рами' + (shaft !== undefined && bore !== undefined ? `, отвір ${bore} мм збігається з валом` : '') + '. Перевірте реальний зазор після складання.' };
}

function checkWiring(by: (c: string) => Part | undefined): Check {
  const fc = by('flight-controllers'), esc = by('esc');
  const base = { id: 'wiring' as const, title: 'FC ↔ ESC: підключення й прошивка', slots: ['flight-controllers', 'esc'] };
  if (fc?.specs.aio === true) return { ...base, status: 'ok', line: `${fc.name}: FC і ESC на одній платі`, detail: 'Проводка між FC і ESC не потрібна. Перевірте цільову плату прошивки у виробника.' };
  if (!fc || !esc) return { ...base, status: 'idle', line: 'Потрібні FC і ESC', detail: 'Додайте польотний контролер і ESC, щоб перевірити підключення.' };
  const f1 = str(fc.specs, 'stack_family'), f2 = str(esc.specs, 'stack_family');
  const target = str(fc.specs, 'betaflight_target');
  const proto = arr(esc.specs, 'protocols').join(', ');
  if (f1 && f1 === f2) {
    return { ...base, status: 'ok', line: `${fc.name} + ${esc.name}: один стек`,
      detail: `Плати з одного стека виробника — роз'єм і розпіновка збігаються${target ? `. Цільова плата Betaflight: ${target}` : ''}${proto ? `; протоколи ESC: ${proto}` : ''}.` };
  }
  const c1 = str(fc.specs, 'esc_connector'), c2 = str(esc.specs, 'fc_connector');
  if (c1 && c2 && c1 === c2) {
    return { ...base, status: 'ok', line: `Роз'єм ${c1} на обох платах`,
      detail: `Тип роз'єму збігається, але розпіновку й полярність однаково звірте за схемами${target ? `. Цільова плата Betaflight: ${target}` : ''}.` };
  }
  return { ...base, status: 'open', line: `${fc.name} ↔ ${esc.name}`,
    detail: `Невідомі розпіновка, полярність і цільова плата прошивки${target ? ` (Betaflight: ${target})` : ''}. Напруга та кріплення не гарантують сумісності.` };
}

/* ---------- головна функція ---------- */
export function checkBuild(parts: Part[]): Report {
  const by = (c: string) => parts.find((p) => p.category === c);
  const frame = by('frames');
  const motorCount = frame ? (num(frame.specs, 'motor_count') ?? 4) : 4;

  const { missing, check: comp } = checkCompleteness(parts, by, motorCount);
  const checks: Check[] = [
    ...(comp ? [comp] : []),
    checkMount(by), checkVoltage(by), checkCurrent(by, motorCount), checkProp(by), checkWiring(by),
  ];

  const counts = { ok: 0, warn: 0, fail: 0, open: 0 };
  for (const c of checks) if (c.status !== 'idle') counts[c.status]++;

  const rowStatus: Record<string, Status> = {};
  for (const p of parts) {
    const s = worst(checks.filter((c) => c.slots.includes(p.category) && c.status !== 'idle').map((c) => c.status));
    rowStatus[p.category] = s === 'idle' ? 'ok' : s;
  }

  const bits: string[] = [];
  if (counts.fail) bits.push(`${counts.fail} ${plural(counts.fail, 'помилка', 'помилки', 'помилок')}`);
  if (counts.warn) bits.push(`${counts.warn} ${plural(counts.warn, 'попередження', 'попередження', 'попереджень')}`);
  if (counts.open) bits.push(`${counts.open} ${plural(counts.open, 'незавершена перевірка', 'незавершені перевірки', 'незавершених перевірок')}`);
  let headline: string, subline: string;
  if (!parts.length) {
    headline = 'Збірка порожня';
    subline = 'Додайте деталі з каталогу або почніть з готової збірки — перевірки з’являться автоматично.';
  } else if (bits.length) {
    headline = bits.join(' · ');
    subline = missing.length
      ? `Ще не обрано: ${missing.map((m) => SLOT_NAMES[m]).join(', ')}. Перевірки по відсутніх деталях з’являться після додавання.`
      : counts.fail ? 'Є несумісності — усуньте їх перед замовленням деталей.' : 'Перевірте допустимий струм, підключення FC–ESC і прошивку.';
  } else {
    headline = missing.length ? 'Поки без помилок' : 'Усі перевірки пройдено';
    subline = missing.length ? `Ще не обрано: ${missing.map((m) => SLOT_NAMES[m]).join(', ')}.` : 'Це оцінка за даними каталогу, а не допуск до польоту.';
  }

  const weightG = parts.reduce((s, p) => s + (num(p.specs, 'weight_g') ?? 0) * units(p), 0);
  return {
    checks, counts, rowStatus, missing, headline, subline,
    totalCents: parts.reduce((s, p) => s + p.priceCents * p.quantity, 0),
    weightG: Math.round(weightG),
    unitCount: parts.reduce((s, p) => s + p.quantity, 0),
  };
}

function plural(n: number, one: string, few: string, many: string) {
  const m10 = n % 10, m100 = n % 100;
  if (m10 === 1 && m100 !== 11) return one;
  if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return few;
  return many;
}

/* ---------- підстановка деталі у збірку ---------- */
export const withPart = (parts: Part[], p: Part): Part[] => [...parts.filter((x) => x.category !== p.category), p];

/** Статус кандидата для картки каталогу: як він поведе себе у поточній збірці. */
export function annotate(parts: Part[], candidate: Part): { status: Status; text: string; note: string | null } | null {
  if (!parts.some((p) => p.category !== candidate.category)) return null;
  const rep = checkBuild(withPart(parts, candidate));
  const rel = rep.checks.filter((c) => c.id !== 'completeness' && c.slots.includes(candidate.category) && c.status !== 'idle');
  if (!rel.length) return null;
  const st = worst(rel.map((c) => c.status));
  const c = rel.find((x) => x.status === st)!;
  if (st === 'ok') return { status: 'ok', text: 'Підходить до збірки', note: null };
  if (st === 'warn') return { status: 'warn', text: `Перевірте: ${c.title.toLowerCase()}`, note: c.detail.split('. ')[0] + '.' };
  if (st === 'fail') return { status: 'fail', text: `Не сумісно: ${c.title.toLowerCase()}`, note: c.detail.split('; ')[0].replace(/\.$/, '') + '.' };
  return { status: 'open', text: 'Потрібна ручна перевірка', note: c.line };
}

/* ---------- підказки «Усуньте проблеми сумісності» ---------- */
export type Suggestion = {
  checkId: Check['id'];
  slot: string;
  purpose: string;
  product: Part | null; // null — не заміна, а список перевірок
  priceDeltaCents: number;
  spec: string;
  text: string;
  action: string;
};

const PURPOSE: Record<string, string> = {
  batteries: 'Перевірте ємність акумулятора', props: 'Зменште навантаження', esc: 'Підберіть потужніший ESC',
  motors: 'Підберіть сумісні мотори', frames: 'Підберіть сумісну раму', 'flight-controllers': 'Підберіть сумісний FC',
};
const ACTION: Record<string, string> = {
  batteries: 'Замінити акумулятор', props: 'Замінити пропелери', esc: 'Замінити ESC',
  motors: 'Замінити мотори', frames: 'Замінити раму', 'flight-controllers': 'Замінити FC',
};
const FIX_SLOTS: Record<Check['id'], string[]> = {
  completeness: [], mount: ['frames', 'flight-controllers', 'esc', 'motors'],
  voltage: ['batteries', 'motors', 'esc', 'flight-controllers'], current: ['batteries', 'props', 'esc'],
  prop: ['props', 'frames'], wiring: ['flight-controllers', 'esc'],
};

function oneLine(p: Part) {
  const s = p.specs;
  const bits: string[] = [];
  if (p.category === 'batteries') bits.push(`${arr(s, 'cells')[0]}S`, `${num(s, 'capacity_mah')} мА·год`, `${num(s, 'c_rating')}C`);
  else if (p.category === 'props') bits.push(`${num(s, 'diameter_inch')}″`, num(s, 'pitch_inch') ? `крок ${num(s, 'pitch_inch')}″` : '', num(s, 'bore_mm') ? `отвір ${num(s, 'bore_mm')} мм` : '');
  else if (p.category === 'esc') bits.push(`${num(s, 'continuous_a')} А`, `${arr(s, 'cells').join('–')}S`);
  else if (p.category === 'motors') bits.push(str(s, 'stator') ?? '', `${num(s, 'kv')}KV`, `${arr(s, 'cells').join('–')}S`);
  else if (p.category === 'frames') bits.push(`${num(s, 'wheelbase_mm')} мм`, `до ${num(s, 'max_prop_inch')}″`);
  else if (p.category === 'flight-controllers') bits.push(str(s, 'cpu') ?? '', str(s, 'stack_mount') ?? '');
  return bits.filter(Boolean).join(' · ');
}

export function suggest(parts: Part[], report: Report, catalog: Part[], max = 3): Suggestion[] {
  const out: Suggestion[] = [];
  const bad = (r: Report) => r.counts.warn + r.counts.fail * 2;
  const baseBad = bad(report);

  for (const check of report.checks) {
    if (check.status !== 'warn' && check.status !== 'fail') continue;
    for (const slot of FIX_SLOTS[check.id]) {
      const current = parts.find((p) => p.category === slot);
      if (!current) continue;
      let best: { cand: Part; rep: Report; target: Check; score: number } | null = null;
      for (const raw of catalog.filter((c) => c.category === slot && c.id !== current.id)) {
        const cand: Part = { ...raw, quantity: defaultQuantity(slot, raw.specs) };
        const rep = checkBuild(withPart(parts, cand));
        const target = rep.checks.find((c) => c.id === check.id);
        if (!target || rank[target.status] >= rank[check.status]) continue;      // має покращити цю перевірку
        if (rep.counts.fail > report.counts.fail) continue;                       // і не створити нових помилок
        if (bad(rep) > baseBad) continue;
        const score = rank[target.status] * 1000 + bad(rep) * 100 + Math.abs(cand.priceCents * cand.quantity - current.priceCents * current.quantity) / 100;
        if (!best || score < best.score) best = { cand, rep, target, score };
      }
      if (best) {
        out.push({
          checkId: check.id, slot, purpose: PURPOSE[slot], product: best.cand,
          priceDeltaCents: best.cand.priceCents * best.cand.quantity - current.priceCents * current.quantity,
          spec: oneLine(best.cand),
          text: `Після заміни: ${best.target.line.toLowerCase()}. ${best.target.status === 'ok' ? 'Перевірка пройдена за даними каталогу.' : 'Залишається попередження — звірте дані виробника.'} Повторіть перевірку після зміни.`,
          action: ACTION[slot],
        });
      }
    }
  }
  // по одній пропозиції на слот, найгостріші перевірки першими
  const seen = new Set<string>();
  const uniq = out.filter((s) => (seen.has(s.slot) ? false : (seen.add(s.slot), true))).slice(0, max);

  const wiring = report.checks.find((c) => c.id === 'wiring' && c.status === 'open');
  if (wiring && uniq.length < max + 1) {
    const fc = parts.find((p) => p.category === 'flight-controllers'), esc = parts.find((p) => p.category === 'esc');
    uniq.push({
      checkId: 'wiring', slot: 'wiring', purpose: 'Уточніть відсутні дані', product: null, priceDeltaCents: 0,
      spec: `${fc?.name ?? 'FC'} ↔ ${esc?.name ?? 'ESC'}`,
      text: 'За схемами обох плат звірте живлення, землю, сигнали ESC і цільову плату прошивки до підключення.',
      action: 'Список перевірок',
    });
  }
  return uniq;
}

export const WIRING_CHECKLIST = [
  'Збіг роз’єму FC ↔ ESC (зазвичай 8-pin JST-SH 1.0 мм) і порядку виводів за схемами обох плат.',
  'Полярність живлення (BAT/GND) і наявність конденсатора на вході ESC.',
  'Протокол моторів у Betaflight (DShot300/600) і підтримка його ESC.',
  'Цільова плата прошивки (target) FC та масштаб датчика струму зі сторінки виробника.',
  'Прошивка ESC (BLHeli_S / BLHeli_32 / AM32 / Bluejay) і напрямок обертання моторів.',
  'Перший запуск — без пропелерів, через USB і акумулятор із обмеженням струму.',
];
