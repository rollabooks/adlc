# Appendix F — Autonomous Final Project: BookShelf

## Your Architecture Exam

This project has no step-by-step guide. You have the brief, the starter `_CONTEXT.md`, and the **professional workflow** from Section 3.8 — the same decomposition method you would use in a real project. Your task is to apply it from start to finish: generate the specifications, derive the use cases, structure the epics, break them down into tasks, and implement.

If you can complete BookShelf on your own, you have internalized the ADLC method.

---

## F.1 — The Brief

**BookShelf** is an application for managing your personal library. You can catalog the books you own, the ones you are currently reading, and the ones you want to read. The application has an API backend, a web frontend, and a mobile app.

### Functional Requirements

1. **Book catalog**: Full CRUD (title, author, year, genre, optional ISBN, optional cover URL)
2. **Reading status**: Each book has a status — "To Read", "Reading", "Read", "Abandoned"
3. **Personal notes**: Users can add notes and a rating (1–5 stars) to each book
4. **Search and filters**: Search by title/author, filter by status and genre
5. **Statistics**: Dashboard with book count by status, books read per year, most-read genre
6. **Authentication**: OAuth 2.0 login (Google)
7. **Multi-user**: Each user sees only their own library

### Non-Functional Requirements

- Backend: Node.js + Express + PostgreSQL + Prisma
- Frontend: React + Tailwind CSS
- Mobile: Flutter
- Deployment: Cloud platforms of your choice (Railway, Vercel, Neon, or equivalents)

---

## F.2 — The Starter `_CONTEXT.md`

This is your starting point. Copy it to the project root and use it as a base. You can — and should — modify and improve it as you go.

```markdown
# Project: BookShelf

## Purpose
Web + mobile application for managing a personal library.
Each user can catalog books, track reading status,
add notes, and view statistics.

## Technologies
- Backend: Node.js 20+, Express.js, PostgreSQL 16, Prisma ORM
- Frontend: React 18+ with Vite, Tailwind CSS
- Mobile: Flutter 3.x with Dart, Riverpod for state management
- Auth: OAuth 2.0 with Google (passport.js)
- Tokens: JWT (access 1h, refresh 7d)

## Structure
bookshelf/
├── _CONTEXT.md
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── middleware/
│   │   └── utils/
│   ├── prisma/
│   │   └── schema.prisma
│   └── tests/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/
│   │   └── context/
│   └── tests/
└── mobile/
    └── bookshelf_app/
        └── lib/
            ├── models/
            ├── providers/
            ├── screens/
            ├── services/
            └── widgets/

## Data Model (indicative Prisma schema)
- User: id, email, name, avatar, createdAt
- Book: id, userId, title, author, year, genre, isbn?, coverUrl?,
        status (TO_READ | READING | READ | ABANDONED),
        rating (1-5)?, notes?, createdAt, updatedAt
- ReadingSession: id, bookId, startDate, endDate?, pagesRead?

## Conventions
- Naming: camelCase for JS/TS, snake_case for DB columns
- API responses: { success: boolean, data: T, error?: string }
- Validation: Zod on all endpoints
- Commits: Conventional Commits (feat, fix, refactor, docs, test)

## Constraints (SEC/PERF)
- SEC-01: JWT secret >= 256 bits, stored in environment variable
- SEC-02: Every query filters by userId — NO exceptions
- SEC-03: Input sanitized and validated before reaching the database
- SEC-04: Rate limiting on auth endpoints (10 req/min)
- SEC-05: Helmet.js for security headers
- PERF-01: Pagination on GET /books (default 20, max 100)
- PERF-02: Index on Book.userId and Book.status

## Commands
- Backend dev: cd backend && npm run dev
- Backend test: cd backend && npm test
- Frontend dev: cd frontend && npm run dev
- Frontend test: cd frontend && npm test
- DB migrate: cd backend && npx prisma migrate dev
- Mobile run: cd mobile/bookshelf_app && flutter run
- Mobile test: cd mobile/bookshelf_app && flutter test
```

---

## F.3 — The Workflow: From Idea to Code

This project has no step-by-step guide, but you have a **method**. Apply the professional workflow from Section 3.8 to break BookShelf down into manageable units of work — exactly as you would in a real project.

### Step 1: Generate the Specifications

Open a chat with the AI and use the brief as input:

```text
"Here is the BookShelf brief: [paste F.1].
 Generate a complete PRD with functional requirements (FR-01, FR-02…),
 non-functional requirements (NFR-01…), technical constraints, and priorities.
 Save to docs/PRD.md."
```

### Step 2: Derive the Use Cases

```text
"Based on the PRD in docs/PRD.md, generate the main use cases.
 For each use case: actor, precondition, main flow,
 alternative flows, postcondition. Save to docs/USE_CASES.md."
```

### Step 3: Design and Technical Decisions

