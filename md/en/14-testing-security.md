# Chapter 14 — Testing and Security

## What You Will Build

A testing and security verification system for the entire stack:
- AI-generated unit tests for backend and frontend
- Integration tests for API endpoints
- Automated OWASP Top 10 security analysis
- Confidence Tagging to decide what to review manually
- A reproducible quality pipeline

**Estimated time**: 60–90 minutes  
**Prerequisite**: Complete full-stack application (Chapters 6–13)

> ⚠️ **SECURITY IS NOT OPTIONAL**
>
> AI-generated code can contain security vulnerabilities — not out of malice, but because AI optimizes for functionality, not for security, unless you explicitly ask it to. This chapter gives you the tools to identify the most common issues (OWASP Top 10), but **it is not a substitute for a professional security review**.
>
> **Before a commercial deployment** — an application that handles real customer data, financial transactions, health data, or any sensitive information — have the code reviewed by an information security professional. The cost of a security audit is a fraction of the reputational and legal damage caused by a data breach.
>
> The techniques you learn here are your **first line of defense**, not your last.

---

## 14.1 — Backend Testing

### The Principle: Tests as Documentation

AI-generated tests have a dual value: they verify functionality **and** document expected behavior. If you change something tomorrow and a test fails, the error message tells you exactly what broke.

### 🔧 PRACTICE — Generate backend tests

```text
Genera test completi per il backend Notes API con vitest.

Setup:
1. Installa vitest e supertest come devDependencies
2. Crea un file vitest.config.js che:
   - Usa un database PostgreSQL di test (notes_test)
   - Esegue le migrazioni prima dei test
   - Pulisce i dati tra un test e l'altro

Test richiesti:

test/unit/
  - note-service.test.js: test CRUD del servizio note
    (crea, leggi, aggiorna, elimina, nota non trovata, accesso negato)
  - auth-service.test.js: test token (generazione JWT, verifica, 
    refresh, token scaduto)
  - validation.test.js: test middleware Zod (titolo vuoto, 
    contenuto troppo lungo, campi extra ignorati)

test/integration/
  - notes-api.test.js: test endpoint con supertest
    (GET /api/notes senza auth → 401,
     POST /api/notes con dati validi → 201,
     GET /api/notes/:id di un altro utente → 403,
     DELETE /api/notes/:id → 200 + nota rimossa)
  - auth-api.test.js: test flusso auth
    (GET /api/auth/me senza token → 401,
     GET /api/auth/me con token valido → 200 + profilo,
     POST /api/auth/refresh con refresh token valido → nuovo access token)

Ogni test deve avere un nome descrittivo che spiega lo scenario.
Usa beforeAll per setup database e afterAll per cleanup.
```

### 🔧 PRACTICE — Run the tests

```bash
cd backend
npx vitest run
```

Expected output:
```text
 ✓ note-service.test.js (6 tests)
 ✓ auth-service.test.js (4 tests)
 ✓ validation.test.js (3 tests)
 ✓ notes-api.test.js (4 tests)
 ✓ auth-api.test.js (3 tests)

 Test Files  5 passed
 Tests       20 passed
```

> 💡 **Tip**: If a test fails, copy the error and paste it to Copilot: "This test fails with this error. What's the problem?" The AI usually identifies the bug on the first try.

---

## 14.2 — Frontend Testing

### 🔧 PRACTICE — Generate React tests

```text
Genera test per il frontend React con vitest e @testing-library/react.

1. Installa: vitest, @testing-library/react, @testing-library/jest-dom, 
   jsdom, msw (Mock Service Worker)

2. Configura MSW per simulare il backend (mock dei endpoint API)

3. Test richiesti:

test/components/
  - NoteCard.test.jsx: renderizza titolo e contenuto, click chiama onTap
  - NoteForm.test.jsx: validazione campi, submit chiama la callback
  - ProtectedRoute.test.jsx: redirige se non autenticato, 
    mostra contenuto se autenticato

test/hooks/
  - useNotes.test.jsx: carica note, gestisce errori, aggiorna dopo CRUD

test/pages/
  - LoginPage.test.jsx: mostra bottoni OAuth, non mostra errori inizialmente
  - DashboardPage.test.jsx: mostra loading, poi lista note, 
    mostra empty state se vuoto
```

```bash
cd frontend
npx vitest run
```

---

## 14.3 — Flutter App Testing

### 🔧 PRACTICE — Generate Flutter tests

