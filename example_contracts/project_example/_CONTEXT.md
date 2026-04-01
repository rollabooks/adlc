# PROJECT CONTEXT — Notes App

> This file is the **single source of truth** for the AI agent.
> Updated at the end of every session.
> Priority: this file overrides `.copilot/instructions.md` and `.github/copilot_modules/`.

---

## Current State

| Param | Value |
|-------|-------|
| **Project** | Notes App |
| **Phase** | 4 — Implementation |
| **Sprint** | 2 |
| **Active Task** | E-003 T-003.2 — CRUD endpoints for Notes |
| **Branch** | `feat/E-003-crud-notes` |
| **Mode** | STANDARD |
| **Active SKILL** | `api-design.md` (backend CRUD task) |
| **Blockers** | None |

---

## Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **Backend** | Node.js + Express | 20 LTS + 4.x |
| **Database** | PostgreSQL + Prisma | 16 + 5.x |
| **Frontend** | React + Vite + Tailwind | 18 + 5.x + 3.x |
| **Mobile** | Flutter + Riverpod | 3.x + 2.x |
| **Auth** | OAuth2 Google + JWT | Passport.js |
| **Deploy** | Railway (backend) + Vercel (frontend) + Neon (DB) | — |
| **Testing** | Jest (backend) + Vitest (frontend) + flutter_test | — |

---

## Architecture

**Pattern**: Layered (Routes → Controllers → Services → Prisma)
**API Style**: REST with JSON envelope `{ success, data, error }`
**Auth**: OAuth2 Google → JWT (httpOnly cookies for web, secure storage for mobile)

```
Frontend (React/Vite)  ←→  Backend (Express)  ←→  PostgreSQL (Prisma)
                              ↑
Mobile (Flutter/Dio)  ────────┘
```

---

## Critical Constraints

| ID | Constraint | Details |
|----|-----------|---------|
| SEC-01 | Input validation | Zod schemas on all POST/PUT/PATCH. Server-side mandatory. |
| SEC-02 | Password hashing | bcrypt with cost ≥ 12. Never plain text. |
| SEC-03 | Token storage | httpOnly cookies (web), flutter_secure_storage (mobile). Never localStorage. |
| SEC-04 | Resource ownership | Every query filters by `userId`. Never return another user's data. |
| SEC-05 | No secrets in code | All secrets via `.env`. Never hardcoded. |
| PERF-01 | Pagination | All list endpoints paginated. Max 100 items per page. |
| PERF-02 | DB indexes | Index on every foreign key and frequently filtered column. |
| PERF-03 | Response time | P95 < 200ms for API endpoints. |

---

## Commands

| Purpose | Command |
|---------|---------|
| **Start backend** | `cd backend && npm run dev` |
| **Start frontend** | `cd frontend && npm run dev` |
| **Run backend tests** | `cd backend && npm test` |
| **Run frontend tests** | `cd frontend && npm test` |
| **Prisma migrate** | `cd backend && npx prisma migrate dev` |
| **Prisma studio** | `cd backend && npx prisma studio` |
| **Flutter run** | `cd mobile && flutter run` |
| **Flutter test** | `cd mobile && flutter test` |

---

## Conventions

- **JavaScript**: ES2022+, ESModules (`import/export`), async/await
- **Naming**: camelCase (vars/functions), PascalCase (classes/components), UPPER_SNAKE (constants)
- **Files**: kebab-case (backend), PascalCase (React components), snake_case (Flutter)
- **API responses**: always `{ success: boolean, data: T, error?: { code, message } }`
- **Commits**: conventional commits (`feat:`, `fix:`, `docs:`, `test:`)
- **Branching**: `feat/E-NNN-description`, `fix/issue-description`

---

## Recent Decisions

| Date | Decision | Rationale |
|------|---------|-----------|
| 2026-03-28 | Prisma over Drizzle | Better DX, auto-migrations, extensive docs |
| 2026-03-28 | Zod over Joi | TypeScript-first, smaller bundle, composable |
| 2026-03-29 | OAuth2 Google only | Simplifies auth, no password management needed |
| 2026-03-30 | Neon for PostgreSQL | Free tier, serverless scaling, branch databases |

---

## Scratchpad

- [ ] Evaluate adding tag filtering (GET /api/notes?tag=work)
- [ ] Consider WebSocket for real-time note sync (Phase 6 if needed)
- [x] ~~Decided on Prisma over Drizzle~~ (2026-03-28)
