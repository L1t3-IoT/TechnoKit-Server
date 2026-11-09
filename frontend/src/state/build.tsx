import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { api, type BuildLine, type Product } from '../api';

/** Кількість за замовчуванням: 4 мотори, 4 пропелери (комплекти по 4), решта — по 1. */
export const defaultQty = (p: Product) => {
  const pack = Number(p.specs.pack_qty ?? 1) || 1;
  return p.categorySlug === 'motors' || p.categorySlug === 'props' ? Math.max(1, Math.ceil(4 / pack)) : 1;
};

type Ctx = {
  items: BuildLine[]; parts: number; units: number; totalCents: number;
  name: string; serverId: string | null;
  /** Додає деталь; у кожній категорії може бути лише одна — наступна замінює попередню. */
  add: (p: Product) => void;
  setQuantity: (id: number, q: number) => void;
  remove: (id: number) => void; clear: () => void;
  rename: (n: string) => void;
  load: (items: BuildLine[], name?: string, serverId?: string | null) => void;
  setServerId: (id: string | null) => void;
};
const KEY = 'technokit:build:v2';
const DEFAULT_NAME = 'Нова збірка';
type Stored = { items: { productId: number; quantity: number }[]; name: string; serverId: string | null };
const BuildCtx = createContext<Ctx | null>(null);

const readStored = (): Stored => {
  try {
    const raw = JSON.parse(localStorage.getItem(KEY) ?? '{}') as Partial<Stored>;
    return { items: raw.items ?? [], name: raw.name ?? DEFAULT_NAME, serverId: raw.serverId ?? null };
  } catch { return { items: [], name: DEFAULT_NAME, serverId: null }; }
};

export function BuildProvider({ children }: { children: ReactNode }) {
  const initial = useRef(readStored());
  const [items, setItems] = useState<BuildLine[]>([]);
  const [name, setName] = useState(initial.current.name);
  const [serverId, setServerId] = useState<string | null>(initial.current.serverId);
  const [ready, setReady] = useState(false);

  // У localStorage лежать лише id та кількість; актуальні ціни й характеристики підтягуємо з сервера.
  useEffect(() => {
    const stored = initial.current.items;
    if (!stored.length) { setReady(true); return; }
    api.hydrate(stored).then((r) => setItems(r.items)).catch(() => undefined).finally(() => setReady(true));
  }, []);
  useEffect(() => {
    if (!ready) return;
    const data: Stored = { items: items.map((i) => ({ productId: i.product.id, quantity: i.quantity })), name, serverId };
    try { localStorage.setItem(KEY, JSON.stringify(data)); } catch { /* ignore */ }
  }, [items, name, serverId, ready]);

  const add = useCallback((p: Product) => setItems((cur) => [...cur.filter((i) => i.product.categorySlug !== p.categorySlug), { product: p, quantity: defaultQty(p) }]), []);
  const setQuantity = useCallback((id: number, q: number) => setItems((cur) => cur.map((i) => (i.product.id === id ? { ...i, quantity: Math.min(99, Math.max(1, q)) } : i))), []);
  const remove = useCallback((id: number) => setItems((cur) => cur.filter((i) => i.product.id !== id)), []);
  const clear = useCallback(() => { setItems([]); setName(DEFAULT_NAME); setServerId(null); }, []);
  const load = useCallback((list: BuildLine[], n?: string, sid?: string | null) => { setItems(list); setName(n ?? DEFAULT_NAME); setServerId(sid ?? null); }, []);

  const value = useMemo<Ctx>(() => ({
    items, name, serverId, add, setQuantity, remove, clear, load, rename: setName, setServerId, parts: items.length,
    units: items.reduce((s, i) => s + i.quantity, 0),
    totalCents: items.reduce((s, i) => s + i.quantity * i.product.priceCents, 0),
  }), [items, name, serverId, add, setQuantity, remove, clear, load]);
  return <BuildCtx.Provider value={value}>{children}</BuildCtx.Provider>;
}

export function useBuild() {
  const c = useContext(BuildCtx);
  if (!c) throw new Error('useBuild поза BuildProvider');
  return c;
}
