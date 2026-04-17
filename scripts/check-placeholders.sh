#!/usr/bin/env bash
# check-placeholders.sh — pre-commit guard for unresolved {{TOKEN}} placeholders.
# Exits 1 if any non-allow-listed placeholder is found in the staged tree.
#
# Allow-listed runtime tokens (per AGENTS.md placeholder taxonomy):
#   {{USER}} {{LINEAR_ID}} {{DESCRIPTION}} {{VERCEL_PROJECT_ID}}
#   {{PLACEHOLDER}} {{PLACEHOLDERS}}

set -euo pipefail

ALLOW='\{\{(USER|LINEAR_ID|DESCRIPTION|VERCEL_PROJECT_ID|PLACEHOLDER|PLACEHOLDERS)\}\}'

# Only scan text files in the staged change-set. Skip the templates and this
# script itself — they contain {{TOKEN}} by design.
FILES=$(git diff --cached --name-only --diff-filter=ACM \
  | grep -Ev '^(scripts/check-placeholders\.sh|\.pre-commit-config\.yaml|setup\.sh)$' \
  || true)

[[ -z "$FILES" ]] && exit 0

FAIL=0
while IFS= read -r f; do
  [[ ! -f "$f" ]] && continue
  # Skip binaries
  file --mime "$f" 2>/dev/null | grep -q 'charset=binary' && continue
  # Find placeholders, filter out allow-listed ones
  if grep -Eon '\{\{[A-Z_][A-Z0-9_]*\}\}' "$f" \
      | grep -Ev ":[0-9]+:$ALLOW" >/dev/null 2>&1; then
    echo "✗ unresolved placeholder(s) in $f:"
    grep -Eon '\{\{[A-Z_][A-Z0-9_]*\}\}' "$f" | grep -Ev ":[0-9]+:$ALLOW" || true
    FAIL=1
  fi
done <<< "$FILES"

if [[ $FAIL -ne 0 ]]; then
  echo ""
  echo "Run ./setup.sh to resolve install-time placeholders, or edit the files by hand."
  echo "Runtime tokens (USER, LINEAR_ID, DESCRIPTION, etc.) are allowed — see AGENTS.md."
  exit 1
fi

exit 0
