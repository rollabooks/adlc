# Capitolo 14 — Testing e Sicurezza

## Cosa Costruirai

Un sistema di testing e verifica di sicurezza per l'intero stack:
- Test unitari generati dall'IA per backend e frontend
- Test di integrazione per gli endpoint API
- Analisi di sicurezza OWASP Top 10 automatizzata
- Confidence Tagging per decidere cosa revisionare manualmente
- Pipeline di qualità riproducibile

**Tempo stimato**: 60-90 minuti  
**Prerequisito**: Applicazione full-stack completa (Capitoli 6-13)

> ⚠️ **LA SICUREZZA NON È OPZIONALE**
>
> Il codice generato dall'IA può contenere vulnerabilità di sicurezza — non per malevolenza, ma perché l'IA ottimizza per la funzionalità, non per la sicurezza, a meno che non glielo chiedi esplicitamente. Questo capitolo ti fornisce gli strumenti per individuare i problemi più comuni (OWASP Top 10), ma **non sostituisce una revisione professionale di sicurezza**.
>
> **Prima di un deployment commerciale** — un'applicazione che gestisce dati di clienti reali, transazioni finanziarie, dati sanitari o qualsiasi informazione sensibile — fai revisionare il codice da un professionista di sicurezza informatica. Il costo di un audit di sicurezza è una frazione del danno reputazionale e legale di un data breach.
>
> Le tecniche che impari qui sono il tuo **primo livello di difesa**, non l'ultimo.

---

## 14.1 — Test del Backend

### Il principio: Test come Documentazione

I test generati dall'IA hanno un doppio valore: verificano il funzionamento **e** documentano il comportamento atteso. Se domani cambi qualcosa e un test fallisce, il messaggio di errore ti dice esattamente cosa si è rotto.

### 🔧 PRATICA — Genera i test del backend

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

### 🔧 PRATICA — Esegui i test

```bash
cd backend
npx vitest run
```

Output atteso:
```text
 ✓ note-service.test.js (6 tests)
 ✓ auth-service.test.js (4 tests)
 ✓ validation.test.js (3 tests)
 ✓ notes-api.test.js (4 tests)
 ✓ auth-api.test.js (3 tests)

 Test Files  5 passed
 Tests       20 passed
```

> 💡 **Suggerimento**: Se un test fallisce, copia l'errore e incollalo a Copilot: "Questo test fallisce con questo errore. Qual è il problema?" L'IA di solito identifica il bug al primo tentativo.

---

## 14.2 — Test del Frontend

### 🔧 PRATICA — Genera i test React

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

## 14.3 — Test dell'App Flutter

### 🔧 PRATICA — Genera i test Flutter

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

Non tutto il codice generato dall'IA richiede la stessa attenzione in revisione. Il **Confidence Tagging** classifica il codice per livello di rischio.

### La matrice di rischio

| Livello | Cosa include | Azione |
|:--|:--|:--|
| 🟢 **LOW** | UI, styling, componenti stateless, modelli dati | Revisione rapida: il codice funziona? |
| 🟡 **MEDIUM** | Logica business, validazione, routing, state management | Revisione attenta: la logica è corretta? |
| 🔴 **HIGH** | Autenticazione, autorizzazione, crypto, query DB, input utente | Revisione rigorosa: è sicuro? |

### 🔧 PRATICA — Analisi di rischio del progetto

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

## 14.5 — Code Review del Codice Generato dall'IA

Il Confidence Tagging ti dice **cosa** revisionare. Questa sezione ti insegna **come** farlo — anche se non sei uno sviluppatore esperto.

### Perché l'IA sbaglia in modi diversi dall'umano

Un programmatore umano fa errori di distrazione: typo, parentesi dimenticate, variabili con nomi sbagliati. L'IA non fa quasi mai questi errori. I bug dell'IA sono più insidiosi:

| Tipo di bug | Esempio | Perché succede |
|:--|:--|:--|
| **Happy path only** | La funzione funziona con input validi, crasha con input vuoti | L'IA ottimizza per "funziona", non per "resiste" |
| **API inesistenti** | Usa un metodo che non esiste nella versione installata | Ha mescolato documentazione di versioni diverse |
| **Logica plausibile ma errata** | Un filtro che sembra corretto ma esclude casi limite | Il pattern sembrava giusto nel training data |
| **Sicurezza dimenticata** | Endpoint senza controllo di autorizzazione | Non glielo hai chiesto esplicitamente |
| **Dipendenze fantasma** | Importa un pacchetto che non è nel package.json | L'ha visto in un progetto simile |

