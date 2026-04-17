# GitHub Copilot Custom Instructions — repo-skeletor Meta-Template

> **Version:** 1.0.0
> **Last Updated:** February 2026
> **Scope:** This file provides repository-level custom instructions for GitHub
> Copilot across all projects generated from the repo-skeletor meta-template.
> Copilot reads this file automatically when it is located at
> `.github/copilot-instructions.md` in the repository root.
>
> Reference: [Adding custom instructions for GitHub Copilot](https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Build & Test Commands](#2-build--test-commands)
3. [Code Style & Conventions](#3-code-style--conventions)
4. [Architecture Patterns](#4-architecture-patterns)
5. [Review Checklist](#5-review-checklist)
6. [Educational Feedback Format](#6-educational-feedback-format)
7. [Security Guidelines](#7-security-guidelines)
8. [Performance Considerations](#8-performance-considerations)
9. [Documentation Requirements](#9-documentation-requirements)
10. [Workflow Integration](#10-workflow-integration)

---

## 1. Project Overview

### 1.1 What is repo-skeletor?

repo-skeletor is a **meta-template** designed for AI-augmented solo developer
workflows. It provides a standardized foundation that new repositories inherit
when created via GitHub's "Use this template" feature, followed by running the
`setup.sh` script.

Every configuration file, workflow, and convention defined here is carried
forward into child projects, making this the single source of truth for
project scaffolding.

### 1.2 Supported Project Types

The template supports four project archetypes. The `{{PROJECT_TYPE}}`
placeholder is replaced during setup:

| Type  | Description                       | Typical Stack                  |
|-------|-----------------------------------|--------------------------------|
| `api` | REST or GraphQL API services      | Express/Fastify, Prisma, Zod   |
| `web` | Web applications with UI          | React/Next.js, Tailwind CSS    |
| `cli` | Command-line tools and utilities  | Commander.js, Ink               |
| `lib` | Reusable libraries and packages   | TypeScript, Vitest, Rollup     |

### 1.3 Placeholder System

The template uses mustache-style placeholders that `setup.sh` replaces at
project creation time. When you see these in any file, they represent values
the developer supplies during initialization:

- `{{PROJECT_NAME}}` — The name of the new project
- `{{PROJECT_DESCRIPTION}}` — A short description of the project
- `{{PROJECT_TYPE}}` — One of: `api`, `web`, `cli`, `lib`
- `{{PROJECT_DOMAIN}}` — The project's domain (e.g., `example.com`)
- `{{USER}}` — The developer's Git username
- `{{LINEAR_ID}}` — Linear issue identifier (e.g., `PRX-123`)
- `{{NOTION_SPEC_DATABASE_ID}}` — Notion spec database ID
- `{{NOTION_WIKI_PAGE_ID}}` — Notion wiki page ID
- `{{LINEAR_TEAM_ID}}` — Linear team ID
- `{{GITHUB_REPOSITORY}}` — Full GitHub repository path (e.g., `owner/repo`)

**Important:** Never suggest replacing these placeholders in the template
repository itself. They should only be replaced by `setup.sh` in child
projects.

### 1.4 Copilot's Role in the AI Toolchain

This project uses multiple AI assistants, each with a distinct responsibility:

| Tool           | Primary Role                                        |
|----------------|-----------------------------------------------------|
| **Claude Code** | PR reviews, complex reasoning, code generation      |
| **Gemini**      | Spec generation, style guide enforcement            |
| **Continue.dev**| Slash commands (`/review`, `/test`, `/doc`, etc.)   |
| **Copilot**     | Inline suggestions, chat assistance, incremental review |

**Copilot's focus areas:**

1. **Inline code completion** — Context-aware suggestions that follow the
   conventions in this file
2. **Chat assistance** — Answering questions about the codebase, suggesting
   approaches, and explaining patterns
3. **Incremental code review** — Spotting issues in small diffs during
   development, before the full PR review pipeline
4. **Refactoring support** — Suggesting improvements when prompted via
   Copilot Chat

Copilot should **not** attempt to replicate the responsibilities of the other
tools. Instead, focus on complementing them by providing fast, contextual
assistance during the coding process.

---

## 2. Build & Test Commands

### 2.1 Runtime Requirements

- **Node.js:** 20 (LTS)
- **Package Manager:** pnpm 9

All projects created from this template use pnpm with a lockfile. Always
prefer `pnpm` over `npm` or `yarn` in suggestions and commands.

### 2.2 Primary Commands

When suggesting commands to the developer, use these exact invocations:

```bash
# Install dependencies (CI-safe, uses lockfile)
pnpm install --frozen-lockfile

# Linting (ESLint)
pnpm lint

# Type checking (TypeScript compiler)
pnpm typecheck

# Formatting verification (Prettier)
pnpm format:check

# Unit tests with coverage
pnpm test:unit --coverage

# Integration tests
pnpm test:integration

# Production build
pnpm build

# Security audit
pnpm audit --audit-level=high
```

### 2.3 CI Pipeline Sequence

The continuous integration pipeline runs in this order. When suggesting
changes, ensure they pass each stage:

```
lint (ESLint + TypeScript + Prettier)
  ├── test (Unit tests with coverage)
  ├── build (Production build)
  │     └── integration (Integration tests — main branch or labeled PRs)
  └── security (pnpm audit + Snyk scan)
```

**Key points:**

- `test` and `build` run in parallel after `lint` passes
- `integration` tests run only on the `main` branch or PRs labeled
  `run-integration`
- The `ci-success` job gates branch protection by requiring `lint`, `test`,
  and `build` to all pass

### 2.4 Pre-Commit Validation

Before suggesting that a developer commit their changes, remind them to run:

```bash
pnpm lint && pnpm typecheck && pnpm format:check && pnpm test:unit
```

This mirrors the CI pipeline's first stage and catches issues early.

### 2.5 Security Auditing

Always suggest running `pnpm audit --audit-level=high` after adding or
updating dependencies. Flag any high or critical severity vulnerabilities
and suggest remediation steps.

---

## 3. Code Style & Conventions

### 3.1 Authoritative Style Reference

The full coding style guide lives at `.gemini/styleguide.md`. This section
summarizes the key conventions that Copilot should enforce. When in doubt,
defer to the styleguide.

### 3.2 TypeScript Strict Mode

All TypeScript code must compile under strict mode. The following compiler
options are mandatory:

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noUncheckedIndexedAccess": true
  }
}
```

**Implications for suggestions:**

- Always provide explicit types for function parameters and return values
- Never use `any` — use `unknown` with type narrowing instead
- Handle `undefined` values from indexed access (`noUncheckedIndexedAccess`)
- Prefer `const` over `let`; avoid `var` entirely

### 3.3 Naming Conventions

| Element      | Convention             | Example                          |
|--------------|------------------------|----------------------------------|
| Variables    | camelCase              | `userName`, `isActive`           |
| Functions    | camelCase              | `getUserById()`, `calculateTotal()` |
| Classes      | PascalCase             | `UserService`, `DataProcessor`   |
| Interfaces   | PascalCase (no `I` prefix) | `User`, `ApiResponse`        |
| Types        | PascalCase             | `UserId`, `RequestConfig`        |
| Constants    | SCREAMING_SNAKE_CASE   | `MAX_RETRIES`, `API_BASE_URL`    |
| Enum values  | SCREAMING_SNAKE_CASE   | `Status.ACTIVE`                  |
| Files        | kebab-case             | `user-service.ts`, `api-client.ts` |
| Directories  | kebab-case             | `user-management/`, `api-routes/` |
| Test files   | `*.test.ts`            | `user-service.test.ts`           |

**Common mistakes to flag:**

```typescript
// ❌ WRONG: "I" prefix on interface
interface IUserProfile { }

// ✅ CORRECT: No prefix
interface UserProfile { }

// ❌ WRONG: Abbreviated names
const cnt = users.filter(u => u.isActive).length;

// ✅ CORRECT: Descriptive names
const activeUserCount = users.filter(user => user.isActive).length;
```

### 3.4 Code Formatting Rules

These formatting rules are enforced by Prettier and ESLint. Copilot
suggestions should match them:

| Rule               | Value             |
|--------------------|-------------------|
| Indentation        | 2 spaces          |
| Line width         | 100 characters    |
| Quotes             | Single quotes     |
| Trailing commas    | `es5`             |
| Semicolons         | Required          |

### 3.5 Preferences

- Prefer `const` over `let` — only use `let` when reassignment is necessary
- Avoid `any` — use `unknown` with type guards or generics
- Prefer named exports over default exports (except React components/pages)
- Use template literals over string concatenation
- Prefer destructuring for object and array access
- Use optional chaining (`?.`) and nullish coalescing (`??`) over manual checks

---

## 4. Architecture Patterns

### 4.1 Domain-Driven Directory Structure

Projects follow a layered architecture. When suggesting new files, place them
in the correct layer:

```
src/
├── domain/              # Core business logic (framework-agnostic)
│   ├── entities/        # Domain entities and value objects
│   ├── services/        # Business logic services
│   └── repositories/    # Repository interfaces (no implementation)
│
├── application/         # Use cases and application logic
│   ├── use-cases/       # Application use cases
│   ├── dtos/            # Data transfer objects
│   └── mappers/         # Entity ↔ DTO mappers
│
├── infrastructure/      # External services and frameworks
│   ├── database/        # Database implementation (Prisma, etc.)
│   ├── http/            # HTTP server (routes, middleware, controllers)
│   └── external/        # Third-party service clients
│
├── shared/              # Shared utilities and types
│   ├── utils/           # Utility functions
│   ├── types/           # Shared type definitions
│   ├── constants/       # Application constants
│   └── errors/          # Custom error classes
│
└── tests/               # Test files
    ├── unit/            # Unit tests
    ├── integration/     # Integration tests
    └── e2e/             # End-to-end tests
```

**Key rules:**

- `domain/` must not depend on `infrastructure/` or `application/`
- `application/` may depend on `domain/` but not on `infrastructure/`
- `infrastructure/` implements interfaces defined in `domain/`
- `shared/` may be used by any layer

### 4.2 SOLID Principles

Apply these principles when suggesting code:

**Single Responsibility:** Each class/module should have one reason to change.

```typescript
// ❌ WRONG: Class does too many things
class UserManager {
  async createUser(data: CreateUserInput) { /* ... */ }
  async sendWelcomeEmail(user: User) { /* ... */ }
  async generateReport(users: User[]) { /* ... */ }
}

// ✅ CORRECT: Separate responsibilities
class UserService {
  async createUser(data: CreateUserInput): Promise<User> { /* ... */ }
}

class EmailService {
  async sendWelcomeEmail(user: User): Promise<void> { /* ... */ }
}

class ReportService {
  async generateUserReport(users: User[]): Promise<Report> { /* ... */ }
}
```

**Dependency Inversion:** Depend on abstractions, not concretions.

```typescript
// ✅ CORRECT: Depend on interface
interface UserRepository {
  findById(id: string): Promise<User | null>;
  create(data: CreateUserInput): Promise<User>;
}

class UserService {
  constructor(private readonly repository: UserRepository) {}

  async getUserById(id: string): Promise<User | null> {
    return this.repository.findById(id);
  }
}
```

### 4.3 Error Handling Pattern

The codebase uses a custom `AppError` class hierarchy for structured error
handling. Always use these patterns rather than throwing raw `Error` objects:

```typescript
// Base error class — all custom errors extend this
class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
    public readonly isOperational: boolean = true
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

// Specialized errors
class ValidationError extends AppError {
  constructor(message: string, public readonly fields?: Record<string, string>) {
    super(message, 'VALIDATION_ERROR', 400);
  }
}

class NotFoundError extends AppError {
  constructor(resource: string, identifier: string) {
    super(`${resource} with identifier '${identifier}' not found`, 'NOT_FOUND', 404);
  }
}

class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(message, 'UNAUTHORIZED', 401);
  }
}
```

**Error handling best practices:**

```typescript
// ✅ CORRECT: Catch, classify, and re-throw with context
async function getUserData(userId: string): Promise<UserData> {
  try {
    const user = await userRepository.findById(userId);
    if (!user) {
      throw new NotFoundError('User', userId);
    }
    return mapUserToData(user);
  } catch (error) {
    if (error instanceof AppError) {
      throw error; // Re-throw known errors
    }
    logger.error('Unexpected error fetching user', {
      userId,
      error: error instanceof Error ? error.message : String(error),
    });
    throw new AppError('Failed to fetch user data', 'INTERNAL_ERROR', 500);
  }
}

// ❌ WRONG: Swallowing errors silently
try {
  await riskyOperation();
} catch (error) {
  // Silent failure — never do this
}
```

### 4.4 Result Type Pattern

For recoverable errors where exceptions are not appropriate, use the Result
type pattern:

```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

function parseConfig(raw: string): Result<Config, ValidationError> {
  try {
    const parsed = JSON.parse(raw);
    const validated = configSchema.parse(parsed);
    return { success: true, data: validated };
  } catch (error) {
    return {
      success: false,
      error: new ValidationError('Invalid config format'),
    };
  }
}

// Usage
const result = parseConfig(rawConfig);
if (result.success) {
  console.log(result.data);
} else {
  console.error(result.error.message);
}
```

### 4.5 Import Order Convention

Organize imports in this strict order, separated by blank lines:

```typescript
// 1. Node.js built-in modules
import { readFile } from 'node:fs/promises';
import { EventEmitter } from 'node:events';

// 2. External packages (alphabetically)
import { z } from 'zod';
import express from 'express';
import { PrismaClient } from '@prisma/client';

// 3. Internal absolute imports (using path aliases)
import { UserService } from '@/domain/services';
import { validateRequest } from '@/shared/utils';
import { AppError } from '@/shared/errors';

// 4. Relative imports (parent → sibling → child)
import { UserDto } from '../dtos';
import { mapUserToDto } from './mappers';
import type { CreateUserInput } from './types';

// 5. Asset imports
import styles from './component.module.css';
```

---

## 5. Review Checklist

When reviewing code — whether in Copilot Chat, inline suggestions, or
diff-based review — evaluate changes against these categories in priority
order.

### 5.1 Priority Order

1. **Security** — Vulnerabilities must be fixed before any other concern
2. **Correctness** — Logic errors and bugs take second priority
3. **Performance** — Inefficient patterns that impact user experience
4. **Maintainability** — Code that will be hard to change or understand
5. **Style** — Formatting and naming convention violations

### 5.2 Checklist by Category

#### Security

- [ ] All user inputs are validated (Zod schemas preferred)
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] No use of `eval()` or `Function` constructor
- [ ] SQL queries use parameterized statements (Prisma ORM preferred)
- [ ] Authentication is checked on protected routes
- [ ] Sensitive data is not logged (passwords, tokens, PII)
- [ ] Rate limiting is applied to authentication endpoints
- [ ] Dependencies have no known high/critical vulnerabilities

#### Correctness

- [ ] Edge cases are handled (null, undefined, empty arrays, zero values)
- [ ] Error handling follows the AppError pattern
- [ ] Async operations are properly awaited
- [ ] Return types match the function signature
- [ ] Type narrowing is used after type guards
- [ ] Promise rejections are caught and handled

#### Performance

- [ ] Independent async operations use `Promise.all()`
- [ ] Database queries select only needed fields
- [ ] Pagination is used for list endpoints
- [ ] No N+1 query patterns
- [ ] Expensive computations are cached where appropriate

#### Maintainability

- [ ] Functions have a single responsibility
- [ ] No code duplication (DRY principle)
- [ ] Dependencies flow in the correct direction (domain → app → infra)
- [ ] Magic numbers and strings are extracted to constants
- [ ] Complex logic has explanatory comments (WHY, not WHAT)

#### Testing

- [ ] New code has corresponding unit tests
- [ ] Tests follow the Arrange-Act-Assert (AAA) pattern
- [ ] Edge cases and error paths are tested
- [ ] Mocks are properly reset between tests
- [ ] Test descriptions clearly state the expected behavior

#### Style

- [ ] Names follow conventions (see Section 3.3)
- [ ] Imports follow the ordering convention (see Section 4.5)
- [ ] Code compiles under `strict: true` without errors
- [ ] No `any` types — `unknown` with narrowing is preferred
- [ ] JSDoc is present on all exported members

### 5.3 File-Type–Specific Considerations

**API Handlers / Controllers:**

- Validate request body, params, and query with Zod schemas
- Return appropriate HTTP status codes (201 for creation, 204 for deletion)
- Include error responses in consistent format
- Apply authentication and authorization middleware
- Log request metadata without sensitive data

**Database Operations:**

- Use transactions for multi-step mutations
- Include `select` to limit returned fields
- Add indexes for frequently filtered/sorted columns
- Handle unique constraint violations gracefully
- Use pagination for list queries

**UI Components (web projects):**

- Keep components focused — prefer composition over large components
- Separate data fetching from presentation
- Handle loading, error, and empty states
- Use semantic HTML elements
- Ensure accessibility (ARIA labels, keyboard navigation)

### 5.4 Always Check

Regardless of the file type, always verify these items:

1. **Error handling** — Is every error case covered?
2. **Null safety** — Are null/undefined values handled?
3. **Type safety** — Does the code compile under strict mode?
4. **Input validation** — Is user input validated before use?

---

## 6. Educational Feedback Format

Copilot should provide constructive, educational feedback that helps the
developer grow. Follow these guidelines when offering suggestions or
reviewing code.

### 6.1 Severity Levels

Use this four-level severity system when flagging issues:

| Icon | Level        | Meaning                                     | Action    |
|------|-------------|----------------------------------------------|-----------|
| 🔴   | **CRITICAL** | Security vulnerability or data loss risk     | Must fix  |
| 🟠   | **WARNING**  | Bug, correctness issue, or bad practice      | Should fix |
| 🟡   | **SUGGESTION** | Improvement opportunity or minor concern   | Nice to have |
| 🟢   | **PRAISE**   | Well-written code worth highlighting         | Keep it up |

### 6.2 Three-Step Feedback Structure

When flagging an issue, follow this structure:

**Step 1: Quote the problematic code**

Show the specific code that needs attention.

**Step 2: Explain why it is an issue**

Provide the rationale — reference security risks, performance impacts, or
maintainability concerns. Include links to documentation when relevant.

**Step 3: Suggest a specific fix**

Provide a concrete code example that resolves the issue.

**Example of well-structured feedback:**

> 🟠 **WARNING: Unvalidated user input passed to database query**
>
> ```typescript
> // Current code
> const user = await prisma.user.findUnique({
>   where: { email: req.body.email },
> });
> ```
>
> **Why this is an issue:** The `req.body.email` value is used directly
> without validation. While Prisma prevents SQL injection, the email could
> be malformed, empty, or an unexpected type, leading to confusing errors
> or unexpected behavior downstream.
>
> **Suggested fix:**
>
> ```typescript
> import { z } from 'zod';
>
> const EmailSchema = z.string().email();
>
> const email = EmailSchema.parse(req.body.email);
> const user = await prisma.user.findUnique({
>   where: { email },
> });
> ```
>
> This validates the email format before the database query and throws a
> clear `ZodError` if the input is invalid.

### 6.3 Feedback Tone

Adopt a **mentor-like tone** that is:

- **Constructive** — Focus on how to improve, not what is wrong
- **Specific** — Reference exact lines and patterns, not vague concerns
- **Evidence-based** — Cite conventions, documentation, or security standards
- **Helpful** — Offer alternatives and explain trade-offs
- **Encouraging** — Acknowledge good patterns with 🟢 PRAISE

**Example of good vs. poor feedback:**

```
❌ Poor feedback:
"This code is bad. Don't do it this way."

✅ Good feedback:
"🟡 SUGGESTION: Consider using `Promise.all()` here to run these two
independent API calls in parallel. This could reduce the response time
from ~600ms (sequential) to ~300ms (parallel). See Section 8.1 for the
recommended pattern."
```

### 6.4 Refactoring vs. Quick Fix Decision Matrix

Use this matrix to decide whether to suggest a refactor or a quick fix:

| Situation                          | Recommendation     | Severity |
|------------------------------------|--------------------|----------|
| Security vulnerability             | Quick fix          | 🔴       |
| Bug causing incorrect behavior     | Quick fix          | 🟠       |
| Performance issue in hot path      | Quick fix          | 🟠       |
| Architectural concern              | Refactor           | 🟡       |
| Code duplication (2 occurrences)   | Note for later     | 🟡       |
| Code duplication (3+ occurrences)  | Refactor           | 🟠       |
| Naming convention violation        | Quick fix          | 🟡       |
| Missing error handling             | Quick fix          | 🟠       |
| Missing tests                      | Add tests          | 🟠       |
| Opportunity for better pattern     | Suggest refactor   | 🟡       |

**Rule of thumb:** If the issue could cause a production incident, prefer a
quick fix. If it is about long-term code health, suggest a refactor with a
TODO comment tracking the work.

---

## 7. Security Guidelines

### 7.1 Input Validation

All user-facing inputs must be validated using Zod schemas before processing.
This applies to API request bodies, query parameters, URL parameters, and
form data.

```typescript
import { z } from 'zod';

// Define the schema
const CreateUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
  role: z.enum(['user', 'admin', 'moderator']).default('user'),
});

type CreateUserInput = z.infer<typeof CreateUserSchema>;

// ✅ CORRECT: Validate before use
app.post('/api/users', async (req, res) => {
  const result = CreateUserSchema.safeParse(req.body);

  if (!result.success) {
    return res.status(400).json({
      error: { code: 'VALIDATION_ERROR', details: result.error.flatten() },
    });
  }

  const user = await userService.create(result.data);
  res.status(201).json(user);
});

// ❌ WRONG: Direct use of unvalidated input
app.post('/api/users', async (req, res) => {
  const user = await userService.create(req.body); // Dangerous!
  res.status(201).json(user);
});
```

### 7.2 SQL Injection Prevention

Always use parameterized queries through an ORM (Prisma is the default):

```typescript
// ✅ CORRECT: ORM handles parameterization
const user = await prisma.user.findUnique({
  where: { email: validatedEmail },
});

// ✅ CORRECT: Tagged template for raw SQL (Prisma parameterizes this)
const users = await prisma.$queryRaw`
  SELECT * FROM users WHERE email = ${validatedEmail}
`;

// ❌ WRONG: String interpolation in raw SQL
const users = await prisma.$queryRawUnsafe(
  `SELECT * FROM users WHERE email = '${email}'` // SQL injection risk!
);
```

**Always flag** any use of `$queryRawUnsafe` or string concatenation in SQL.

### 7.3 Secrets Management

- **Environment variables only:** All secrets (API keys, database URLs, tokens)
  must come from environment variables
- **Never hardcoded:** No secrets in source code, ever
- **Gitignored:** All `.env*` files must be listed in `.gitignore`
- **Validated at startup:** Required environment variables should be validated
  when the application starts

```typescript
// ✅ CORRECT: Validate required env vars at startup
const requiredEnvVars = ['DATABASE_URL', 'API_KEY', 'JWT_SECRET'] as const;

for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    throw new Error(`Missing required environment variable: ${envVar}`);
  }
}

// ❌ WRONG: Hardcoded secret
const API_KEY = 'sk-1234567890abcdef'; // NEVER do this
```

### 7.4 Logging Security

Logs must never contain sensitive data. Apply these rules:

- **Sanitize PII:** Mask email addresses (e.g., `j***@e***.com`)
- **Never log tokens:** JWT tokens, API keys, and session IDs are forbidden
- **Never log passwords:** Even hashed passwords should not appear in logs
- **Redact automatically:** Use a sanitization function for log payloads

```typescript
// ✅ CORRECT: Sanitized logging
logger.info('User authenticated', {
  userId: user.id,
  email: maskEmail(user.email),
  ip: req.ip,
});

// ❌ WRONG: Leaking sensitive data
logger.info('User login', {
  email: user.email,       // PII exposed
  password: user.password, // CRITICAL: Never log passwords
  token: session.token,    // CRITICAL: Never log tokens
});
```

### 7.5 Rate Limiting

Apply rate limiting to all public endpoints, with stricter limits on
authentication endpoints:

```typescript
import rateLimit from 'express-rate-limit';

// General API rate limit
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
  message: 'Too many requests from this IP, please try again later.',
});

