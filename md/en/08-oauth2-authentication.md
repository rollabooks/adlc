# Chapter 8 — Project 5: OAuth 2.0 Authentication and JWT

## What You'll Build

You'll add a complete authentication system to the Notes API:
- Login with Google and GitHub via OAuth 2.0
- JWT tokens for sessions
- Middleware to protect endpoints
- Each user sees only their own notes
- Refresh tokens for persistent sessions

**Estimated time**: 60–90 minutes  
**Prerequisite**: `notes-api` project with PostgreSQL (Chapter 7)

---

> 💡 **Theory Box — Authentication and Authorization.** **Authentication** answers the question "Who are you?" (e.g., logging in with Google). **Authorization** answers "What can you do?" (e.g., seeing only *your* notes). **OAuth 2.0** is a protocol that delegates authentication to an external service (Google, GitHub): you don't manage passwords — the service confirms the user's identity. A **JWT** (JSON Web Token) is a signed "digital ticket" that the server issues after login: the user attaches it to every subsequent request to prove their identity without logging in again. A **middleware** is code that sits between the request and the response to perform a cross-cutting concern (such as verifying the JWT).

## 8.1 — OAuth 2.0 in 5 Minutes

Before implementing, let's understand the flow. OAuth 2.0 is the protocol that lets a user log in with Google/GitHub without you having to manage passwords.

![The Simplified OAuth 2.0 Flow](../../figures/en/04-oauth2-flusso.png)

**In short**: the user authenticates with Google, Google confirms their identity to your backend, and your backend creates a JWT (a digital "ticket") that the user includes with every subsequent request.

> ⚠️ **Warning**: You won't write this flow manually. The AI will implement it for you. But you need to understand it to verify that the implementation is correct and secure.

> 📦 **Tooling Box — Stack chosen for this example.**
> - **Protocol:** OAuth 2.0 (Google and GitHub providers)
> - **Token:** JWT (JSON Web Token)
> - **Library:** Passport.js
>
> **Equivalent alternatives:** Auth0, Firebase Auth, Clerk, Supabase Auth. The **pattern** (delegated authentication + session token + protection middleware) remains identical regardless of the library or service chosen. In other languages: Python/Authlib, Go/golang-jwt, Java/Spring Security.

---

## 8.2 — Creating OAuth Credentials

### 🔧 HANDS-ON — Google OAuth

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create a new project (or select an existing one)
3. Navigate to **APIs & Services → Credentials**
4. Click **Create Credentials → OAuth Client ID**
5. Type: **Web Application**
6. Name: `Notes App`
7. Authorized redirect URIs: `http://localhost:3000/api/auth/google/callback`
8. Copy the **Client ID** and **Client Secret**

### 🔧 HANDS-ON — GitHub OAuth

