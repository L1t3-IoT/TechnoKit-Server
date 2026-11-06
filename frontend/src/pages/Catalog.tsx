import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { api, formatPrice, type Category, type ProductsPage } from '../api';

export default function Catalog() {
  const [params, setParams] = useSearchParams();
  const [categories, setCategories] = useState<Category[]>([]);
  const [data, setData] = useState<ProductsPage | null>(null);
  const [error, setError] = useState('');

  const category = params.get('category') ?? '';
  const q = params.get('q') ?? '';
  const cells = params.get('cells') ?? '';
  const page = Number(params.get('page') ?? 1);

  const set = (patch: Record<string, string>) => {
    const next = new URLSearchParams(params);
    for (const [k, v] of Object.entries(patch)) (v ? next.set(k, v) : next.delete(k));
    if (!('page' in patch)) next.delete('page');
    setParams(next);
  };

  useEffect(() => { api.categories().then((r) => setCategories(r.items)).catch((e) => setError(e.message)); }, []);

  useEffect(() => {
    setError('');
    api.products({ category, q, cells, page, limit: 12 }).then(setData).catch((e) => setError(e.message));
  }, [category, q, cells, page]);

  const pages = data ? Math.max(1, Math.ceil(data.total / data.limit)) : 1;

  return (
    <div className="container">
      <h1>Каталог</h1>
      <input className="input" placeholder="Пошук за назвою, параметрами чи SKU…" defaultValue={q}
        onKeyDown={(e) => e.key === 'Enter' && set({ q: e.currentTarget.value })} />

      <div className="catalog">
        <aside className="filters">
          <h3>Категорія</h3>
          <button className={!category ? 'chip active' : 'chip'} onClick={() => set({ category: '' })}>Усі компоненти</button>
          {categories.map((c) => (
            <button key={c.id} className={category === c.slug ? 'chip active' : 'chip'} onClick={() => set({ category: c.slug })}>
              {c.name} <span className="muted">{c.count}</span>
            </button>
          ))}
          <h3>Напруга</h3>
          {['', '4', '6', '8'].map((v) => (
            <button key={v} className={cells === v ? 'chip active' : 'chip'} onClick={() => set({ cells: v })}>
              {v ? `${v}S` : 'Будь-яка'}
            </button>
          ))}
        </aside>

        <section>
          {error && <p className="error">{error}</p>}
          {!data && !error && <p className="muted">Завантаження…</p>}
          {data && <p className="muted">Показано {data.items.length} із {data.total} деталей</p>}
          <div className="grid">
            {data?.items.map((p) => (
              <article key={p.id} className="card">
                <div className="card__img">{p.imageUrl ? <img src={p.imageUrl} alt={p.name} /> : <span className="muted">фото</span>}</div>
                <h4>{p.name}</h4>
                <p className="muted">{p.description}</p>
                <div className="card__foot">
                  <strong>{formatPrice(p.priceCents)}</strong>
                  <button className="btn" disabled>Додати до збірки</button>
                </div>
              </article>
            ))}
          </div>
          {data && pages > 1 && (
            <div className="row">
              <button className="btn" disabled={page <= 1} onClick={() => set({ page: String(page - 1) })}>Назад</button>
              <span className="muted">{page} / {pages}</span>
              <button className="btn" disabled={page >= pages} onClick={() => set({ page: String(page + 1) })}>Далі</button>
            </div>
          )}
        </section>
      </div>
    </div>
  );
}
