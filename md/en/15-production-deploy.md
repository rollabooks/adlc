# Chapter 15 — Production Deploy

## What You Will Build

The entire stack deployed on cloud platforms:
- PostgreSQL database on **Neon** (serverless, free)
- Express.js backend on **Railway** (simple PaaS)
- React frontend on **Vercel** (optimized for frontend)
- Mobile app published to the stores (Ch. 13)
- Custom domain and HTTPS

**Estimated time**: 60–90 minutes  
**Prerequisite**: Tested application (Ch. 14)

---

## 15.1 — Deploy Strategy

### Production Architecture

![Production architecture](../../figures/en/07-deploy-produzione.png)

### Why These Platforms

| Platform | Reason | Free Tier |
|:--|:--|:--|
| **Neon** | Serverless PostgreSQL, shuts down when not in use | 512 MB storage |
| **Railway** | Deploy with git push, zero config for Node.js | $5 credit/month |
| **Vercel** | Global CDN, instant deploy for React | Unlimited for hobby |

> 💡 **Tip**: Equivalent alternatives: Supabase (database), Render (backend), Netlify (frontend). The procedure is similar — the `_CONTEXT.md` is the same, only the platform changes.

> 📦 **Tooling Box — Stack chosen for this example.**
> - **Database:** Neon (serverless PostgreSQL)
> - **Backend:** Railway (PaaS with Git deploy)
> - **Frontend:** Vercel (global CDN)
>
> **Equivalent alternatives:** Supabase/PlanetScale (database), Render/Fly.io/AWS App Runner (backend), Netlify/Cloudflare Pages (frontend). The **deploy pattern** (managed database + backend PaaS + frontend CDN) and configuration via environment variables are identical across any combination of platforms. The 0-code method guides you in the same way.

---

## 15.2 — Database: Neon

### 🔧 HANDS-ON — Neon Setup

