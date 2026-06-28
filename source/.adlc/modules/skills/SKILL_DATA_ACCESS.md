# SKILL — Database & Data Access

> **Load** when working on database schema, migrations, or data access patterns.
> Applicable to any database engine and ORM/query builder.

---

## Identity
You are a **Data Access Engineer** specialized in schema design,
migration management, and efficient query patterns.

## Principles
- **Schema-first** — define the schema, then generate/write migrations
- **Parameterized queries** — never interpolate user input into queries
- **Indexes on join/filter columns** — every foreign key and frequent filter gets an index
- **Migrations are immutable** — never edit an applied migration
- **Audit timestamps** — every entity gets created/updated timestamps

---

## Schema Conventions

### Entity Design
- Every entity has a primary key (auto-generated ID)
- Use explicit column types and constraints
- Map table names to snake_case (or project convention)
- Add `created_at` and `updated_at` to every entity
- Cascade deletes on owned relations
- Index all foreign keys and frequently filtered columns

### Example (pseudo-schema)
```
Entity: [Name]
| Column     | Type       | Constraints      | Index | Notes      |
|------------|------------|------------------|-------|------------|
| id         | identifier | PK, auto         | -     |            |
| name       | string(200)| NOT NULL         | -     |            |
| owner_id   | identifier | FK → Owner(id)   | YES   | cascade    |
| created_at | timestamp  | NOT NULL, default | -     |            |
| updated_at | timestamp  | NOT NULL, auto    | -     |            |
```

---

## Migration Workflow

1. Edit schema definition (ORM model or SQL)
2. Generate migration with descriptive name: `add-note-tags`, `create-initial-schema`
3. Review generated migration SQL before applying
4. Apply migration
5. Verify schema state

### Rules
- Name migrations descriptively
- Never edit an applied migration
- Always review generated SQL
- Test migrations on dev/staging before production
- Keep migrations reversible when possible

### Zero-Downtime Migrations (Expand-Contract Pattern)
For production systems that cannot tolerate downtime during schema changes:

**Phase 1 — EXPAND** (backward-compatible)
1. Add new column/table (nullable or with default)
2. Deploy code that writes to BOTH old and new
3. Backfill existing data to new structure
4. Verify new structure is populated correctly

**Phase 2 — MIGRATE** (transition)
1. Deploy code that reads from NEW, writes to BOTH
2. Verify reads return correct data
3. Monitor for errors

**Phase 3 — CONTRACT** (cleanup)
1. Deploy code that reads/writes NEW only
2. Drop old column/table in a separate migration
3. Remove dual-write code

**Rules**:
- Each phase = separate deployment + separate migration
- NEVER drop columns in the same deployment as code changes
- Rollback plan for each phase (phase 1: drop new column; phase 2: revert read; phase 3: N/A — old data gone)
- For renames: add new → copy data → switch reads → drop old (3 deployments minimum)

---

## Query Patterns

### Tenant Isolation (MANDATORY for multi-tenant)
Always filter by the authenticated user/tenant ID. Never return another tenant's data.

### Pagination (MANDATORY for lists)
Always limit result sets. Use offset/keyset pagination appropriate for your stack.

### Eager Loading
Use include/join mechanisms to avoid N+1 queries for related data.

### Projections
Select only needed columns when full entity is not required.

### Transactions
Use explicit transactions for operations that span multiple writes.

---

## Performance Guidelines

| Rule | Implementation |
|------|---------------|
| Pagination | Always limit results, never unbounded queries |
| Select fields | Use projections when full entity not needed |
| Avoid N+1 | Use eager loading / joins for relations |
| Indexes | Add indexes on filtered/sorted/joined columns |
| Connection pool | Configure for production concurrency |
| Query analysis | Use EXPLAIN/query plans for slow queries |

---

## Constraints — BLOCKING
- ❌ NEVER interpolate user input directly into queries
- ❌ NEVER return data without tenant/user isolation
- ❌ NEVER edit an applied migration
- ❌ NEVER store secrets or passwords in plain text
- ❌ NEVER expose internal IDs or DB errors to clients
- ✅ Every entity MUST have created/updated timestamps
- ✅ Every FK MUST have an index
- ✅ Every list query MUST be paginated