app.use('/api/', apiLimiter);

// Stricter limit for authentication
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5,                   // Only 5 attempts
  skipSuccessfulRequests: true,
});

app.post('/api/auth/login', authLimiter, loginHandler);
```

### 7.6 Patterns to Always Flag

When reviewing code, immediately flag these patterns:

| Pattern                             | Risk                    | Severity |
|-------------------------------------|-------------------------|----------|
| Hardcoded credentials or API keys   | Secret exposure         | 🔴       |
| `eval()` or `Function` constructor  | Remote code execution   | 🔴       |
| Unvalidated user input in queries   | Injection attacks       | 🔴       |
| `$queryRawUnsafe` with interpolation | SQL injection          | 🔴       |
| Logging passwords or tokens         | Data leak               | 🔴       |
| Missing auth middleware on routes   | Unauthorized access     | 🟠       |
| No rate limiting on auth endpoints  | Brute force attacks     | 🟠       |
| `.env` files not in `.gitignore`    | Secret exposure         | 🟠       |
| `any` type used for user input      | Type safety bypass      | 🟡       |

---

## 8. Performance Considerations

### 8.1 Parallel Async Operations

When multiple async operations are independent, run them in parallel with
`Promise.all()`:

```typescript
// ✅ CORRECT: Parallel execution (~300ms total)
const [user, posts, comments] = await Promise.all([
  getUser(userId),
  getUserPosts(userId),
  getUserComments(userId),
]);

