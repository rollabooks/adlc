# Progetto: Notes API

## Scopo
REST API per la gestione di note personali. Backend che verrà usato come 
fondamento per un'applicazione full-stack (frontend React + mobile Flutter).

## Tecnologie
- Runtime: Node.js 20 LTS
- Framework: Express.js 4.x
- Linguaggio: JavaScript ES2022+ con ESModules (import/export)
- Validazione: Zod
- Documentazione: swagger-jsdoc + swagger-ui-express
- Testing: Jest con supertest
- Linting: ESLint

## Struttura del Progetto

notes-api/
├── _CONTEXT.md
├── package.json
├── .env.example         ← Template variabili d'ambiente
├── .gitignore
├── src/
│   ├── index.js         ← Entry point: crea app e avvia server
│   ├── app.js           ← Configurazione Express (middleware, routes)
│   ├── routes/
│   │   └── notes.js     ← Definizione route /api/notes
│   ├── controllers/
│   │   └── notesController.js  ← Logica dei controller
│   ├── services/
│   │   └── notesService.js     ← Business logic (per ora in-memory)
│   ├── middleware/
│   │   ├── errorHandler.js     ← Gestione errori centralizzata
│   │   └── validateRequest.js  ← Middleware validazione con Zod
│   ├── schemas/
│   │   └── noteSchema.js       ← Schema Zod per validazione note
│   └── utils/
│       └── apiResponse.js      ← Helper per risposte standardizzate
└── tests/
    ├── setup.js
    └── notes.test.js           ← Test di integrazione API

## Modello Dati (Nota)

Per ora usiamo storage in-memory (array). Nel Capitolo 7 migreremo a PostgreSQL.

- id: string UUID v4 (generato automaticamente)
- title: string (obbligatorio, 1-200 caratteri)
- content: string (obbligatorio, 1-10000 caratteri)
- tags: string[] (opzionale, default [])
- createdAt: string ISO 8601
- updatedAt: string ISO 8601

## Endpoint API

| Metodo | Path | Descrizione | Status Code |
|:--|:--|:--|:--|
| GET | /api/notes | Lista tutte le note | 200 |
| GET | /api/notes/:id | Dettaglio nota | 200 / 404 |
| POST | /api/notes | Crea nota | 201 |
| PUT | /api/notes/:id | Aggiorna nota | 200 / 404 |
| DELETE | /api/notes/:id | Elimina nota | 204 / 404 |
| GET | /api/health | Health check | 200 |
| GET | /api/docs | Swagger UI | 200 |

## Formato Risposte API

Tutte le risposte DEVONO seguire questo formato:

Successo:
{ "success": true, "data": T }

Successo con lista:
{ "success": true, "data": T[], "count": number }

Errore:
{ "success": false, "error": { "message": string, "code": string } }

## Convenzioni

- ESModules: usa SEMPRE import/export, MAI require/module.exports
- Async: usa SEMPRE async/await, MAI callback o .then()
- Naming: camelCase per variabili/funzioni, PascalCase per classi
- File: kebab-case per nomi file
- Status code: usa le costanti appropriate (201 per POST, 204 per DELETE)
- Ogni controller è una funzione async

## Vincoli

- NON usare require(). Questo è un progetto ESModules.
- NON mettere logica di business nei controller. Usa i service.
- NON ritornare stack trace negli errori. Solo messaggi user-friendly.
- NON usare console.log per debugging in produzione. Usa un logLevel.
- NON hardcodare la porta. Usa process.env.PORT con default 3000.
- CORS deve essere abilitato per lo sviluppo (origin: '*' in dev).
- Ogni endpoint deve avere il commento JSDoc Swagger.

## Comandi

- Installare dipendenze: npm install
- Avviare in dev: npm run dev (con nodemon)
- Avviare in prod: npm start
- Test: npm test
- Lint: npm run lint

## package.json type

OBBLIGATORIO: il package.json DEVE contenere "type": "module" per supportare
ESModules.