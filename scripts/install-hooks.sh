#!/usr/bin/env bash
# install-hooks.sh — installs pre-commit hooks for {{PROJECT_NAME}}
# Run once after cloning/forking. Idempotent — safe to re-run.

set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'
say()  { printf "${GREEN}✓${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}!${NC} %s\n" "$*"; }
die()  { printf "${RED}✗${NC} %s\n" "$*" >&2; exit 1; }

# ------------------------------------------------------------------
# 1. Confirm we're inside the repo
# ------------------------------------------------------------------
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -z "$REPO_ROOT" ]] && die "run this from inside the repo (not detected as a git working tree)"
cd "$REPO_ROOT"

# ------------------------------------------------------------------
# 2. Install pre-commit if missing
# ------------------------------------------------------------------
if ! command -v pre-commit >/dev/null 2>&1; then
  warn "pre-commit not found, attempting install…"
  if command -v pipx >/dev/null 2>&1; then
    pipx install pre-commit
  elif command -v brew >/dev/null 2>&1; then
    brew install pre-commit
  elif command -v pip3 >/dev/null 2>&1; then
    pip3 install --user pre-commit
  else
    die "install pipx, brew, or pip3 first, then re-run this script"
  fi
fi
say "pre-commit $(pre-commit --version)"

# ------------------------------------------------------------------
# 3. Wire the hooks
# ------------------------------------------------------------------
pre-commit install --hook-type pre-commit --hook-type commit-msg --hook-type pre-push
say "hooks installed: pre-commit, commit-msg, pre-push"

# ------------------------------------------------------------------
# 4. Warm the cache so first commit doesn't stall for 60s
# ------------------------------------------------------------------
pre-commit install-hooks
say "hook environments warmed"

# ------------------------------------------------------------------
# 5. Sanity run on existing tree (non-blocking)
# ------------------------------------------------------------------
if pre-commit run --all-files; then
  say "initial run clean — you're ready"
else
  warn "initial run found issues — review output above; fix or commit with --no-verify once if you know what you're doing"
fi