```text
Genera test per l'app Flutter:

test/
  unit/
    - token_service_test.dart: salvataggio, lettura, cancellazione token
    - note_model_test.dart: fromJson, toJson, campi obbligatori
  
  widget/
    - login_screen_test.dart: mostra bottoni OAuth, loading state
    - note_card_test.dart: renderizza titolo, tap callback
    - dashboard_screen_test.dart: loading → lista note, empty state

Usa il package mockito per simulare i servizi.
Usa ProviderScope.overrides per iniettare provider mock nei test widget.
```

```bash
cd notes_mobile
flutter test
```

---

## 14.4 — Confidence Tagging

Not all AI-generated code requires the same level of review attention. **Confidence Tagging** classifies code by risk level.

### The risk matrix

| Level | What it includes | Action |
|:--|:--|:--|
| 🟢 **LOW** | UI, styling, stateless components, data models | Quick review: does the code work? |
| 🟡 **MEDIUM** | Business logic, validation, routing, state management | Careful review: is the logic correct? |
| 🔴 **HIGH** | Authentication, authorization, crypto, DB queries, user input | Rigorous review: is it secure? |

### 🔧 PRACTICE — Project risk analysis

```text
Analizza l'intero progetto notes-fullstack e classifica ogni file 
secondo la matrice di rischio:

- 🟢 LOW RISK: file che non gestiscono dati sensibili né logica critica
- 🟡 MEDIUM RISK: file con logica business o validazione
- 🔴 HIGH RISK: file che gestiscono autenticazione, autorizzazione, 
  dati utente o query database

Per ogni file HIGH RISK, elenca le specifiche vulnerabilità da verificare.
Formato output:

🔴 HIGH: backend/src/middleware/auth.js
   - JWT verification: verificare che il secret non sia hardcoded
   - Token extraction: verificare che gestisca token malformati
   - User lookup: verificare che non sia vulnerabile a injection

🟡 MEDIUM: backend/src/services/note-service.js
   - Verificare che filtri sempre per userId (autorizzazione)

🟢 LOW: frontend/src/components/ui/Button.jsx
   - Nessuna verifica necessaria
```

---

## 14.5 — Code Review of AI-Generated Code

Confidence Tagging tells you **what** to review. This section teaches you **how** to do it — even if you are not an experienced developer.

### Why AI fails in ways different from humans

A human programmer makes careless mistakes: typos, forgotten parentheses, badly named variables. AI almost never makes these mistakes. AI bugs are more insidious:

| Type of bug | Example | Why it happens |
|:--|:--|:--|
| **Happy path only** | The function works with valid input, crashes with empty input | AI optimizes for "it works", not for "it's resilient" |
| **Non-existent APIs** | Uses a method that doesn't exist in the installed version | It mixed up documentation from different versions |
| **Plausible but wrong logic** | A filter that looks correct but excludes edge cases | The pattern looked right in the training data |
| **Forgotten security** | Endpoint without authorization check | You didn't explicitly ask for it |
| **Phantom dependencies** | Imports a package that isn't in package.json | It saw it in a similar project |

### Review methodology by level

**🟢 LOW RISK — Functional verification (2 minutes/file)**

UI components, styling, data models. The question is simple: *does it work?*

1. Did the AI create the file? Open it and verify it's not empty
2. Start the app and check whether the component renders
3. If yes, move on

**🟡 MEDIUM RISK — Logic verification (5–10 minutes/file)**

Business logic, validation, routing. The question: *does it do what it should?*

1. Read the main function and ask yourself: "What happens if the input is empty? Null? Huge?"
2. Look for dangerous keywords: `any`, `as any` (TypeScript), `!` (force unwrap), empty `catch` blocks
3. Verify that Zod/Joi validations match the requirements in `_CONTEXT.md`
4. If the logic looks correct but you're not sure, ask the AI: *"Explain step by step what this function does and what edge cases it might not handle"*

**🔴 HIGH RISK — Rigorous verification (15–30 minutes/file)**

Authentication, authorization, crypto, DB queries. The question: *is it secure?*

1. **Authorization**: does every endpoint that accesses user data filter by `userId`? Can a user access another user's data?
2. **JWT**: is the secret stored in an environment variable? Does the token have an expiration?
3. **User input**: does all input go through validation before reaching the database?
4. **Errors**: do error messages in production NOT expose stack traces or internal details?
5. Use the Security Checklist (§14.7) as a systematic guide

### 🔧 PRACTICE — AI-assisted review

```text
Analizza i file HIGH RISK del progetto notes-fullstack.

Per ogni file:
1. Elenca tutti i possibili edge case non gestiti
2. Identifica ogni punto dove l'input utente raggiunge il database 
   senza passare per validazione
3. Verifica che non ci siano segreti hardcoded
4. Controlla che ogni endpoint protetto verifichi l'autorizzazione

Formato output per ogni file:
✅ VERIFICATO: [cosa va bene]
⚠️ ATTENZIONE: [cosa potrebbe essere un problema]
❌ BUG: [cosa è sicuramente sbagliato, con fix]
```