Before breaking the work into epics and tasks, have the human (that is, you) make the architectural decisions:

```text
"Based on the PRD and use cases for BookShelf, propose the system
 architecture. For each technical decision (database, ORM, authentication,
 project structure, API patterns) present 2–3 options with pros, cons,
 and a recommendation. I choose, you document in docs/DESIGN.md."
```

Make every decision deliberately — the AI proposes, you decide. The result is a `docs/DESIGN.md` containing the ADRs (Architecture Decision Records) that will guide the entire project.

### Step 4: Structure the Epics

```text
"Based on the use cases, organize the work into epics (E-001, E-002…).
 For each epic: title, objective, covered use cases, dependencies.
 Save the index to docs/epics/INDEX.md and one file per epic."
```

The suggested epics cover the 4 project phases:

| Phase | Epic | Reference Chapters |
|-------|------|---------------------|
| Backend | E-001 Setup, E-002 Auth, E-003 CRUD, E-004 Filters, E-005 Stats | Ch. 6–8 |
| Frontend | E-006 Web Frontend | Ch. 9–10 |
| Mobile | E-007 Mobile App | Ch. 11–12 |
| Production | E-008 Testing/Security, E-009 Deploy | Ch. 14–15 |

### Step 5: Break Down into Tasks

For each epic, ask the AI to generate atomic tasks:

```text
"Break down epic E-003 into atomic tasks (T-003.1, T-003.2…).
 Each task must have: verifiable acceptance criteria,
 involved files, applicable SEC/PERF constraints, story points."
```

Follow the task template from Section 3.8. Save to `docs/epics/tasks/E-003/`.

### Step 6: Implement Task by Task

```text
"Implement T-003.1. Read docs/epics/tasks/E-003/T-003.1_*.md.
 Follow the constraints from _CONTEXT.md."
```

Each session closes one or more tasks. When finished, update the status and the `_CONTEXT.md`.

> **Tip:** Do not proceed to Phase 2 (Frontend) until all backend tasks are ✅ and the tests pass. The task breakdown gives you visibility — use it.

---

## F.4 — Phase Challenges

Here are the high-level objectives for each phase. The detailed breakdown into epics and tasks is your job — using the workflow from Steps 4 and 5.

### Phase 1: Backend (Chapters 6–8)

1. Initialize the Node.js project with Express
2. Configure Prisma with the `Book` and `User` schema
3. Implement the CRUD endpoints for books
4. Add OAuth 2.0 authentication with Google
5. Add the statistics endpoint (`GET /api/stats`)
6. Write unit and integration tests
7. Verify the security checklist (SEC-01 → SEC-05)

### Phase 2: Frontend (Chapters 9–10)

1. Create the React project with Vite and Tailwind
2. Implement the login page with OAuth redirect
3. Build the dashboard with book list and filters
4. Implement the form to add/edit books
5. Create the statistics page with counts and simple charts
6. Integrate with the real backend (remove mocks)
7. Write tests with testing-library

### Phase 3: Mobile (Chapters 11–12)

1. Create the Flutter project
2. Implement authentication from mobile
3. Build the book list with pull-to-refresh
4. Implement the book detail view with notes and rating
5. Add search and filters
6. Write widget tests

### Phase 4: Production (Chapters 14–15)

1. Run an OWASP Top 10 audit on the backend
2. Apply the security fixes
3. Deploy the backend to Railway
4. Deploy the frontend to Vercel
5. Database on Neon
6. Verify that everything works end-to-end

---

## F.5 — Success Criteria

The project is complete when:

- [ ] A user can log in with Google
- [ ] They can add, edit, and delete books
- [ ] They can change the reading status
- [ ] They can add notes and ratings
- [ ] They can search and filter books
- [ ] They see statistics on the dashboard
- [ ] The mobile app shows the same data
- [ ] All tests pass
- [ ] The security checklist is completed
- [ ] The application is accessible online (deployed)
- [ ] The `_CONTEXT.md` is updated with lessons learned (ADLC Phase 6)

---

## F.6 — Hints (Spoiler-Free)

- **Follow the workflow from Section 3.8.** First generate the PRD, then use cases, then epics, then tasks. Only then implement.
- **Start with the backend.** It is the foundation for everything else.
- **Use the `_CONTEXT.md` from the very beginning.** Do not proceed without context.
- **Test each phase before moving on to the next.** Do not build the frontend on a backend that does not work.
- **If the AI generates something you do not understand, ask**: "Explain this code line by line" — it is always a valid prompt.
- **If you get stuck**, revisit the corresponding chapter of the book. The technique is the same — only the application domain changes.
- **Update the `_CONTEXT.md`** every time you discover something new. This is Continuous Learning (ADLC Phase 6) in action.

---

> *If you have completed BookShelf, congratulations: you are a context architect. The ADLC method is no longer something you have read — it is something you know how to do.*
