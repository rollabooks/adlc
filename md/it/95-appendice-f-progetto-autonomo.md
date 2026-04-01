# Appendice F — Progetto Finale Autonomo: BookShelf

## Il Tuo Esame di Architettura

Questo progetto non ha una guida passo-passo. Hai il brief, il `_CONTEXT.md` di partenza, e il **workflow professionale** della Sezione 3.8 — lo stesso metodo di decomposizione che useresti in un progetto reale. Il tuo compito è applicarlo dall'inizio alla fine: generare le specifiche, derivare i casi d'uso, strutturare le epic, scomporre in task e implementare.

Se riesci a completare BookShelf da solo, hai interiorizzato il metodo ADLC.

---

## F.1 — Il Brief

**BookShelf** è un'applicazione per gestire la tua libreria personale. Puoi catalogare i libri che possiedi, quelli che stai leggendo e quelli che vuoi leggere. L'applicazione ha un backend API, un frontend web e un'app mobile.

### Requisiti funzionali

1. **Catalogo libri**: CRUD completo (titolo, autore, anno, genere, ISBN opzionale, copertina URL opzionale)
2. **Stati di lettura**: Ogni libro ha uno stato — "Da leggere", "In lettura", "Letto", "Abbandonato"
3. **Note personali**: L'utente può aggiungere note e una valutazione (1-5 stelle) a ogni libro
4. **Ricerca e filtri**: Ricerca per titolo/autore, filtro per stato e genere
5. **Statistiche**: Dashboard con numero libri per stato, libri letti per anno, genere più letto
6. **Autenticazione**: Login OAuth 2.0 (Google)
7. **Multi-utente**: Ogni utente vede solo la propria libreria

### Requisiti non funzionali

- Backend: Node.js + Express + PostgreSQL + Prisma
- Frontend: React + Tailwind CSS
- Mobile: Flutter
- Deploy: piattaforme cloud a scelta (Railway, Vercel, Neon o equivalenti)

---

## F.2 — Il `_CONTEXT.md` di Partenza

Questo è il tuo punto di partenza. Copialo nella root del progetto e usalo come base. Puoi — e dovresti — modificarlo e migliorarlo man mano che procedi.

```markdown
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
```

---

## F.3 — Il Workflow: Dall'Idea al Codice

Questo progetto non ha una guida passo-passo, ma hai un **metodo**. Applica il workflow professionale della Sezione 3.8 per scomporre BookShelf in unità di lavoro gestibili — esattamente come faresti in un progetto reale.

### Passo 1: Genera le specifiche

Apri una chat con l'IA e usa il brief come input:

```text
"Ecco il brief di BookShelf: [incolla F.1].
 Genera un PRD completo con requisiti funzionali (RF-01, RF-02…),
 requisiti non funzionali (RNF-01…), vincoli tecnici e priorità.
 Salva in docs/PRD.md."
```

### Passo 2: Deriva i casi d'uso

```text
"A partire dal PRD in docs/PRD.md, genera i casi d'uso principali.
 Per ogni caso d'uso: attore, precondizione, flusso principale,
 flussi alternativi, postcondizione. Salva in docs/USE_CASES.md."
```

### Passo 3: Progettazione e scelte tecnologiche

Prima di scomporre in epic e task, fai scegliere all'umano (cioè a te) le decisioni architetturali:

```text
"A partire dal PRD e dai casi d'uso di BookShelf, proponi l'architettura
 del sistema. Per ogni decisione tecnica (database, ORM, autenticazione,
 struttura progetto, pattern API) presenta 2-3 opzioni con pro, contro
 e raccomandazione. Io scelgo, tu documenti in docs/DESIGN.md."
```

Prendi ogni decisione consapevolmente — l'IA propone, tu decidi. Il risultato è un `docs/DESIGN.md` con le ADR (Architecture Decision Records) che guideranno tutto il progetto.

### Passo 4: Struttura le epic

```text
"A partire dai casi d'uso, organizza il lavoro in epic (E-001, E-002…).
 Per ogni epic: titolo, obiettivo, casi d'uso coperti, dipendenze.
 Salva l'indice in docs/epics/INDEX.md e un file per epic."
```

Le epic suggerite coprono le 4 fasi del progetto:

| Fase | Epic | Capitoli di riferimento |
|------|------|-------------------------|
| Backend | E-001 Setup, E-002 Auth, E-003 CRUD, E-004 Filtri, E-005 Stats | Cap. 6-8 |
| Frontend | E-006 Frontend Web | Cap. 9-10 |
| Mobile | E-007 App Mobile | Cap. 11-12 |
| Produzione | E-008 Testing/Sicurezza, E-009 Deploy | Cap. 14-15 |

