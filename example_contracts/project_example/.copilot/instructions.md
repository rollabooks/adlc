# Notes App — Project-Specific Agent Rules

> This file contains rules specific to the Notes App project.
> It overrides generic `.github/copilot_modules/` rules where noted.
> Priority: `_CONTEXT.md` > this file > `.copilot/skills/` > `.github/copilot_modules/`

---

## Available SKILLs

Load the appropriate SKILL based on the current phase and task:

| Phase | SKILL | When to Load |
|-------|-------|-------------|
| 0-1 | `.copilot/skills/analysis.md` | Requirements elicitation, user stories, threat model |
| 2 | `.copilot/skills/design.md` | Stack selection, ADRs, EPIC/task breakdown |
| 3-4 | `.copilot/skills/react.md` | Frontend React tasks |
| 3-4 | `.copilot/skills/flutter.md` | Mobile Flutter tasks |
| 3-4 | `.copilot/skills/api-design.md` | Backend API endpoints |
| 3-4 | `.copilot/skills/database.md` | Schema, migrations, queries |
| 3-4 | `.copilot/skills/security.md` | Auth, JWT, CORS |
| 6 | `.copilot/skills/ops.md` | Incidents, monitoring, runbooks |

---

## Stack Rules

### Backend (Node.js + Express)
- **JavaScript ES2022+** with ESModules (`import/export`). NEVER use `require()` or `module.exports`.
- **async/await** for all asynchronous code. NEVER use callbacks or `.then()`.
- **Prisma Client** for all database queries. NEVER use raw SQL.
- **Express Router** for modular routes. One file per resource.

### Frontend (React + Vite)
- **Load SKILL**: `.copilot/skills/react.md` when working on frontend tasks
- **Vite** for build and dev server. NEVER use Create React App.
- **Tailwind CSS** for styling. NEVER use CSS-in-JS or inline styles.
- **Axios** via `services/api.js` for all API calls. NEVER use `fetch` directly.

### Mobile (Flutter)
- **Load SKILL**: `.copilot/skills/flutter.md` when working on mobile tasks
- **Riverpod** for state management. NEVER use `setState` for shared state.
- **Dio** for HTTP client. NEVER use `http` package directly.
- **GoRouter** for navigation. NEVER use `Navigator.push` directly.

---

## Domain Knowledge

### Note Entity
```
Note {
  id: string (cuid)
  title: string (1-200 chars, required)
  content: string (0-10000 chars, optional)
  userId: string (FK → User, required)
  tags: Tag[] (many-to-many, max 10)
  createdAt: DateTime
  updatedAt: DateTime
}
```

### User Entity
```
User {
  id: string (cuid)
  email: string (unique, from Google OAuth)
  name: string (from Google profile)
  avatar: string (Google profile picture URL)
  provider: "google"
  notes: Note[]
  createdAt: DateTime
  updatedAt: DateTime
}
```

### Tag Entity
```
Tag {
  id: string (cuid)
  name: string (unique, 1-50 chars)
  notes: Note[]
}
```

---

## Testing Requirements

- **Backend**: Jest with supertest for integration tests
  - Every service function has at least one unit test
  - Every route has at least one integration test
  - Mock Prisma client in unit tests, use test database in integration tests
- **Frontend**: Vitest with React Testing Library
  - Every component renders without crashing
  - Key interactions tested (form submit, delete confirmation)
- **Mobile**: flutter_test with mocktail
  - Every screen has a widget test
  - Every provider has a unit test

---

## Environment Variables

```bash
# Backend
DATABASE_URL=postgresql://user:pass@host:5432/notes?sslmode=require
JWT_SECRET=<random-64-chars>
JWT_REFRESH_SECRET=<random-64-chars>
GOOGLE_CLIENT_ID=<from-google-console>
GOOGLE_CLIENT_SECRET=<from-google-console>
GOOGLE_CALLBACK_URL=http://localhost:3000/api/auth/google/callback
FRONTEND_URL=http://localhost:5173
PORT=3000

# Frontend
VITE_API_URL=http://localhost:3000

# Mobile (--dart-define)
API_URL=http://10.0.2.2:3000  # Android emulator → host localhost
```

---

## Deployment

| Service | Provider | URL |
|---------|---------|-----|
| Backend | Railway | `https://notes-api.up.railway.app` |
| Frontend | Vercel | `https://notes-app.vercel.app` |
| Database | Neon | `postgresql://...@ep-xxx.us-east-2.aws.neon.tech/notes` |

### Deploy Checklist
- [ ] All tests passing
- [ ] Environment variables configured in Railway/Vercel dashboard
- [ ] CORS origin updated to production URL
- [ ] Google OAuth callback URL updated for production
- [ ] Database migrations applied to production
