import { createContext, useCallback, useContext, useEffect, useState, type ReactNode } from 'react';
import { api, type User } from '../api';

type Ctx = { user: User | null; loading: boolean; setUser: (u: User | null) => void; logout: () => Promise<void> };
const AuthCtx = createContext<Ctx | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  useEffect(() => { api.me().then((r) => setUser(r.user)).catch(() => setUser(null)).finally(() => setLoading(false)); }, []);
  const logout = useCallback(async () => { await api.logout().catch(() => undefined); setUser(null); }, []);
  return <AuthCtx.Provider value={{ user, loading, setUser, logout }}>{children}</AuthCtx.Provider>;
}

export function useAuth() {
  const c = useContext(AuthCtx);
  if (!c) throw new Error('useAuth поза AuthProvider');
  return c;
}
