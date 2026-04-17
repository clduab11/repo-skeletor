# Claude Code — project instructions for {{PROJECT_NAME}}

> You are working on **{{PROJECT_NAME}}** — {{PROJECT_DESCRIPTION}}.
> Project type: `{{PROJECT_TYPE}}`. Domain: `{{PROJECT_DOMAIN}}`.
> This file is auto-loaded by Claude Code as your working-memory layer. Read it before your first action in a new session.

## Reading order

1. This file — project conventions and working agreements.
2. `docs/coding-style.md` — authoritative style guide. Defer to it when this file is silent.
3. `AGENTS.md` — cross-agent shared instructions (Codex, Cursor, Aider read this too).
4. `.github/copilot-instructions.md` — same rules, expressed for Copilot. Useful as a second opinion; do not duplicate into output.

## Hard rules

- Never commit secrets. `.env*` is gitignored; verify before every commit.
- Never downgrade TypeScript strictness. `any` is a code smell; prefer `unknown` with narrowing.
- Never swallow an error silently. Catch, classify, re-throw with context, or surface.
- Never introduce a net-new dependency without flagging the tradeoff. If it's justified, add it; if it's not, solve the problem differently.
- Conventional Commits on every commit. Subject ≤ 50 chars, imperative mood.
- Branch names: `{{USER}}/{{LINEAR_ID}}-{{DESCRIPTION}}` — these are runtime tokens resolved at branch-creation time, not by setup.sh.

## Agent topology

| Agent | Role | Invocation |
|---|---|---|
| Primary (me) | Implementation, planning, direct code changes | Default |
| `reviewer` subagent | Independent review before merge — especially for auth/payments/data layers | Auto before any merge to `main` touching those areas |
| `tester` subagent | Writes tests for untested code or regression tests for bugs | After feature lands, before PR opens |
| `security` subagent | Threat-model new features, audit sensitive diffs | Before any PR tagged `security` or `p0-critical` |

Subagent definitions live in `.claude/agents/`. Invoke them via the Task tool — never inline their prompts.

## MCP servers available

Configured in `.mcp.json` at the repo root. All auto-discover on session start:

- `filesystem` — read/write within the workspace
- `github` — PRs, issues, releases, workflow runs
- `linear` — issue tracking (OAuth on first call)
- `notion` — specs and wiki (OAuth on first call)
- `git` — advanced local git ops beyond the shell
- `memory` — persistent context across sessions
- `context7` — up-to-date library docs; use it before asserting a framework API
- `sequential-thinking` — structured problem decomposition

Use `context7` instead of guessing library APIs. Training data is older than the installed version of anything.

## Code change workflow

1. Read before editing. Never `Write` over an existing file you haven't `Read` in this session.
2. Before starting non-trivial changes, surface a brief plan — the user may redirect before you commit time to the wrong path.
3. Prefer `Edit` for small changes; reserve `Write` for new files or full rewrites.
4. After changes, run the project's local CI equivalent:
   ```bash
   pnpm lint && pnpm typecheck && pnpm test:unit
   ```
5. Commit with a Conventional Commits message. Reference the Linear ID in the footer if one applies.

## Testing

- Framework: Vitest.
- Coverage floor: 80% overall, 100% on critical paths (auth, payments, data integrity).
- Tests go in `tests/` or next to the module as `*.test.ts`.
- AAA structure (Arrange, Act, Assert) with blank-line separators.
- Mock at the module boundary, not at internal private functions.

## Things to ask about, not assume

- Schema changes that would require a migration.
- Adding a new external service or vendor integration.
- Any change that alters a public API contract.
- Deleting more than ~100 lines of existing code.
- Disabling a lint rule, a test, or a CI check.

## Placeholder taxonomy

The repo ships with two classes of `{{TOKEN}}`:

- **Install-time** — resolved by `setup.sh` on first run. Should never appear in a working repo. If you see one, `./setup.sh` was not run or was interrupted.
- **Runtime** — filled by the agent at branch-creation or per-task time. These survive setup by design:
  - `{{USER}}` — git username
  - `{{LINEAR_ID}}` — Linear ticket (e.g., `ACE-123`)
  - `{{DESCRIPTION}}` — branch-description slug
  - `{{VERCEL_PROJECT_ID}}` — only if Vercel MCP is enabled
  - `{{PLACEHOLDER}}` / `{{PLACEHOLDERS}}` — meta-references in docs

Do not rewrite runtime tokens by hand. The verifier in `setup.sh` allow-lists them explicitly.
