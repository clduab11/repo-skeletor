feat(bootstrap): v2 â€” Claude Code + Codex CLI + Copilot, MCP catalog, pre-commit + branch protection

Drop deprecated tooling, land the production bootstrap layer, rewrite
the first-run path for non-dev users, and prepare the repo for its
Praxen debut.

Agent stack:
- Add .claude/ (settings, slash commands, subagents) for Claude Code
- Add .codex/config.toml with review/ship profiles, sandbox + approval policies
- Add .github/copilot-instructions.md for Copilot inline completions
- Add AGENTS.md + CLAUDE.md as cross-agent source of truth
- Remove .continue/ and .gemini/ entirely

MCP + automation:
- Add .mcp.json with linear/notion/github and optional context7, sentry, tavily
- Mirror MCP catalog in .codex/config.toml so Claude Code + Codex share tools
- Keep Linear<->Notion sync, sync-labels, claude.yml, ci.yml, template-protection.yml
- Harden template-protection.yml and claude.yml for the new layout

Guardrails:
- Add .pre-commit-config.yaml (gitleaks, conventional-commits, markdownlint, placeholder guard)
- Add .markdownlint.yaml with sensible defaults
- Add scripts/install-hooks.sh, scripts/apply-branch-protection.sh, scripts/check-placeholders.sh
- Add .github/branch-protection.json for declarative main-branch rules
- Expand .github/labels.yml into a 30+ label taxonomy (agent/claude|codex|copilot, type, area, priority, status)

Docs:
- Rewrite README.md as the Praxen debut front-door: badge row, three-agent stack table, 8-step quick start, two-layer architecture
- Add docs/wiki/Click-By-Click-First-Fork.md for first-time non-dev users
- Rewrite Quick-Start, Secrets-and-Environment-Setup, Template-Structure,
  Customization-Guide, Proper-Template-Usage, Common-Mistakes,
  GitHub-Actions-Architecture, Home around the new agent set
- Update CONTRIBUTING.md, docs/README.md, launcher/INTEGRATION.md to match

Housekeeping:
- Append .pre-commit-cache/ to .gitignore
- Preserve install-time placeholders ({{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, {{PROJECT_TYPE}})
  and whitelist runtime placeholders ({{USER}}, {{LINEAR_ID}}, {{DESCRIPTION}},
  {{VERCEL_PROJECT_ID}}, {{PLACEHOLDER}}, {{PLACEHOLDERS}}) in scripts/check-placeholders.sh

Kicks off the Praxen bootstrap layer. Built by Praxen Engineering.
