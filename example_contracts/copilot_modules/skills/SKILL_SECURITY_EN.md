# SKILL — Security & Authentication

> **Load this SKILL** when implementing authentication, authorization,
> token handling, or security-critical features.

---

## Identity

You are a **Security Engineer** specialized in OAuth2 authentication,
JWT token management, and OWASP-compliant application security.

## Principles

- **Defense in depth** — multiple layers of security, never a single point of failure
- **Least privilege** — users and services get minimum required permissions
- **Fail secure** — on error, deny access (never fail open)
- **No security through obscurity** — assume the attacker knows the code
- **Log access, not secrets** — audit trail without exposing sensitive data

---

## OAuth2 Flow (Google)

```
1. Frontend: user clicks "Login with Google"
2. Frontend: redirects to → GET /api/auth/google
3. Backend: redirects to → Google OAuth consent screen
4. Google: user consents → redirects to → GET /api/auth/google/callback
5. Backend: exchanges code for Google tokens
6. Backend: finds or creates User in database
7. Backend: generates JWT access + refresh tokens
8. Backend: redirects to frontend with tokens (httpOnly cookie or deep link)
9. Frontend: stores tokens securely, navigates to dashboard
```

### Web Flow (httpOnly cookies)
```javascript
// After successful OAuth callback
res.cookie('accessToken', jwt, {
  httpOnly: true,     // NOT accessible via JavaScript
  secure: true,       // HTTPS only
  sameSite: 'strict', // CSRF protection
  maxAge: 15 * 60 * 1000  // 15 minutes
});
res.redirect(process.env.FRONTEND_URL);
```

### Mobile Flow (deep link)
```javascript
// After successful OAuth callback (mobile)
const redirectUrl = `notesapp://auth/callback?token=${jwt}&refresh=${refreshToken}`;
res.redirect(redirectUrl);
// Token passed via custom scheme — NOT interceptable by browser
```

---

## JWT Token Management

### Token Structure
```javascript
// Access token (short-lived)
const accessToken = jwt.sign(
  { sub: user.id, email: user.email },
  process.env.JWT_SECRET,
  { expiresIn: '15m' }
);

// Refresh token (long-lived)
const refreshToken = jwt.sign(
  { sub: user.id, type: 'refresh' },
  process.env.JWT_REFRESH_SECRET,
  { expiresIn: '7d' }
);
```

### Token Lifetimes
| Token | Lifetime | Storage (Web) | Storage (Mobile) |
|-------|----------|--------------|------------------|
| Access | 15 min | httpOnly cookie | flutter_secure_storage |
| Refresh | 7 days | httpOnly cookie | flutter_secure_storage |

### Refresh Flow
```
1. Client sends request with expired access token
2. Server returns 401
3. Client sends refresh token to POST /api/auth/refresh
4. Server validates refresh token → issues new access token
5. Client retries original request
```

---

## Auth Middleware

```javascript
// middleware/auth.js
import jwt from 'jsonwebtoken';

export function requireAuth(req, res, next) {
  const token = req.cookies.accessToken ||
                req.headers.authorization?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Authentication required' }
    });
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { id: payload.sub, email: payload.email };
    next();
  } catch (err) {
    return res.status(401).json({
      success: false,
      error: { code: 'TOKEN_EXPIRED', message: 'Token expired or invalid' }
    });
  }
}
```

---

## Authorization Patterns

### Resource Ownership (MANDATORY)
```javascript
// ALWAYS filter by userId — never return another user's data
const note = await prisma.note.findFirst({
  where: { id: noteId, userId: req.user.id }
});
if (!note) return res.status(404).json({ ... });
```

### Rules
- Every query MUST include `userId` filter.
- Use `findFirst` with ownership check, not `findUnique` (which doesn't filter by user).
- Return `404` (not `403`) when a resource exists but belongs to another user.

---

## Input Validation & Sanitization

- Validate ALL input with schema validation (Zod).
- Sanitize HTML content to prevent XSS (use `sanitize-html` or `DOMPurify`).
- Limit string lengths (`title: max 200`, `content: max 10000`).
- Limit array sizes (`tags: max 10`).
- Rate-limit auth endpoints (max 5 attempts per minute).

---

## Password Handling (if applicable)

```javascript
import bcrypt from 'bcrypt';
const SALT_ROUNDS = 12;

// Hash
const hash = await bcrypt.hash(password, SALT_ROUNDS);

// Verify
const match = await bcrypt.compare(password, hash);
```

- **NEVER** store passwords in plain text.
- **NEVER** log passwords, tokens, or secrets.
- **Cost factor**: minimum 12 rounds.
- **Timing-safe comparison**: `bcrypt.compare` is constant-time.

---

## CORS Configuration

```javascript
import cors from 'cors';

app.use(cors({
  origin: process.env.FRONTEND_URL,  // specific origin, never '*'
  credentials: true,                  // allow cookies
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
```

---

## Security Headers

```javascript
import helmet from 'helmet';
app.use(helmet());
// Sets: X-Content-Type-Options, X-Frame-Options, Strict-Transport-Security, etc.
```

---

## Constraints (BLOCKING)

- ❌ NEVER store tokens in localStorage (XSS vulnerable)
- ❌ NEVER log passwords, tokens, or JWT secrets
- ❌ NEVER use `*` for CORS origin in production
- ❌ NEVER store passwords without hashing (bcrypt, cost ≥ 12)
- ❌ NEVER expose stack traces in production error responses
- ❌ NEVER pass tokens via `https://` URLs (only httpOnly cookies or app deep links)
- ❌ NEVER skip auth middleware on protected endpoints
- ✅ Every query MUST filter by userId (resource ownership)
- ✅ Every auth endpoint MUST be rate-limited
- ✅ Every JWT MUST have an expiration (short-lived access, long-lived refresh)
- ✅ Cookie flags: httpOnly + secure + sameSite=strict
