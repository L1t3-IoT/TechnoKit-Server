import { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { api, formatPrice, type Drone } from '../api';
import { Icon } from '../icons';
import Img from '../components/Img';
import { useBuild } from '../state/build';

const TABS = [['reference', 'Готові збірки'], ['model', 'Серійні дрони']] as const;
const SPEC_LABELS: Record<string, string> = {
  class: 'Клас', motor: 'Мотори', esc: 'ESC', battery: 'Акумулятор', wheelbase_mm: 'Колісна база, мм', fc: 'FC', motors: 'Мотори',
  props: 'Пропелери', video: 'Відео', dry_weight_g: 'Суха вага, г', max_speed_kmh: 'Макс. швидкість, км/год', size_mm: 'Розміри, мм', geometry: 'Геометрія',
};

function DroneCard({ d }: { d: Drone }) {
  const { load } = useBuild();
  const navigate = useNavigate();
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState('');
  const open = async () => {
    setBusy(true);
    try { const full = await api.drone(d.slug); load(full.items, d.name); navigate('/checker'); }
    catch (e) { setErr((e as Error).message); setBusy(false); }
  };
  const specs = Object.entries(d.specs).filter(([k]) => k !== 'note' && SPEC_LABELS[k]);
  return (
    <article className="pcard">
      <div className="pcard__photo"><Img id={`drone_${d.slug}`} alt={d.name} label="фото дрона" /></div>
      <div className="pcard__body">
        <div className="pcard__id">
          <span className="muted">{d.segment}″ · {d.cells.map((c) => `${c}S`).join('/')}{d.brand ? ` · ${d.brand}` : ''}</span>
          <h3>{d.name}</h3>
          <p className="muted">{d.summary}</p>
        </div>
        <div className="specs">
          {d.weightG && <div><span className="muted">Злітна вага</span><span>≈ {d.weightG} г</span></div>}
          {specs.slice(0, 4).map(([k, v]) => <div key={k}><span className="muted">{SPEC_LABELS[k]}</span><span>{String(v)}</span></div>)}
        </div>
        {typeof d.specs.note === 'string' && <p className="muted">{d.specs.note}</p>}
        {err && <p className="error">{err}</p>}
        <div className="pcard__foot">
          {d.kind === 'reference'
            ? <><div className="price"><strong>{formatPrice(d.totalCents)}</strong><span className="muted">{d.partCount} позицій</span></div>
                <button className="btn btn--primary btn--sm" onClick={open} disabled={busy}>Відкрити у збірці <Icon name="arrowRight" size={15} /></button></>
            : <><div className="price"><span className="muted">Довідкові дані виробника</span></div>
                {d.sourceUrl && <a className="btn btn--secondary btn--sm" href={d.sourceUrl} target="_blank" rel="noreferrer noopener">Джерело <Icon name="arrowUpRight" size={14} /></a>}</>}
        </div>
      </div>
    </article>
  );
}

export default function Drones() {
  const [tab, setTab] = useState<'reference' | 'model'>('reference');
  const [items, setItems] = useState<Drone[] | null>(null);
  const [error, setError] = useState('');
  useEffect(() => { setItems(null); api.drones(tab).then((r) => setItems(r.items)).catch((e) => setError(e.message)); }, [tab]);

  return (
    <div className="page">
      <div className="cat-head">
        <h1 className="h-page">Дрони й готові збірки</h1>
      </div>
      <div className="guide-strip">
        <span className="muted">Готові збірки складено з деталей каталогу й проходять усі перевірки сумісності. Відкрийте збірку, щоб змінити будь-яку деталь.</span>
        <Link to="/catalog"><b>До каталогу →</b></Link>
      </div>
      <div className="tabs" role="tablist">
        {TABS.map(([k, label]) => (
          <button key={k} role="tab" aria-selected={tab === k} className={`tab${tab === k ? ' is-active' : ''}`} onClick={() => setTab(k)}>{label}</button>
        ))}
      </div>
      {error && <p className="error">{error}</p>}
      {!items && !error && <p className="muted">Завантаження…</p>}
      <div className="pgrid">{items?.map((d) => <DroneCard key={d.id} d={d} />)}</div>
    </div>
  );
}
