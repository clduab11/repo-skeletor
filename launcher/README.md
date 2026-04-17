# Launcher — Astro 5 SSG starter

Optional production website starter that ships inside [`clduab11/repo-skeletor`](https://github.com/clduab11/repo-skeletor). Pure static build (no server runtime), brand-tokens generated from a markdown brand guide, dual-target deploy ready (Vercel preview + Hostinger / any static host for production).

> If you are not building a marketing site, **delete the `launcher/` directory entirely.** The bootstrap layer (Linear↔Notion sync, multi-AI agent configs, label management) is independent of this path.

## Stack

- **Astro 5** — `output: 'static'`, `trailingSlash: 'never'`, sitemap + Sharp image service.
- **Typography** — self-hosted via `@fontsource-variable/{inter,source-serif-4}` + `@fontsource/jetbrains-mono`. No CDN font calls, no FOUT.
- **Brand tokens** — generated from `docs/brand_guide.md` (one level above `launcher/`) by `scripts/extract-tokens.mjs` on every prebuild. Editing `brand_guide.md` propagates colors and the type scale to the build with zero hand-maintained drift.
- **Pre-deploy grep gate** — `scripts/verify-no-deprecated.mjs` walks `dist/` and fails the build if any string from `verify.config.json` (or the shipped `verify.config.default.json`) appears in shipped output. Externalised so each consumer maintains their own deny-list.

## Layout dialects

The starter ships three layout registers, one per page in `src/pages/`. They map 1:1 to brand-guide §5:

| Route | Dialect | Container | Use for |
|------|---------|-----------|---------|
| `/dense` | `DenseDialect.astro` | `--max-dense` (1200px) | Catalogs, dashboards, indexes, scannable surfaces |
| `/editorial` | `EditorialDialect.astro` | `--max-editorial` (960px / 1280px bleed) | Essays, working papers, long-form |
| `/sparse` | `SparseDialect.astro` | `--max-sparse` (840px) | Forward-positioning, manifesto, coming-soon |

Replace, rename, or delete any of these. The `Lockup` and `DialectPanel` components key off the variant name (`dense` / `editorial` / `sparse`) — if you rename a route, rename its lockup SVG in `public/brand/` and the variant string in those two components.

## Local development

```bash
nvm use            # picks up .nvmrc → Node 20
npm install
npm run dev        # http://localhost:4321
```

## Build + verify

```bash
npm run build      # prebuild (extract-tokens) → astro build → dist/
npm run preview    # serves dist/ for local smoke test
npm run verify     # runs the pre-deploy grep gate against dist/
npm run ci         # build + verify, in one shot (used by CI)
```

`npm run build` is fail-closed: if `extract-tokens.mjs` cannot find or parse the brand guide, the build aborts before any HTML is emitted. Same for `verify` — a single `fatal` rule hit blocks the deploy.

## Brand-tokens contract

`scripts/extract-tokens.mjs` parses four `###` H3 sections from the brand guide:

1. `### Core palette` (anything starting with this prefix)
2. `### Neutral tonal scale` (any parenthetical OK)
3. `### Signal tonal scale`
4. `### Semantic states`

Each section must contain a fenced code block with lines of the shape:

```
--token-name   #HEXVALUE   optional comment
```

Friendly names (e.g. `Obsidian`, `Slate`) are dropped; only the `--token-name`, the hex value, and any trailing comment are emitted to `tokens.css`.

The script also hard-codes the type scale, layout dialect widths, line heights, and the dark-mode swap rules. Edit those directly in the script if your brand guide diverges from the 1.25 modular scale or the three-dialect width pattern.

## Deploy

Deploy is host-agnostic — `dist/` is plain static HTML/CSS/JS/SVG. The shipped GitHub Actions workflow under `.github/workflows/deploy-hostinger.yml` is one example (SFTP upload to Hostinger). Swap it for Vercel, Cloudflare Pages, S3, or whatever your target is. The build artifact is the contract.

## What `setup.sh` rewrites

When the parent repo-skeletor `setup.sh` runs, it sweeps the launcher and rewrites these placeholders:

- `{{PROJECT_NAME}}` → your project's display name (used in lockup alt text, header aria-label, footer attribution, page titles)
- `{{PROJECT_DOMAIN}}` → your production domain (used in `Base.astro` for canonical URLs, `mailto:` addresses in header/footer)

If you copied the launcher manually, grep for `{{PROJECT_` and rewrite by hand.

## Customising

The minimum surgery to make this site yours, in order:

1. Replace `public/brand/` SVGs with your own lockups (keep `currentColor` for theming).
2. Edit `docs/brand_guide.md` (the one in the repo root, one level above `launcher/`) — change the palette and the type scale to match your brand.
3. Run `npm run build` once to regenerate `src/styles/tokens.css`.
4. Edit `src/pages/index.astro` — replace the three demo panels with your real top-level destinations.
5. Edit `src/components/Header.astro` and `src/components/Footer.astro` — replace the three demo nav items with your real routes.
6. Edit or delete `src/pages/{dense,editorial,sparse}.astro` — these are demo pages for the three layout registers; keep, rename, or replace.
7. Add your project's deprecated strings to `verify.config.json` (predecessor brand names, retired domains, banned marketing terms) so the grep gate enforces them.
