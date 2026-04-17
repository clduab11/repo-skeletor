---
description: Fix bugs or issues in the selected code
---

Fix any defects in the selected code. Priorities, in order:

1. Logic errors
2. Type errors (respect strict TypeScript — no `any`)
3. Null / undefined handling
4. Unhandled edge cases
5. Missing or swallowed error handling
6. Performance cliffs (N+1 queries, blocking I/O in hot path)

Output:

1. A diff showing the exact change.
2. A one-paragraph explanation of the root cause — not just what you changed.
3. If the fix warrants a regression test, write it.

Do not refactor unrelated code in the same pass.
