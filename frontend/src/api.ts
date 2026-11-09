export type Category = { id: number; slug: string; name: string; count: number };
export type Product = {
  id: number; sku: string; categoryId: number; categorySlug: string; name: string; brand: string | null;
  verified: boolean; sourceUrl: string | null;
  description: string | null; priceCents: number; imageUrl: string | null; inStock: boolean;
  unitLabel: string | null; cardSpecs: { label: string; value: string }[];
  statusText: string | null; statusNote: string | null;
  specs: Record<string, string | number | boolean | (string | number)[]>;
};
export type ProductsPage = { items: Product[]; total: number; page: number; limit: number };
export type User = { id: string; email: string };

export type Status = 'ok' | 'warn' | 'fail' | 'open' | 'idle';
export type Check = {
  id: 'completeness' | 'mount' | 'voltage' | 'current' | 'prop' | 'wiring';
  title: string; status: Status; line: string; detail: string; slots: string[];
  metrics?: { value: string; label: string; ratio: number }[];
};
export type Report = {
  checks: Check[]; counts: { ok: number; warn: number; fail: number; open: number };
  rowStatus: Record<string, Status>; missing: string[]; headline: string; subline: string;
  totalCents: number; weightG: number; unitCount: number;
};
export type Suggestion = {
  checkId: Check['id']; slot: string; purpose: string; product: { id: number; name: string; category: string } | null;
  priceDeltaCents: number; spec: string; text: string; action: string;
};
export type CheckResponse = { report: Report; suggestions: Suggestion[]; wiringChecklist: string[] };
export type Annotation = { status: Status; text: string; note: string | null } | null;
export type BuildLine = { product: Product; quantity: number };

export type Drone = {
  id: number; slug: string; name: string; brand: string | null; kind: 'model' | 'reference'; segment: string;
  propInch: number | null; cells: number[]; weightG: number | null; summary: string | null;
  specs: Record<string, string | number | boolean | (string | number)[]>; imageUrl: string | null; sourceUrl: string | null;
  verified: boolean; partCount: number; totalCents: number;
};
export type DroneDetail = Drone & { items: BuildLine[]; report: Report | null };
export type SavedBuild = { id: string; name: string; createdAt: string; itemCount: number; totalCents: number };

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`/api${path}`, {
    credentials: 'include',
    headers: { 'Content-Type': 'application/json' },
    ...init,
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error((data as { error?: string }).error ?? `Помилка ${res.status}`);
  return data as T;
}

export const api = {
  categories: () => request<{ items: Category[] }>('/categories'),
  products: (params: Record<string, string | number | undefined>) => {
    const qs = new URLSearchParams();
    for (const [k, v] of Object.entries(params)) if (v !== undefined && v !== '') qs.set(k, String(v));
    return request<ProductsPage>(`/products?${qs}`);
  },
  stats: () => request<{ products: number; categories: number; drones: number; voltages: number }>('/stats'),
  check: (items: { productId: number; quantity: number }[]) =>
    request<CheckResponse>('/compat/check', { method: 'POST', body: JSON.stringify({ items }) }),
  annotate: (items: { productId: number; quantity: number }[], productIds: number[]) =>
    request<{ items: Record<number, Annotation> }>('/compat/annotate', { method: 'POST', body: JSON.stringify({ items, productIds }) }),
  hydrate: (items: { productId: number; quantity: number }[]) =>
    request<{ items: BuildLine[] }>('/compat/hydrate', { method: 'POST', body: JSON.stringify({ items }) }),
  drones: (kind?: string) => request<{ items: Drone[] }>(`/drones${kind ? `?kind=${kind}` : ''}`),
  drone: (slug: string) => request<DroneDetail>(`/drones/${slug}`),
  builds: () => request<{ items: SavedBuild[] }>('/builds'),
  build: (id: string) => request<{ id: string; name: string; items: BuildLine[] }>(`/builds/${id}`),
  createBuild: (name: string) => request<{ id: string }>('/builds', { method: 'POST', body: JSON.stringify({ name }) }),
  renameBuild: (id: string, name: string) => request<{ ok: true }>(`/builds/${id}`, { method: 'PATCH', body: JSON.stringify({ name }) }),
  saveBuildItems: (id: string, items: { productId: number; quantity: number }[]) =>
    request<{ ok: true }>(`/builds/${id}/items`, { method: 'PUT', body: JSON.stringify({ items }) }),
  deleteBuild: (id: string) => request<{ ok: true }>(`/builds/${id}`, { method: 'DELETE' }),
  me: () => request<{ user: User | null }>('/auth/me'),
  login: (email: string, password: string) =>
    request<{ user: User }>('/auth/login', { method: 'POST', body: JSON.stringify({ email, password }) }),
  register: (email: string, password: string) =>
    request<{ user: User }>('/auth/register', { method: 'POST', body: JSON.stringify({ email, password }) }),
  logout: () => request<{ ok: true }>('/auth/logout', { method: 'POST' }),
};

export const formatPrice = (cents: number) => `$${(cents / 100).toFixed(2)}`;
