import { useState, type FormEvent } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { api } from '../api';
import { useAuth } from '../state/auth';

export default function Login() {
  const [mode, setMode] = useState<'login' | 'register'>('login');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const { setUser } = useAuth();
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const next = params.get('next');

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    setBusy(true); setError('');
    try {
      const r = await (mode === 'login' ? api.login : api.register)(email, password);
      setUser(r.user);
      navigate(next && next.startsWith('/') ? next : '/builds');
    } catch (err) { setError((err as Error).message); } finally { setBusy(false); }
  };

  return (
    <div className="page auth">
      <h1 className="h-page">{mode === 'login' ? 'Вхід' : 'Реєстрація'}</h1>
      <p className="muted">Обліковий запис потрібен, щоб зберігати збірки й відкривати їх з іншого пристрою.</p>
      <form className="panel panel--pad auth__form" onSubmit={submit}>
        <label>Email<input type="email" required autoComplete="email" value={email} onChange={(e) => setEmail(e.target.value)} /></label>
        <label>Пароль (мін. 8 символів)<input type="password" required minLength={8} autoComplete={mode === 'login' ? 'current-password' : 'new-password'} value={password} onChange={(e) => setPassword(e.target.value)} /></label>
        {error && <p className="error" role="alert">{error}</p>}
        <button className="btn btn--primary btn--block" disabled={busy}>{mode === 'login' ? 'Увійти' : 'Створити акаунт'}</button>
        <button type="button" className="link-btn" onClick={() => { setMode(mode === 'login' ? 'register' : 'login'); setError(''); }}>
          {mode === 'login' ? 'Немає акаунта? Зареєструватися' : 'Уже є акаунт? Увійти'}
        </button>
      </form>
    </div>
  );
}
