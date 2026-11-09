import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';
import type { Product } from '../api';

type Item = { product: Product; quantity: number };
type Ctx = {
  items: Item[]; parts: number; units: number; totalCents: number;
  add: (p: Product) => void; remove: (id: number) => void; clear: () => void;
};
const KEY = 'technokit:build:v1';
const BuildCtx = createContext<Ctx | null>(null);

export function BuildProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<Item[]>(() => {
    try { return JSON.parse(localStorage.getItem(KEY) ?? '[]') as Item[]; } catch { return []; }
  });
  useEffect(() => { try { localStorage.setItem(KEY, JSON.stringify(items)); } catch { /* ignore */ } }, [items]);

  const add = useCallback((p: Product) => setItems((cur) => {
    const hit = cur.find((i) => i.product.id === p.id);
    return hit ? cur.map((i) => (i === hit ? { ...i, quantity: i.quantity + 1 } : i)) : [...cur, { product: p, quantity: 1 }];
  }), []);
  const remove = useCallback((id: number) => setItems((cur) => cur.filter((i) => i.product.id !== id)), []);
  const clear = useCallback(() => setItems([]), []);

  const value = useMemo<Ctx>(() => ({
    items, add, remove, clear, parts: items.length,
    units: items.reduce((s, i) => s + i.quantity, 0),
    totalCents: items.reduce((s, i) => s + i.quantity * i.product.priceCents, 0),
  }), [items, add, remove, clear]);
  return <BuildCtx.Provider value={value}>{children}</BuildCtx.Provider>;
}

export function useBuild() {
  const c = useContext(BuildCtx);
  if (!c) throw new Error('useBuild поза BuildProvider');
  return c;
}