### Metodologia di review per livello

**🟢 LOW RISK — Verifica funzionale (2 minuti/file)**

Componenti UI, styling, modelli dati. La domanda è una sola: *funziona?*

1. L'IA ha creato il file? Aprilo e verifica che non sia vuoto
2. Avvia l'app e guarda se il componente si visualizza
3. Se sì, passa oltre

**🟡 MEDIUM RISK — Verifica logica (5-10 minuti/file)**

Logica business, validazione, routing. La domanda: *fa quello che dovrebbe?*

1. Leggi la funzione principale e chiediti: "Cosa succede se l'input è vuoto? Nullo? Enorme?"
2. Cerca le parole chiave pericolose: `any`, `as any` (TypeScript), `!` (force unwrap), `catch` vuoti
3. Verifica che le validazioni Zod/Joi corrispondano ai requisiti del `_CONTEXT.md`
4. Se la logica ti sembra corretta ma non sei sicuro, chiedi all'IA: *"Spiega passo per passo cosa fa questa funzione e quali edge case potrebbe non gestire"*

**🔴 HIGH RISK — Verifica rigorosa (15-30 minuti/file)**

Autenticazione, autorizzazione, crypto, query DB. La domanda: *è sicuro?*

1. **Autorizzazione**: ogni endpoint che accede a dati utente filtra per `userId`? Può un utente accedere ai dati di un altro?
2. **JWT**: il secret è in una variabile d'ambiente? Il token ha una scadenza?
3. **Input utente**: tutto l'input passa attraverso validazione prima di raggiungere il database?
4. **Errori**: i messaggi di errore in produzione NON espongono stack trace o dettagli interni?
5. Usa la Security Checklist (§14.7) come guida sistematica

### 🔧 PRATICA — Review assistita dall'IA

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

> 💡 **La regola d'oro della review**: Non devi capire *come* funziona ogni riga di codice. Devi capire *cosa* fa la funzione e chiederti: "Cosa potrebbe andare storto?". L'IA è il tuo microscopio — tu devi sapere dove puntarlo.

---

## 14.6 — Analisi OWASP Top 10

Le 10 vulnerabilità più comuni nelle applicazioni web. Verifichiamole nel nostro progetto.

### 🔧 PRATICA — Audit OWASP

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

### Fix comuni che l'IA probabilmente suggerirà

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

Se `npm audit` riporta vulnerabilità:
```bash
npm audit fix
```

---

## 14.7 — Security Checklist Finale

### 🔧 PRATICA — Verifica completa

| # | Controllo | Stato |
|:--|:--|:--|
| 1 | JWT secret >= 256 bit, in variabile d'ambiente | ☐ |
| 2 | Access token scade in 1 ora | ☐ |
| 3 | Refresh token scade in 7 giorni | ☐ |
| 4 | Logout cancella il refresh token dal database | ☐ |
| 5 | Le note sono filtrate per userId in TUTTE le query | ☐ |
| 6 | Input validato con Zod prima del database | ☐ |
| 7 | Errori in produzione NON espongono stack trace | ☐ |
| 8 | Helmet.js attivo con header di sicurezza | ☐ |
| 9 | Rate limiting su endpoint auth | ☐ |
| 10 | CORS configurato solo per i domini consentiti | ☐ |
| 11 | npm audit non riporta vulnerabilità critiche | ☐ |
| 12 | Token mobile in flutter_secure_storage (non SharedPrefs) | ☐ |
| 13 | Frontend non salva token in localStorage | ☐ |
| 14 | Database usa SSL in produzione | ☐ |
| 15 | .env e keystore.jks nel .gitignore | ☐ |

### 🎯 CHECKPOINT
Se tutti i 15 controlli sono spuntati e i test passano, l'applicazione è pronta per il deploy in produzione.

---

## 14.8 — Commit

```bash
cd notes-fullstack
git add .
git commit -m "feat: test unitari e integrazione + audit sicurezza OWASP"
```

---

## Sicurezza Agentica: Oltre l'OWASP Web

L'analisi OWASP Top 10 protegge l'**applicazione** che costruisci. Ma chi protegge l'**infrastruttura di sviluppo**? Quando concedi a un agente IA l'accesso a database, file system e API tramite MCP, introduci vettori di minaccia nuovi che l'OWASP tradizionale non copre.

