# PROGRESS — Notes App

> Session history and persistent memory between conversations.
> Updated by the agent at the end of each session (with human approval).

---

## Session 3 — 2026-03-30

### Completed
- ✅ E-002 T-002.1: OAuth2 Google authentication (Passport.js)
- ✅ E-002 T-002.2: JWT middleware (access + refresh tokens)
- ✅ E-002 T-002.3: Auth routes (`/api/auth/google`, `/api/auth/refresh`, `/api/auth/logout`)
- ✅ Auth integration tests (3 tests passing)

### Decisions Made
- Using httpOnly cookies for web token storage (SEC-03)
- Refresh token rotation: each refresh invalidates the previous token
- Rate limiting on auth endpoints: 5 requests/minute per IP

### Problems Encountered
- Google OAuth callback URL must match exactly (trailing slash issue)
- Solved: normalized callback URL in both Google Console and `.env`

### Next Steps
- E-003 T-003.1: Define Note model in Prisma schema
- E-003 T-003.2: Implement CRUD endpoints for Notes

---

## Session 2 — 2026-03-29

### Completed
- ✅ E-001 T-001.3: PostgreSQL setup with Neon
- ✅ E-001 T-001.4: Prisma initial schema (User model)
- ✅ E-001 T-001.5: Health check endpoint (`GET /api/health`)
- ✅ First migration applied successfully

### Decisions Made
- Using cuid() for IDs (URL-safe, shorter than UUID)
- Added `@@map("table_name")` for explicit table naming

### Problems Encountered
- Neon connection string requires `?sslmode=require` — added to `.env.example`

### Next Steps
- E-002: Authentication with OAuth2 Google

---

## Session 1 — 2026-03-28

### Completed
- ✅ E-001 T-001.1: Project scaffolding (monorepo structure)
- ✅ E-001 T-001.2: Express server with basic middleware (cors, helmet, error handler)
- ✅ `_CONTEXT.md` created with full project spec
- ✅ `.copilot/instructions.md` configured

### Decisions Made
- Monorepo structure: `backend/`, `frontend/`, `mobile/`, `docs/`
- Prisma over Drizzle (better DX, more tutorials available)
- Zod over Joi (TypeScript-first, composable schemas)

### Problems Encountered
- None

### Next Steps
- E-001 T-001.3: Connect to PostgreSQL (Neon)