// ❌ WRONG: Sequential execution (~900ms total)
const user = await getUser(userId);
const posts = await getUserPosts(userId);
const comments = await getUserComments(userId);
```

Use `Promise.allSettled()` when you need results from all promises even if
some fail:

```typescript
const results = await Promise.allSettled([
  fetchUserProfile(userId),
  fetchUserPreferences(userId),
  fetchUserNotifications(userId),
]);

const profile = results[0].status === 'fulfilled' ? results[0].value : null;
const preferences = results[1].status === 'fulfilled' ? results[1].value : defaults;
const notifications = results[2].status === 'fulfilled' ? results[2].value : [];
```

### 8.2 Pagination

All list endpoints must support pagination:

- **Default page size:** 20 items
- **Maximum page size:** 100 items
- **Always return metadata:** total count, current page, total pages

```typescript
async function getUsers(page: number = 1, limit: number = 20): Promise<PaginatedResult<User>> {
  const safePage = Math.max(1, page);
  const safeLimit = Math.min(Math.max(1, limit), 100); // Cap at 100
  const skip = (safePage - 1) * safeLimit;

  const [users, total] = await Promise.all([
    prisma.user.findMany({
      skip,
      take: safeLimit,
      orderBy: { createdAt: 'desc' },
    }),
    prisma.user.count(),
  ]);

  return {
    data: users,
    pagination: {
      page: safePage,
      limit: safeLimit,
      total,
      pages: Math.ceil(total / safeLimit),
    },
  };
}
```

### 8.3 Caching

Cache expensive operations using an LRU (Least Recently Used) strategy:

```typescript
import { LRUCache } from 'lru-cache';