1. Go to [neon.tech](https://neon.tech) and sign up
2. Create a new project: "notes-app"
3. Copy the **connection string** (format: `postgresql://user:pass@host/db?sslmode=require`)

### 🔧 HANDS-ON — Migrate the Schema

```bash
cd backend

# Update .env with the Neon connection string
# DATABASE_URL=postgresql://user:pass@ep-xxx.region.neon.tech/neondb?sslmode=require

# Run migrations on the production database
npx prisma migrate deploy

# Verify
npx prisma studio
```

> ⚠️ **Warning**: Use `prisma migrate deploy` in production, **never** `prisma migrate dev`. The `dev` command is interactive and can delete data. The `deploy` command only applies pending migrations.

---

## 15.3 — Backend: Railway

### 🔧 HANDS-ON — Railway Setup

1. Go to [railway.app](https://railway.app) and sign up with GitHub
2. Click "New Project" → "Deploy from GitHub repo"
3. Select the `notes-fullstack` repository
4. Railway automatically detects that it is a Node.js project

### Configuration

In Railway, configure the environment variables:

| Variable | Value |
|:--|:--|
| `DATABASE_URL` | Neon connection string |
| `JWT_SECRET` | A random string at least 64 characters long |
| `JWT_EXPIRES_IN` | 1h |
| `REFRESH_TOKEN_EXPIRES_IN` | 7d |
| `GOOGLE_CLIENT_ID` | Your Google client ID |
| `GOOGLE_CLIENT_SECRET` | Your Google client secret |
| `GITHUB_CLIENT_ID` | Your GitHub client ID |
| `GITHUB_CLIENT_SECRET` | Your GitHub client secret |
| `FRONTEND_URL` | https://notes-app.vercel.app (or your domain) |
| `NODE_ENV` | production |

### 🔧 HANDS-ON — Configure the Build

Railway needs to know how to start the backend. Ask the AI:

```text
Configure the backend for Railway deployment:
1. Add a "start" field in package.json scripts: "node src/index.js"
2. Make sure the Procfile or railway.toml specifies the root directory 
   as "backend/"
3. The server must listen on the port from the PORT variable 
   (Railway assigns it automatically)
4. Add a health check endpoint: GET /api/health → { status: "ok" }
```

### Deploy

```bash
git push origin main
```

Railway detects the push and deploys automatically. After 1–2 minutes, the backend is live at a URL like `https://notes-api-production.up.railway.app`.

### Verify

```bash
curl https://notes-api-production.up.railway.app/api/health
# {"status":"ok"}
```

---

## 15.4 — Frontend: Vercel

### 🔧 HANDS-ON — Vercel Setup

1. Go to [vercel.com](https://vercel.com) and sign up with GitHub
2. Click "Add New Project" → Select the repository
3. Configure:
   - **Root Directory**: `frontend`
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`

### Environment Variables

| Variable | Value |
|:--|:--|
| `VITE_API_URL` | `https://notes-api-production.up.railway.app/api` |

### Deploy

Vercel deploys automatically on every push to `main`. The frontend will be available at a URL like `https://notes-app.vercel.app`.

### 🔧 HANDS-ON — Update CORS and OAuth

After deploying, update:

1. **Backend (Railway)**: Add the Vercel domain to the `FRONTEND_URL` variable
2. **Google Cloud Console**: Add the Vercel domain to the authorized redirect URIs
3. **GitHub OAuth Settings**: Add the Vercel domain to the callback URL

```text
Update the backend CORS configuration to accept requests from:
- http://localhost:5173 (development)
- https://notes-app.vercel.app (production)

Update the OAuth callback URLs to support both environments.
```

---

## 15.5 — Custom Domain

### Vercel (Frontend)

1. In Vercel: Settings → Domains → Add
2. Enter your domain (e.g., `notes.yourdomain.com`)
3. Configure DNS with a CNAME record pointing to `cname.vercel-dns.com`

### Railway (Backend)

1. In Railway: Settings → Domains → Add Custom Domain
2. Enter the subdomain (e.g., `api.notes.yourdomain.com`)
3. Configure DNS with the CNAME provided by Railway

HTTPS is automatic on both platforms.

---

## 15.6 — Monitoring

### 🔧 HANDS-ON — Production Logging

```text
Add structured logging to the backend for production:
1. Install pino (fast JSON logger for Node.js)
2. Log every request: method, path, status code, response time
3. Log errors with stack traces (only in logs, NEVER in API responses)
4. In development: human-readable output. In production: JSON for automatic parsing.
5. Exclude sensitive data from logs (tokens, passwords, cookie values)
```

### Health Check and Uptime

```text
Create a /api/health endpoint that returns:
{
  "status": "ok",
  "version": "1.0.0",
  "uptime": 12345,
  "database": "connected"
}

The endpoint also verifies the database connection with a simple
Prisma query (SELECT 1).
```

Use a free service like [UptimeRobot](https://uptimerobot.com) to monitor the health check every 5 minutes and receive notifications if the backend goes down.

---

## 15.7 — Production Checklist

### 🔧 HANDS-ON — Full Verification

| # | Check | Status |
|:--|:--|:--|
| 1 | Neon database reachable with SSL | ☐ |
| 2 | Migrations applied with `prisma migrate deploy` | ☐ |
| 3 | Railway backend responds on /api/health | ☐ |
| 4 | Environment variables set (NO development values) | ☐ |
| 5 | JWT_SECRET different from the development one | ☐ |
| 6 | NODE_ENV = production | ☐ |
| 7 | Vercel frontend loads without console errors | ☐ |
| 8 | VITE_API_URL points to the Railway backend | ☐ |
| 9 | Google OAuth works in production | ☐ |
| 10 | GitHub OAuth works in production | ☐ |
| 11 | CORS accepts only the frontend domain | ☐ |
| 12 | HTTPS active on both frontend and backend | ☐ |
| 13 | Mobile app connected to the production backend | ☐ |
| 14 | Health check monitored | ☐ |
| 15 | Production .env NOT committed to git | ☐ |

### 🎯 CHECKPOINT
If all checks pass, your application is **live in production**: anyone in the world can sign up, create notes from the web or from mobile.

---

## 15.8 — Final Commit

```bash
cd notes-fullstack
git add .
git commit -m "feat: production deploy configuration (Neon + Railway + Vercel)"
git push origin main
```

---

## Summary

| Component | Platform | URL |
|:--|:--|:--|
| **Database** | Neon | (internal connection string) |
| **Backend** | Railway | https://api.notes.yourdomain.com |
| **Frontend** | Vercel | https://notes.yourdomain.com |
| **Mobile** | Play Store / App Store | (store link) |
| **Monitoring** | UptimeRobot | (dashboard) |

---

**→ In the final chapter**: advanced patterns. How to apply the 0-code method to complex projects: microservices, legacy code, multi-agent enterprise, and the limits of the paradigm.
