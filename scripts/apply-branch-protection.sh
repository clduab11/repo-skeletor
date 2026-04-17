#!/usr/bin/env bash
# apply-branch-protection.sh — applies .github/branch-protection.json to `main`
# Requires: gh CLI authenticated (`gh auth status`) with admin:repo scope.
# Idempotent — GitHub replaces the ruleset on each call.

set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'
say()  { printf "${GREEN}✓${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}!${NC} %s\n" "$*"; }
die()  { printf "${RED}✗${NC} %s\n" "$*" >&2; exit 1; }

# ------------------------------------------------------------------
# 1. Prereqs
# ------------------------------------------------------------------
command -v gh >/dev/null 2>&1 || die "gh CLI not installed — see https://cli.github.com/"
gh auth status >/dev/null 2>&1 || die "run 'gh auth login' first"

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -z "$REPO_ROOT" ]] && die "run this from inside the repo"
cd "$REPO_ROOT"

CONFIG=".github/branch-protection.json"
[[ ! -f "$CONFIG" ]] && die "$CONFIG not found"

# ------------------------------------------------------------------
# 2. Resolve owner/repo from the origin remote
# ------------------------------------------------------------------
REMOTE_URL="$(git config --get remote.origin.url || true)"
[[ -z "$REMOTE_URL" ]] && die "no origin remote configured"

# Strip git@github.com:owner/repo.git or https://github.com/owner/repo.git
OWNER_REPO="$(echo "$REMOTE_URL" | sed -E 's#.*github\.com[:/](.+/.+)\.git$#\1#; s#.*github\.com[:/](.+/.+)$#\1#')"
[[ "$OWNER_REPO" != */* ]] && die "could not parse owner/repo from $REMOTE_URL"
say "target: $OWNER_REPO"

# ------------------------------------------------------------------
# 3. Apply protection — PUT the full ruleset
# ------------------------------------------------------------------
warn "about to replace branch protection on $OWNER_REPO:main"
warn "this is a destructive (overwriting) call — Ctrl-C within 3s to abort"
sleep 3

gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/$OWNER_REPO/branches/main/protection" \
  --input "$CONFIG" >/dev/null

say "branch protection applied to $OWNER_REPO:main"
say "verify at: https://github.com/$OWNER_REPO/settings/branches"
