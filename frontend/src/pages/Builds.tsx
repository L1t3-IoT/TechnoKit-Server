import { useEffect, useState } from 'react';
import { Link, Navigate, useNavigate } from 'react-router-dom';
import { api, formatPrice, type SavedBuild } from '../api';
import { useAuth } from '../state/auth';
import { useBuild } from '../state/build';

export default function Builds() {
  const { user, loading } = useAuth();
  const { load } = useBuild();
  const navigate = useNavigate();
  const [items, setItems] = useState<SavedBuild[] | null>(null);
  const [error, setError] = useState('');
  useEffect(() => { if (user) api.builds().then((r) => setItems(r.items)).catch((e) => setError(e.message)); }, [user]);

  if (loading) return <div className="page"><p className="muted">Завантаження…</p></div>;
  if (!user) return <Navigate to="/login?next=/builds" replace />;

  const open = async (id: string) => {
    try { const b = await api.build(id); load(b.items, b.name, b.id); navigate('/checker'); } catch (e) { setError((e as Error).message); }
  };
  const del = async (id: string) => {
    if (!confirm('Видалити збірку?')) return;
    await api.deleteBuild(id).catch((e) => setError(e.message));
    setItems((cur) => cur?.filter((b) => b.id !== id) ?? null);
  };

  return (
    <div className="page">
      <h1 className="h-page">Мої збірки</h1>
      <p className="muted">{user.email}</p>
      {error && <p className="error">{error}</p>}
      {items && !items.length && <p className="muted">Збережених збірок поки немає. <Link to="/catalog" className="t-accent"><b>Обрати деталі →</b></Link></p>}
      <div className="saved">
        {items?.map((b) => (
          <div key={b.id} className="panel saved__row">
            <div><b>{b.name}</b><p className="muted">{b.itemCount} шт. · {formatPrice(b.totalCents)} · {new Date(b.createdAt).toLocaleDateString('uk-UA')}</p></div>
            <div className="saved__actions">
              <button className="btn btn--primary btn--sm" onClick={() => open(b.id)}>Відкрити</button>
              <button className="link-btn" onClick={() => del(b.id)}>Видалити</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
