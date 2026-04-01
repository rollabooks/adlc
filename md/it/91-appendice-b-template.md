# Appendice B — Template Pronti all'Uso

Tutti i template di questo libro, pronti da copiare e adattare ai tuoi progetti.

---

## B.1 — Template `_CONTEXT.md` Base

```markdown
# Progetto: [Nome Progetto]

## Scopo
[Descrizione in 2-3 frasi di cosa fa l'applicazione]

## Tecnologie
- Linguaggio: [es. Python 3.12, Node.js 20, Dart]
- Framework: [es. Express.js, React, Flutter]
- Database: [es. PostgreSQL 16 con Prisma]
- Altro: [dipendenze chiave]

## Architettura
[Diagramma ASCII o descrizione della struttura]

src/
  [struttura directory con commento per ogni cartella]

## Convenzioni
- [Naming conventions]
- [Pattern architetturali]
- [Formato risposta API se applicabile]

## Vincoli
- [NON fare X perché Y]
- [SEMPRE fare Z]
- [Limiti tecnici o di sicurezza]

## Comandi
- Avviare: [comando]
- Test: [comando]
- Build: [comando]
```

---

## B.2 — Template `_CONTEXT.md` REST API

```markdown
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
```

---

## B.3 — Template `SKILL.md` React

```markdown
---
name: react-developer
description: Skill per sviluppo frontend React con Tailwind CSS.
---

# React Developer Skill

## Stack
- React 18+ con Vite
- Tailwind CSS 4
- React Router 6
- Axios per HTTP

## Struttura
src/
  components/ui/     ← Componenti riutilizzabili
  components/layout/ ← Header, Footer, Container
  pages/             ← Pagine (una per route)
  hooks/             ← Hook personalizzati
  context/           ← Context API per stato globale
  services/          ← Chiamate API (Axios)

## Convenzioni
- Componenti: PascalCase, functional only, un file per componente
- Hook: camelCase con prefisso "use"
- NON fare fetch nei componenti, usa hook personalizzati
- NON usare localStorage per token JWT
- Ogni pagina: loading state + error state + empty state
```

---

## B.4 — Template `SKILL.md` Flutter

```markdown
---
name: flutter-developer
description: Skill per sviluppo app mobile Flutter.
---

# Flutter Developer Skill

## Stack
- Flutter 3.x / Dart
- Riverpod 2 per state management
- GoRouter per navigazione
- Dio per HTTP
- flutter_secure_storage per token

## Struttura
lib/
  config/      ← Configurazione (API URL, tema)
  models/      ← Classi immutabili con fromJson/toJson
  services/    ← Client HTTP, auth, business logic
  providers/   ← Riverpod StateNotifier
  screens/     ← Schermate (una per route)
  widgets/     ← Widget riutilizzabili

## Convenzioni
- File: snake_case.dart, Classi: PascalCase
- Widget: ConsumerWidget per accedere ai provider
- Modelli: classi immutabili con factory constructor
- NON usare setState per stato condiviso
- NON usare SharedPreferences per token
- Material Design 3 con useMaterial3: true
```

---

## B.5 — Template `SKILL.md` Analisi

```markdown
---
name: discovery-analysis-specialist
description: Skill per le fasi 0-1 dell'ADLC — scoperta e analisi dei requisiti.
---

# Discovery & Analysis Specialist

## Responsibilities
- Elicitazione requisiti funzionali e non funzionali
- User stories con acceptance criteria
- Threat model e analisi rischi
- Non-Functional Requirements (NFR) checklist

## Deliverables
- PRD (Product Requirements Document)
- User Stories con criteri di accettazione
- Risk Register
- NFR Matrix

## Conventions
- Ogni requisito: ID univoco (RF-01, RNF-01)
- User story: formato "Come [attore], voglio [azione], affinché [beneficio]"
- Acceptance Criteria: formato Given/When/Then
- NON procedere a implementazione senza PRD approvato
```

---

## B.6 — Template `SKILL.md` Design

