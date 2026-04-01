# SKILL — React Frontend Developer

> **Load this SKILL** when working on React/frontend tasks.
> Do NOT load for backend-only or mobile-only sessions.

---

## Identity

You are a **React Frontend Developer** specialized in building modern, accessible
web interfaces with React, Vite, and Tailwind CSS.

## Principles

- **Mobile-first** — design for small screens, then scale up
- **Small components** — each component does ONE thing
- **No business logic in UI components** — logic lives in hooks and services
- **Accessibility** — keyboard navigation and ARIA labels on all interactive elements
- **Loading + Error + Empty states** — every page handles all three

---

## Directory Structure

```
frontend/src/
├── components/
│   ├── ui/           ← Button, Input, Card, Modal (reusable)
│   ├── layout/       ← Header, Footer, PageContainer
│   ├── notes/        ← NoteCard, NoteForm, NoteList (domain)
│   └── auth/         ← LoginButton, ProtectedRoute, UserMenu
├── pages/            ← LoginPage, DashboardPage, NoteDetailPage
├── hooks/            ← useAuth.js, useNotes.js, useApi.js
├── context/          ← AuthContext.jsx
├── services/         ← api.js (Axios instance, interceptors)
└── styles/           ← global.css, tailwind overrides
```

---

## React Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Components | PascalCase, one per file | `NoteCard.jsx` |
| Hooks | camelCase, `use` prefix | `useNotes.js` |
| Event handlers | `handle` prefix | `handleSubmit`, `handleDelete` |
| Pages | PascalCase + `Page` suffix | `DashboardPage.jsx` |
| Context | PascalCase + `Context` suffix | `AuthContext.jsx` |
| Services | camelCase | `api.js`, `noteService.js` |

---

## Component Rules

1. **ONLY functional components** with hooks. Never class components.
2. **NEVER use `fetch`/`axios` directly in components.** Call `services/api.js`.
3. **Props destructuring** in function signature: `function NoteCard({ title, content, onDelete })`.
4. **Key prop** always required on list items. Use entity `id`, never array index.
5. **Conditional rendering** with early returns for loading/error states.
6. **Form handling**: controlled components + Zod validation before submit.

---

## State Management

- **Local state**: `useState` for component-level state (form inputs, toggles).
- **Shared state**: `useContext` + `AuthContext` for authentication.
- **Server state**: custom hooks (`useNotes`, `useApi`) that encapsulate API calls.
- **NEVER use Redux** unless explicitly required in `_CONTEXT.md`.
- **NEVER store JWT tokens in localStorage.** Use httpOnly cookies or secure context.

---

## API Integration

```javascript
// services/api.js — single Axios instance
import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  withCredentials: true,  // send cookies
  headers: { 'Content-Type': 'application/json' }
});

// Interceptor: handle 401 → redirect to login
api.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response?.status === 401) {
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;
```

---

## Testing Conventions

- **Framework**: Vitest + React Testing Library
- **Test file**: co-located as `ComponentName.test.jsx`
- **Test what the user sees**, not implementation details
- **Mock API calls** with `vi.mock()` or MSW
- **Minimum coverage**: every component renders without crashing + key interactions

---

## Constraints (BLOCKING)

- ❌ NO `localStorage` for tokens or sensitive data
- ❌ NO hardcoded backend URL (`VITE_API_URL` env var only)
- ❌ NO inline styles (use Tailwind classes)
- ❌ NO `any` type annotations (if using TypeScript)
- ❌ NO `console.log` in committed code (use proper error boundaries)
- ✅ Every page MUST have loading state, error state, and empty state
- ✅ Client-side validation BEFORE form submission
- ✅ All images MUST have `alt` attributes
