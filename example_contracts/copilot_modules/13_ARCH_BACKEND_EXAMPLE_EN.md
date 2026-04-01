# AI Contract – Node.js/Express Backend Organization (EXAMPLE)

> **This is a technology-specific example** based on the Notes App from the ADLC book.
> Adapt the structure and conventions to your project's stack.
> For a Python/FastAPI, Go/Gin, Java/Spring, or .NET project, replace the Node.js-specific
> patterns with equivalent conventions from your ecosystem.

Directives for structuring a Node.js/Express backend with Prisma ORM and PostgreSQL.

---

## 1. Project Structure

```
notes-app/
├── _CONTEXT.md                      # project state and AI contract
├── PROGRESS.md                      # session history
├── .copilot/
│   ├── instructions.md              # project-specific agent rules
│   └── skills/                      # domain-specific SKILL files
│       ├── react.md
│       └── flutter.md
├── package.json
├── .env                             # local environment (NEVER committed)
├── .env.example                     # template for environment variables
│
├── backend/
│   ├── package.json
│   ├── server.js                    # entry point
│   ├── prisma/
│   │   ├── schema.prisma            # database schema
│   │   └── migrations/              # versioned migrations
│   ├── src/
│   │   ├── routes/                  # endpoint definitions (routing only)
│   │   ├── controllers/             # request/response handling
│   │   ├── services/                # business logic (DB interaction)
│   │   ├── middleware/              # auth, error handling, validation
│   │   └── utils/                   # helper functions
│   └── tests/
│       ├── unit/
│       └── integration/
│
├── frontend/
│   ├── package.json
│   ├── vite.config.js
│   ├── src/
│   │   ├── components/
│   │   │   ├── ui/                  # Button, Input, Card, Modal
│   │   │   ├── layout/              # Header, Footer, PageContainer
│   │   │   ├── notes/               # NoteCard, NoteForm, NoteList
│   │   │   └── auth/                # LoginButton, ProtectedRoute
│   │   ├── pages/                   # LoginPage, DashboardPage
│   │   ├── hooks/                   # useAuth, useNotes, useApi
│   │   ├── context/                 # AuthContext
│   │   └── services/                # api.js (Axios configured)
│   └── tests/
│
├── mobile/                          # Flutter app (optional)
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── models/
│   │   ├── providers/               # Riverpod providers
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── services/                # API client, secure storage
│   └── test/
│
└── docs/
    ├── PRD.md                       # Product Requirements Document
    ├── DESIGN.md                    # Architecture Decision Records
    ├── USE_CASES.md                 # Use cases
    └── epics/
        ├── INDEX.md
        └── tasks/
```

---

## 2. Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | kebab-case | `note-controller.js` |
| Variables/Functions | camelCase | `createNote()`, `userId` |
| Classes/Components | PascalCase | `NoteCard`, `AuthMiddleware` |
| Constants | UPPER_SNAKE | `MAX_TITLE_LENGTH`, `JWT_SECRET` |
| Database tables | snake_case (via Prisma) | `user_notes` |
| API endpoints | kebab-case, plural | `/api/notes`, `/api/auth/login` |
| Test files | `*.test.js` / `*.test.jsx` | `note-service.test.js` |

---

## 3. Organization Rules

1. **Layered architecture** — Routes → Controllers → Services → Prisma. Each layer has a single responsibility.
2. **No business logic in routes or controllers** — routes define endpoints, controllers handle HTTP, services contain logic.
3. **One service per domain entity** — `note-service.js`, `user-service.js`, `auth-service.js`.
4. **Centralized error handling** — all errors pass through `middleware/error-handler.js`.
5. **Environment variables** — all config via `.env`, accessed through a single `config.js` file.
6. **API response format** — always `{ success: boolean, data: T, error?: string }`.
7. **Validation at the boundary** — use Zod schemas in middleware, never trust client input.

---

## 4. Layer Dependencies

```
Routes → Controllers → Services → Prisma Client → PostgreSQL
                                 ↘ Utils
         Middleware (auth, validation, error handling)
```

- **Routes** depend on **Controllers** (never directly on Services).
- **Controllers** call **Services** and return HTTP responses.
- **Services** use **Prisma Client** for data access and contain all business logic.
- **Middleware** is cross-cutting: auth, validation, error handling.
- **Utils** have no upward dependencies.

---

## 5. Directives for Adding a New Feature

1. Define the Prisma model in `schema.prisma`.
2. Generate and apply the migration: `npx prisma migrate dev --name <feature>`.
3. Create the service in `src/services/<feature>-service.js`.
4. Create the controller in `src/controllers/<feature>-controller.js`.
5. Create the route in `src/routes/<feature>-routes.js`.
6. Register the route in `server.js`.
7. Add Zod validation schema in `src/middleware/validators/<feature>.js`.
8. Write tests: unit for service, integration for routes.
9. Verify: `npm test` must pass with 0 failures.

---

## 6. Directives for Frontend Components

1. One component per file, PascalCase naming.
2. Components go in the appropriate subdirectory of `src/components/`.
3. Business logic in hooks (`src/hooks/`), never in components.
4. API calls in `src/services/api.js`, never directly in components.
5. Each page must handle 3 states: loading, error, success.
6. Client-side form validation before API submission.

---

## 7. Compliance Checklist

### Manual Checklist
- [ ] File naming follows kebab-case convention.
- [ ] New files are in the correct directory (routes/, controllers/, services/).
- [ ] Every service function has a corresponding test.
- [ ] API responses follow the `{ success, data, error }` format.
- [ ] Environment variables are in `.env.example` (never hardcoded).
- [ ] Prisma migrations are committed and apply cleanly.

### Auto-Validation Rules (Agent Must Execute)

Before approving any structural change, the AI agent **must** run these checks:

| # | Rule | Validation Command / Check | Severity |
|---|------|---------------------------|----------|
| V1 | Naming convention | All files follow kebab-case; components follow PascalCase | 🔴 BLOCK |
| V2 | Layer separation | Controllers don't import Prisma directly; Routes don't contain logic | 🔴 BLOCK |
| V3 | Response format | All API responses use `{ success, data, error? }` | 🔴 BLOCK |
| V4 | Input validation | All POST/PUT/PATCH routes have Zod validation middleware | 🔴 BLOCK |
| V5 | Env vars | No hardcoded secrets; all config via `process.env` | 🔴 BLOCK |
| V6 | Test coverage | Every service function has at least one test | 🟡 WARN |
| V7 | Build green | `npm run build` (frontend) exits with code 0 | 🔴 BLOCK |
| V8 | Tests pass | `npm test` exits with code 0 | 🔴 BLOCK |
| V9 | Migration clean | `npx prisma migrate status` shows no pending migrations | 🟡 WARN |

**Validation Protocol**:
```
1. Agent proposes structural change
2. Agent runs V1-V9 checks BEFORE committing
3. If any 🔴 BLOCK fails → STOP, fix, re-validate
4. If any 🟡 WARN fails → document as tech debt in _CONTEXT.md
5. Report: "Architecture validation: ✅ V1-V9 passed" or "❌ V[N] failed: [reason]"
```