const userCache = new LRUCache<string, User>({
  max: 500,                  // Maximum 500 entries
  ttl: 1000 * 60 * 5,       // 5-minute TTL
});

async function getUserCached(userId: string): Promise<User | null> {
  const cached = userCache.get(userId);
  if (cached) {
    return cached;
  }

  const user = await prisma.user.findUnique({ where: { id: userId } });

  if (user) {
    userCache.set(userId, user);
  }

  return user;
}
```

**When to cache:**

- Database queries that are read-heavy and change infrequently
- External API responses with stable data
- Computed values that are expensive to calculate

**When NOT to cache:**

- Data that changes frequently (real-time feeds, counters)
- User-specific sensitive data in shared caches
- Small queries that are already fast

### 8.4 Database Optimization

- **Select only needed fields:** Avoid `SELECT *` — use Prisma's `select`
- **Use indexes:** Add indexes for columns used in `WHERE`, `ORDER BY`, and
  `JOIN` clauses
- **Avoid N+1 queries:** Use `include` or `join` to load related data in a
  single query
- **Use transactions:** Wrap multi-step mutations in transactions

```typescript
// ❌ WRONG: N+1 query pattern
const users = await prisma.user.findMany();
for (const user of users) {
  const posts = await prisma.post.findMany({ where: { authorId: user.id } }); // N queries!
}

