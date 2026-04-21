type CacheEntry<T> = { data: T; expiresAt: number };
const store = new Map<string, CacheEntry<unknown>>();
export function getCached<T>(key: string): T | null {
  const e = store.get(key) as CacheEntry<T> | undefined;
  if (!e) return null;
  if (Date.now() > e.expiresAt) { store.delete(key); return null; }
  return e.data;
}
export function setCached<T>(key: string, data: T, ttlSeconds = 300): void {
  store.set(key, { data, expiresAt: Date.now() + ttlSeconds * 1000 });
}
export function invalidateCache(prefix: string): void {
  for (const key of store.keys()) { if (key.startsWith(prefix)) store.delete(key); }
}
