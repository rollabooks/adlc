# Appendix B — Ready-to-Use Templates

All the templates from this book, ready to copy and adapt to your projects.

---

## B.1 — Base `_CONTEXT.md` Template

```markdown
# Project: [Project Name]

## Purpose
[Description in 2-3 sentences of what the application does]

## Technologies
- Language: [e.g. Python 3.12, Node.js 20, Dart]
- Framework: [e.g. Express.js, React, Flutter]
- Database: [e.g. PostgreSQL 16 with Prisma]
- Other: [key dependencies]

## Architecture
[ASCII diagram or description of the structure]

src/
  [directory structure with a comment for each folder]

## Conventions
- [Naming conventions]
- [Architectural patterns]
- [API response format if applicable]

## Constraints
- [DO NOT do X because Y]
- [ALWAYS do Z]
- [Technical or security limitations]

## Commands
- Start: [command]
- Test: [command]
- Build: [command]
```

---

## B.2 — REST API `_CONTEXT.md` Template

```markdown
# Project: [Name] API

## Purpose
[Description of the API service]

## Technologies
- Runtime: Node.js 20
- Framework: Express.js
- Validation: Zod
- Database: PostgreSQL 16 with Prisma ORM
- Auth: JWT + OAuth 2.0
- Docs: Swagger/OpenAPI

## Architecture

src/
  index.js          ← Entry point, server startup
  app.js            ← Express app, middleware, routes
  routes/           ← Endpoint definitions
  controllers/      ← Request/response handling
  services/         ← Business logic
  middleware/       ← Auth, validation, error handling
  prisma/           ← Schema and migrations

## Endpoints

| Method | Path | Auth | Description |
|:--|:--|:--|:--|
| GET | /api/resource | Yes | List resources |
| POST | /api/resource | Yes | Create resource |
| GET | /api/resource/:id | Yes | Detail |
| PUT | /api/resource/:id | Yes | Update |
| DELETE | /api/resource/:id | Yes | Delete |

## Response Format

Success:
{ "success": true, "data": { ... } }

Error:
{ "success": false, "error": { "message": "...", "code": "ERROR_CODE" } }

## Constraints
- Zod validation BEFORE the controller
- Every query filters by userId (authorization)
- Errors in production: only generic messages, never stack traces
- Rate limiting on auth endpoints

## Commands
- Dev: npm run dev
- Test: npx vitest run
- Migrate: npx prisma migrate dev
- Studio: npx prisma studio
```

---

## B.3 — React `SKILL.md` Template

```markdown
---
name: react-developer
description: Skill for React frontend development with Tailwind CSS.
---

# React Developer Skill

## Stack
- React 18+ with Vite
- Tailwind CSS 4
- React Router 6
- Axios for HTTP

## Structure
src/
  components/ui/     ← Reusable components
  components/layout/ ← Header, Footer, Container
  pages/             ← Pages (one per route)
  hooks/             ← Custom hooks
  context/           ← Context API for global state
  services/          ← API calls (Axios)

## Conventions
- Components: PascalCase, functional only, one file per component
- Hooks: camelCase with "use" prefix
- DO NOT fetch inside components, use custom hooks
- DO NOT use localStorage for JWT tokens
- Every page: loading state + error state + empty state
```

---

## B.4 — Flutter `SKILL.md` Template

```markdown
---
name: flutter-developer
description: Skill for Flutter mobile app development.
---

# Flutter Developer Skill

## Stack
- Flutter 3.x / Dart
- Riverpod 2 for state management
- GoRouter for navigation
- Dio for HTTP
- flutter_secure_storage for tokens

## Structure
lib/
  config/      ← Configuration (API URL, theme)
  models/      ← Immutable classes with fromJson/toJson
  services/    ← HTTP client, auth, business logic
  providers/   ← Riverpod StateNotifier
  screens/     ← Screens (one per route)
  widgets/     ← Reusable widgets

## Conventions
- Files: snake_case.dart, Classes: PascalCase
- Widgets: ConsumerWidget to access providers
- Models: immutable classes with factory constructor
- DO NOT use setState for shared state
- DO NOT use SharedPreferences for tokens
- Material Design 3 with useMaterial3: true
```

---

## B.5 — Analysis `SKILL.md` Template

```markdown
---
name: discovery-analysis-specialist
description: Skill for ADLC phases 0-1 — discovery and requirements analysis.
---

# Discovery & Analysis Specialist

## Responsibilities
- Elicitation of functional and non-functional requirements
- User stories with acceptance criteria
- Threat model and risk analysis
- Non-Functional Requirements (NFR) checklist

## Deliverables
- PRD (Product Requirements Document)
- User Stories with acceptance criteria
- Risk Register
- NFR Matrix

## Conventions
- Every requirement: unique ID (FR-01, NFR-01)
- User story: format "As a [role], I want [action], so that [benefit]"
- Acceptance Criteria: Given/When/Then format
- DO NOT proceed to implementation without an approved PRD
```