```markdown
---
name: architecture-design-specialist
description: Skill per la fase 2 dell'ADLC — architettura e design.
---

# Architecture & Design Specialist

## Responsibilities
- Valutazione stack tecnologico (matrice pesata)
- Architecture Decision Records (ADR)
- Scomposizione in EPIC → Task
- Contratti API e interfacce

## Deliverables
- ADR per ogni decisione architetturale
- EPIC con task atomici e story point
- Diagrammi architetturali (C4, sequenza)
- Contratto API OpenAPI/Swagger

## Conventions
- ADR: formato "Contesto → Opzioni → Decisione → Conseguenze"
- Task: ID, titolo, acceptance criteria, vincoli SEC/PERF
- NON iniziare implementazione senza design approvato
- Ogni decisione motivata, mai "perché è lo standard"
```

---

## B.7 — Template `SKILL.md` Operations

```markdown
---
name: operations-monitoring-specialist
description: Skill per la fase 6 dell'ADLC — operazioni e monitoraggio.
---

# Operations & Monitoring Specialist

## Responsibilities
- Triage e gestione incidenti
- Monitoraggio SLA e metriche
- Post-mortem strutturati
- Runbook operativi

## Deliverables
- Incident Report con RCA (Root Cause Analysis)
- Post-mortem con timeline e azioni correttive
- Runbook per scenari ricorrenti
- Dashboard metriche (uptime, latenza, errori)

## Conventions
- Incidenti classificati per severity (S1-S4)
- Post-mortem: blameless, focus su sistema
- NON applicare hotfix senza test di regressione
- Ogni runbook: trigger, passi, rollback, escalation
```

---

## B.8 — Template `_CONTEXT.md` Full-Stack

```markdown
# Progetto: [Nome] Full-Stack

## Panoramica
[Descrizione in 3-4 frasi]

## Architettura
[Browser] → [Frontend :5173] → [Proxy /api] → [Backend :3000] → [PostgreSQL]

## Componenti

### Backend (./backend/)
- Contesto: ./backend/_CONTEXT.md
- Porta: 3000

### Frontend (./frontend/)
- Contesto: ./frontend/_CONTEXT.md
- Skill: ./frontend/SKILL.md
- Porta: 5173

### Mobile (./mobile/) — opzionale
- Contesto: ./mobile/_CONTEXT.md
- Skill: ./mobile/SKILL.md

## Contratto API
[Tabella endpoint condivisa tra tutti i componenti]

## Variabili d'Ambiente
### Backend: DATABASE_URL, JWT_SECRET, ...
### Frontend: VITE_API_URL

## Comandi
- Tutto: npm run dev (con concurrently)
- Backend: cd backend && npm run dev
- Frontend: cd frontend && npm run dev
```

---

## B.9 — Template `PROGRESS.md`

```markdown
# [Nome Progetto] — Progresso

## Stato Attuale
- [x] Task completato 1
- [x] Task completato 2
- [ ] Task in corso
- [ ] Task futuro

## Decisioni Architetturali
- [Decisione]: [Motivazione]

## Problemi Risolti
- [Problema]: [Soluzione adottata]

## Note per la Prossima Sessione
- [Cosa ricordare per continuare il lavoro]
```

---

## B.10 — Template `.gitignore` Full-Stack

```text
# Environment
.env
.env.local
.env.production

# Dependencies
node_modules/

# Build
dist/
build/

# Database
*.db
*.sqlite

# IDE
.vscode/settings.json
.idea/

# OS
.DS_Store
Thumbs.db

# Secrets
*.jks
*.keystore
key.properties

# Flutter
.dart_tool/
.packages
```

---

## B.11 — Checklist Pre-Deploy

```markdown
## Sicurezza
- [ ] JWT_SECRET >= 256 bit, in variabile d'ambiente
- [ ] Token scade (access: 1h, refresh: 7d)
- [ ] Logout invalida refresh token
- [ ] Input validato con Zod
- [ ] Errori non espongono stack trace
- [ ] Helmet.js attivo
- [ ] Rate limiting su auth
- [ ] CORS solo domini consentiti
- [ ] npm audit clean
- [ ] .env nel .gitignore

## Funzionalità
- [ ] Login OAuth funziona
- [ ] CRUD completo funziona
- [ ] Protezione route funziona
- [ ] Error handling end-to-end
- [ ] Mobile connesso al backend
- [ ] Health check endpoint

## Infrastruttura
- [ ] Database migrato in produzione
- [ ] Variabili d'ambiente impostate
- [ ] HTTPS attivo
- [ ] Monitoring attivo
```
