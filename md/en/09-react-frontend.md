# Chapter 9 — Project 6: React Frontend

## What You'll Build

A complete React frontend application that:
- Connects to the Notes API backend
- Supports login with Google and GitHub
- Displays a dashboard with the user's notes
- Supports full CRUD operations
- Has protected routes (no access without authentication)
- Uses a consistent design system

**Estimated time**: 60–90 minutes  
**Prerequisite**: Notes API backend with authentication (Chapters 6–8)

> 📦 **Tooling Box — Stack chosen for this example.**
> - **Framework:** React 19 with Vite
> - **Styling:** Tailwind CSS 4
> - **Routing:** React Router 7
> - **HTTP Client:** Axios
>
> **Equivalent alternatives:** Vue.js/Nuxt, Svelte/SvelteKit, Angular, Next.js, Astro. The **pattern** (components, protected routing, state management, API calls) is the same in any modern frontend framework. The `SKILL.md` file you'll create in this chapter works with any stack — just adapt the conventions.

---

## 9.1 — Frontend Project Setup

### 🔧 HANDS-ON — Create the React project

Open a terminal IN THE SAME directory where you have the backend, and create the frontend as a separate project:

```bash
cd ..  # Go back to the parent directory of notes-api
npm create vite@latest notes-frontend -- --template react
cd notes-frontend
npm install
```

Now you have two projects side by side:
```text
workspace/
├── notes-api/          ← Backend (Chapters 6–8)
└── notes-frontend/     ← Frontend (this chapter)
```

### 🔧 HANDS-ON — Install dependencies

```bash
npm install react-router-dom axios
npm install -D tailwindcss @tailwindcss/vite
```

---

## 9.2 — Agent Skill for the Frontend

This is the time to introduce your first **SKILL.md** — a document that gives the AI specialized expertise for the frontend.

### 🔧 HANDS-ON — Create the `SKILL.md` file

```markdown
---
name: react-frontend-developer
description: Skill for developing React interfaces with Tailwind CSS, 
  OAuth authentication, and state management with Context API.
---

# React Frontend Developer Skill

## Design Principles

- Mobile-first: design for mobile first, then scale up for desktop
- Small components: each component does ONE thing
- No business logic in UI components: use custom hooks
- Accessibility: all interactive elements must be keyboard accessible

## Tech Stack

- React 18+ with Vite
- React Router 6 for navigation
- Tailwind CSS 4 for styling (utility-first)
- Axios for API calls
- React Context for global state (auth)

## Component Structure

src/
  components/
    ui/                  ← Reusable components (Button, Input, Card, Modal)
    layout/              ← Header, Footer, Sidebar, PageContainer
    notes/               ← NoteCard, NoteForm, NoteList, NoteDetail
    auth/                ← LoginButton, ProtectedRoute, UserMenu
  pages/
    LoginPage.jsx
    DashboardPage.jsx
    NoteDetailPage.jsx
    NotFoundPage.jsx
  hooks/
    useAuth.js           ← Hook for authentication
    useNotes.js          ← Hook for notes CRUD
    useApi.js            ← Hook for API calls with error handling
  context/
    AuthContext.jsx      ← Global authentication provider
  services/
    api.js               ← Configured Axios instance (base URL, interceptors)
  App.jsx
  main.jsx

## React Conventions

- Components: PascalCase, one file per component
- Hooks: camelCase with "use" prefix
- Event handlers: "handle" prefix (handleSubmit, handleDelete)
- Props: destructuring in function parameters
- State: useState for local state, Context for global state
- Effects: useEffect with explicit dependency array, NEVER empty without reason

## Constraints

- DO NOT use class components. Only functional components with hooks.
- DO NOT fetch/axios in components. Use custom hooks.
- DO NOT store JWT in localStorage (vulnerable to XSS). Use httpOnly cookies 
  or in-memory with Context.
- DO NOT hardcode the backend URL. Use VITE_API_URL from .env.
- Every page must have a loading state and an error state.
- Forms must have client-side validation before submission.

## Style and Design

- Use Tailwind CSS utility classes, not custom CSS
- Color palette: slate for neutrals, indigo as primary, red for errors, 
  green for successes
- Rounded borders: rounded-lg as standard
- Shadows: shadow-sm for cards, shadow-md for modals
- Spacing: p-4 for standard padding, gap-4 for grid/flexbox
- Typography: font-sans, text-sm for body, text-xl for section titles
```

> 📖 **Deep Dive**: The `SKILL.md` file works like `_CONTEXT.md` but is **specialized**. It is loaded by the AI only when the type of work requires it (Progressive Disclosure). This avoids overloading the context with frontend information when you're working on the backend.

---

## 9.3 — The Frontend Context

### 🔧 HANDS-ON — Create `_CONTEXT.md` in the frontend project