---

## B.6 — Design `SKILL.md` Template

```markdown
---
name: architecture-design-specialist
description: Skill for ADLC phase 2 — architecture and design.
---

# Architecture & Design Specialist

## Responsibilities
- Technology stack evaluation (weighted matrix)
- Architecture Decision Records (ADR)
- Decomposition into EPIC → Task
- API contracts and interfaces

## Deliverables
- ADR for each architectural decision
- EPIC with atomic tasks and story points
- Architectural diagrams (C4, sequence)
- API contract OpenAPI/Swagger

## Conventions
- ADR: format "Context → Options → Decision → Consequences"
- Task: ID, title, acceptance criteria, SEC/PERF constraints
- DO NOT start implementation without approved design
- Every decision justified, never "because it's the standard"
```

---

## B.7 — Operations `SKILL.md` Template

```markdown
---
name: operations-monitoring-specialist
description: Skill for ADLC phase 6 — operations and monitoring.
---

# Operations & Monitoring Specialist

## Responsibilities
- Incident triage and management
- SLA and metrics monitoring
- Structured post-mortems
- Operational runbooks

## Deliverables
- Incident Report with RCA (Root Cause Analysis)
- Post-mortem with timeline and corrective actions
- Runbooks for recurring scenarios
- Metrics dashboard (uptime, latency, errors)

## Conventions
- Incidents classified by severity (S1-S4)
- Post-mortem: blameless, system-focused
- DO NOT apply hotfixes without regression testing
- Every runbook: trigger, steps, rollback, escalation
```

---

## B.8 — Full-Stack `_CONTEXT.md` Template

```markdown
# Project: [Name] Full-Stack

## Overview
[Description in 3-4 sentences]

## Architecture
[Browser] → [Frontend :5173] → [Proxy /api] → [Backend :3000] → [PostgreSQL]

## Components

### Backend (./backend/)
- Context: ./backend/_CONTEXT.md
- Port: 3000

### Frontend (./frontend/)
- Context: ./frontend/_CONTEXT.md
- Skill: ./frontend/SKILL.md
- Port: 5173

### Mobile (./mobile/) — optional
- Context: ./mobile/_CONTEXT.md
- Skill: ./mobile/SKILL.md

## API Contract
[Endpoint table shared across all components]

## Environment Variables
### Backend: DATABASE_URL, JWT_SECRET, ...
### Frontend: VITE_API_URL

## Commands
- All: npm run dev (with concurrently)
- Backend: cd backend && npm run dev
- Frontend: cd frontend && npm run dev
```

---

## B.9 — `PROGRESS.md` Template

```markdown
# [Project Name] — Progress

## Current Status
- [x] Completed task 1
- [x] Completed task 2
- [ ] In-progress task
- [ ] Future task

## Architectural Decisions
- [Decision]: [Rationale]

## Resolved Issues
- [Problem]: [Adopted solution]

## Notes for the Next Session
- [What to remember to continue the work]
```

---

## B.10 — Full-Stack `.gitignore` Template

```text
# Environment
.env
.env.local
.env.production

# Dependencies
node_modules/

# Build
dist/
build/

# Database
*.db
*.sqlite

# IDE
.vscode/settings.json
.idea/

# OS
.DS_Store
Thumbs.db

# Secrets
*.jks
*.keystore
key.properties

# Flutter
.dart_tool/
.packages
```

---

## B.11 — Pre-Deploy Checklist

```markdown
## Security
- [ ] JWT_SECRET >= 256 bit, stored in environment variable
- [ ] Token expires (access: 1h, refresh: 7d)
- [ ] Logout invalidates refresh token
- [ ] Input validated with Zod
- [ ] Errors do not expose stack traces
- [ ] Helmet.js enabled
- [ ] Rate limiting on auth
- [ ] CORS restricted to allowed domains only
- [ ] npm audit clean
- [ ] .env in .gitignore

## Functionality
- [ ] OAuth login works
- [ ] Full CRUD works
- [ ] Route protection works
- [ ] End-to-end error handling
- [ ] Mobile connected to backend
- [ ] Health check endpoint

## Infrastructure
- [ ] Database migrated in production
- [ ] Environment variables set
- [ ] HTTPS enabled
- [ ] Monitoring enabled
```
