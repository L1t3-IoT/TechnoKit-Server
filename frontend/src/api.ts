export type Category = { id: number; slug: string; name: string; count: number };
export type Product = {
  id: number; sku: string; categoryId: number; name: string; brand: string | null;
  description: string | null; priceCents: number; imageUrl: string | null; inStock: boolean;
  specs: Record<string, string | number | boolean | (string | number)[]>;
};
export type ProductsPage = { items: Product[]; total: number; page: number; limit: number };
export type User = { id: string; email: string };

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
  me: () => request<{ user: User | null }>('/auth/me'),
  login: (email: string, password: string) =>
    request<{ user: User }>('/auth/login', { method: 'POST', body: JSON.stringify({ email, password }) }),
  register: (email: string, password: string) =>
    request<{ user: User }>('/auth/register', { method: 'POST', body: JSON.stringify({ email, password }) }),
  logout: () => request<{ ok: true }>('/auth/logout', { method: 'POST' }),
};

export const formatPrice = (cents: number) => `$${(cents / 100).toFixed(2)}`;
