# Launcher integration

The `launcher/` directory is an opt-in Astro SSG starter that sits inside the [`clduab11/repo-skeletor`](https://github.com/clduab11/repo-skeletor) bootstrap kit. The bootstrap layer (Linear↔Notion sync, multi-AI agent configs, label management, MCP server config) lives at the repo root; this directory adds the website production scaffold on top of that foundation.

## Relationship to the bootstrap layer

| Bootstrap (root)                      | Launcher (`launcher/`)                  |
|---------------------------------------|-----------------------------------------|
| `.github/workflows/` org automation   | `launcher/.github/workflows/` deploy   |
| `.claude/`, `.codex/`, `.mcp.json`    | (uses parent's agent + MCP configs)     |
| `docs/brand_guide.md`                 | Consumed by `scripts/extract-tokens.mjs`|
| `scripts/` (label-sync etc.)          | `scripts/` (extract-tokens, verify)     |
| `public/brand/` (master SVGs)         | (referenced via path, not duplicated)   |

The launcher reads `docs/brand_guide.md` from one level up (the repo root), and references brand SVGs from the repo's `public/brand/` directory either via copy or symlink (your choice — the build only cares that they end up in `launcher/public/brand/` at build time).

## If you skip the launcher

Delete the `launcher/` directory entirely. The bootstrap layer is fully independent and will keep working — the agent configs, the workflows, the label management, and the Linear↔Notion sync all live at the repo root. The only thing you lose is the website scaffold.

## If you keep the launcher

Run `setup.sh` at the repo root once. It rewrites the `{{PROJECT_NAME}}` and `{{PROJECT_DOMAIN}}` placeholders in both layers in a single pass. After that, `cd launcher && npm install && npm run dev` boots the dev server.

The `prebuild` script (`extract-tokens.mjs`) finds the brand guide via this resolution order, first hit wins:

1. `--config` argument (CLI override)
2. `../docs/brand_guide.md` (repo root, the standard skeletor layout)
3. `../docs/brand_guide_v1.md` (legacy filename)
4. `../brand_guide.md` (root, no docs/)
5. `docs/brand_guide.md` (inside the launcher itself, for standalone use)
6. `brand_guide.md` (launcher root)

## Independence guarantee

The launcher must not import from the bootstrap layer at runtime. The only cross-layer dependencies are at *build* time (token extraction) and at *workflow* time (CI invokes `npm run ci` from inside `launcher/`). The bootstrap layer's GitHub Actions workflows ignore everything under `launcher/` unless explicitly pathed.
