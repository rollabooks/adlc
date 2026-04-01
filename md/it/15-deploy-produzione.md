# Capitolo 15 — Deploy in Produzione

## Cosa Costruirai

L'intero stack deployato su piattaforme cloud:
- Database PostgreSQL su **Neon** (serverless, gratuito)
- Backend Express.js su **Railway** (PaaS semplice)
- Frontend React su **Vercel** (ottimizzato per frontend)
- App mobile pubblicata sugli store (Cap. 13)
- Dominio personalizzato e HTTPS

**Tempo stimato**: 60-90 minuti  
**Prerequisito**: Applicazione testata (Cap. 14)

---

## 15.1 — Strategia di Deploy

### Architettura di produzione

![Architettura di produzione](../../figures/it/07-deploy-produzione.png)

### Perché queste piattaforme

| Piattaforma | Motivo | Piano gratuito |
|:--|:--|:--|
| **Neon** | PostgreSQL serverless, si spegne quando non usato | 512 MB storage |
| **Railway** | Deploy con git push, zero config per Node.js | $5 credito/mese |
| **Vercel** | CDN globale, deploy istantaneo per React | Illimitato per hobby |

> 💡 **Suggerimento**: Alternative equivalenti: Supabase (database), Render (backend), Netlify (frontend). La procedura è simile — il `_CONTEXT.md` è lo stesso, cambia solo la piattaforma.

> 📦 **Box Tooling — Stack scelto per questo esempio.**
> - **Database:** Neon (PostgreSQL serverless)
> - **Backend:** Railway (PaaS con deploy Git)
> - **Frontend:** Vercel (CDN globale)
>
> **Alternative equivalenti:** Supabase/PlanetScale (database), Render/Fly.io/AWS App Runner (backend), Netlify/Cloudflare Pages (frontend). Il **pattern di deploy** (database managed + backend PaaS + frontend CDN) e la configurazione tramite variabili d'ambiente sono identici su qualunque combinazione di piattaforme. Il metodo 0-code ti guida allo stesso modo.

---

## 15.2 — Database: Neon

### 🔧 PRATICA — Setup Neon