> 💡 **The golden rule of review**: You don't need to understand *how* every line of code works. You need to understand *what* the function does and ask yourself: "What could go wrong?" The AI is your microscope — you need to know where to point it.

---

## 14.6 — OWASP Top 10 Analysis

The 10 most common vulnerabilities in web applications. Let's verify them in our project.

### 🔧 PRACTICE — OWASP audit

```text
Esegui un'analisi di sicurezza del backend notes-api basata su OWASP Top 10 (2021).
Per ogni categoria OWASP, verifica se il nostro codice è vulnerabile:

A01: Broken Access Control
- Un utente può accedere alle note di un altro utente?
- Gli endpoint admin (se presenti) sono protetti?
- Le route protette verificano SEMPRE il JWT?

A02: Cryptographic Failures
- I token JWT usano un secret sufficientemente lungo?
- Le password (se presenti) sono hashate con bcrypt?
- La connessione al database usa SSL in produzione?

A03: Injection
- Le query Prisma sono parametrizzate (sì, Prisma le parametrizza)?
- L'input utente è validato con Zod prima di raggiungere il database?
- I parametri URL sono sanitizzati?

A04: Insecure Design
- Il refresh token ha una scadenza?
- C'è un rate limiting sul login?
- C'è un limite al numero di refresh token per utente?

A05: Security Misconfiguration
- I messaggi di errore in produzione espongono dettagli interni?
- Gli header di sicurezza sono configurati (Helmet.js)?
- CORS è configurato correttamente per la produzione?

A06: Vulnerable Components
- Le dipendenze hanno vulnerabilità note? (npm audit)
- Le dipendenze sono aggiornate?

A07: Authentication Failures
- I token JWT scadono?
- Il logout invalida il refresh token nel database?
- C'è protezione contro brute force?

A08: Software and Data Integrity Failures
- Le dipendenze vengono da fonti attendibili?
- Il package-lock.json è committato?

A09: Security Logging
- I tentativi di login falliti vengono loggati?
- Gli accessi non autorizzati vengono loggati?
- I log NON contengono dati sensibili (token, password)?

A10: Server-Side Request Forgery (SSRF)
- Il backend fa richieste a URL forniti dall'utente? (No → non applicabile)

Per ogni vulnerabilità trovata, fornisci il fix specifico con il codice.
```

### Common fixes the AI will likely suggest

**Rate Limiting:**
```text
Aggiungi rate limiting al backend:
1. Installa express-rate-limit
2. Limita /api/auth/* a 10 richieste per minuto per IP
3. Limita /api/notes a 100 richieste per minuto per utente
```

**Helmet.js:**
```text
Aggiungi Helmet.js per gli header di sicurezza:
1. Installa helmet
2. Aggiungi helmet() come primo middleware
3. Configura CSP (Content Security Policy) per la produzione
```

**npm audit:**
```bash
cd backend && npm audit
cd frontend && npm audit
```

If `npm audit` reports vulnerabilities:
```bash
npm audit fix
```

---

## 14.7 — Final Security Checklist

### 🔧 PRACTICE — Full verification

| # | Check | Status |
|:--|:--|:--|
| 1 | JWT secret >= 256 bit, in environment variable | ☐ |
| 2 | Access token expires in 1 hour | ☐ |
| 3 | Refresh token expires in 7 days | ☐ |
| 4 | Logout deletes the refresh token from the database | ☐ |
| 5 | Notes are filtered by userId in ALL queries | ☐ |
| 6 | Input validated with Zod before reaching the database | ☐ |
| 7 | Production errors do NOT expose stack traces | ☐ |
| 8 | Helmet.js active with security headers | ☐ |
| 9 | Rate limiting on auth endpoints | ☐ |
| 10 | CORS configured only for allowed domains | ☐ |
| 11 | npm audit reports no critical vulnerabilities | ☐ |
| 12 | Mobile tokens in flutter_secure_storage (not SharedPrefs) | ☐ |
| 13 | Frontend does not store tokens in localStorage | ☐ |
| 14 | Database uses SSL in production | ☐ |
| 15 | .env and keystore.jks in .gitignore | ☐ |

### 🎯 CHECKPOINT
If all 15 checks are ticked and the tests pass, the application is ready for production deployment.

---

## 14.8 — Commit

```bash
cd notes-fullstack
git add .
git commit -m "feat: unit and integration tests + OWASP security audit"
```

---

## Agentic Security: Beyond the OWASP Web