// ✅ CORRECT: Single query with include
const users = await prisma.user.findMany({
  include: { posts: true },
});
```

### 8.5 Data Structure Preferences

- Use `Map` over plain objects for dynamic key-value collections (O(1) lookup)
- Use `Set` over arrays for unique value collections (O(1) membership check)
- Use arrays for ordered, indexed collections

```typescript
// ✅ CORRECT: Map for dynamic lookups
const userCache = new Map<string, User>();
userCache.set(userId, user);
const cached = userCache.get(userId);

// ❌ WRONG: Plain object for dynamic keys
const userCache: Record<string, User> = {};
userCache[userId] = user;
```

### 8.6 Memory Management

For large data processing, avoid loading entire datasets into memory:

```typescript
// ✅ CORRECT: Process in batches
async function processAllUsers(): Promise<void> {
  const batchSize = 100;
  let cursor: string | undefined;

  while (true) {
    const users = await prisma.user.findMany({
      take: batchSize,
      skip: cursor ? 1 : 0,
      cursor: cursor ? { id: cursor } : undefined,
      orderBy: { id: 'asc' },
    });

    if (users.length === 0) break;

    await processBatch(users);
    cursor = users[users.length - 1]?.id;
  }
}

// ❌ WRONG: Loading all records at once
const allUsers = await prisma.user.findMany(); // Could be millions!
```

---

## 9. Documentation Requirements

### 9.1 JSDoc Standards

All exported functions, classes, interfaces, and types must have JSDoc
documentation. Include these tags as applicable:

| Tag        | Usage                                         | Required |
|------------|-----------------------------------------------|----------|
| `@param`   | Document each parameter                       | Yes      |
| `@returns` | Document the return value                     | Yes      |
| `@throws`  | Document each error type that may be thrown    | Yes      |
| `@example` | Provide a usage example                       | Yes      |
| `@since`   | Version when the member was introduced        | Yes      |

**Complete JSDoc example:**

```typescript
/**
 * Retrieves a user by their unique identifier.
 *
 * Queries the database for a user matching the provided ID.
 * Returns null if no user is found, rather than throwing an error.
 *
 * @param userId - The unique identifier of the user to retrieve
 * @returns A promise resolving to the user object, or null if not found
 * @throws {ValidationError} If the userId format is invalid
 * @throws {DatabaseError} If the database connection fails
 *
 * @example
 * ```typescript
 * const user = await getUserById('user_123abc');
 * if (user) {
 *   console.log(user.name);
 * }
 * ```
 *
 * @since 1.0.0
 */
