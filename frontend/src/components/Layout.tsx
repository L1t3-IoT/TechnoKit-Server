import { useEffect, useState } from 'react';
import { Link, NavLink, Outlet, useLocation } from 'react-router-dom';
import { Icon, Logo } from '../icons';
import { useAuth } from '../state/auth';
import { useBuild } from '../state/build';

const NAV = [
  { to: '/', label: 'Головна', end: true },
  { to: '/catalog', label: 'Каталог' },
  { to: '/checker', label: 'Перевірка збірки' },
  { to: '/drones', label: 'Дрони' },
  { to: '/learn', label: 'Навчання' },
  { to: '/notes', label: 'Нотатки' },
];
const pad = (n: number) => String(n).padStart(2, '0');

function useTheme() {
  const [theme, setTheme] = useState<'dark' | 'light'>(() => {
    try { return localStorage.getItem('technokit:theme') === 'light' ? 'light' : 'dark'; } catch { return 'dark'; }
  });
  useEffect(() => {
    document.documentElement.dataset.theme = theme;
    try { localStorage.setItem('technokit:theme', theme); } catch { /* ignore */ }
  }, [theme]);
  return [theme, () => setTheme((t) => (t === 'dark' ? 'light' : 'dark'))] as const;
}

export default function Layout() {
  const { user, logout } = useAuth();
  const [theme, toggleTheme] = useTheme();
  const { parts, units } = useBuild();
  const { pathname } = useLocation();

  useEffect(() => { window.scrollTo(0, 0); }, [pathname]);

  return (
    <>
      <header className="header">
        <div className="header__inner">
          <Link to="/" className="brand"><Logo /><span>TechnoKit</span></Link>
          <nav className="nav" aria-label="Основна навігація">
            {NAV.map((l) => (
              <NavLink key={l.to} to={l.to} end={l.end} className={({ isActive }) => `nav__item${isActive ? ' is-active' : ''}`}>
                {l.label}
              </NavLink>
            ))}
          </nav>
          <div className="account">
            {user ? (
              <>
                <Link to="/builds" className="icon-btn" title={`${user.email} — мої збірки`} aria-label="Мої збірки"><Icon name="user" size={19} /></Link>
                <button className="link-btn" onClick={() => logout()}>Вийти</button>
              </>
            ) : (
              <Link to="/login" className="icon-btn" title="Увійти" aria-label="Увійти"><Icon name="user" size={19} /></Link>
            )}
            <span className="account__divider" />
            <Link to="/checker" className="bag" aria-label="Збірка"><Icon name="bag" size={19} /><span>{pad(units)}</span></Link>
            <Link to="/checker" className="btn btn--secondary btn--sm">Моя збірка / {pad(parts)}</Link>
          </div>
        </div>
      </header>

      <main><Outlet /></main>

      <footer className="footer">
        <div className="footer__nav">
          <Link to="/" className="brand"><Logo /><span>TechnoKit</span></Link>
          <div className="footer__col">
            <span>Розділи</span>
            <Link to="/catalog">Каталог деталей</Link>
            <Link to="/checker">Перевірка збірки</Link>
            <Link to="/drones">Дрони й готові збірки</Link>
            <Link to="/learn">Навчання</Link>
          </div>
          <div className="footer__col">
            <span>Корисні матеріали</span>
            <Link to="/notes">Довідник кріплень</Link>
            <Link to="/notes">Безпечне використання LiPo</Link>
            <Link to="/notes">Нотатки</Link>
          </div>
          <p className="footer__note">Дані деталей зібрано зі сторінок виробників і магазинів; ціни орієнтовні. Перевірка сумісності — попередня оцінка, не допуск до польоту.</p>
        </div>
        <div className="footer__register">
          <span>© 2026 TechnoKit</span>
          <button className="link-btn" onClick={toggleTheme}>{theme === 'dark' ? 'Світла тема' : 'Темна тема'}</button>
        </div>
      </footer>
    </>
  );
}