The OWASP Top 10 analysis protects the **application** you build. But who protects the **development infrastructure**? When you grant an AI agent access to databases, the file system, and APIs through MCP, you introduce new threat vectors that the traditional OWASP does not cover.

In 2025, OWASP published the **OWASP Top 10 for MCP**, a classification specific to protocol vulnerabilities. Three of these deserve immediate attention:

### Tool Poisoning (MCP03)

When you configure an MCP server, the agent trusts the **descriptions** of the tools exposed by the server to decide which action to perform. A compromised server can inject malicious descriptions that trick the agent into executing destructive operations.

> 🚨 **Warning**: A tampered PostgreSQL MCP server could describe the `cleanup_old_data` tool as "removes test records", when in reality it executes `DROP TABLE users CASCADE`. The agent, trusting the description, would invoke it without hesitation.

**Mitigation:** install *only* MCP servers from verified repositories (official `@modelcontextprotocol/` or with thousands of GitHub stars). Review the server's source code before adoption.

### Shadow MCP Servers (MCP09)

Just as with "Shadow IT", developers may install unverified MCP servers to speed up integration with new APIs. These servers bypass the team's security controls and create hidden entry points.

**Mitigation:** maintain a shared registry of approved MCP servers (in the project's `_CONTEXT.md` or in team policies).

### Context Injection and Over-Sharing (MCP10)

When the context window is shared across different sessions, sensitive information — API tokens, secrets, user data — can leak from one task to another.

**Mitigation:** always use `.env` files for secrets, **never** inline them in MCP configurations. Verify that `.gitignore` includes all sensitive files. In team environments, consider mutual TLS to authenticate MCP connections.

### 🔧 PRACTICE — Agentic security audit

```text
Analizza la sicurezza della nostra infrastruttura agentica:

1. TOOL VERIFICATION:
   - Elenca tutti i server MCP configurati (.vscode/mcp.json)
   - Per ognuno: verifica la fonte, controlla le stelle GitHub
     e la data dell'ultimo commit
   - Segnala server non ufficiali o non manutenuti

2. SECRET MANAGEMENT:
   - Verifica che NESSUN segreto sia hardcoded in mcp.json
   - Tutti i segreti devono essere in variabili d'ambiente
   - Il file .env è nel .gitignore?

3. CONTEXT HYGIENE:
   - Il _CONTEXT.md contiene credenziali?
   - I log di sessione contengono dati sensibili?
   - Le configurazioni MCP espongono URL o token interni?
```

---

## Testing Non-Deterministic Systems

The unit and integration tests you wrote in this chapter validate **deterministic code**: given an input, the output is always the same. But in 2026, many applications integrate AI agents that produce **probabilistic** responses — chatbots, recommendation engines, autonomous reasoning pipelines.

In these scenarios, binary pass/fail assertions break down: the "correct" output can take many possible forms.

### Strategies for probabilistic testing

| Technique | When to use it |
|:--|:--|
| **Semantic evaluation** | The output must *mean* the same thing, not be identical letter-by-letter |
| **Golden dataset** | Compare responses against a reference set curated by human experts |
| **Evaluator Agent** | A second agent evaluates the quality of the first agent's output |
| **Observability (tracing)** | Trace the agent's *decision tree* to understand *why* it gave that response |
| **Probabilistic fuzzing** | Inject variations into the input to verify the robustness of the output |

> 💡 Platforms like **Maxim AI** allow you to evaluate multi-agent systems by measuring reasoning accuracy across multi-turn interactions. Open-source tools like **Arize Phoenix** (built on OpenTelemetry) trace the entire execution tree of an agent's decisions.

> 📘 For the applications in this book (CRUD, REST API, authentication), traditional tests are perfectly adequate. Probabilistic testing becomes necessary only when you integrate AI models *within* your application — for example, a chatbot or a semantic search engine.

---

## Summary

| Aspect | Detail |
|:--|:--|
| **Backend Testing** | vitest + supertest, unit + integration |
| **Frontend Testing** | vitest + testing-library + MSW |
| **Mobile Testing** | flutter test + mockito |
| **Risk** | Confidence Tagging at 3 levels |
| **Code Review** | Review methodology by risk level |
| **Web Security** | OWASP Top 10 audit with fixes |
| **Agentic Security** | OWASP MCP Top 10: Tool Poisoning, Shadow MCP, Context Injection |
| **Probabilistic Testing** | Strategies for non-deterministic outputs |
| **Checklist** | 15 verifiable security checks |

---

**→ In the next chapter**: production deployment. Backend on Railway, frontend on Vercel, database on Neon, and the mobile app on the stores.
