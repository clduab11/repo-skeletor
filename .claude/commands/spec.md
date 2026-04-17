---
description: Generate a Notion-compatible spec from current context
---

Create a specification document ready to paste into a Notion page. Pull structure from the current conversation, open file, or selected diff.

Template:

```markdown
# {{Feature Name}}

## Overview
High-level description and business value. Who asked for this, and what changes for them when it ships.

## Requirements
### Functional
- REQ-1: ...
- REQ-2: ...

### Non-Functional
- Performance target
- Security constraint
- Scalability envelope

## Technical Design
### Architecture
- Components, data flow, sequence

### API Contracts
```typescript
// request / response schemas
```

### Data Models
```typescript
// entity definitions
```

## Implementation Plan
1. Phase 1 — scope, acceptance, estimate
2. Phase 2 — ...

## Testing Strategy
- Unit, integration, E2E

## Rollout Plan
- Feature flag name
- Monitoring dashboard / alert
- Rollback trigger

## Open Questions
- Q1?
```

Fill only what is knowable from context; mark unknowns as open questions rather than guessing.
