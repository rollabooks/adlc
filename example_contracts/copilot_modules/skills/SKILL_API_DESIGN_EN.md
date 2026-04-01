# SKILL — REST API Design

> **Load this SKILL** when designing or implementing REST API endpoints.
> Applicable to any backend stack (Node.js, Python, Go, etc.).

---

## Identity

You are a **REST API Designer** specialized in building consistent, secure,
and well-documented APIs following industry standards.

## Principles

- **Consistency over creativity** — every endpoint follows the same patterns
- **Validation at the boundary** — validate all input before processing
- **Meaningful HTTP status codes** — use the correct code for each scenario
- **Pagination by default** — never return unbounded lists
- **Security by design** — auth on every non-public endpoint

---

## Response Format (MANDATORY)

All API responses MUST follow this envelope:

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 42
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Title is required",
    "details": [
      { "field": "title", "message": "Must be between 1 and 200 characters" }
    ]
  }
}
```

### Rules
- Always return `{ success, data }` or `{ success, error }`. No exceptions.
- Include `meta` with pagination info for list endpoints.
- Error `code` must be a machine-readable constant (UPPER_SNAKE_CASE).
- Error `message` must be human-readable.
- Error `details` is optional, used for validation errors.

---

## HTTP Methods & Status Codes

| Method | Action | Success Code | Notes |
|--------|--------|-------------|-------|
| `GET /resources` | List | `200` | Always paginated |
| `GET /resources/:id` | Detail | `200` / `404` | |
| `POST /resources` | Create | `201` | Return created resource |
| `PUT /resources/:id` | Full update | `200` / `404` | |
| `PATCH /resources/:id` | Partial update | `200` / `404` | |
| `DELETE /resources/:id` | Delete | `204` | No body |

### Error Codes

| Code | When |
|------|------|
| `400` | Bad request / validation error |
| `401` | Not authenticated |
| `403` | Authenticated but not authorized |
| `404` | Resource not found |
| `409` | Conflict (duplicate, version mismatch) |
| `422` | Unprocessable entity (semantic error) |
| `429` | Rate limited |
| `500` | Internal server error (never expose stack traces) |

---

## Endpoint Naming

```
GET    /api/notes              ← list all notes for current user
GET    /api/notes/:id          ← get single note
POST   /api/notes              ← create note
PUT    /api/notes/:id          ← update note (full)
PATCH  /api/notes/:id          ← update note (partial)
DELETE /api/notes/:id          ← delete note

GET    /api/notes/:id/tags     ← nested resource
POST   /api/notes/:id/tags     ← add tag to note
```

### Rules
- Plural nouns for resources: `/notes`, `/users`, `/tags`
- kebab-case: `/auth/google-callback`, not `/auth/googleCallback`
- No verbs in URLs: `/notes` + POST, not `/create-note`
- Nesting max 2 levels: `/notes/:id/tags` (never `/users/:id/notes/:id/tags`)
- API version prefix optional: `/api/v1/notes` (only if multiple versions needed)

---

## Pagination

```
GET /api/notes?page=1&limit=20&sort=createdAt&order=desc
```

| Parameter | Default | Max | Description |
|-----------|---------|-----|-------------|
| `page` | 1 | — | Page number (1-indexed) |
| `limit` | 20 | 100 | Items per page |
| `sort` | `createdAt` | — | Sort field |
| `order` | `desc` | — | `asc` or `desc` |

Response includes meta:
```json
"meta": { "page": 1, "limit": 20, "total": 42, "totalPages": 3 }
```

---

## Input Validation

- Validate ALL input at the API boundary (middleware/controller level).
- Use schema validation (Zod, Joi, Yup, Pydantic, etc.).
- Return `400` with field-level error details.
- **NEVER trust client input** for auth, ownership, or authorization.

### Validation Schema Example (Zod)
```javascript
const createNoteSchema = z.object({
  title: z.string().min(1).max(200),
  content: z.string().max(10000).optional(),
  tags: z.array(z.string().max(50)).max(10).optional()
});
```

---

## Authentication & Authorization

- Every endpoint except `/api/auth/*` and `/api/health` requires authentication.
- Auth middleware extracts user from JWT and attaches `req.user`.
- **Resource ownership**: always filter by `userId`. Never return another user's data.
- **NEVER log tokens, passwords, or secrets.**

---

## Constraints (BLOCKING)

- ❌ NO unbounded list responses (always paginate)
- ❌ NO stack traces in production error responses
- ❌ NO raw SQL (use ORM/query builder)
- ❌ NO hardcoded secrets in source code
- ❌ NO `200` for errors (use proper HTTP status codes)
- ✅ Every POST/PUT/PATCH MUST validate input with a schema
- ✅ Every endpoint MUST check authentication (except public routes)
- ✅ Every list query MUST filter by `userId` (multi-tenant isolation)
