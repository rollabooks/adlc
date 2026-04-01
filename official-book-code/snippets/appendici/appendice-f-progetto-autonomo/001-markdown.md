# Progetto: BookShelf

## Scopo
Applicazione web + mobile per la gestione di una libreria personale.
Ogni utente può catalogare libri, tracciare lo stato di lettura, 
aggiungere note e visualizzare statistiche.

## Tecnologie
- Backend: Node.js 20+, Express.js, PostgreSQL 16, Prisma ORM
- Frontend: React 18+ con Vite, Tailwind CSS
- Mobile: Flutter 3.x con Dart, Riverpod per state management
- Auth: OAuth 2.0 con Google (passport.js)
- Token: JWT (access 1h, refresh 7d)

## Struttura
bookshelf/
├── _CONTEXT.md
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── middleware/
│   │   └── utils/
│   ├── prisma/
│   │   └── schema.prisma
│   └── tests/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/
│   │   └── context/
│   └── tests/
└── mobile/
    └── bookshelf_app/
        └── lib/
            ├── models/
            ├── providers/
            ├── screens/
            ├── services/
            └── widgets/

## Modello Dati (schema Prisma indicativo)
- User: id, email, name, avatar, createdAt
- Book: id, userId, title, author, year, genre, isbn?, coverUrl?, 
        status (TO_READ | READING | READ | ABANDONED),
        rating (1-5)?, notes?, createdAt, updatedAt
- ReadingSession: id, bookId, startDate, endDate?, pagesRead?

## Convenzioni
- Naming: camelCase per JS/TS, snake_case per DB columns
- Risposte API: { success: boolean, data: T, error?: string }
- Validazione: Zod su tutti gli endpoint
- Commit: Conventional Commits (feat, fix, refactor, docs, test)

## Vincoli (SEC/PERF)
- SEC-01: JWT secret >= 256 bit, in variabile d'ambiente
- SEC-02: Ogni query filtra per userId — NESSUNA eccezione
- SEC-03: Input sanitizzato e validato prima del database
- SEC-04: Rate limiting su endpoint auth (10 req/min)
- SEC-05: Helmet.js per header di sicurezza
- PERF-01: Paginazione su GET /books (default 20, max 100)
- PERF-02: Indice su Book.userId e Book.status

## Comandi
- Backend dev: cd backend && npm run dev
- Backend test: cd backend && npm test
- Frontend dev: cd frontend && npm run dev
- Frontend test: cd frontend && npm test
- DB migrate: cd backend && npx prisma migrate dev
- Mobile run: cd mobile/bookshelf_app && flutter run
- Mobile test: cd mobile/bookshelf_app && flutter test