```markdown
# Project: Notes Frontend

## Purpose
Frontend React for the Notes application. Connects to the Notes API backend
(http://localhost:3000) for authentication and note management.

## Technologies
- Framework: React 18 with Vite
- Routing: React Router 6
- Styling: Tailwind CSS 4
- HTTP: Axios
- State: React Context (AuthContext)
- Build: Vite

## Backend
The backend is an Express.js API available at http://localhost:3000/api
- Authentication: OAuth 2.0 (Google + GitHub)
- Notes endpoints: /api/notes (protected by JWT)
- Auth endpoints: /api/auth/google, /api/auth/github, /api/auth/me, 
  /api/auth/refresh, /api/auth/logout
- Response format: { success: boolean, data: T, error?: { message, code } }

## Authentication Flow

1. User clicks "Login with Google/GitHub"
2. Redirect to backend /api/auth/google (or /api/auth/github)
3. Backend handles OAuth and returns JWT as httpOnly cookie + 
   redirect to the frontend
4. Frontend calls /api/auth/me to get the user profile
5. AuthContext saves the user in memory
6. All subsequent API calls automatically include the cookie

## Pages

| Route | Page | Protected |
|:--|:--|:--|
| / | LoginPage (if not authenticated) / redirect to /dashboard | No |
| /dashboard | DashboardPage (note list + creation) | Yes |
| /notes/:id | NoteDetailPage (detail + edit + delete) | Yes |
| * | NotFoundPage | No |

## Constraints
- DO NOT use localStorage for JWT tokens
- DO NOT make API calls directly in components
- EVERY protected page redirects to / if not authenticated
- Axios must send cookies with withCredentials: true
- Handle loading and errors for every asynchronous operation
- The backend runs on port 3000, the frontend on port 5173 (Vite default)
- Configure the Vite proxy to avoid CORS issues in development

## Commands
- Start: npm run dev
- Build: npm run build
- Preview: npm run preview
```

---

## 9.4 — Frontend Generation

### 🔧 HANDS-ON — Generate the entire application

In Copilot Agent Mode:

```text
Read _CONTEXT.md and SKILL.md. Implement the entire React frontend.

Implementation order:
1. Configure Tailwind CSS with Vite
2. Create src/services/api.js (configured Axios instance)
3. Create src/context/AuthContext.jsx (provider + useAuth hook)
4. Create the base UI components (Button, Input, Card)
5. Create the layout (Header with UserMenu, PageContainer)
6. Create LoginPage with Google and GitHub buttons
7. Create the ProtectedRoute component
8. Create src/hooks/useNotes.js (CRUD hook for notes)
9. Create DashboardPage (note list + creation form)
10. Create notes components (NoteCard, NoteForm)
11. Create NoteDetailPage (view + edit + delete)
12. Configure React Router in App.jsx
13. Configure the Vite proxy for the backend
14. Create .env with VITE_API_URL
```

---

## 9.5 — Vite Proxy Configuration

To avoid CORS issues during development, the frontend must proxy API calls to the backend.

In the Vite configuration, the AI should have generated something like:

```javascript
// vite.config.js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        secure: false
      }
    }
  }
});
```

> 💡 **Tip**: With this proxy, in the frontend you can call `/api/notes` instead of `http://localhost:3000/api/notes`. Vite automatically forwards requests to the backend.

---

## 9.6 — Testing the Application

### 🔧 HANDS-ON — Starting up

Open **two** terminals:

**Terminal 1 — Backend:**
```bash
cd notes-api
npm run dev
```

**Terminal 2 — Frontend:**
```bash
cd notes-frontend
npm run dev
```

Open in the browser: `http://localhost:5173`

### Verification checklist

| Feature | Test |
|:--|:--|
| **Login Page** | You see the page with Google and GitHub buttons |
| **Google OAuth** | Click → redirect to Google → login → redirect to dashboard |
| **Dashboard** | You see the note list (empty at first) |
| **Create note** | Fill in the form → the note appears in the list |
| **Detail** | Click a note → detail page |
| **Edit** | Edit title/content → save → verify |
| **Delete** | Click delete → confirm → the note disappears |
| **Logout** | Click logout → redirect to login page |
| **Route protection** | Go directly to /dashboard without login → redirect to / |
| **User Menu** | You see the user's name and avatar in the header |

### 🎯 CHECKPOINT
If you can log in, create a note, edit it, and delete it, the frontend is complete.

---

## 9.7 — Design Iterations

### 🔧 HANDS-ON — Improving the appearance

```text
The dashboard works but it's a bit bare-bones. Improve the design:
1. Add an EmptyState component when there are no notes 
   (icon + message + "Create your first note" button)
2. Add transition animations on cards (hover: scale-[1.02])
3. Show tags as colored badges on NoteCards
4. Add a search field in the dashboard that filters notes by title
5. Show the creation date formatted in a relative way 
   ("2 hours ago", "yesterday", etc.)
```

### 🔧 HANDS-ON — Responsive design

```text
Verify that the interface is responsive:
1. The note list should be a grid: 1 column on mobile, 
   2 on tablet, 3 on desktop
2. The header should collapse into a hamburger menu on mobile
3. Forms should be full-width on mobile
4. Buttons should have larger padding on mobile (touch target >= 44px)
```

---

## 9.8 — Backend Updates for the Frontend

When working full-stack, sometimes the frontend reveals the need for backend changes. For example:

```text
The frontend needs a note search endpoint. 
Go back to the notes-api project and add:

GET /api/notes/search?q=term
- Search in title and content
- Case-insensitive
- Return matching notes for the authenticated user
- Also update the backend tests
```

> This back-and-forth between frontend and backend is normal in full-stack development. The `_CONTEXT.md` in each project keeps things organized.

---

## 9.9 — Commit

```bash
git init
git add .
git commit -m "feat: React frontend with OAuth login, notes dashboard, and full CRUD"
```

---

## Summary

| Aspect | Detail |
|:--|:--|
| **Framework** | React 18 + Vite |
| **Styling** | Tailwind CSS 4 |
| **Auth** | OAuth 2.0 via backend proxy |
| **State** | React Context (AuthContext) |
| **Pages** | Login, Dashboard, NoteDetail, 404 |
| **First SKILL.md** | react-frontend-developer |
| **Time** | ~60–90 minutes |

---

**→ In the next chapter**: the final integration. We'll connect all the pieces, configure end-to-end communication, and tackle the challenges of full-stack development: state synchronization, cross-layer error handling, and multi-agent development.
