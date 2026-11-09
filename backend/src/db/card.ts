import type { SpecValue } from './schema.js';

type Spec = Record<string, SpecValue>;
const arr = (v: SpecValue | undefined): (string | number)[] => (Array.isArray(v) ? v : v === undefined || typeof v === 'boolean' ? [] : [v]);
const mount = (m: unknown) => (typeof m === 'string' ? `${m.replace('x', ' × ')} мм` : '—');
const cellsText = (v: SpecValue | undefined) => {
  const c = arr(v).map(Number).filter(Number.isFinite).sort((a, b) => a - b);
  if (!c.length) return '—';
  const contiguous = c.every((n, i) => i === 0 || n === c[i - 1] + 1);
  return `${contiguous && c.length > 1 ? `${c[0]}–${c[c.length - 1]}` : c.join(', ')}S LiPo`;
};

export const UNIT_LABEL: Record<string, string> = {
  frames: '/ рама', motors: '/ мотор', esc: '/ плата', 'flight-controllers': '/ плата',
  props: '/ комплект із 4 шт.', batteries: '/ акумулятор',
};

/** Дві ключові характеристики для картки каталогу. */
export function cardSpecs(category: string, s: Spec): { label: string; value: string }[] {
  switch (category) {
    case 'frames': return [{ label: 'Колісна база', value: `${s.wheelbase_mm} мм` }, { label: 'Кріплення Stack', value: arr(s.stack_mounts).map((m) => String(m).replace('x', ' × ')).join(' / ') }];
    case 'motors': return [{ label: 'Живлення', value: cellsText(s.cells) }, { label: 'Кріплення', value: mount(s.motor_mount) }];
    case 'esc': return [{ label: 'Струм', value: `${s.continuous_a} А на канал` }, { label: 'Живлення', value: cellsText(s.cells) }];
    case 'flight-controllers': return [{ label: 'Процесор', value: `Серія ${s.cpu}` }, { label: 'Кріплення', value: mount(s.stack_mount) }];
    case 'props': return [{ label: 'Діаметр', value: `${s.diameter_inch} дюйма` }, { label: 'Посадковий отвір', value: s.bore_mm ? `${s.bore_mm} мм` : 'уточніть' }];
    case 'batteries': return [{ label: 'Напруга', value: `${s.nominal_v} В номінальна` }, { label: 'Заявлений рейтинг', value: `${s.c_rating}C` }];
    default: return [];
  }
}
