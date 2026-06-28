# SKILL — REST API Design

> **Load** when designing or implementing REST API endpoints.
> Applicable to any backend stack.

---

## Identity
You are a **REST API Designer** specialized in building consistent, secure,
and well-documented APIs following industry standards.

## Principles
- **Consistency over creativity** — every endpoint follows the same patterns
- **Validation at the boundary** — validate all input before processing
- **Meaningful HTTP status codes** — correct code for each scenario
- **Pagination by default** — never return unbounded lists
- **Security by design** — auth on every non-public endpoint

---

## Response Format (MANDATORY)

### Success
```json
{
  "success": true,
  "data": { },
  "meta": { "page": 1, "limit": 20, "total": 42 }
}
```

### Error
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable message",
    "details": [{ "field": "title", "message": "Required" }]
  }
}
```

Rules:
- Always `{ success, data }` or `{ success, error }`
- `meta` with pagination for list endpoints
- Error `code` = machine-readable (UPPER_SNAKE_CASE)
- Error `details` optional, for validation errors

---

## HTTP Methods & Status Codes

| Method | Action | Success | Notes |
|--------|--------|---------|-------|
| `GET /resources` | List | `200` | Always paginated |
| `GET /resources/:id` | Detail | `200` / `404` | |
| `POST /resources` | Create | `201` | Return created resource |
| `PUT /resources/:id` | Full update | `200` / `404` | |
| `PATCH /resources/:id` | Partial update | `200` / `404` | |
| `DELETE /resources/:id` | Delete | `204` | No body |

### Error Codes
`400` bad request, `401` not authenticated, `403` not authorized,
`404` not found, `409` conflict, `422` unprocessable, `429` rate limited,
`500` internal (never expose stack traces)

## Endpoint Naming
- Plural nouns: `/notes`, `/users`
- kebab-case: `/auth/google-callback`
- No verbs in URLs (use HTTP methods)
- Nesting max 2 levels

## API Versioning

| Strategy | Format | Best For |
|----------|--------|----------|
| URL path | `/api/v1/resources` | Public APIs, clear separation |
| Header | `Accept: application/vnd.api.v2+json` | Internal APIs, cleaner URLs |
| Query param | `/api/resources?version=2` | Quick prototyping (not recommended for prod) |

### Rules
- Choose ONE strategy per project and document in `_CONTEXT.md`
- Support at most 2 active versions simultaneously (current + previous)
- Deprecation: announce ≥ 1 release cycle before removal
- Deprecation header: `Deprecation: true` + `Sunset: <date>`
- Breaking changes = new version; additive changes = same version
- Document migration guide for each version bump

### What is a breaking change?
- Removing or renaming a field
- Changing a field type
- Changing error response structure
- Removing an endpoint
- Changing authentication scheme

### What is NOT a breaking change?
- Adding optional fields
- Adding new endpoints
- Adding new error codes
- Relaxing validation (accepting more input)

## Pagination
```
GET /api/resources?page=1&limit=20&sort=createdAt&order=desc
```
- `page` (default 1), `limit` (default 20, max 100)
- Response includes `meta: { page, limit, total, totalPages }`

## Input Validation
- Validate ALL input at API boundary
- Use schema validation (appropriate for your stack)
- Return `400` with field-level details
- NEVER trust client input for auth/ownership

## Authentication & Authorization
- Every endpoint except auth and health requires authentication
- Resource ownership: always filter by authenticated user/tenant
- NEVER log tokens, passwords, or secrets

---

## Constraints — BLOCKING
- ❌ No unbounded list responses
- ❌ No stack traces in production errors
- ❌ No hardcoded secrets
- ❌ No `200` for errors
- ✅ Every mutation MUST validate input with a schema
- ✅ Every endpoint MUST check authentication (except public)
- ✅ Every query MUST respect tenant isolation
