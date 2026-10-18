import type { Variant } from '@mpi-informatique/exercices-core';

export const base = import.meta.env.BASE_URL.replace(/\/$/, '');
export const assetUrl = (path: string): string => `${base}/${path.split('/').map(encodeURIComponent).join('/')}`;
export const exerciseUrl = (id: string, variant: Variant = 'enonce'): string => id.startsWith('private:') ? `${base}/${variant === 'enonce' ? '' : `?vue=${variant}`}#${encodeURIComponent(id)}` : `${base}/${encodeURIComponent(id)}/${variant === 'enonce' ? '' : `?vue=${variant}`}`;

export function routeId(pathname: string, hash = ''): string | undefined {
  if (hash.startsWith('#private%3A')) return decodeURIComponent(hash.slice(1));
  const match = pathname.slice(base.length).match(/^\/([^/]+)\/?$/);
  return match ? decodeURIComponent(match[1]!) : undefined;
}

export function routeVariant(search: string): Variant {
  const value = new URLSearchParams(search).get('vue');
  return value === 'corrige' || value === 'presentation' ? value : 'enonce';
}
