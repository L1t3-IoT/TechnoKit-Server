import { useEffect, useState } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { api, formatPrice, type Category, type Product, type ProductsPage } from '../api';
import { Icon } from '../icons';
import Img from '../components/Img';
import { useBuild } from '../state/build';

const SORTS = [
  ['recommended', 'Рекомендовані'], ['price_asc', 'Ціна: від низької'],
  ['price_desc', 'Ціна: від високої'], ['name', 'За назвою'],
] as const;
const VOLTS = [[4, '4S / 14.8 В'], [6, '6S / 22.2 В'], [8, '8S / 29.6 В']] as const;
const PAGE_SIZE = 6;

function Card({ p, category }: { p: Product; category: string }) {
  const { add } = useBuild();
  return (
    <article className="pcard">
      <div className="pcard__photo">
        {p.imageUrl ? <img src={p.imageUrl} alt={p.name} className="img" /> : <Img id="__none" label="фото" alt={p.name} />}
      </div>
      <div className="pcard__body">
        <div className="pcard__id">
          <span className="muted">{category}</span>
          <h3>{p.name}</h3>
          <p className="muted">{p.description}</p>
        </div>
        {p.statusText && <p className="pcard__status">{p.statusText}</p>}
        {p.statusNote && <p className="muted">{p.statusNote}</p>}
        <div className="specs">
          {p.cardSpecs.map((s) => (<div key={s.label}><span className="muted">{s.label}</span><span>{s.value}</span></div>))}
        </div>
        <div className="pcard__foot">
          <div className="price"><strong>{formatPrice(p.priceCents)}</strong><span className="muted">{p.unitLabel}</span></div>
          <button className="btn btn--secondary btn--sm" onClick={() => add(p)}>Додати до збірки <Icon name="plus" size={15} /></button>
        </div>
      </div>
    </article>
  );
}

