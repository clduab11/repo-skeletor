# AGENTS.md — shared instructions for all coding agents on {{PROJECT_NAME}}

> This file is the **source of truth** when multiple AI agents disagree.
> Read it before your first action. Every agent (Claude Code, Codex CLI, Cursor, Aider, Copilot) is expected to respect what's written here.

## What this file is for

Coding agents ship to the same repo. They have different strengths, different context windows, and different default behaviors — and if each one follows its own rulebook, the repo drifts. `AGENTS.md` exists to make the rulebook **singular and portable**.

When an agent-specific file (`CLAUDE.md`, `.github/copilot-instructions.md`, `.codex/config.toml`) conflicts with this file, **AGENTS.md wins**. Agent-specific files are allowed to *add* detail, but they cannot *override* the rules here.

## Reading order (every agent)

1. **AGENTS.md** (this file) — shared rules, tone, constraints.
2. **docs/coding-style.md** — authoritative style guide. Defer to it when this file is silent.
3. **Agent-specific file** — e.g. `CLAUDE.md` for Claude Code, `.codex/config.toml` for Codex, `.github/copilot-instructions.md` for Copilot. Use it for agent-only nuance (sandbox modes, subagent topology).
4. **`docs/wiki/`** — runbooks, deep-dives, historical decisions. Pull in on demand.

## Hard rules — shared across all agents

These apply whether you're Claude, Codex, Cursor, Aider, or Copilot. Breaking one of these is a bug, not a judgment call.

- **Never commit secrets.** `.env*` is gitignored. Verify `git diff --cached` before every commit.
- **Never downgrade TypeScript strictness.** `any` is a code smell; prefer `unknown` with narrowing. Do not disable `strict`, `noImplicitAny`, or `strictNullChecks`.
- **Never swallow an error silently.** Catch, classify, re-throw with context, or surface to the caller.
- **Never add a net-new dependency without flagging the tradeoff.** If it's justified, add it with a one-line rationale in the commit message. If it's not, solve the problem without a new package.
- **Never force-push `main`.** Feature branches only. Always `--force-with-lease` when force-pushing a feature branch.
- **Conventional Commits on every commit.** Subject ≤ 50 chars, imperative mood. Types: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `ci`, `perf`, `revert`.
- **Branch names: `{{USER}}/{{LINEAR_ID}}-{{DESCRIPTION}}`** — these are runtime tokens resolved at branch-creation time, not by `setup.sh`.

## Code change workflow — shared

1. **Read before editing.** Never overwrite a file you haven't read in this session.
2. **Surface a brief plan for non-trivial work** before committing time to it. A user or reviewer may redirect you.
3. **Small edits over full rewrites.** Reserve full-file replacement for new files or intentional rewrites.
4. **Run the local CI equivalent** after changes:
   ```bash
   pnpm lint && pnpm typecheck && pnpm test:unit
   ```
5. **Commit with Conventional Commits.** Reference the Linear ID in the footer when one applies: `Refs ACE-123`.

## Things to ask about, not assume

These changes require human sign-off before merging. Open a PR draft and flag the reviewer:

- Schema changes that would require a migration.
- Adding a new external service or vendor integration.
- Any change that alters a public API contract.
- Deleting more than ~100 lines of existing code.
- Disabling a lint rule, a test, or a CI check.

## MCP servers — shared catalog

All agents have access to the same MCP servers. Config lives in:

- `.mcp.json` — Claude Code's native format
- `.codex/config.toml` `[mcp_servers.*]` — Codex's native format

Keep them in sync when adding or removing servers.

| Server | Transport | What it's for |
|---|---|---|
| `filesystem` | stdio | Read/write within the workspace |
| `github` | stdio | PRs, issues, releases, workflow runs |
| `git` | stdio | Advanced local git ops beyond the shell |
| `memory` | stdio | Persistent context across sessions |
| `sequential-thinking` | stdio | Structured problem decomposition |
| `linear` | http | Issue tracking (OAuth on first call) |
| `notion` | http | Specs and wiki (OAuth on first call) |
| `context7` | http | Up-to-date library docs — use before asserting a framework API |

**Rule:** prefer `context7` over memory when checking a library's API. Training data is older than the installed version of anything.

## Testing — shared

- **Framework:** Vitest.
- **Coverage floor:** 80% overall, 100% on critical paths (auth, payments, data integrity).
- **Location:** `tests/` or next to the module as `*.test.ts`.
- **Structure:** AAA (Arrange, Act, Assert) with blank-line separators.
- **Mock scope:** at the module boundary, never at internal private functions.

## Agent-specific files — what lives where

| File | Owner agent | Scope |
|---|---|---|
| `AGENTS.md` (this file) | All | Shared rules, reading order, hard constraints |
| `CLAUDE.md` | Claude Code | Subagent topology (`reviewer`, `tester`, `security`), MCP discovery, Claude-specific workflow |
| `.codex/config.toml` | Codex CLI | Sandbox modes, approval policy, profile definitions |
| `.github/copilot-instructions.md` | GitHub Copilot | Inline-suggestion bias, Copilot-specific style cues |
| `.cursorrules` or `.cursor/rules/` | Cursor | Cursor-specific UI/composer rules (only if enabled) |

If you're reading this as an agent that doesn't have a dedicated file, default to everything in `AGENTS.md` + `docs/coding-style.md` and you'll be fine.

## Placeholder taxonomy

The repo ships with two classes of `{{TOKEN}}` placeholder:

- **Install-time** — resolved by `setup.sh` on first run. Should never appear in a working repo. If you see one, `./setup.sh` was not run or was interrupted.
- **Runtime** — filled by the agent at branch-creation or per-task time. These survive setup by design:
  - `{{USER}}` — git username
  - `{{LINEAR_ID}}` — Linear ticket (e.g., `ACE-123`)
  - `{{DESCRIPTION}}` — branch-description slug
  - `{{VERCEL_PROJECT_ID}}` — only if Vercel MCP is enabled
  - `{{PLACEHOLDER}}` / `{{PLACEHOLDERS}}` — meta-references in docs

**Do not rewrite runtime tokens by hand.** The verifier in `setup.sh` allow-lists them explicitly.

## When agents disagree

1. Re-read this file — the disagreement is usually resolved by a rule that one agent didn't consult.
2. If the disagreement is about *implementation strategy*, surface both options to the user. Don't silently pick one.
3. If the disagreement is about *policy* (secrets, dependencies, CI, migrations), the more conservative position wins.
4. If the rule doesn't exist yet and you had to invent one, propose adding it here in the same PR.

## How to propose a change to this file

`AGENTS.md` changes are higher-stakes than normal code changes because every agent reads them. Follow this rule:

- Small wording fix? Normal PR, one reviewer.
- New rule that constrains future work? PR + explicit sign-off from the repo owner, and link the PR from Linear so it shows up in retrospectives.
