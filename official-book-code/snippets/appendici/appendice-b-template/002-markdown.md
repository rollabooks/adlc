# Progetto: [Nome] API

## Scopo
[Descrizione del servizio API]

## Tecnologie
- Runtime: Node.js 20
- Framework: Express.js
- Validazione: Zod
- Database: PostgreSQL 16 con Prisma ORM
- Auth: JWT + OAuth 2.0
- Docs: Swagger/OpenAPI

## Architettura

src/
  index.js          ← Entry point, avvio server
  app.js            ← Express app, middleware, route
  routes/           ← Definizione endpoint
  controllers/      ← Gestione request/response
  services/         ← Logica business
  middleware/       ← Auth, validazione, error handling
  prisma/           ← Schema e migrazioni

## Endpoint

| Metodo | Path | Auth | Descrizione |
|:--|:--|:--|:--|
| GET | /api/resource | Sì | Lista risorse |
| POST | /api/resource | Sì | Crea risorsa |
| GET | /api/resource/:id | Sì | Dettaglio |
| PUT | /api/resource/:id | Sì | Aggiorna |
| DELETE | /api/resource/:id | Sì | Elimina |

## Formato Risposte

Successo:
{ "success": true, "data": { ... } }

Errore:
{ "success": false, "error": { "message": "...", "code": "ERROR_CODE" } }

## Vincoli
- Validazione Zod PRIMA del controller
- Ogni query filtra per userId (autorizzazione)
- Errori in produzione: solo messaggi generici, mai stack trace
- Rate limiting su endpoint auth

## Comandi
- Dev: npm run dev
- Test: npx vitest run
- Migrate: npx prisma migrate dev
- Studio: npx prisma studio