### Passo 5: Scomponi in task

Per ogni epic, chiedi all'IA di generare task atomici:

```text
"Scomponi l'epic E-003 in task atomici (T-003.1, T-003.2…).
 Ogni task deve avere: acceptance criteria verificabili,
 file coinvolti, vincoli SEC/PERF applicabili, story point."
```

Segui il template task della Sezione 3.8. Salva in `docs/epics/tasks/E-003/`.

### Passo 6: Implementa task per task

```text
"Implementa T-003.1. Leggi docs/epics/tasks/E-003/T-003.1_*.md.
 Rispetta i vincoli dal _CONTEXT.md."
```

Ogni sessione chiude uno o più task. Al termine, aggiorna lo stato e il `_CONTEXT.md`.

> 💡 **Ricorda**: Non procedere alla Fase 2 (Frontend) finché tutti i task backend non sono ✅ e i test non passano. La decomposizione in task ti dà visibilità — usala.

---

## F.4 — Le Sfide per Fase

Ecco gli obiettivi di alto livello per ogni fase. La scomposizione dettagliata in epic e task è compito tuo — usando il workflow del Passo 4 e 5.

### Fase 1: Backend (Capitoli 6-8)

1. Inizializza il progetto Node.js con Express
2. Configura Prisma con lo schema `Book` e `User`
3. Implementa gli endpoint CRUD per i libri
4. Aggiungi autenticazione OAuth 2.0 con Google
5. Aggiungi l'endpoint statistiche (`GET /api/stats`)
6. Scrivi test unitari e di integrazione
7. Verifica la security checklist (SEC-01 → SEC-05)

### Fase 2: Frontend (Capitoli 9-10)

1. Crea il progetto React con Vite e Tailwind
2. Implementa la pagina login con redirect OAuth
3. Crea la dashboard con lista libri e filtri
4. Implementa il form per aggiungere/modificare libri
5. Crea la pagina statistiche con conteggi e grafici semplici
6. Integra con il backend reale (rimuovi mock)
7. Scrivi test con testing-library

### Fase 3: Mobile (Capitoli 11-12)

1. Crea il progetto Flutter
2. Implementa l'autenticazione da mobile
3. Crea la lista libri con pull-to-refresh
4. Implementa il dettaglio libro con note e rating
5. Aggiungi ricerca e filtri
6. Scrivi test widget

### Fase 4: Produzione (Capitoli 14-15)

1. Esegui audit OWASP Top 10 sul backend
2. Applica i fix di sicurezza
3. Deploy backend su Railway
4. Deploy frontend su Vercel
5. Database su Neon
6. Verifica che tutto funzioni end-to-end

---

## F.5 — Criteri di Successo

Il progetto è completato quando:

- [ ] Un utente può fare login con Google
- [ ] Può aggiungere, modificare e cancellare libri
- [ ] Può cambiare lo stato di lettura
- [ ] Può aggiungere note e rating
- [ ] Può cercare e filtrare i libri
- [ ] Vede le statistiche sulla dashboard
- [ ] L'app mobile mostra gli stessi dati
- [ ] Tutti i test passano
- [ ] La security checklist è completata
- [ ] L'applicazione è accessibile online (deployata)
- [ ] Il `_CONTEXT.md` è aggiornato con le lezioni apprese (Fase 6 ADLC)

---

## F.6 — Suggerimenti (Spoiler-Free)

- **Segui il workflow della Sezione 3.8.** Prima genera PRD, poi use case, poi epic, poi task. Solo dopo implementa.
- **Inizia dal backend.** È la base di tutto il resto.
- **Usa il `_CONTEXT.md` fin dall'inizio.** Non procedere senza contesto.
- **Testa ogni fase prima di passare alla successiva.** Non costruire il frontend su un backend che non funziona.
- **Se l'IA genera qualcosa che non capisci, chiedi**: "Spiega questo codice riga per riga" — è sempre un prompt valido.
- **Se ti blocchi**, riguarda il capitolo corrispondente del libro. La tecnica è la stessa — cambia solo il dominio applicativo.
- **Aggiorna il `_CONTEXT.md`** ogni volta che scopri qualcosa di nuovo. Questo è l'Apprendimento Continuo (Fase 6 dell'ADLC) in azione.

---

> *Se hai completato BookShelf, complimenti: sei un architetto di contesto. Il metodo ADLC non è più qualcosa che hai letto — è qualcosa che sai fare.*