export default function Catalog() {
  const [params, setParams] = useSearchParams();
  const [cats, setCats] = useState<Category[]>([]);
  const [data, setData] = useState<ProductsPage | null>(null);
  const [error, setError] = useState('');
  const { parts, totalCents } = useBuild();

  const category = params.get('category') ?? '';
  const q = params.get('q') ?? '';
  const cells = (params.get('cells') ?? '').split(',').filter(Boolean);
  const inStock = params.get('inStock') === 'true';
  const sort = params.get('sort') ?? 'recommended';
  const maxPrice = params.get('maxPrice') ?? '';
  const minPrice = params.get('minPrice') ?? '';
  const page = Number(params.get('page') ?? 1);

  const set = (patch: Record<string, string>) => {
    const next = new URLSearchParams(params);
    for (const [k, v] of Object.entries(patch)) (v ? next.set(k, v) : next.delete(k));
    if (!('page' in patch)) next.delete('page');
    setParams(next);
  };
  const toggleCell = (n: number) => {
    const s = new Set(cells); const k = String(n);
    s.has(k) ? s.delete(k) : s.add(k);
    set({ cells: [...s].sort().join(',') });
  };

  useEffect(() => { api.categories().then((r) => setCats(r.items)).catch((e) => setError(e.message)); }, []);
  useEffect(() => {
    setError('');
    api.products({ category, q, cells: cells.join(','), inStock: inStock ? 'true' : '', sort, minPrice, maxPrice, page, limit: PAGE_SIZE })
      .then(setData).catch((e) => setError(e.message));
  }, [category, q, cells.join(','), inStock, sort, minPrice, maxPrice, page]); // eslint-disable-line react-hooks/exhaustive-deps

  const total = data?.total ?? 0;
  const pages = Math.max(1, Math.ceil(total / PAGE_SIZE));
  const totalAll = cats.reduce((s, c) => s + c.count, 0);
  const catName = (id: number) => cats.find((c) => c.id === id)?.name ?? '';
  const from = total ? (page - 1) * PAGE_SIZE + 1 : 0;
  const to = (page - 1) * PAGE_SIZE + (data?.items.length ?? 0);

  return (
    <div className="page page--catalog">
      <div className="cat-head">
        <h1 className="h-page">Каталог</h1>
        <label className="search">
          <Icon name="search" size={17} />
          <input key={q} type="search" placeholder="Пошук за назвою, параметрами чи SKU…" defaultValue={q}
            onKeyDown={(e) => e.key === 'Enter' && set({ q: e.currentTarget.value.trim() })} />
        </label>
      </div>

      <div className="guide-strip">
        <span className="muted">Вперше збираєте FPV? Дізнайтеся, як обрати сумісні деталі.</span>
        <Link to="/learn"><b>Посібник для початківців →</b></Link>
      </div>

      <div className="cat-layout">
        <aside className="filters">
          <div className="buildpanel">
            <h2>Моя збірка</h2>
            <p className="muted">Обрано {parts} {parts === 1 ? 'деталь' : 'деталей'}</p>
            <strong className="buildpanel__total">{formatPrice(totalCents)}</strong>
            <Link to="/checker" className="btn btn--primary btn--block">Перевірити збірку</Link>
          </div>

          <div className="fhead">
            <span><Icon name="sliders" size={15} /> <b>Фільтри</b></span>
            <button className="link-btn" onClick={() => setParams(new URLSearchParams())}>Скинути</button>
          </div>

          <div className="fgroup">
            <div className="fgroup__title"><span>Категорія</span><Icon name="minus" size={12} /></div>
            <button className={`copt${!category ? ' is-selected' : ''}`} onClick={() => set({ category: '' })}>
              <span>Усі компоненти</span><span>{totalAll}</span>
            </button>
            {cats.map((c) => (
              <button key={c.id} className={`copt${category === c.slug ? ' is-selected' : ''}`} onClick={() => set({ category: c.slug })}>
                <span>{c.name}</span><span>{c.count}</span>
              </button>
            ))}
          </div>

          <hr />
          <div className="fgroup">
            <div className="fgroup__title"><span>Напруга</span><Icon name="minus" size={12} /></div>
            {VOLTS.map(([n, label]) => (
              <label key={n} className="check">
                <input type="checkbox" checked={cells.includes(String(n))} onChange={() => toggleCell(n)} />
                <span className="check__box"><Icon name="check" size={10} /></span>
                <span>{label}</span>
              </label>
            ))}
          </div>

          <hr />
          <div className="fgroup">
            <div className="fgroup__title"><span>Ціна</span><Icon name="minus" size={12} /></div>
            <input type="range" className="range" min={0} max={150} value={maxPrice || 150} onChange={(e) => set({ maxPrice: e.target.value === '150' ? '' : e.target.value })} aria-label="Максимальна ціна" />
            <div className="prices">
              <label className="pbound">$<input type="number" min={0} placeholder="0" defaultValue={minPrice} key={`min${minPrice}`}
                onBlur={(e) => set({ minPrice: e.target.value })} /></label>
              <label className="pbound">$<input type="number" min={0} placeholder="150" defaultValue={maxPrice} key={`max${maxPrice}`}
                onBlur={(e) => set({ maxPrice: e.target.value })} /></label>
            </div>
          </div>

          <hr />
          <label className="check">
            <input type="checkbox" checked={inStock} onChange={(e) => set({ inStock: e.target.checked ? 'true' : '' })} />
            <span className="check__box"><Icon name="check" size={10} /></span>
            <span>У наявності</span>
          </label>
        </aside>

        <section className="results">
          <div className="toolbar">
            <span className="muted">{data ? `Показано ${data.items.length} із ${total} деталей` : 'Завантаження…'}</span>
            <div className="sort">
              <span className="muted">Сортування</span>
              <label className="select">
                <select value={sort} onChange={(e) => set({ sort: e.target.value === 'recommended' ? '' : e.target.value })}>
                  {SORTS.map(([v, l]) => <option key={v} value={v}>{l}</option>)}
                </select>
                <Icon name="chevronDown" size={12} />
              </label>
              <span className="sort__div" />
              <Icon name="layoutGrid" size={17} />
            </div>
          </div>

          {error && <p className="error">{error}</p>}
          {data && !data.items.length && <p className="muted">Нічого не знайдено. Спробуйте змінити фільтри.</p>}
          <div className="pgrid">
            {data?.items.map((p) => <Card key={p.id} p={p} category={catName(p.categoryId)} />)}
          </div>

          <div className="pagination">
            <span className="muted">{from}–{to} із {total}</span>
            <div className="pagination__ctrl">
              {Array.from({ length: Math.min(pages, 3) }, (_, i) => i + 1).map((n) => (
                <button key={n} className={`pg${n === page ? ' is-active' : ''}`} onClick={() => set({ page: String(n) })}>{n}</button>
              ))}
              {pages > 3 && <span className="muted">…</span>}
              <button className="btn btn--secondary btn--sm" disabled={page >= pages} onClick={() => set({ page: String(page + 1) })}>Далі <Icon name="arrowRight" size={15} /></button>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}
