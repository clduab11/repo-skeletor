# {{PROJECT_NAME}} Coding Style Guide

**Project Type:** {{PROJECT_TYPE}}  
**Version:** 1.0.0

---

## Table of Contents

1. [Overview](#overview)
2. [TypeScript Standards](#typescript-standards)
3. [JavaScript Standards](#javascript-standards)
4. [Naming Conventions](#naming-conventions)
5. [Code Organization](#code-organization)
6. [Documentation](#documentation)
7. [Error Handling](#error-handling)
8. [Testing Standards](#testing-standards)
9. [Git Conventions](#git-conventions)
10. [Security Best Practices](#security-best-practices)
11. [Performance Guidelines](#performance-guidelines)
12. [AI Assistant Instructions](#ai-assistant-instructions)

---

## Overview

This style guide defines the coding standards for **{{PROJECT_NAME}}**. All code, whether written by humans or AI assistants (Claude, Gemini, Continue.dev), must adhere to these guidelines.

**Core Principles:**
- **Clarity over cleverness** - Code should be easy to understand
- **Consistency over preference** - Follow established patterns
- **Safety by default** - Validate inputs, handle errors gracefully
- **Test everything** - No code without tests
- **Document intent** - Explain the "why", not just the "what"

---

## TypeScript Standards

### General Rules

```typescript
// ✅ CORRECT: Strict mode enabled
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noUncheckedIndexedAccess": true
  }
}

// ✅ CORRECT: Explicit types, const over let
const userName: string = "John";
const userAge: number = 30;
const isActive: boolean = true;

// ❌ WRONG: Using let when const is appropriate
let userName = "John";

// ❌ WRONG: Using any type
function processData(data: any) { }

// ✅ CORRECT: Use unknown for truly unknown types
function processData(data: unknown) {
  if (typeof data === 'string') {
    // TypeScript knows data is string here
  }
}
```

### Type Definitions

```typescript
// ✅ CORRECT: Interface for objects
interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
}

// ✅ CORRECT: Type for unions and primitives
type UserId = string;
type Status = 'active' | 'inactive' | 'pending';

// ✅ CORRECT: Use const assertions for immutable objects
const CONFIG = {
  maxRetries: 3,
  timeout: 5000,
  endpoint: 'https://api.example.com'
} as const;

// ✅ CORRECT: Discriminated unions for complex types
type Result<T> =
  | { success: true; data: T }
  | { success: false; error: Error };

// ✅ CORRECT: Generic constraints
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

### Functions

```typescript
// ✅ CORRECT: Explicit parameter and return types
async function getUserById(userId: string): Promise<User | null> {
  const user = await db.users.findUnique({ where: { id: userId } });
  return user;
}

// ✅ CORRECT: Arrow functions for callbacks
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map((n) => n * 2);

// ✅ CORRECT: Default parameters
function createUser(name: string, role: string = 'user'): User {
  // Implementation
}

// ❌ WRONG: No return type
async function getUserById(userId: string) {
  return await db.users.findUnique({ where: { id: userId } });
}
```

---

## JavaScript Standards

### ES6+ Features

```javascript
// ✅ CORRECT: Use template literals
const message = `Hello, ${userName}! You have ${count} messages.`;

// ❌ WRONG: String concatenation
const message = 'Hello, ' + userName + '! You have ' + count + ' messages.';

// ✅ CORRECT: Destructuring
const { name, email } = user;
const [first, second, ...rest] = array;

// ✅ CORRECT: Spread operator
const newUser = { ...oldUser, name: 'New Name' };
const newArray = [...oldArray, newItem];

// ✅ CORRECT: Optional chaining and nullish coalescing
const userName = user?.profile?.name ?? 'Anonymous';

// ❌ WRONG: Manual null checking
const userName = user && user.profile && user.profile.name ? user.profile.name : 'Anonymous';
```

### Async/Await

```javascript
// ✅ CORRECT: Use async/await over promises
async function fetchUserData(userId) {
  try {
    const user = await api.getUser(userId);
    const posts = await api.getUserPosts(userId);
    return { user, posts };
  } catch (error) {
    logger.error('Failed to fetch user data', { userId, error });
    throw error;
  }
}

// ✅ CORRECT: Parallel async operations with Promise.all
async function fetchMultipleUsers(userIds) {
  const users = await Promise.all(
    userIds.map((id) => api.getUser(id))
  );
  return users;
}

// ❌ WRONG: Sequential awaits when parallel is possible
async function fetchMultipleUsers(userIds) {
  const users = [];
  for (const id of userIds) {
    const user = await api.getUser(id); // Slow!
    users.push(user);
  }
  return users;
}
```

---

## Naming Conventions

| Element | Convention | Example | Notes |
|---------|------------|---------|-------|
| Variables | camelCase | `userName`, `isActive` | Descriptive, not abbreviated |
| Constants | SCREAMING_SNAKE_CASE | `MAX_RETRIES`, `API_BASE_URL` | Only for truly constant values |
| Functions | camelCase | `getUserById()`, `calculateTotal()` | Verb or verb phrase |
| Classes | PascalCase | `UserService`, `DataProcessor` | Noun or noun phrase |
| Interfaces | PascalCase | `User`, `ApiResponse` | NO "I" prefix |
| Types | PascalCase | `UserId`, `RequestConfig` | Descriptive of the type |
| Enums | PascalCase | `Status`, `ErrorCode` | Singular noun |
| Enum Values | SCREAMING_SNAKE_CASE | `Status.ACTIVE` | |
| Files | kebab-case | `user-service.ts`, `api-client.ts` | Match primary export |
| Directories | kebab-case | `user-management/`, `api-routes/` | Plural for collections |
| Test Files | `*.test.ts` | `user-service.test.ts` | Match source file name |

### Examples

```typescript
// ✅ CORRECT: Clear, descriptive names
const activeUserCount = users.filter(u => u.isActive).length;
function calculateMonthlyRevenue(transactions: Transaction[]): number { }
class UserAuthenticationService { }
interface UserProfile { }
type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';

// ❌ WRONG: Abbreviated or unclear names
const cnt = users.filter(u => u.isActive).length;
function calc(txns) { }
class UAS { }
interface IUserProfile { }
```

---

## Code Organization

### File Structure

```
src/
├── domain/              # Core business logic (framework-agnostic)
│   ├── entities/        # Domain entities and value objects
│   │   ├── user.entity.ts
│   │   └── order.entity.ts
│   ├── services/        # Business logic services
│   │   ├── user.service.ts
│   │   └── order.service.ts
│   └── repositories/    # Repository interfaces (no implementation)
│       └── user.repository.ts
│
├── application/         # Use cases and application logic
│   ├── use-cases/       # Application use cases
│   │   ├── create-user.use-case.ts
│   │   └── place-order.use-case.ts
│   ├── dtos/            # Data transfer objects
│   │   ├── create-user.dto.ts
│   │   └── user-response.dto.ts
│   └── mappers/         # Entity <-> DTO mappers
│       └── user.mapper.ts
│
├── infrastructure/      # External services and frameworks
│   ├── database/        # Database implementation
│   │   ├── prisma/
│   │   └── repositories/
│   ├── http/            # HTTP server (Express, Fastify, etc.)
│   │   ├── routes/
│   │   ├── middleware/
│   │   └── controllers/
│   └── external/        # Third-party service clients
│       ├── stripe.client.ts
│       └── sendgrid.client.ts
│
├── shared/              # Shared utilities and types
│   ├── utils/           # Utility functions
│   │   ├── validation.util.ts
│   │   └── date.util.ts
│   ├── types/           # Shared types
│   │   └── common.types.ts
│   ├── constants/       # Application constants
│   │   └── error-codes.ts
│   └── errors/          # Custom error classes
│       └── app.error.ts
│
└── tests/               # Test files
    ├── unit/            # Unit tests
    ├── integration/     # Integration tests
    └── e2e/             # End-to-end tests
```

### Import Order

Always organize imports in this order:

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

// 4. Relative imports (parent -> sibling -> child)
import { UserDto } from '../dtos';
import { mapUserToDto } from './mappers';
import type { CreateUserInput } from './types';

// 5. Asset imports
import styles from './component.module.css';
```

### Module Exports

```typescript
// ✅ CORRECT: Named exports (preferred)
export class UserService { }
export function validateEmail(email: string): boolean { }
export const MAX_RETRIES = 3;

// ✅ CORRECT: Barrel exports for public API
// domain/index.ts
export * from './entities';
export * from './services';
export type { UserRepository } from './repositories';

// ⚠️ ACCEPTABLE: Default export for components/pages
// components/UserProfile.tsx
export default function UserProfile() { }

// ❌ WRONG: Mixing default and named exports in same file
export default class UserService { }
export const helper = () => { };
```

---

## Documentation

### JSDoc Standards

All exported functions, classes, interfaces, and types MUST have JSDoc documentation.

```typescript
/**
 * Retrieves a user by their unique identifier.
 *
 * This function queries the database for a user matching the provided ID.
 * Returns null if no user is found.
 *
 * @param userId - The unique identifier of the user to retrieve
 * @returns A promise that resolves to the user object, or null if not found
 * @throws {ValidationError} If the userId format is invalid
 * @throws {DatabaseError} If the database query fails
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

/**
 * Service for managing user operations.
 *
 * Handles user creation, updates, deletion, and retrieval.
 * Enforces business rules and validation.
 *
 * @example
 * ```typescript
 * const userService = new UserService(repository);
 * const newUser = await userService.create({
 *   name: 'John Doe',
 *   email: 'john@example.com'
 * });
 * ```
 */
export class UserService {
  /**
   * Creates a new user in the system.
   *
   * @param input - User creation data
   * @param input.name - Full name of the user
   * @param input.email - Email address (must be unique)
   * @returns The created user with generated ID and timestamps
   * @throws {ValidationError} If input validation fails
   * @throws {DuplicateError} If email already exists
   */
  async create(input: CreateUserInput): Promise<User> {
    // Implementation
  }
}
```

### Inline Comments

```typescript
// ✅ CORRECT: Explain WHY, not WHAT
// Using a Map for O(1) lookup performance on large datasets
const userCache = new Map<string, User>();

// ✅ CORRECT: Document non-obvious behavior
// Note: This function mutates the input array for performance
function sortInPlace(items: Item[]): Item[] {
  return items.sort((a, b) => a.priority - b.priority);
}

// ❌ WRONG: Stating the obvious
// Increment counter by 1
counter++;

// ✅ CORRECT: TODO and FIXME comments
// TODO(john): Implement caching layer for this query
// FIXME: Race condition when multiple users update simultaneously
// HACK: Temporary workaround until API v2 is ready
```

---

## Error Handling

### Custom Error Classes

```typescript
/**
 * Base application error class.
 * All custom errors should extend this class.
 */
export class AppError extends Error {
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

export class ValidationError extends AppError {
  constructor(message: string, public readonly fields?: Record<string, string>) {
    super(message, 'VALIDATION_ERROR', 400);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string, identifier: string) {
    super(
      `${resource} with identifier '${identifier}' not found`,
      'NOT_FOUND',
      404
    );
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(message, 'UNAUTHORIZED', 401);
  }
}
```

### Error Handling Patterns

```typescript
// ✅ CORRECT: Try-catch with specific error handling
async function getUserData(userId: string): Promise<UserData> {
  try {
    const user = await userRepository.findById(userId);
    
    if (!user) {
      throw new NotFoundError('User', userId);
    }
    
    return mapUserToData(user);
  } catch (error) {
    // Re-throw known errors
    if (error instanceof AppError) {
      throw error;
    }
    
    // Log and wrap unexpected errors
    logger.error('Unexpected error fetching user', {
      userId,
      error: error instanceof Error ? error.message : String(error)
    });
    
    throw new AppError('Failed to fetch user data', 'INTERNAL_ERROR', 500);
  }
}

// ✅ CORRECT: Result type for recoverable errors
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
      error: new ValidationError('Invalid config format') 
    };
  }
}

// Usage
const result = parseConfig(rawConfig);
if (result.success) {
  console.log(result.data);
} else {
  console.error(result.error);
}

// ❌ WRONG: Swallowing errors
try {
  await riskyOperation();
} catch (error) {
  // Silent failure - never do this!
}

// ❌ WRONG: Generic catch without re-throwing
try {
  await operation();
} catch (error) {
  console.log('Error occurred');
  // Error is lost!
}
```

### Input Validation

```typescript
import { z } from 'zod';

// ✅ CORRECT: Use Zod for runtime validation
const CreateUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
  role: z.enum(['user', 'admin', 'moderator']).default('user'),
});

type CreateUserInput = z.infer<typeof CreateUserSchema>;

function createUser(input: unknown): User {
  // Validate and parse input
  const validated = CreateUserSchema.parse(input);
  
  // validated is now type-safe
  return userRepository.create(validated);
}

// ✅ CORRECT: Safe parsing with error handling
function createUserSafe(input: unknown): Result<User, ValidationError> {
  const result = CreateUserSchema.safeParse(input);
  
  if (!result.success) {
    const fields = result.error.flatten().fieldErrors;
    return { 
      success: false, 
      error: new ValidationError('Invalid input', fields) 
    };
  }
  
  const user = userRepository.create(result.data);
  return { success: true, data: user };
}
```

---

## Testing Standards

### Test File Organization

```typescript
// user-service.test.ts
import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import { UserService } from './user-service';
import type { UserRepository } from './user.repository';

describe('UserService', () => {
  let userService: UserService;
  let mockRepository: UserRepository;
  
  beforeEach(() => {
    // Create fresh mocks for each test
    mockRepository = {
      findById: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
    };
    
    userService = new UserService(mockRepository);
  });
  
  describe('getUserById', () => {
    it('should return user when found', async () => {
      // Arrange
      const userId = 'user_123';
      const expectedUser = { 
        id: userId, 
        name: 'John', 
        email: 'john@example.com' 
      };
      mockRepository.findById.mockResolvedValue(expectedUser);
      
      // Act
      const result = await userService.getUserById(userId);
      
      // Assert
      expect(result).toEqual(expectedUser);
      expect(mockRepository.findById).toHaveBeenCalledWith(userId);
      expect(mockRepository.findById).toHaveBeenCalledOnce();
    });
    
    it('should return null when user not found', async () => {
      // Arrange
      mockRepository.findById.mockResolvedValue(null);
      
      // Act
      const result = await userService.getUserById('nonexistent');
      
      // Assert
      expect(result).toBeNull();
    });
    
    it('should throw ValidationError for invalid userId format', async () => {
      // Arrange
      const invalidUserId = '';
      
      // Act & Assert
      await expect(
        userService.getUserById(invalidUserId)
      ).rejects.toThrow(ValidationError);
    });
    
    it('should throw DatabaseError when repository fails', async () => {
      // Arrange
      mockRepository.findById.mockRejectedValue(
        new Error('Connection failed')
      );
      
      // Act & Assert
      await expect(
        userService.getUserById('user_123')
      ).rejects.toThrow(DatabaseError);
    });
  });
  
  describe('createUser', () => {
    it('should create user with valid input', async () => {
      // Arrange
      const input = { 
        name: 'Jane Doe', 
        email: 'jane@example.com' 
      };
      const createdUser = { 
        id: 'user_456', 
        ...input, 
        createdAt: new Date() 
      };
      mockRepository.create.mockResolvedValue(createdUser);
      
      // Act
      const result = await userService.createUser(input);
      
      // Assert
      expect(result).toEqual(createdUser);
      expect(mockRepository.create).toHaveBeenCalledWith(
        expect.objectContaining(input)
      );
    });
    
    it('should throw ValidationError for invalid email', async () => {
      // Arrange
      const input = { name: 'John', email: 'invalid-email' };
      
      // Act & Assert
      await expect(
        userService.createUser(input)
      ).rejects.toThrow(ValidationError);
      
      expect(mockRepository.create).not.toHaveBeenCalled();
    });
    
    it('should throw DuplicateError when email exists', async () => {
      // Arrange
      const input = { name: 'John', email: 'existing@example.com' };
      mockRepository.create.mockRejectedValue(
        new DuplicateError('Email already exists')
      );
      
      // Act & Assert
      await expect(
        userService.createUser(input)
      ).rejects.toThrow(DuplicateError);
    });
  });
});
```

### Test Coverage Requirements

- **Minimum coverage:** 80% for all code
- **Critical paths:** 100% coverage (authentication, payments, data integrity)
- **Edge cases:** Always test boundary conditions
- **Error paths:** Test all error handling code

### Integration Tests

```typescript
// user-api.integration.test.ts
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import { app } from './app';
import { setupTestDatabase, teardownTestDatabase } from './test-utils';

describe('User API Integration Tests', () => {
  beforeAll(async () => {
    await setupTestDatabase();
  });
  
  afterAll(async () => {
    await teardownTestDatabase();
  });
  
  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({ 
          name: 'Test User', 
          email: 'test@example.com' 
        })
        .expect(201);
      
      expect(response.body).toMatchObject({
        id: expect.any(String),
        name: 'Test User',
        email: 'test@example.com',
        createdAt: expect.any(String),
      });
    });
    
    it('should return 400 for invalid email', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({ name: 'Test', email: 'invalid' })
        .expect(400);
      
      expect(response.body).toMatchObject({
        error: expect.objectContaining({
          code: 'VALIDATION_ERROR',
        }),
      });
    });
  });
});
```

---

## Git Conventions

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring (no functional changes)
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `build`: Build system or dependencies
- `ci`: CI/CD configuration
- `chore`: Other changes (maintenance, tooling)

**Examples:**

```
feat(auth): add OAuth2 login support

Implemented OAuth2 authentication flow using Passport.js.
Supports Google and GitHub providers.

Closes PAR-123

---

fix(api): handle null response from external service

The external API occasionally returns null instead of an empty
array. Added null check and default to empty array.

Fixes PAR-456

---

docs(readme): update installation instructions

Added steps for setting up local development environment
and required environment variables.

---

refactor(user-service): extract validation logic

Moved validation logic to separate validator module for
better testability and reusability.

---

perf(database): add index on user.email column

Query performance improved from 500ms to 50ms for
email lookup operations.

---

test(auth): add integration tests for login flow

Added comprehensive integration tests covering:
- Successful login
- Invalid credentials
- Account lockout after failed attempts
```

### Branch Naming

Format: `<username>/<linear-id>-<description>`

```bash
# ✅ CORRECT
clduab11/PAR-123-add-oauth-login
clduab11/PAR-456-fix-api-timeout
clduab11/PAR-789-refactor-user-service

# ❌ WRONG
feature/oauth-login
fix-api-bug
john-working-branch
```

### Pull Request Guidelines

**Title:** Same format as commit messages

**Description Template:**

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
Closes PAR-XXX

## Breaking Changes
None / List any breaking changes

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guide
- [ ] Tests have been added/updated
- [ ] Documentation has been updated
- [ ] No console.log or debug code
- [ ] No secrets or sensitive data in code
```

---

## Security Best Practices

### Input Validation

```typescript
// ✅ CORRECT: Always validate user input
import { z } from 'zod';

const UserInputSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
});

app.post('/api/users', async (req, res) => {
  try {
    const validated = UserInputSchema.parse(req.body);
    const user = await createUser(validated);
    res.status(201).json(user);
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({ error: error.flatten() });
    }
  }
});

// ❌ WRONG: Direct use of user input
app.post('/api/users', async (req, res) => {
  const user = await createUser(req.body); // Dangerous!
});
```

### SQL Injection Prevention

```typescript
// ✅ CORRECT: Use parameterized queries (Prisma, TypeORM, etc.)
const user = await prisma.user.findUnique({
  where: { email: userEmail }
});

// ✅ CORRECT: For raw SQL, use parameters
const users = await prisma.$queryRaw`
  SELECT * FROM users WHERE email = ${userEmail}
`;

// ❌ WRONG: String concatenation in SQL
const users = await prisma.$queryRawUnsafe(
  `SELECT * FROM users WHERE email = '${userEmail}'` // SQL injection risk!
);
```

### Authentication & Authorization

```typescript
// ✅ CORRECT: Verify authentication on protected routes
async function requireAuth(req: Request, res: Response, next: NextFunction) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    throw new UnauthorizedError('No token provided');
  }
  
  try {
    const payload = await verifyToken(token);
    req.user = payload;
    next();
  } catch (error) {
    throw new UnauthorizedError('Invalid token');
  }
}

// ✅ CORRECT: Check permissions before operations
async function deleteUser(userId: string, requestingUser: User) {
  // Users can only delete their own account, unless they're admin
  if (userId !== requestingUser.id && !requestingUser.isAdmin) {
    throw new ForbiddenError('Insufficient permissions');
  }
  
  await userRepository.delete(userId);
}
```

### Secrets Management

```typescript
// ✅ CORRECT: Use environment variables
const API_KEY = process.env.API_KEY;
if (!API_KEY) {
  throw new Error('API_KEY environment variable is required');
}

// ❌ WRONG: Hardcoded secrets
const API_KEY = 'sk-1234567890abcdef'; // Never do this!

// ✅ CORRECT: Load secrets from secure vault (production)
import { SecretManagerServiceClient } from '@google-cloud/secret-manager';

const client = new SecretManagerServiceClient();
const [version] = await client.accessSecretVersion({
  name: 'projects/my-project/secrets/api-key/versions/latest',
});
const apiKey = version.payload?.data?.toString();
```

### Logging Security

```typescript
// ✅ CORRECT: Redact sensitive data in logs
logger.info('User logged in', {
  userId: user.id,
  email: maskEmail(user.email), // john@example.com -> j***@e***.com
  ip: req.ip,
});

// ❌ WRONG: Logging sensitive data
logger.info('User logged in', {
  userId: user.id,
  email: user.email,
  password: user.password, // NEVER LOG PASSWORDS!
  token: user.token, // NEVER LOG TOKENS!
});

// ✅ CORRECT: Redact sensitive fields
function sanitizeForLogging(obj: any): any {
  const sensitive = ['password', 'token', 'apiKey', 'secret', 'ssn', 'creditCard'];
  const result = { ...obj };
  
  for (const key of Object.keys(result)) {
    if (sensitive.some(s => key.toLowerCase().includes(s.toLowerCase()))) {
      result[key] = '[REDACTED]';
    }
  }
  
  return result;
}
```

### Rate Limiting

```typescript
// ✅ CORRECT: Implement rate limiting
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per window
  message: 'Too many requests from this IP, please try again later.',
});

app.use('/api/', limiter);

// ✅ CORRECT: Stricter limits for sensitive endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // Only 5 login attempts per 15 minutes
  skipSuccessfulRequests: true,
});

app.post('/api/auth/login', authLimiter, loginHandler);
```

---

## Performance Guidelines

### Async Operations

```typescript
// ✅ CORRECT: Parallel execution
const [user, posts, comments] = await Promise.all([
  getUser(userId),
  getUserPosts(userId),
  getUserComments(userId),
]);

// ❌ WRONG: Sequential execution
const user = await getUser(userId);
const posts = await getUserPosts(userId); // Waits for user
const comments = await getUserComments(userId); // Waits for posts
```

### Database Optimization

```typescript
// ✅ CORRECT: Use pagination
async function getUsers(page: number = 1, limit: number = 20) {
  const skip = (page - 1) * limit;
  
  const [users, total] = await Promise.all([
    prisma.user.findMany({
      skip,
      take: limit,
      orderBy: { createdAt: 'desc' },
    }),
    prisma.user.count(),
  ]);
  
  return {
    users,
    pagination: {
      page,
      limit,
      total,
      pages: Math.ceil(total / limit),
    },
  };
}

// ✅ CORRECT: Select only needed fields
const user = await prisma.user.findUnique({
  where: { id: userId },
  select: {
    id: true,
    name: true,
    email: true,
    // Don't fetch password hash unless needed
  },
});

// ✅ CORRECT: Use indexes for frequently queried fields
// prisma/schema.prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique  // Automatically indexed
  name      String
  createdAt DateTime @default(now())
  
  @@index([createdAt]) // Index for sorting
}
```

### Caching

```typescript
// ✅ CORRECT: Cache expensive operations
import { LRUCache } from 'lru-cache';

const userCache = new LRUCache<string, User>({
  max: 500,
  ttl: 1000 * 60 * 5, // 5 minutes
});

async function getUserCached(userId: string): Promise<User | null> {
  // Check cache first
  const cached = userCache.get(userId);
  if (cached) {
    return cached;
  }
  
  // Fetch from database
  const user = await prisma.user.findUnique({ where: { id: userId } });
  
  // Store in cache
  if (user) {
    userCache.set(userId, user);
  }
  
  return user;
}
```

---

## AI Assistant Instructions

### For All AI Assistants (Claude, Gemini, Continue.dev)

When generating code for **{{PROJECT_NAME}}**, you MUST:

1. **Read this entire style guide** before generating any code
2. **Follow ALL conventions** defined in this document
3. **Use TypeScript strict mode** with explicit types
4. **Write comprehensive tests** for all new code
5. **Add JSDoc documentation** for all exported functions/classes
6. **Validate all user inputs** using Zod schemas
7. **Handle errors properly** with custom error classes
8. **Never log sensitive data** (passwords, tokens, PII)
9. **Use environment variables** for configuration
10. **Follow security best practices** for authentication and authorization

### Code Review Checklist

When reviewing code, check for:

- [ ] Follows naming conventions
- [ ] Has proper TypeScript types
- [ ] Has JSDoc documentation
- [ ] Has comprehensive tests
- [ ] Handles errors correctly
- [ ] Validates inputs
- [ ] No security vulnerabilities
- [ ] No hardcoded secrets
- [ ] Proper logging (no sensitive data)
- [ ] Efficient database queries
- [ ] Uses async/await correctly
- [ ] Follows file organization structure

### When in Doubt

1. **Check existing code** for patterns and examples
2. **Ask for clarification** if requirements are unclear
3. **Follow the principle of least surprise** - be consistent
4. **Prioritize correctness** over cleverness
5. **Write code that others can understand and maintain**

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024 | Initial style guide for {{PROJECT_NAME}} |

---

**Questions or suggestions?** Contact the team or create a Linear issue with the `documentation` label.