1. Go to [github.com/settings/developers](https://github.com/settings/developers)
2. Click **New OAuth App**
3. Application name: `Notes App`
4. Homepage URL: `http://localhost:3000`
5. Authorization callback URL: `http://localhost:3000/api/auth/github/callback`
6. Copy the **Client ID** and **Client Secret**

### 🔧 HANDS-ON — Update the `.env` File

```env
DATABASE_URL="postgresql://notes:notes123@localhost:5432/notesdb"

# OAuth Google
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_CALLBACK_URL=http://localhost:3000/api/auth/google/callback

# OAuth GitHub
GITHUB_CLIENT_ID=your-client-id
GITHUB_CLIENT_SECRET=your-client-secret
GITHUB_CALLBACK_URL=http://localhost:3000/api/auth/github/callback

# JWT
JWT_SECRET=a-long-random-string-at-least-32-characters
JWT_EXPIRES_IN=1h
JWT_REFRESH_EXPIRES_IN=7d
```

> ⚠️ **SECURITY Warning**: The `.env` file must NEVER be committed to Git. Verify that `.gitignore` includes it. Never share client secrets.

---

## 8.3 — Updating the Context

### 🔧 HANDS-ON — Authentication Section in `_CONTEXT.md`

Add these sections:

```markdown
## Authentication

- OAuth 2.0 Provider: Google, GitHub
- Library: passport.js with passport-google-oauth20 and passport-github2
- Token: JWT (jsonwebtoken)
- Session strategy: stateless (JWT only, no server-side sessions)
- Refresh token: stored in the database, HTTP-only cookie

## Database Schema — Added User Table

model User {
  id          String   @id @default(uuid())
  email       String   @unique
  name        String
  avatarUrl   String?  @map("avatar_url")
  provider    String   // "google" | "github"
  providerId  String   @map("provider_id")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")
  notes       Note[]

  @@unique([provider, providerId])
  @@map("users")
}

model Note {
  // ... existing fields ...
  userId    String @map("user_id")
  user      User   @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model RefreshToken {
  id        String   @id @default(uuid())
  token     String   @unique
  userId    String   @map("user_id")
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  expiresAt DateTime @map("expires_at")
  createdAt DateTime @default(now()) @map("created_at")

  @@map("refresh_tokens")
}

## Updated Structure — New Files

src/
  routes/
    auth.js              ← OAuth routes (login, callback, refresh, logout)
  controllers/
    authController.js    ← Authentication controller
  services/
    authService.js       ← User and token logic
  middleware/
    authenticate.js      ← JWT middleware: protects endpoints
  config/
    passport.js          ← Passport strategy configuration

## Authentication Endpoints

| Method | Path | Description | Protected |
|:--|:--|:--|:--|
| GET | /api/auth/google | Redirect to Google login | No |
| GET | /api/auth/google/callback | Google callback | No |
| GET | /api/auth/github | Redirect to GitHub login | No |
| GET | /api/auth/github/callback | GitHub callback | No |
| POST | /api/auth/refresh | Renew access token | No (uses refresh token) |
| POST | /api/auth/logout | Invalidate refresh token | Yes |
| GET | /api/auth/me | Current user profile | Yes |

## Authentication Constraints (CRITICAL)

- NEVER store passwords in plain text (OAuth doesn't use passwords, but the principle applies)
- NEVER put the JWT secret in the code. Only in .env.
- NEVER trust user input for identity. Use ONLY data from Passport/OAuth.
- The refresh token MUST be stored in the database and invalidated on logout.
- The JWT MUST have a short expiration (1h). The refresh token expires in 7 days.
- Note endpoints MUST filter by userId: a user MUST NOT
  see other users' notes.
- OAuth callbacks MUST validate the "state" parameter to prevent CSRF.

## Risk Classification

Authentication-related operations are classified as MEDIUM RISK:
- User creation: MEDIUM (creates a record in the database)
- Token issuance: MEDIUM (grants access to the system)
- Logout/invalidation: LOW (deletion-only operation)
- Profile read: LOW (read-only)
```

> 📖 **Deep Dive**: Notice the "Risk Classification" section. This is an ADLC concept that becomes very practical: by defining the risk level of each operation in the context, the AI will be more careful when generating security code. It's the equivalent of saying "pay attention here — this part is sensitive."

---

## 8.4 — Generating the Authentication

### 🔧 HANDS-ON — Implementation

In Copilot Agent Mode:

```text
Re-read the updated _CONTEXT.md. Implement the OAuth 2.0 authentication 
system for the Notes API.

Implementation order:
1. Update the Prisma schema with User, RefreshToken, and the Note→User relation
2. Generate the migration
3. Install the dependencies (passport, passport-google-oauth20, passport-github2, 
   jsonwebtoken, cookie-parser)
4. Create src/config/passport.js with OAuth strategies
5. Create src/services/authService.js (createOrFindUser, generateTokens, 
   refreshAccessToken, revokeRefreshToken)
6. Create src/middleware/authenticate.js (JWT middleware)
7. Create src/controllers/authController.js
8. Create src/routes/auth.js
9. Update src/app.js to mount the auth routes and passport middleware
10. Update notesService.js to filter notes by userId
11. Update notesController.js to pass req.user.id to the service
12. Update tests
```

---

## 8.5 — Verifying the Authentication

### 🔧 HANDS-ON — Testing the OAuth Flow

1. Start the server: `npm run dev`

2. Open in the browser: `http://localhost:3000/api/auth/google`
   - You'll be redirected to the Google login page
   - After logging in, you'll be redirected to the callback
   - The backend will generate a JWT

3. Copy the JWT token from the response

4. Test a protected endpoint:
```bash
curl http://localhost:3000/api/notes \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

5. Test without a token (should fail):
```bash
curl http://localhost:3000/api/notes
```
```json
{ "success": false, "error": { "message": "Authentication required", "code": "UNAUTHORIZED" } }
```

6. Test user isolation: notes created with user A's token must not be visible with user B's token.

### 🎯 CHECKPOINT
- Google OAuth works ✅
- GitHub OAuth works ✅
- JWT protects endpoints ✅
- User sees only their own notes ✅
- Refresh token renews the JWT ✅
- Logout invalidates the refresh token ✅

---

## 8.6 — Security: OWASP Checklist

### 🔧 HANDS-ON — Security Verification

Ask Copilot:

```text
Analyze the project's authentication code and verify that it follows 
these OWASP security best practices:

1. Is the JWT secret long enough (>= 32 characters)?
2. Do tokens have a reasonable expiration?
3. Is the refresh token stored in the database and invalidated on logout?
4. Do OAuth callbacks validate the anti-CSRF state parameter?
5. Are security headers set (helmet)?
6. Is rate limiting applied to auth endpoints?
7. Is the database connection string not exposed in the output?

For each point, answer ✅ or ❌ with the necessary fix.
```

If there are issues, follow the suggested fixes.

> ⚠️ **Warning**: Security is the area where human review is most critical. Don't blindly trust the AI on security matters — always verify that JWT secrets, token management, and input validation are implemented correctly.

---

## 8.7 — Commit and Next Steps

```bash
git add .
git commit -m "feat: OAuth 2.0 authentication (Google + GitHub) with JWT and refresh tokens"
```

---

## Summary

| Aspect | Detail |
|:--|:--|
| **Authentication** | OAuth 2.0 (Google + GitHub) |
| **Session** | JWT + Refresh Token |
| **Libraries** | Passport.js, jsonwebtoken |
| **Security** | User isolation, token expiration, CSRF protection |
| **New files** | ~6 files |
| **Time** | ~60–90 minutes |

---