export async function getUserById(userId: string): Promise<User | null> {
  // Implementation
}
```

### 9.2 Inline Comment Philosophy

Comments should explain **why**, not **what**. The code itself should be
readable enough to explain what it does.

```typescript
// ✅ CORRECT: Explains WHY
// Using a Map for O(1) lookup performance on large datasets
const userCache = new Map<string, User>();

// ✅ CORRECT: Documents non-obvious behavior
// Note: This function mutates the input array for performance
function sortInPlace(items: Item[]): Item[] {
  return items.sort((a, b) => a.priority - b.priority);
}

// ❌ WRONG: States the obvious
// Increment counter by 1
counter++;

// ❌ WRONG: Restates the code
// Set the user's name to the value of input.name
user.name = input.name;
```

### 9.3 TODO / FIXME / HACK Comments

Use structured comments with author attribution for tracking:

```typescript
// TODO(username): Implement caching layer for this query
// FIXME(username): Race condition when multiple users update simultaneously
// HACK(username): Temporary workaround until API v2 is ready — PRX-456
```

**Rules:**

- Always include the developer's username in parentheses
- Reference a Linear issue ID when applicable
- `TODO` — Planned work that is not urgent
- `FIXME` — Known bug that should be fixed soon
- `HACK` — Temporary workaround that must be replaced

### 9.4 Test Coverage Requirements

| Category        | Minimum Coverage |
|-----------------|------------------|
| Overall         | 80%              |
| Critical paths  | 100%             |

**Critical paths** include:

- Authentication and authorization logic
- Payment processing
- Data integrity operations (create, update, delete)
- Input validation

### 9.5 Test File Naming Conventions

| Test Type       | Pattern                          | Example                         |
|-----------------|----------------------------------|---------------------------------|
| Unit tests      | `*.test.ts`                      | `user-service.test.ts`          |
| Integration     | `*.integration.test.ts`          | `user-api.integration.test.ts`  |
| End-to-end      | `*.e2e.test.ts`                  | `login-flow.e2e.test.ts`        |

**Test structure follows the AAA pattern:**

```typescript
describe('UserService', () => {
  describe('getUserById', () => {
    it('should return user when found', async () => {
      // Arrange
      const userId = 'user_123';
      const expectedUser = { id: userId, name: 'John' };
      mockRepository.findById.mockResolvedValue(expectedUser);

      // Act
      const result = await userService.getUserById(userId);

      // Assert
      expect(result).toEqual(expectedUser);
      expect(mockRepository.findById).toHaveBeenCalledWith(userId);
    });

    it('should return null when user not found', async () => {
      // Arrange
      mockRepository.findById.mockResolvedValue(null);

      // Act
      const result = await userService.getUserById('nonexistent');

      // Assert
      expect(result).toBeNull();
    });
  });
});
```

---

## 10. Workflow Integration

### 10.1 Branch Naming Convention

All branches follow this format:

```
<username>/<linear-id>-<description>
```

**Examples:**

```bash
# ✅ CORRECT
clduab11/PRX-123-add-oauth-login
clduab11/PRX-456-fix-api-timeout
clduab11/PRX-789-refactor-user-service

