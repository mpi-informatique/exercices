import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  output: 'static',
  site: process.env.SITE_URL || 'https://mpi-informatique.github.io',
  base: process.env.BASE_PATH || '/',
  trailingSlash: 'always',
  integrations: [react(), sitemap({ filter: page => !/\/(?:apercu|contribution)(?:\/|$)/.test(new URL(page).pathname) })],
  vite: { plugins: [tailwindcss()], worker: { format: 'es' } },
  devToolbar: { enabled: false },
});
