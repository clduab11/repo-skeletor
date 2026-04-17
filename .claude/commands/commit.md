---
description: Generate a conventional commit message for staged changes
---

Generate a Conventional Commits message for the currently staged diff. Run `git diff --cached` to read it.

Format:

```
<type>(<scope>): <subject>

[optional body — wrap at 72 chars]

[optional footer — Closes <LINEAR-ID>]
```

Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore

Rules:

- Subject ≤ 50 chars, imperative mood ("add X" not "added X").
- Scope is the affected area (e.g., `auth`, `api`, `launcher`).
- Body explains *why*, not *what* — the diff already shows what.
- Reference Linear issues in the footer when relevant.

If the diff touches multiple unrelated areas, flag it and recommend splitting the commit.