1. Vai su [neon.tech](https://neon.tech) e registrati
2. Crea un nuovo progetto: "notes-app"
3. Copia la **connection string** (formato: `postgresql://user:pass@host/db?sslmode=require`)

### 🔧 PRATICA — Migra lo schema

```bash
cd backend

# Aggiorna .env con la connection string di Neon
# DATABASE_URL=postgresql://user:pass@ep-xxx.region.neon.tech/neondb?sslmode=require

# Esegui le migrazioni sul database di produzione
npx prisma migrate deploy

# Verifica
npx prisma studio
```

> ⚠️ **Attenzione**: Usa `prisma migrate deploy` in produzione, **mai** `prisma migrate dev`. Il comando `dev` è interattivo e può cancellare dati. Il comando `deploy` applica solo le migrazioni pendenti.

---

## 15.3 — Backend: Railway

### 🔧 PRATICA — Setup Railway

1. Vai su [railway.app](https://railway.app) e registrati con GitHub
2. Clicca "New Project" → "Deploy from GitHub repo"
3. Seleziona il repository `notes-fullstack`
4. Railway rileva automaticamente che è un progetto Node.js

### Configurazione

In Railway, configura le variabili d'ambiente:

| Variabile | Valore |
|:--|:--|
| `DATABASE_URL` | Connection string Neon |
| `JWT_SECRET` | Una stringa casuale lunga >= 64 caratteri |
| `JWT_EXPIRES_IN` | 1h |
| `REFRESH_TOKEN_EXPIRES_IN` | 7d |
| `GOOGLE_CLIENT_ID` | Il tuo client ID Google |
| `GOOGLE_CLIENT_SECRET` | Il tuo client secret Google |
| `GITHUB_CLIENT_ID` | Il tuo client ID GitHub |
| `GITHUB_CLIENT_SECRET` | Il tuo client secret GitHub |
| `FRONTEND_URL` | https://notes-app.vercel.app (o il tuo dominio) |
| `NODE_ENV` | production |

### 🔧 PRATICA — Configura il build

Railway deve sapere come avviare il backend. Chiedi all'IA:

```text
Configura il backend per il deploy su Railway:
1. Aggiungi un campo "start" in package.json scripts: "node src/index.js"
2. Assicurati che il Procfile o railway.toml specifichi la root directory 
   come "backend/"
3. Il server deve ascoltare sulla porta dalla variabile PORT 
   (Railway la assegna automaticamente)
4. Aggiungi un health check endpoint: GET /api/health → { status: "ok" }
```

### Deploy

```bash
git push origin main
```

Railway rileva il push e fa il deploy automaticamente. Dopo 1-2 minuti, il backend è live su un URL come `https://notes-api-production.up.railway.app`.

### Verifica

```bash
curl https://notes-api-production.up.railway.app/api/health
# {"status":"ok"}
```

---

## 15.4 — Frontend: Vercel

### 🔧 PRATICA — Setup Vercel

1. Vai su [vercel.com](https://vercel.com) e registrati con GitHub
2. Clicca "Add New Project" → Seleziona il repository
3. Configura:
   - **Root Directory**: `frontend`
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`

### Variabili d'ambiente

| Variabile | Valore |
|:--|:--|
| `VITE_API_URL` | `https://notes-api-production.up.railway.app/api` |

### Deploy

Vercel deploya automaticamente ad ogni push su `main`. Il frontend sarà disponibile su un URL come `https://notes-app.vercel.app`.

### 🔧 PRATICA — Aggiorna CORS e OAuth

Dopo il deploy, aggiorna:

1. **Backend (Railway)**: Aggiungi il dominio Vercel alla variabile `FRONTEND_URL`
2. **Google Cloud Console**: Aggiungi il dominio Vercel agli URI di redirect autorizzati
3. **GitHub OAuth Settings**: Aggiungi il dominio Vercel al callback URL

```text
Aggiorna la configurazione CORS del backend per accettare richieste da:
- http://localhost:5173 (sviluppo)
- https://notes-app.vercel.app (produzione)

Aggiorna le callback URL OAuth per supportare entrambi gli ambienti.
```

---

## 15.5 — Dominio Personalizzato

### Vercel (Frontend)

1. In Vercel: Settings → Domains → Add
2. Inserisci il tuo dominio (es. `notes.tuodominio.com`)
3. Configura il DNS con un record CNAME verso `cname.vercel-dns.com`

### Railway (Backend)

1. In Railway: Settings → Domains → Add Custom Domain
2. Inserisci il sottodominio (es. `api.notes.tuodominio.com`)
3. Configura il DNS con il CNAME fornito da Railway

HTTPS è automatico su entrambe le piattaforme.

---

## 15.6 — Monitoraggio

### 🔧 PRATICA — Logging di produzione

```text
Aggiungi logging strutturato al backend per la produzione:
1. Installa pino (logger JSON veloce per Node.js)
2. Logga ogni richiesta: metodo, path, status code, tempo di risposta
3. Logga gli errori con stack trace (solo nei log, MAI nelle risposte API)
4. In sviluppo: output leggibile. In produzione: JSON per parsing automatico.
5. Escludi i dati sensibili dai log (token, password, cookie values)
```

### Health Check e Uptime

```text
Crea un endpoint /api/health che restituisce:
{
  "status": "ok",
  "version": "1.0.0",
  "uptime": 12345,
  "database": "connected"
}

L'endpoint verifica anche la connessione al database con una query
Prisma semplice (SELECT 1).
```

Usa un servizio gratuito come [UptimeRobot](https://uptimerobot.com) per monitorare il health check ogni 5 minuti e ricevere notifiche se il backend va giù.

---

## 15.7 — Checklist di Produzione

### 🔧 PRATICA — Verifica completa

| # | Controllo | Stato |
|:--|:--|:--|
| 1 | Database Neon raggiungibile con SSL | ☐ |
| 2 | Migrazioni applicate con `prisma migrate deploy` | ☐ |
| 3 | Backend Railway risponde su /api/health | ☐ |
| 4 | Variabili d'ambiente impostate (NO valori di sviluppo) | ☐ |
| 5 | JWT_SECRET diverso da quello di sviluppo | ☐ |
| 6 | NODE_ENV = production | ☐ |
| 7 | Frontend Vercel carica senza errori console | ☐ |
| 8 | VITE_API_URL punta al backend Railway | ☐ |
| 9 | OAuth Google funziona in produzione | ☐ |
| 10 | OAuth GitHub funziona in produzione | ☐ |
| 11 | CORS accetta solo il dominio frontend | ☐ |
| 12 | HTTPS attivo su frontend e backend | ☐ |
| 13 | App mobile connessa al backend di produzione | ☐ |
| 14 | Health check monitorato | ☐ |
| 15 | .env di produzione NON committato in git | ☐ |

### 🎯 CHECKPOINT
Se tutti i controlli sono superati, la tua applicazione è **live in produzione**: qualsiasi persona al mondo può registrarsi, creare note dal web o dal mobile.

---

## 15.8 — Commit Finale

```bash
cd notes-fullstack
git add .
git commit -m "feat: configurazione deploy produzione (Neon + Railway + Vercel)"
git push origin main
```

---

## Riepilogo

| Componente | Piattaforma | URL |
|:--|:--|:--|
| **Database** | Neon | (connection string interna) |
| **Backend** | Railway | https://api.notes.tuodominio.com |
| **Frontend** | Vercel | https://notes.tuodominio.com |
| **Mobile** | Play Store / App Store | (link store) |
| **Monitoring** | UptimeRobot | (dashboard) |

---

**→ Nell'ultimo capitolo**: pattern avanzati. Come applicare il metodo 0-code a progetti complessi: microservizi, legacy code, multi-agente enterprise e i limiti del paradigma.
