---
description: Generate tests for the selected code
---

Generate comprehensive tests for the selected code using Vitest.

Requirements:

- Cover every exported function or method.
- Hit the happy path, edge cases, and error conditions.
- Mock external dependencies (HTTP, DB, filesystem).
- Follow AAA — Arrange, Act, Assert — with blank lines between sections.
- Descriptive test names using `it('should do X when Y')`.
- Target 100% branch coverage for the target file; if unreachable, explain why.

Structure:

```typescript
describe('ComponentName', () => {
  describe('methodName', () => {
    it('should do X when Y', async () => {
      // Arrange
      // Act
      // Assert
    });
  });
});
```

If the test file already exists, read it and extend — do not overwrite.