# ❌ WRONG
feature/oauth-login
fix-api-bug
working-branch
```

When a developer asks for help creating a branch, suggest the correct format
using their username and the relevant Linear issue ID.

### 10.2 Conventional Commits

All commit messages must follow the
[Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

**Commit types:**

| Type       | Description                                          |
|------------|------------------------------------------------------|
| `feat`     | New feature                                          |
| `fix`      | Bug fix                                              |
| `docs`     | Documentation changes only                           |
| `style`    | Formatting, semicolons, etc. (no code logic change)  |
| `refactor` | Code refactoring (no functional change)              |
| `perf`     | Performance improvement                              |
| `test`     | Adding or updating tests                             |
| `build`    | Build system or dependency changes                   |
| `ci`       | CI/CD configuration changes                          |
| `chore`    | Other changes (maintenance, tooling)                 |

**Example commit messages:**

```
feat(auth): add OAuth2 login support

Implemented OAuth2 authentication flow using Passport.js.
Supports Google and GitHub providers.

Closes PRX-123
```

```
fix(api): handle null response from external service

The external API occasionally returns null instead of an empty
array. Added null check and default to empty array.

Fixes PRX-456
```

```
perf(database): add index on user.email column

Query performance improved from 500ms to 50ms for
email lookup operations.
```

### 10.3 Pull Request Requirements

When suggesting or drafting PR descriptions, include these sections:

```markdown
## Summary
Brief description of what this PR does and why.

