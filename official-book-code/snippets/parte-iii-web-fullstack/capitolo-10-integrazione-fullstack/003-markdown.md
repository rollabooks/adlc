# Progetto: Notes Full-Stack Application

## Panoramica
Applicazione web full-stack per la gestione di note personali con 
autenticazione OAuth 2.0. Composta da un backend REST API e un frontend React.

## Architettura

```
[Browser] → [Frontend React :5173] → [Proxy Vite /api] → [Backend Express :3000]
                                                              ↓
                                                        [PostgreSQL :5432]
```

## Componenti

### Backend (./backend/)
- **Tecnologia**: Node.js 20, Express.js, Prisma ORM
- **Database**: PostgreSQL 16
- **Auth**: OAuth 2.0 (Google + GitHub), JWT, Passport.js
- **API Base**: /api
- **Porta**: 3000
- **Contesto**: ./backend/_CONTEXT.md

### Frontend (./frontend/)
- **Tecnologia**: React 18, Vite, Tailwind CSS 4
- **Routing**: React Router 6
- **Auth**: Cookie httpOnly via backend proxy
- **Porta**: 5173 (dev), servito da CDN in produzione
- **Contesto**: ./frontend/_CONTEXT.md
- **Skill**: ./frontend/SKILL.md

## Contratto API

Il frontend e il backend comunicano attraverso questo contratto:

### Formato risposte (SEMPRE rispettato)
```json
{
  "success": true|false,
  "data": { ... },
  "error": { "message": "...", "code": "VALIDATION_ERROR" }
}
```

### Endpoint

| Metodo | Endpoint | Auth | Descrizione |
|:--|:--|:--|:--|
| GET | /api/auth/google | No | Avvia login Google |
| GET | /api/auth/github | No | Avvia login GitHub |
| GET | /api/auth/me | Sì | Profilo utente corrente |
| POST | /api/auth/refresh | Cookie | Rinnova JWT |
| POST | /api/auth/logout | Sì | Logout (invalida token) |
| GET | /api/notes | Sì | Lista note utente |
| POST | /api/notes | Sì | Crea nota |
| GET | /api/notes/:id | Sì | Dettaglio nota |
| PUT | /api/notes/:id | Sì | Modifica nota |
| DELETE | /api/notes/:id | Sì | Elimina nota |
| GET | /api/notes/search?q= | Sì | Cerca note |

### Codici errore
- 401: Non autenticato → frontend redirige al login
- 403: Non autorizzato (nota di un altro utente) → mostra errore
- 404: Risorsa non trovata → mostra pagina 404
- 422: Validazione fallita → mostra errori nei campi del form
- 500: Errore server → mostra messaggio generico

## Variabili d'ambiente

### Backend (.env)
DATABASE_URL, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET,
GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, JWT_SECRET, 
JWT_EXPIRES_IN, REFRESH_TOKEN_EXPIRES_IN, FRONTEND_URL

### Frontend (.env)
VITE_API_URL=/api (in dev con proxy)

## Comandi

### Sviluppo
- Backend: cd backend && npm run dev
- Frontend: cd frontend && npm run dev
- Database: npx prisma studio (dalla cartella backend)

### Produzione
- Backend: cd backend && npm start
- Frontend: cd frontend && npm run build (genera ./frontend/dist/)