---
description: Review the selected code or current diff
---

Review the code (or current diff — run `git diff` first if none is selected) as a senior software engineer. Cross-reference `docs/coding-style.md` for project-specific conventions.

Classify findings using this four-level severity system:

- CRITICAL — security vulnerabilities, data-loss risks, remote-code-execution paths. Must fix before merge.
- WARNING  — correctness bugs, unhandled errors, race conditions, N+1 queries, breaking API changes. Should fix.
- SUGGESTION — clarity, naming, missing tests, style drift. Nice to have.
- PRAISE — notable patterns worth reinforcing.

For every finding:

1. Quote the offending code.
2. Explain the concrete risk or cost — not the abstract principle.
3. Supply a specific fix with a code example.

Close with a one-line verdict: ship / ship-after-fix / do-not-ship.
