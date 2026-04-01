# REVIEW EDITORIALE — Casa Editrice

## Titolo in esame: *"Architettura di Sistemi Agentici 0-Code"*
## Revisore: Ufficio Editoriale, Collana Manuali Tecnici
## Data: 30 Marzo 2026

---

## 1. DIAGNOSI DEL PROBLEMA FONDAMENTALE

**Il libro risponde alla domanda sbagliata.**

L'opera attuale è un eccellente trattato accademico su *come funzionano i sistemi agentici*. Spiega in modo brillante il Confidence Tagging, il Mandatory STOP, la Classificazione del Rischio, il Planner-Generator-Evaluator. 

Ma il lettore target — uno sviluppatore (o aspirante tale) che vuole **costruire applicazioni reali** usando VS Code con Copilot o Claude Code — chiuderà il libro dopo 16 capitoli senza aver mai:

- Aperto VS Code
- Installato un'estensione
- Scritto un `_CONTEXT.md` funzionante 
- Creato un progetto reale
- Visto una riga di codice generata dall'IA
- Deployato qualcosa in produzione

### Il libro attuale è un manuale sull'anatomia della bicicletta. Il lettore vuole imparare a pedalare.

---

## 2. ANALISI DETTAGLIATA DEI DIFETTI

### 2.1 — L'assenza totale dell'ambiente di sviluppo
Non esiste un singolo capitolo che spieghi:
- Come installare e configurare VS Code
- Come attivare GitHub Copilot o Claude Code (Copilot con Claude Sonnet)
- Come configurare un progetto per lo sviluppo 0-code
- Come installare server MCP in pratica (con comandi reali)
- Come strutturare una cartella di progetto

Il lettore legge di MCP, Agent Skills e Context Engineering senza mai vedere **dove** e **come** si applicano concretamente.

### 2.2 — Nessun progetto pratico costruito dall'inizio alla fine
I "tutorial" nella Parte V (Cap. 12-16) sono **scenari teorici**, non tutorial operativi. Descrivono *cosa farebbe un agente* in un contesto ipotetico, ma non guidano mai il lettore attraverso:
1. "Apri il terminale"
2. "Crea questa cartella"
3. "Scrivi questo _CONTEXT.md"
4. "Chiedi all'IA di generare..."
5. "Verifica l'output"
6. "Correggi eventuali problemi"

### 2.3 — Focus sbagliato: agenti come soggetto vs. agenti come strumento
Il libro tratta gli agenti come l'**oggetto** da costruire. Ma il lettore target vuole usare gli agenti (Copilot/Claude Code) come **strumento** per costruire applicazioni.

La differenza è fondamentale:
- **Libro attuale**: "Come progettare un Agente Analista con Confidence Tagging"
- **Libro necessario**: "Come usare Copilot per creare un'API REST con autenticazione OAuth 2.0"

### 2.4 — Assenza di progressione progettuale concreta
Il lettore ha bisogno di una progressione chiara:
```
Hello World → CLI Tool → REST API → Database → OAuth 2.0 → Frontend → Mobile Flutter
```
Ogni passo costruisce sulle competenze del precedente. Ogni progetto è COMPLETAMENTE FUNZIONANTE.

### 2.5 — Assenza di screenshot, comandi terminale, output reali
Un manuale tecnico pratico richiede:
- Screenshot dell'interfaccia VS Code/Copilot
- Comandi terminale copia-incolla
- Strutture di cartelle reali (tree output)
- File `_CONTEXT.md` e `SKILL.md` completi e testati
- Output dell'IA commentati e analizzati
- Risultati visibili (browser, app mobile, terminale)

---

## 3. CONTENUTO RECUPERABILE

Non tutto va buttato. La teoria è solida e va **compressa** e **riposizionata** come supporto ai progetti pratici:

| Contenuto attuale | Riutilizzo proposto |
|:--|:--|
| Cap. 1-3 (Fondamenti ADLC) | Condensare in 1 capitolo introduttivo |
| Cap. 4 (Context Engineering) | Integrare come tecnica dentro i primi progetti |
| Cap. 5 (Agent Skills) | Spiegare quando si usa il primo SKILL.md (progetto Web) |
| Cap. 6 (MCP) | Integrare quando si configura il primo server MCP |
| Cap. 7 (Rischio) | Riquadro pratico nel progetto OAuth/Backend |
| Cap. 8 (Multi-Agente) | Tecnica avanzata nel progetto Full-Stack |
| Cap. 10-11 (Testing/Sicurezza) | Capitolo dedicato al testing dei progetti |
| Glossario | Mantenere e aggiornare |
| Bibliografia | Unificare e aggiornare |

