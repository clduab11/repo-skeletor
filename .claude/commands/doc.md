---
description: Generate JSDoc for the selected code
---

Generate JSDoc for every exported symbol in the selected code.

Each block must include:

- A one-line description (imperative mood).
- `@param` for every parameter with type and meaning.
- `@returns` with type and description.
- `@throws` for every distinct error type that may be thrown.
- `@example` with a runnable usage snippet.
- `@since` with the current version from `package.json`.

Example:

```typescript
/**
 * Retrieves a user by their unique identifier.
 *
 * @param userId - The unique identifier of the user
 * @returns A promise that resolves to the user object, or null if not found
 * @throws {ValidationError} If userId format is invalid
 *
 * @example
 * ```typescript
 * const user = await getUserById('user_123');
 * ```
 *
 * @since 1.0.0
 */
```

Do not document private or unexported symbols unless asked.