Nel 2025 l'OWASP ha pubblicato la **OWASP Top 10 for MCP**, una classificazione specifica per le vulnerabilità del protocollo. Tre di queste meritano attenzione immediata:

### Tool Poisoning (MCP03)

Quando configuri un server MCP, l'agente si fida delle **descrizioni** dei tool esposti dal server per decidere quale azione eseguire. Un server compromesso può inserire descrizioni malevole che inducono l'agente a eseguire operazioni distruttive.

> 🚨 **Pericolo**: Un server MCP PostgreSQL manomesso potrebbe descrivere il tool `cleanup_old_data` come "rimuove i record di test", quando in realtà esegue `DROP TABLE users CASCADE`. L'agente, fidandosi della descrizione, lo invocherebbe senza esitazione.

**Mitigazione:** installa *solo* server MCP da repository verificati (`@modelcontextprotocol/` ufficiali o con migliaia di stelle GitHub). Verifica il codice sorgente del server prima dell'adozione.

### Shadow MCP Servers (MCP09)

Come accadeva con lo "Shadow IT", gli sviluppatori possono installare server MCP non verificati per accelerare l'integrazione con nuove API. Questi server bypassano i controlli di sicurezza del team e creano punti di ingresso occulti.

**Mitigazione:** mantieni un registro condiviso dei server MCP approvati (nel `_CONTEXT.md` di progetto o nelle policy del team).

### Context Injection e Over-Sharing (MCP10)

Quando la finestra di contesto è condivisa tra sessioni diverse, informazioni sensibili — token API, segreti, dati utente — possono fuoriuscire da un task all'altro.

**Mitigazione:** usa sempre file `.env` per i segreti, **mai** inline nelle configurazioni MCP. Verifica che il `.gitignore` includa tutti i file sensibili. In ambienti di team, considera la mutual TLS per autenticare le connessioni MCP.

### 🔧 PRATICA — Audit di sicurezza agentica

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

## Testing di Sistemi Non Deterministici

I test unitari e di integrazione che hai scritto in questo capitolo validano **codice deterministico**: dato un input, l'output è sempre lo stesso. Ma nel 2026 molte applicazioni integrano agenti IA che producono risposte **probabilistiche** — chatbot, motori di raccomandazione, pipeline di ragionamento autonomo.

In questi scenari, le asserzioni binarie pass/fail crollano: l'output "corretto" ha molte forme possibili.

### Strategie per il testing probabilistico

| Tecnica | Quando usarla |
|:--|:--|
| **Valutazione semantica** | L'output deve *significare* la stessa cosa, non essere identico lettera per lettera |
| **Golden dataset** | Confronta le risposte con un set di riferimento curato da esperti umani |
| **Evaluator Agent** | Un secondo agente valuta la qualità dell'output del primo |
| **Osservabilità (tracing)** | Traccia l'*albero decisionale* dell'agente per capire *perché* ha dato quella risposta |
| **Fuzzing probabilistico** | Inietta variazioni nell'input per verificare la robustezza dell'output |

> 💡 Piattaforme come **Maxim AI** permettono di valutare sistemi multi-agente misurando l'accuratezza del ragionamento su interazioni multi-turno. Strumenti open-source come **Arize Phoenix** (basato su OpenTelemetry) tracciano l'intero albero di esecuzione delle decisioni di un agente.

> 📘 Per le applicazioni di questo libro (CRUD, REST API, autenticazione) i test tradizionali sono perfettamente adeguati. Il testing probabilistico diventa necessario solo quando integri modelli IA *all'interno* della tua applicazione — ad esempio un chatbot o un motore di ricerca semantica.

---

## Riepilogo

| Aspetto | Dettaglio |
|:--|:--|
| **Test Backend** | vitest + supertest, unit + integration |
| **Test Frontend** | vitest + testing-library + MSW |
| **Test Mobile** | flutter test + mockito |
| **Rischio** | Confidence Tagging a 3 livelli |
| **Code Review** | Metodologia di review per livello di rischio |
| **Sicurezza Web** | OWASP Top 10 audit con fix |
| **Sicurezza Agentica** | OWASP MCP Top 10: Tool Poisoning, Shadow MCP, Context Injection |
| **Testing Probabilistico** | Strategie per output non deterministici |
| **Checklist** | 15 controlli di sicurezza verificabili |

---

**→ Nel prossimo capitolo**: deploy in produzione. Backend su Railway, frontend su Vercel, database su Neon, e l'app mobile sugli store.