## Changes
- Change 1
- Change 2
- Change 3

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] All tests passing

## Linear Issue
Closes PRX-XXX

## Breaking Changes
None / List any breaking changes
```

### 10.4 Issue and Project Integration

This template integrates with Linear and Notion for project management:

- **Linear** — Issue tracking with team prefix `PAR`
- **Notion** — Spec documents and wiki pages
- **GitHub** — PRs auto-link to Linear issues via branch naming and commit
  footers

When a developer references a Linear issue (e.g., `PRX-123`), understand that
this links to their project management system and include it in commit
footers where appropriate.

### 10.5 When to Recommend `/plan` vs. Immediate Implementation

Use this guidance when a developer asks Copilot to help with a task:

| Task Complexity                              | Recommendation       |
|----------------------------------------------|----------------------|
| Single-file change, clear requirements       | Implement directly   |
| Multi-file change, clear requirements        | Brief plan, then implement |
| Architectural change or new feature          | Recommend `/plan` first |
| Unclear requirements or multiple approaches  | Ask clarifying questions |
| Bug fix with known root cause                | Implement directly   |
| Bug fix with unknown root cause              | Investigate first    |
| Refactoring across multiple modules          | Recommend `/plan` first |

**When recommending `/plan`:**

> "This change touches multiple modules and could benefit from a structured
> plan. Consider using `/plan` to outline the approach before implementing.
> This helps ensure all affected areas are identified and the changes are
> coordinated."

### 10.6 CI/CD Checkpoint Reminders

Before a developer pushes their changes or opens a PR, remind them of these
checkpoints:

1. **All tests passing** — `pnpm test:unit` must pass with no failures
2. **No linting errors** — `pnpm lint && pnpm typecheck` must be clean
3. **Formatting verified** — `pnpm format:check` must pass
4. **Documentation updated** — JSDoc for new/changed exports, README if needed
5. **No secrets in code** — Verify no hardcoded credentials
6. **Security audit clean** — `pnpm audit --audit-level=high` shows no
   high/critical vulnerabilities

---

## Cross-References

This file works alongside other project documentation:

| Document                  | Purpose                                     |
|---------------------------|---------------------------------------------|
| `.gemini/styleguide.md`   | Detailed coding style guide (authoritative) |
| `CONTRIBUTING.md`         | Contribution guidelines and processes       |
| `README.md`               | Project overview and setup instructions     |
| `ci.yml`                  | CI pipeline configuration                   |
| `.claude/settings.json`   | Claude Code project configuration           |
| `.continue/config.yaml`   | Continue.dev AI assistant configuration     |

## Official GitHub Copilot Documentation

These references informed the structure and content of this file:

- [Adding custom instructions for GitHub Copilot](https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [Copilot custom instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions)
- [Best practices for using Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices)
- [Copilot in your IDE](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat/using-github-copilot-chat-in-your-ide)

---

*This file is part of the repo-skeletor meta-template. It is automatically
inherited by all projects created from this template. Modify it in the
template repository to update instructions across all future projects.*
