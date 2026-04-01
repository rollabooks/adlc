# Notes Full-Stack — Progresso

## Stato Attuale
- [x] Backend REST API con Express.js
- [x] Database PostgreSQL con Prisma
- [x] Autenticazione OAuth 2.0 (Google + GitHub)
- [x] Frontend React con dashboard note
- [x] CRUD note completo (frontend ↔ backend)
- [x] Error handling end-to-end
- [ ] Testing automatizzato (Capitolo 14)
- [ ] Deploy in produzione (Capitolo 15)

## Decisioni Architetturali
- JWT in cookie httpOnly (non localStorage) per sicurezza XSS
- Proxy Vite in dev, static serving in produzione
- Monorepo con contesti separati per backend e frontend
- Context API per stato auth (no Redux, il progetto è abbastanza semplice)

## Problemi Risolti
- CORS: risolto con proxy Vite in dev + cors middleware condizionale
- Refresh token: gestito con interceptor Axios che riprova la richiesta
- OAuth redirect: callback URL punta al backend, che redirige al frontend

## Note per la Prossima Sessione
- Quando modifichi gli endpoint del backend, aggiorna anche il 
  _CONTEXT.md di root (tabella endpoint)
- Il database di sviluppo si chiama "notes_dev" (vedi .env del backend)