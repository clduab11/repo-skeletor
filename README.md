# repo-skeletor

**A working repository — not a starter kit.** Three-agent stack, Linear↔Notion sync, MCP catalog, pre-commit hardening, and branch protection wired together so the first commit on `main` is production-grade, not day-zero homework.

Open-sourced by **[Praxen Engineering](https://cld-dev.io)**. The first site shipped from this template is [**cld-dev.io**](https://cld-dev.io) itself — Astro SSG, dual-target deploy (Vercel preview + Hostinger production), Lighthouse 95+ on every route.

[![License: MIT](https://img.shields.io/badge/license-MIT-1d2330.svg?style=flat-square)](./LICENSE)
[![Astro](https://img.shields.io/badge/astro-5.x-bc52ee.svg?style=flat-square)](https://astro.build)
[![Claude Code](https://img.shields.io/badge/agent-claude--code-cc785c.svg?style=flat-square)](https://docs.claude.com/en/docs/claude-code)
[![Codex CLI](https://img.shields.io/badge/agent-codex--cli-10a37f.svg?style=flat-square)](https://platform.openai.com)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-fab040.svg?style=flat-square)](https://pre-commit.com)

---

## The two-minute pitch

Most repo templates fail one of two ways. The tiny ones ("just a README and a LICENSE") leave you a week of yak-shaving before you can actually ship. The giant ones ("300-file starter with an opinion about everything") arrive polluted with the original author's company names, abandoned branches, and half-broken workflows. You spend an afternoon cleaning up someone else's past.

`repo-skeletor` targets the gap. One `./setup.sh` rebrands the whole tree. One `./scripts/install-hooks.sh` locks the supply chain. One `./scripts/apply-branch-protection.sh` keeps `main` honest. What you see in this repo is exactly what you get — no `template/` shadow directory, no orphaned `.yml` at root that GitHub silently ignores, no vendor-specific breadcrumbs to sweep up.

If you've run `docker compose up` for Open WebUI or Ollama once, you already know enough to finish the walkthrough below in under twenty minutes.

---

## What you get

### The three-agent stack — shared catalog, different postures

| Agent | Where it runs | What it owns | Reads |
|---|---|---|---|
| **[Claude Code](https://docs.claude.com/en/docs/claude-code)** | Local CLI + GitHub Action (`@claude` mentions) | Subagents, slash commands, PR auto-review | `.claude/`, `AGENTS.md`, `CLAUDE.md`, `.mcp.json` |
| **[Codex CLI](https://platform.openai.com)** | Local CLI with sandboxed approvals | Implementation under `review`/`ship` profiles | `.codex/config.toml`, `AGENTS.md` |
| **[GitHub Copilot](https://github.com/features/copilot)** | Editor inline completions | Day-to-day typing assist | `.github/copilot-instructions.md` |

All three read the same style guide (`docs/coding-style.md`), the same hard rules (`AGENTS.md`), and — for Claude Code and Codex — the same MCP server catalog (`.mcp.json`, mirrored into `.codex/config.toml`). Switch agents without re-teaching them the rules.

### The MCP catalog (default)

`filesystem` · `github` · `git` · `memory` · `sequential-thinking` · `linear` (HTTP+OAuth) · `notion` (HTTP+OAuth) · `context7` (up-to-date library docs)

Add your own server in `.mcp.json`, mirror it in `.codex/config.toml`, push. Both agents pick it up on next session.

### The automation layer

- **`ci.yml`** — lint, type-check, test, build, security audit
- **`claude.yml`** — `@claude` mentions + automatic PR review citing `docs/coding-style.md` and `AGENTS.md`
- **`deploy.yml`** — staging on merge to `main`, production on tag
- **`linear-to-notion-sync.yml` / `notion-to-linear-sync.yml`** — bidirectional sync so specs and tickets can't drift
- **`sync-labels.yml`** — `.github/labels.yml` is the single source of truth; labels reconcile on change
- **`template-protection.yml`** — blocks commits that look project-specific from polluting the template

### The guardrails

- **Pre-commit framework** — [gitleaks](https://github.com/gitleaks/gitleaks) blocks committed secrets, [conventional-pre-commit](https://github.com/compilerla/conventional-pre-commit) enforces Conventional Commits, [markdownlint](https://github.com/DavidAnson/markdownlint) keeps docs tidy, a repo-local hook blocks unresolved `{{PLACEHOLDERS}}`.
- **Declarative branch protection** — `.github/branch-protection.json` + `./scripts/apply-branch-protection.sh`. Required status checks, one approving review, linear history, no force pushes, no deletions.
- **Label taxonomy** — 30+ canonical labels covering triage, agent attribution (`agent/claude`, `agent/codex`, `agent/copilot`), review state, and risk (`security`, `breaking-change`, `migration-required`).

---

## Quick start

> **Don't `git clone` this repo directly.** Cloning copies the template's commit history into your new project and the `setup.sh` guard detects it. Use **"Use this template"** — it gives you a clean repo with zero baggage.

### Step 1 — Create your repo from the template

1. Go to **[github.com/clduab11/repo-skeletor](https://github.com/clduab11/repo-skeletor)**.
2. Click the green **"Use this template"** button at the top-right → **"Create a new repository"**.
3. Pick an owner, give the repo a kebab-case name (`my-project`, not `My_Cool_Thing`), add a one-sentence description.
4. Leave **"Include all branches"** unchecked. You want `main` only.
5. Click **"Create repository"**.

### Step 2 — Clone your new repo

```bash
git clone https://github.com/YOU/your-project.git
cd your-project
```

On Windows, use **Git Bash** or **WSL2** — the scripts assume a POSIX shell. If git asks for credentials, paste a [personal access token](https://github.com/settings/tokens), not your account password (GitHub stopped accepting passwords in 2021).

### Step 3 — Run the configurator

```bash
./setup.sh
```

Answers six to eight prompts (project name, Linear team prefix, deploy target, author info), then rewrites every `{{PLACEHOLDER}}` across the config files in one pass. Square-bracket defaults are almost always right for a first-time fork.

### Step 4 — Fill in `.env`

```bash
cp .env.example .env
```

Edit `.env` with the keys you actually need. Triage table:

| Key | Purpose | Where | Day-one? |
|---|---|---|---|
| `ANTHROPIC_API_KEY` | Claude Code (CLI + Action) | [console.anthropic.com](https://console.anthropic.com) → API Keys | **Yes** |
| `OPENAI_API_KEY` | Codex CLI | [platform.openai.com/api-keys](https://platform.openai.com/api-keys) | Optional |
| `LINEAR_API_KEY` | Linear MCP + sync workflow | Linear → Settings → API → Personal API keys | Only if using Linear |
| `NOTION_API_KEY` | Notion MCP + sync workflow | [notion.so/my-integrations](https://www.notion.so/my-integrations) | Only if using Notion |
| `GITHUB_TOKEN` | GitHub MCP (local), auto-provided in Actions | [github.com/settings/tokens](https://github.com/settings/tokens) — `repo` + `workflow` scopes | **Yes** |

Narrowest scope that works is the right scope. You're not minting an admin key.

### Step 5 — Install pre-commit hooks

```bash
./scripts/install-hooks.sh
```

Installs via `pipx`, `brew`, or `pip3` (whichever you have) and wires in `pre-commit`, `commit-msg`, and `pre-push` hook types. First run warms the cache (~60s); subsequent commits are near-instant.

### Step 6 — Set GitHub Actions secrets

Install the [`gh` CLI](https://cli.github.com) if you don't have it, run `gh auth login` once, then:

```bash
gh secret set ANTHROPIC_API_KEY
gh secret set OPENAI_API_KEY
gh secret set LINEAR_API_KEY
gh secret set NOTION_API_KEY
```

Paste each secret when prompted. GitHub encrypts them on submission — the CLI cannot read them back.

### Step 7 — Apply branch protection (optional but recommended)

```bash
./scripts/apply-branch-protection.sh
```

Reads `.github/branch-protection.json`, calls the GitHub API, applies the full ruleset atomically. Re-run any time you edit the JSON.

### Step 8 — First commit

```bash
git add -A
git commit -m "chore: initial setup"
git push
```

The pre-commit hooks run locally before the push. If anything fails, fix the flagged item and re-commit — don't `--no-verify` on your first push. Once it lands, check the **Actions** tab on GitHub; CI should go green within a minute or two.

### When things go wrong

| Symptom | Cause | Fix |
|---|---|---|
| `./setup.sh: command not found` | Not executable | `chmod +x setup.sh scripts/*.sh` |
| `git clone` asks for a password | Using account password | Paste a [PAT](https://github.com/settings/tokens) instead |
| Pre-commit fails: "unresolved placeholder" | `setup.sh` didn't finish | Re-run `./setup.sh` from repo root |
| `gh secret set`: "not a git repository" | Wrong directory | `cd your-project` first |
| Claude workflow fails with 401 | Secret missing/mistyped | `gh secret list` — names must match exactly |
| Commit rejected: "found potential secret" | `gitleaks` caught a key in the diff | Remove the literal, store in `.env`, recommit |

**Deeper docs:**

- [`docs/wiki/Click-By-Click-First-Fork.md`](./docs/wiki/Click-By-Click-First-Fork.md) — screen-by-screen for non-dev first-timers
- [`docs/wiki/Quick-Start-Guide.md`](./docs/wiki/Quick-Start-Guide.md) — abbreviated walkthrough
- [`docs/wiki/Common-Mistakes.md`](./docs/wiki/Common-Mistakes.md) — mistakes to avoid before you make them
- [`docs/wiki/Proper-Template-Usage.md`](./docs/wiki/Proper-Template-Usage.md) — the one-page version of the template contract

---

## What's in the box

```
repo-skeletor/
├── .claude/
│   ├── agents/                       # Claude Code subagents (reviewer, tester, security)
│   ├── commands/                     # Slash commands (/review, /spec, /test, /doc)
│   └── settings.json                 # Permissions, hooks, integrations
├── .codex/
│   └── config.toml                   # Codex CLI: model, approval, sandbox, profiles, MCP mirror
├── .github/
│   ├── branch-protection.json        # Declarative ruleset for main
│   ├── copilot-instructions.md       # Copilot-specific guidance
│   ├── labels.yml                    # Canonical label taxonomy
│   └── workflows/
│       ├── ci.yml                    # Lint · type-check · test · build · security
│       ├── claude.yml                # @claude + auto-review
│       ├── deploy.yml                # Staging on main, prod on tag
│       ├── linear-to-notion-sync.yml
│       ├── notion-to-linear-sync.yml
│       ├── sync-labels.yml
│       └── template-protection.yml
├── .mcp.json                         # Native MCP catalog (Claude Code + mirrored by Codex)
├── .pre-commit-config.yaml           # Hooks: gitleaks, conventional, markdownlint, placeholder-guard
├── .markdownlint.yaml
├── AGENTS.md                         # Cross-agent source of truth (read first)
├── CLAUDE.md                         # Claude-specific nuance
├── FORK_AND_CUSTOMIZE.md             # Customization checklist
├── docs/
│   ├── brand_guide.md                # Skeletor's own brand (warm-shifted; distinct from Praxen)
│   ├── coding-style.md               # Tool-neutral style authority
│   └── wiki/                         # Long-form docs
├── public/brand/                     # Skeletor mark, wordmark, dialect variants
├── launcher/                         # Optional: Astro 5 SSG starter (delete if not a site)
├── scripts/
│   ├── install-hooks.sh              # Pre-commit installer
│   ├── apply-branch-protection.sh    # gh api PUT wrapper
│   └── check-placeholders.sh         # Guard against unresolved {{TOKENS}}
├── CONTRIBUTING.md
├── LICENSE                           # MIT
├── README.md
└── setup.sh                          # One-shot configurator
```

---

## The two layers

### Layer 1 — Bootstrap *(always installed)*

The part that earns its keep on every repo — CLI, API, Python package, static site, anything. Assumes you live in a Linear ↔ Notion ↔ GitHub triangle, talk to coding agents from inside your editor, and want one PR-review pipeline catching the obvious stuff before a human reviews.

### Layer 2 — Launcher *(opt-in, under `launcher/`)*

A production Astro 5 SSG starter — the actual scaffold that produced `cld-dev.io`, generalised. Not a hello-world.

- **Brand-guide-as-source-of-truth.** A Node prebuild step reads `docs/brand_guide.md` and emits CSS custom properties. Colors live in one place: the markdown.
- **Three layout dialects** — Dense, Editorial, Sparse. Pick the one matching your content register.
- **Self-hosted SVG lockups** that respond to `currentColor`. Theming is one line of CSS.
- **Dual-target deploy** — same `dist/` ships to Vercel preview on every PR and Hostinger (or any static host) on merge to `main`.
- **Pre-deploy grep gate** — blocks the build if any string from a configurable deny-list (deprecated brand names, debug flags, secrets) reaches the output.

The launcher is fully independent of the bootstrap layer. `rm -rf launcher/` if you're not building a marketing site — nothing else references it.

```bash
cd launcher
nvm use                 # Node 20+ (see .nvmrc)
npm install
npm run dev             # local dev server on :4321
npm run build           # SSG → dist/
npm run verify          # grep dist/ against verify.config.json
npm run ci              # build + verify (what GitHub Actions runs)
```

Deeper docs: [`launcher/README.md`](./launcher/README.md) · [`launcher/INTEGRATION.md`](./launcher/INTEGRATION.md) · [`docs/brand_guide.md`](./docs/brand_guide.md)

---

## Attribution

Built and maintained by **[Praxen Engineering](https://cld-dev.io)** — the production-systems arm of [Praxen, LLC](https://cld-dev.io). Praxen ships bespoke AI apps, agentic systems, and legal tech; `repo-skeletor` is the in-house template Praxen uses to start every new project, open-sourced under MIT so you don't have to reinvent it.

Issues, feedback, and PRs welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) for the contributor guide — note the distinction between contributing *to the template itself* vs. contributing to a project you forked from it.

---

## License

[MIT](./LICENSE) — do what you like with it, no warranty, please don't blame Praxen if your deploy breaks.
