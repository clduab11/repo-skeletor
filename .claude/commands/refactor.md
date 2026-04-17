---
description: Refactor the selected code for maintainability
---

Refactor the selected code. Apply, in order:

1. Single responsibility — one reason to change per unit.
2. Clear naming — variables explain purpose without a comment.
3. Dependency inversion — depend on interfaces, not concretions.
4. Extract reusable helpers only if used in two or more places (rule of three).
5. Simplify conditionals — early returns over nested `if`.

Constraints:

- Preserve observable behavior. No functional changes.
- Keep the public API stable unless I say otherwise.
- If existing tests pass unchanged, leave them; if they break because they were testing implementation details, rewrite them to test behavior.
