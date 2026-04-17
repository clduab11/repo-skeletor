// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// Pure SSG. `output: 'static'` is the Astro 5 default but stated explicitly
// because both deploy targets (Vercel preview + Hostinger production) require
// identical static dist/ artifacts. Adding any server adapter would diverge
// the build between targets — don't.
export default defineConfig({
  site: 'https://{{PROJECT_DOMAIN}}',
  output: 'static',
  trailingSlash: 'never',
  build: {
    format: 'directory',
    inlineStylesheets: 'auto',
    assets: '_astro',
  },
  image: {
    // Astro's built-in sharp pipeline. AVIF/WebP with JPEG fallback per brand
    // guide §10.5 (Right-sized).
    service: { entrypoint: 'astro/assets/services/sharp' },
  },
  integrations: [
    sitemap({
      filter: (page) => !page.includes('/draft/'),
      changefreq: 'monthly',
      priority: 0.8,
    }),
  ],
  vite: {
    // Defensive: prevent any dependency from accidentally pulling fonts from
    // a CDN at runtime. All font payloads come from @fontsource-variable
    // packages which Astro bundles as static assets.
    build: {
      cssCodeSplit: true,
      cssMinify: 'lightningcss',
    },
  },
});