---

## 4. RISTRUTTURAZIONE PROPOSTA

### Nuovo titolo proposto:
# **"Sviluppo Software 0-Code: Costruire Applicazioni Reali con VS Code, Copilot e Claude Code"**
### Sottotitolo: *Dal Hello World al Full-Stack con Autenticazione — Una Guida Pratica all'Agent Development Life Cycle*

### Nuova struttura in 6 Parti, 16 Capitoli:

---

#### PARTE I — IL PARADIGMA (3 capitoli di fondazione snella)

**Cap. 1 — La Rivoluzione 0-Code: Sviluppare Senza Scrivere Codice**
- Cos'è lo sviluppo 0-code (in 2 pagine, non 20)
- Cosa cambierà per te, lettore, dopo questo libro
- Demo: un assaggio di cosa costruirai (screenshot del risultato finale)

**Cap. 2 — L'Ambiente di Sviluppo: VS Code, Copilot e Claude Code**
- Installazione VS Code
- Configurazione GitHub Copilot (chat, agent mode, edits)
- In alternativa: Claude Code da terminale  
- Le estensioni essenziali
- Primo test: generare una funzione Python con Copilot

**Cap. 3 — Il Metodo ADLC: Come si Lavora in 0-Code**
- Il ciclo di vita in sintesi (non 7 fasi di teoria — 7 fasi applicate)
- Context Engineering: il file `_CONTEXT.md` come contratto con l'IA
- La regola d'oro: "più il contesto è preciso, migliore è il risultato"
- Primo `_CONTEXT.md` funzionante

---

#### PARTE II — I PRIMI PROGETTI (3 capitoli hands-on)

**Cap. 4 — Progetto 1: Hello World in 0-Code**
- Creazione progetto Python da zero tramite Copilot/Claude Code
- Come formulare richieste efficaci
- Dalla richiesta al codice funzionante
- Debug assistito dall'IA
- Refactoring e miglioramenti iterativi

**Cap. 5 — Progetto 2: Un'Applicazione CLI Completa**
- Tool da riga di comando con argparse
- Lettura/scrittura file, parsing CSV/JSON
- Test automatici generati dall'IA
- Primo `_CONTEXT.md` di progetto strutturato
- Package e distribuzione

**Cap. 6 — Progetto 3: Server REST API con Node.js**
- Scaffolding Express.js tramite 0-code
- Endpoint CRUD completi
- Validazione input e gestione errori
- Documentazione API automatica (Swagger/OpenAPI)
- Test con curl e Postman

---

#### PARTE III — L'APPLICAZIONE WEB FULL-STACK (4 capitoli — il cuore del libro)

**Cap. 7 — Database e Modello Dati con PostgreSQL**
- Setup PostgreSQL (locale o Docker)
- Configurazione MCP Server PostgreSQL (PRIMO USO DI MCP NEL LIBRO)
- ORM Prisma/Sequelize generato dall'IA
- Migrazioni e seed data
- Agent Skills per il database (`SKILL.md`)

**Cap. 8 — Autenticazione OAuth 2.0 e JWT**
- Teoria OAuth 2.0 (quanto basta per capire i flussi)
- Implementazione con Google/GitHub OAuth Provider
- JWT, refresh token, session management
- Middleware di autenticazione
- Classificazione del rischio applicata (MEDIUM/HIGH RISK sulle operazioni auth)

**Cap. 9 — Frontend Web con React e Autenticazione**
- Scaffolding React/Next.js  
- Componenti UI generati dall'IA
- Login/Register con OAuth
- Rotte protette e stato utente
- Dashboard CRUD autenticata
- Agent Skill dedicata per il frontend design

**Cap. 10 — Integrazione Full-Stack: Backend + Frontend + Database**
- Collegamento completo dei tre layer
- CORS, proxy, environment variables
- `_CONTEXT.md` globale del progetto full-stack
- Sincronizzazione dello stato con `PROGRESS.md`
- Pattern Multi-Agente applicato (Planner-Generator-Evaluator in azione reale)

