import { useEffect, useState } from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import { api, type User } from '../api';

const links = [
  { to: '/', label: 'Головна', end: true },
  { to: '/catalog', label: 'Каталог' },
  { to: '/checker', label: 'Перевірка збірки' },
  { to: '/learn', label: 'Навчання' },
];

export default function Layout() {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    api.me().then((r) => setUser(r.user)).catch(() => setUser(null));
  }, []);

  return (
    <>
      <header className="header">
        <div className="container header__inner">
          <NavLink to="/" className="logo">TechnoKit</NavLink>
          <nav className="nav">
            {links.map((l) => (
              <NavLink key={l.to} to={l.to} end={l.end} className={({ isActive }) => (isActive ? 'active' : '')}>
                {l.label}
              </NavLink>
            ))}
          </nav>
          <div className="header__right">
            {user ? (
              <>
                <span className="muted">{user.email}</span>
                <button className="btn" onClick={() => api.logout().then(() => setUser(null))}>Вийти</button>
              </>
            ) : (
              <span className="muted">Вхід — незабаром</span>
            )}
          </div>
        </div>
      </header>
      <main><Outlet /></main>
      <footer className="footer">
        <div className="container muted">© 2026 TechnoKit / демонстраційний каталог</div>
      </footer>
    </>
  );
}
