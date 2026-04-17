# repo-skeletor

> Exoskeleton template for shipping production-grade repos in a weekend.

Built and maintained by [Praxen Development](https://cld-dev.io). The first site shipped from this template is [**cld-dev.io**](https://cld-dev.io) itself — Astro SSG, dual-deploy to Vercel preview + Hostinger production, Lighthouse 95+ on every route.

---

## Why this exists

Most repo templates give you one of two things:

1. **A hello-world scaffold** — cute on day one, ten days of yak-shaving once you actually need CI, secrets, agent configs, and an issue tracker that talks to your docs.
2. **A 5,000-line "starter"** — opinionated about everything, polluted with the original author's company names, half-broken on first clone.

`repo-skeletor` aims at the gap. It gives you:

- A **bootstrap layer** that wires Claude Code, Continue.dev, Gemini, Linear, Notion, GitHub Actions, MCP servers, label taxonomy, branch protection, and pre-commit hooks together — all parameterised on a small set of `{{PLACEHOLDERS}}` so a single `./setup.sh` rebrands the whole thing for your project.
- A **launcher path** (under `launcher/`) — a working Astro SSG starter that demonstrates the brand-system → site pipeline used to ship cld-dev.io. Optional. Delete the directory if you're not building a marketing site.
- A **single canonical layout**. No `template/` subdirectory shadowing the root, no orphaned root-level `.yml` files that don't trigger workflows. What you see is what runs.

---

## Quick start

> Don't `git clone` this repo. Click **"Use this template" → "Create a new repository"** on GitHub. That's the only correct way in.

```bash
# After creating YOUR repo from the template:
git clone https://github.com/YOU/your-project.git
cd your-project
./setup.sh                    # interactive: answers replace {{PLACEHOLDERS}} across configs
cp .env.example .env          # fill in API keys
gh secret set ANTHROPIC_API_KEY < ~/.api-keys/anthropic
gh secret set LINEAR_API_KEY   < ~/.api-keys/linear
gh secret set NOTION_API_KEY   < ~/.api-keys/notion
git add -A && git commit -m "chore: initial setup"
git push
```

Full walkthrough with screenshots: [`docs/wiki/Quick-Start-Guide.md`](./docs/wiki/Quick-Start-Guide.md).
First-time mistakes to avoid: [`docs/wiki/Common-Mistakes.md`](./docs/wiki/Common-Mistakes.md).

---

## What's in the box

```
repo-skeletor/
├── .claude/settings.json              # Claude Code project settings (allowed tools, prompts, integrations)
├── .continue/
│   ├── config.yaml                    # Continue.dev: models, autocomplete, slash commands, agents
│   └── mcpServers/mcp-servers.yaml    # MCP server definitions (filesystem, github, linear, notion, etc.)
├── .gemini/
│   ├── config.yaml                    # Gemini Code Assist project config
│   └── styleguide.md                  # Coding standards Gemini reads on every review
├── .github/
│   ├── copilot-instructions.md        # Repository-wide instructions Copilot/Claude pull from
│   ├── labels.yml                     # Single source of truth for issue/PR label taxonomy
│   ├── workflows/
│   │   ├── ci.yml                     # Lint, type-check, test, build, security audit
│   │   ├── claude.yml                 # @claude mentions on PRs and issues
│   │   ├── deploy.yml                 # Staging on push to main; production on tag
│   │   ├── linear-to-notion-sync.yml  # Linear webhook → Notion page update
│   │   ├── notion-to-linear-sync.yml  # Notion spec → Linear epic + sub-issues
│   │   ├── sync-labels.yml            # Apply labels.yml to the repo on change
│   │   └── template-protection.yml    # Block commits to the template that look project-specific
│   └── *.md                           # Trigger testing notes, webhook setup, quick reference
├── docs/
│   ├── brand_guide.md                 # Skeletor's own brand guide (warm-shifted, distinct from Praxen)
│   └── wiki/                          # Long-form usage docs
├── public/brand/                      # Skeletor mark, wordmark, lockups (master + 3 dialect variants)
├── launcher/                          # Optional: Astro SSG starter (delete if not building a site)
├── CONTRIBUTING.md
├── LICENSE                            # MIT
├── README.md                          # this file
└── setup.sh                           # one-shot configurator
```

---

## The two layers

### Layer 1 — Bootstrap (always installed)

This is the part that earns its keep on every repo, whether you're shipping a CLI, an API, a Python package, or a static site. It assumes you live in a Linear ↔ Notion ↔ GitHub triangle, talk to AI agents from inside your editor, and want a single PR review pipeline that catches the obvious stuff before a human looks at it.

What "polished" means relative to the previous version:

- **Single source of truth.** No more `template/` subdirectory mirroring the root. No more orphaned `ci.yml` at the repo root that GitHub silently ignores because it's not under `.github/workflows/`.
- **Vendor-neutral attribution.** Predecessor company-name strings were stripped wholesale; the Linear team prefix is now a `setup.sh` placeholder (in-repo demo uses `PRX`).
- **Workflows actually run.** `ci.yml`, `claude.yml`, and `deploy.yml` are now under `.github/workflows/` where GitHub looks for them.

### Layer 2 — Launcher (opt-in, under `launcher/`)

A complete Astro 5 SSG starter that produced [cld-dev.io](https://cld-dev.io). Not a hello-world demo — the actual production scaffold, generalised. Includes:

- A **brand-guide-as-source-of-truth pipeline**: a Node script reads `docs/brand_guide.md` and emits CSS custom properties, so the only place colours live is the markdown.
- **Three layout dialects** (Dense / Editorial / Sparse) with their own grids, type rhythms, and components — pick the one that matches your content register.
- **Self-hosted SVG lockups** that respond to `currentColor`, so theming is one line.
- **Dual-target deploy**: same `dist/` ships to a Vercel preview on every PR and to Hostinger (or any static host) on merge to main.
- **Pre-deploy grep gate**: blocks the build if any string from a configurable deny-list (deprecated brand names, debug flags, secrets) makes it into the output.

The launcher is independent of the bootstrap layer. `rm -rf launcher/` if you're not building a marketing site — nothing else in the repo references it.

---

## Using the launcher

```bash
cd launcher
nvm use                 # Node 20+ (see launcher/.nvmrc)
npm install
npm run dev             # local dev server on :4321
npm run build           # SSG build → dist/  (prebuild runs token extraction first)
npm run verify          # grep dist/ against verify.config.{json,default.json}
npm run ci              # build + verify — what GitHub Actions runs on every PR
```

### Six things to know

| You want to... | Do this |
|---|---|
| Change brand colours or type | Edit `docs/brand_guide.md` §3 (type) and §4 (palette), then `npm run prebuild` |
| Add a route | Drop a `.astro` file in `launcher/src/pages/` |
| Pick a layout register | Wrap the page in `DenseDialect`, `EditorialDialect`, or `SparseDialect` |
| Add a banned-string check | Append a rule to `launcher/verify.config.default.json` (or override per-consumer in `launcher/verify.config.json`) |
| Swap the lockup | Drop new SVGs in `launcher/public/brand/`; `Lockup.astro` reads `lockup-{master,dense,editorial,sparse}.svg` |
| Deploy | Vercel handles previews via Git integration; production ships via `.github/workflows/deploy-hostinger.yml` (SFTP) |

### Brand-guide contract

The token extractor expects four H3 sections in `docs/brand_guide.md`. If you rename them, the extractor exits non-zero — fail-closed by design.

| Heading prefix (case-insensitive) | What's parsed |
|---|---|
| `### Core palette` | Named brand colours → `--ink`, `--paper`, etc. |
| `### Neutral` | 12-step neutral tonal scale |
| `### Signal` | 7-step signal/accent scale |
| `### Semantic` | State colours (success, warn) |

Type scale lives in §3 of the guide and is also parsed. Leave the heading structure intact and you can edit colours and ratios freely.

### When to delete the launcher

If your project is a CLI, library, API, or anything that doesn't ship a public marketing site — delete the directory. The bootstrap layer (CI, agent configs, sync workflows, label taxonomy, `setup.sh`) stands alone and has zero coupling to launcher artifacts.

```bash
rm -rf launcher/
git add -A && git commit -m "chore: remove launcher (not a static-site project)"
```

### Deeper docs

- [`launcher/README.md`](./launcher/README.md) — full launcher contract, dialect rules, brand-token pipeline, customisation steps
- [`launcher/INTEGRATION.md`](./launcher/INTEGRATION.md) — how the launcher resolves the brand guide and stays decoupled from the bootstrap layer
- [`docs/brand_guide.md`](./docs/brand_guide.md) — Skeletor's own brand guide, used for the in-repo demo; replace with your own before shipping anything client-facing

---

## License

MIT — see [LICENSE](./LICENSE).
