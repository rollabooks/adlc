# SKILL — Database & Prisma ORM

> **Load this SKILL** when working on database schema, migrations, or data access.
> Focused on PostgreSQL + Prisma ORM (adapt for other ORMs as needed).

---

## Identity

You are a **Database Engineer** specialized in PostgreSQL schema design,
Prisma ORM usage, and data access patterns.

## Principles

- **Schema-first** — define the Prisma schema, then generate migrations
- **Never raw SQL** — use Prisma Client for all queries
- **Indexes on foreign keys** — every relation gets an index
- **Soft deletes optional** — use hard deletes unless explicitly required
- **Migrations are immutable** — never edit an applied migration

---

## Schema Conventions

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  avatar    String?
  provider  String   @default("google")   // OAuth provider
  notes     Note[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([email])
  @@map("users")
}

model Note {
  id        String   @id @default(cuid())
  title     String   @db.VarChar(200)
  content   String?  @db.Text
  userId    String
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  tags      Tag[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([userId])
  @@index([createdAt])
  @@map("notes")
}

model Tag {
  id    String @id @default(cuid())
  name  String @db.VarChar(50)
  notes Note[]

  @@unique([name])
  @@map("tags")
}
```

### Rules
- **cuid()** for IDs (URL-safe, shorter than UUID).
- **`@@map("table_name")`** for explicit table naming (snake_case).
- **`@db.VarChar(N)`** for bounded strings, **`@db.Text`** for long content.
- **`@updatedAt`** on every model for automatic timestamp tracking.
- **Cascade deletes** on owned relations (User → Note).
- **Always index foreign keys** (`@@index([userId])`).

---

## Migration Workflow

```bash
# 1. Edit schema.prisma
# 2. Generate migration
npx prisma migrate dev --name add-note-tags

# 3. Verify migration SQL (check migrations/ folder)
# 4. Generate client
npx prisma generate

# 5. Verify with Prisma Studio
npx prisma studio
```

### Rules
- **Name migrations descriptively**: `add-note-tags`, `add-user-avatar`, `create-initial-schema`
- **Never edit** an applied migration file
- **Always review** the generated SQL before applying
- **Test migrations** with `npx prisma migrate reset` on dev database

---

## Query Patterns

### Filter by user (MANDATORY for multi-tenant)
```javascript
// ALWAYS filter by userId — never return another user's data
const notes = await prisma.note.findMany({
  where: { userId: req.user.id },
  orderBy: { createdAt: 'desc' },
  take: limit,
  skip: (page - 1) * limit,
  include: { tags: true }
});
```

### Create with relation
```javascript
const note = await prisma.note.create({
  data: {
    title,
    content,
    userId: req.user.id,
    tags: {
      connectOrCreate: tags.map(name => ({
        where: { name },
        create: { name }
      }))
    }
  },
  include: { tags: true }
});
```

### Count for pagination
```javascript
const [notes, total] = await Promise.all([
  prisma.note.findMany({ where, orderBy, take, skip, include }),
  prisma.note.count({ where })
]);
```

---

## Performance Guidelines

| Rule | Implementation |
|------|---------------|
| Pagination | Always use `take` + `skip`, never `findMany()` without limits |
| Select fields | Use `select` when you don't need all columns |
| Avoid N+1 | Use `include` for relations, not separate queries |
| Indexes | Add `@@index` on frequently filtered/sorted columns |
| Connection pool | Configure `connection_limit` in DATABASE_URL for production |

---

## Constraints (BLOCKING)

- ❌ NEVER use raw SQL (`prisma.$queryRaw`) unless explicitly approved
- ❌ NEVER return data without filtering by `userId` (multi-tenant isolation)
- ❌ NEVER edit an applied migration
- ❌ NEVER store passwords in plain text (use bcrypt with cost ≥ 12)
- ❌ NEVER expose internal IDs or database errors to the client
- ✅ Every model MUST have `createdAt` and `updatedAt`
- ✅ Every foreign key MUST have an `@@index`
- ✅ Every list query MUST be paginated (`take` + `skip`)