---

#### PARTE IV — L'APPLICAZIONE MOBILE CON FLUTTER (3 capitoli)

**Cap. 11 — Setup Flutter e Primo Widget**
- Installazione Flutter SDK
- Primo progetto Flutter generato in 0-code
- Struttura di un'app Flutter (widget tree, state management)
- Navigazione e theme
- `_CONTEXT.md` per progetti Flutter

**Cap. 12 — Flutter: Connessione al Backend**
- Client HTTP e API integration
- Autenticazione OAuth 2.0 da mobile
- Secure storage per token
- State management (Provider/Riverpod)
- Lista dati dal backend, CRUD completo

**Cap. 13 — Da Prototipo a Release: Build, Test e Distribuzione**
- Testing automatico Flutter (unit, widget, integration)
- Build Android APK / iOS IPA
- App signing e configurazione store
- CI/CD con GitHub Actions generato in 0-code

---

#### PARTE V — QUALITÀ, SICUREZZA E PRODUZIONE (2 capitoli)

**Cap. 14 — Testing e Sicurezza nelle Applicazioni 0-Code**
- Generazione test con l'IA (unit, integration, e2e)
- OWASP Top 10 applicato ai progetti del libro
- Confidence Tagging nell'analisi di sicurezza
- Vulnerability scanning automatizzato 
- Code review assistita dall'IA

**Cap. 15 — Deploy in Produzione**
- Backend: Deploy su Railway/Render/Fly.io
- Frontend: Deploy su Vercel/Netlify
- Database: PostgreSQL gestito (Supabase/Neon)
- Mobile: Pubblicazione Play Store / App Store
- Monitoraggio e manutenzione continua

---

#### PARTE VI — TECNICHE AVANZATE (1 capitolo capstone)

**Cap. 16 — Oltre il Libro: Pattern Avanzati per Progetti Enterprise**
- Orchestrazione Multi-Agente per team complessi
- Microservizi e architetture distribuite in 0-code
- Gestione di codebase legacy
- Quando il 0-code non basta: i limiti del paradigma
- Il futuro dello sviluppo software

---

#### APPENDICI

**A — Glossario** (aggiornato con termini pratici)
**B — Template Pronti all'Uso** (_CONTEXT.md, SKILL.md per diversi scenari)
**C — Comandi e Shortcut Essenziali** (VS Code, Copilot, terminale)
**D — Bibliografia e Risorse**

---

## 5. PRINCIPI EDITORIALI PER LA RISCRITTURA

1. **"Show, don't tell"**: Ogni concetto teorico viene introdotto QUANDO serve in un progetto, non prima
2. **Ogni capitolo ha un deliverable**: il lettore produce qualcosa di funzionante
3. **Progressione continua**: il progetto web del Cap. 6 evolve fino al Cap. 10; l'app mobile del Cap. 11 si connette al backend del Cap. 8
4. **Box tipografici standardizzati**:
   - 🔧 **PRATICA**: comandi terminale e configurazioni copia-incolla
   - 💡 **SUGGERIMENTO**: trucco o best practice
   - ⚠️ **ATTENZIONE**: errore comune o trappola
   - 📖 **APPROFONDIMENTO**: teoria per chi vuole capire di più (rimando ai concetti ADLC)
   - 🎯 **CHECKPOINT**: "a questo punto dovresti vedere..."
5. **Linguaggio diretto**: "Apri il terminale", "Scrivi questo file", "Chiedi a Copilot di..."
6. **Ogni progetto è auto-contenuto**: può essere seguito anche saltando i precedenti (con note sui prerequisiti)

---

## 6. VERDETTO FINALE

**Raccomandazione: RISTRUTTURAZIONE COMPLETA.**

Il materiale teorico esistente è di alta qualità e va riutilizzato come ossatura concettuale. Ma deve essere completamente riorganizzato attorno a **progetti pratici concreti** con un lettore che tiene le mani sulla tastiera, non sulle pagine di un trattato accademico.

Il libro deve rispondere a una promessa chiara: **"Alla fine di questa lettura, avrai costruito un'applicazione web full-stack autenticata e un'app mobile Flutter che ci si connette — senza aver scritto manualmente una riga di codice."**
