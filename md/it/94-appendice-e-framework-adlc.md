# Appendice E — Un Framework ADLC Reale: Analisi di un Contratto Professionale per Agenti IA

## Premessa

Nel corso del libro hai imparato a scrivere file `_CONTEXT.md`, a definire vincoli, a strutturare la comunicazione con l'agente IA. Hai costruito 9 progetti applicando queste tecniche in modo progressivo — dal Hello World al deploy in produzione.

Ora è il momento di vedere come questi stessi principi vengono applicati in un ambiente **professionale e di produzione**. Questa appendice analizza un framework reale composto da 17 moduli e 8 SKILL specializzate, organizzato in una struttura modulare che governa il comportamento di un agente IA lungo l'intero ciclo di sviluppo software. Il framework è incluso nella cartella `example_contracts/` del repository di questo libro.

Non è un esercizio accademico. È un set di istruzioni operative usato in progetti reali, con team reali, su codebase reali. E ogni suo componente è un'applicazione diretta dei concetti ADLC che hai imparato.

---

## E.1 — Architettura del Framework

Il framework si struttura su **tre livelli gerarchici**, esattamente come il pattern di Progressive Disclosure descritto nel Capitolo 3:

```text
Repository/
├── .github/
│   ├── copilot-instructions.md          ← Contratto universale (caricato sempre)
│   └── copilot_modules/                 ← Moduli specializzati (caricati su richiesta)
│       ├── 00_MODE_EN.md                ← Modalità operative
│       ├── 00_CONTEXT_TEMPLATE_EN.md    ← Template context card (completo + variante minimale)
│       ├── 01_CORE_RULES_EN.md          ← Regole base (caricato sempre)
│       ├── 02_DISCOVERY_ANALYSIS_EN.md  ← Fase 0-1: Scoperta e Analisi
│       ├── 03_DESIGN_EN.md              ← Fase 2: Design e Architettura
│       ├── 04_IMPLEMENTATION_EN.md      ← Fase 3: Implementazione
│       ├── 05_VERIFICATION_RELEASE_EN.md← Fase 4-5: Verifica e Rilascio
│       ├── 06_OPS_EN.md                 ← Fase 6: Operazioni
│       ├── 07_SPECIAL_LANES_EN.md       ← Workflow paralleli e speciali
│       ├── 08_PROMPT_LIBRARY_EN.md      ← Libreria di prompt riutilizzabili
│       ├── 09_CODEBASE_ANALYSIS_EN.md   ← Protocollo di analisi codebase
│       ├── 10_DOCUMENTATION_EN.md       ← Generazione e automazione docs
│       ├── 11_BUGFIX_PLAYBOOK_EN.md     ← Approccio strutturato al debug
│       ├── 12_OPERATING_GUIDE_EN.md     ← Guida operativa rapida
│       ├── 13_ARCH_BACKEND_EXAMPLE_EN.md ← Contratto architetturale backend (esempio)
│       ├── SECURITY_CONSTRAINTS_LIBRARY_EN.md
│       └── PERFORMANCE_CONSTRAINTS_LIBRARY_EN.md
│
├── .copilot/
│   └── skills/                          ← SKILL specializzate per fase
│       ├── SKILL_ANALYSIS_EN.md         ← Fase 0-1: Analisi
│       ├── SKILL_DESIGN_EN.md           ← Fase 2: Design
│       ├── SKILL_REACT_EN.md            ← Fase 3-4: Frontend React
│       ├── SKILL_FLUTTER_EN.md          ← Fase 3-4: Mobile Flutter
│       ├── SKILL_API_DESIGN_EN.md       ← Fase 3-4: API Design
│       ├── SKILL_DATABASE_EN.md         ← Fase 3-4: Database
│       ├── SKILL_SECURITY_EN.md         ← Fase 3-4: Sicurezza
│       └── SKILL_OPS_EN.md              ← Fase 6: Operations
│
├── ProgettoA/
│   ├── .copilot/
│   │   ├── instructions.md              ← Regole specifiche del progetto
│   │   └── domain.md                    ← Conoscenza di dominio
│   ├── _CONTEXT.md                      ← Stato corrente del progetto
│   └── PROGRESS.md                      ← Memoria persistente tra sessioni
│
└── ProgettoB/
    ├── .copilot/
    │   └── instructions.md
    ├── _CONTEXT.md
    └── PROGRESS.md
```

### Il principio di separazione

Il framework distingue nettamente tre ambiti:

| Ambito | Posizione | Chi lo gestisce | Scopo |
|:--|:--|:--|:--|
| **Framework universale** | `.github/` | Team di architettura | Regole valide per qualsiasi progetto — immutabili dall'agente |
| **Regole di progetto** | `.copilot/` | Team di progetto | Override specifici per uno stack, un dominio, un team |
| **Stato di sessione** | `_CONTEXT.md` | Umano + Agente | Fase corrente, task attivo, vincoli, comandi — aggiornato continuamente |

Questa architettura risolve un problema reale: come mantenere la coerenza delle regole su decine di progetti senza duplicare le istruzioni. Il framework in `.github/` è la "costituzione" e le regole in `.copilot/` sono le "leggi locali".

---

## E.2 — Il Contratto Universale: `copilot-instructions.md`

Il file principale — circa 350 righe — è il punto d'ingresso che l'agente carica **ad ogni sessione**. Funziona come un **router**: definisce i protocolli essenziali (Bootstrap, Risk Classification, Confidence Tagging) e rimanda ai moduli specializzati per i dettagli. Contiene quattro sezioni critiche:

### Bootstrap Protocol

All'apertura di ogni nuova chat, l'agente esegue automaticamente un protocollo di inizializzazione:

1. **Codebase Discovery**: Analizza il repository per comprendere struttura, stack tecnologico, pattern architetturale, comandi di build/test/deploy
2. **Context Intake**: Cerca il `_CONTEXT.md` più vicino al file attivo, carica le istruzioni specifiche del progetto da `.copilot/`, conferma i parametri di sessione
3. **Context Block Generation**: Produce un riepilogo strutturato con fase, stack, vincoli SEC/PERF, comandi

Confronta questo con il Capitolo 3: è esattamente il `_CONTEXT.md` che hai imparato a scrivere, ma automatizzato. L'agente non aspetta che tu gli dica dove trovare le informazioni — le cerca autonomamente seguendo un protocollo definito.

### Modalità Operative

Il framework definisce 4 modalità che calibrano il comportamento dell'agente:

| Modalità | Controlli attivi | Velocità | Uso tipico |
|:--|:--|:--|:--|
| **STANDARD** | Tutti (SEC/PERF/test/doc) | Normale | Sviluppo quotidiano |
| **FAST** | Solo SEC-XX | 2× | Prototipi e spike |
| **AUDIT** | Tutti + scansioni di compliance | Lenta | Pre-produzione |
| **RAPID** | Minimali (naming + errori) | 5× | Fix d'emergenza |

Nel libro hai lavorato sempre in modalità "STANDARD" implicita. Un framework professionale rende queste scelte esplicite e governabili.

### Classificazione del Rischio e Mandatory STOP

Il contratto implementa la classificazione a tre livelli che hai visto nel Capitolo 14:

```text
LOW RISK + SMALL (spiegare, nominare, formattare):
→ Esegui direttamente, notifica a fine

MEDIUM RISK o SCOPE MEDIO (implementare, testare, refactoring):
→ "Propongo di [X]. Procedo?"

HIGH RISK o SCOPE AMPIO (architettura, schema, eliminazione):
→ Piano dettagliato con step. Conferma esplicita obbligatoria.
```

Le situazioni di **STOP obbligatorio** sono elencate esplicitamente:
- Modifiche a schema database o contratto API
- Cancellazione di dati o codice
- Modifiche alla logica di autenticazione/autorizzazione
- Cambiamenti architetturali
- Deploy in produzione o migrazioni
- Gestione di segreti e credenziali
- Qualsiasi azione che impatti la compliance regolatoria (SEC-XX)

### Confidence Tagging

Ogni output tecnico superiore a 5 righe deve terminare con un tag di affidabilità:

```markdown
---
AI CONFIDENCE: FACT
Basis: Function signature verified in src/auth/handler.ts#L42
```

Nota la differenza qualitativa rispetto al Confidence Tagging che hai imparato: qui il tag non è solo una categoria (FACT/INFERRED/ASSUMPTION), ma include la **base probatoria** — il file e la riga esatta da cui l'informazione è stata verificata. Questo è il livello professionale del protocollo.

---

## E.3 — I Moduli SDLC: Un Agente per Ogni Fase

La vera innovazione del framework è la modularizzazione delle competenze dell'agente **per fase di sviluppo**. Invece di caricare tutte le regole in ogni sessione (saturando il contesto), il sistema attiva solo i moduli necessari per la fase corrente.

### Attivazione Automatica per Fase

L'agente rileva automaticamente la fase dall'input dell'utente:

| Pattern nell'input | Fase attivata | Modulo caricato |
|:--|:--|:--|
| "Ho bisogno di..." / "nuova feature" | 0-1: Discovery | `02_DISCOVERY_ANALYSIS_EN.md` |
| "architettura" / "tech stack" / "ADR" | 2: Design | `03_DESIGN_EN.md` |
| "implementa" / "codifica" / "scrivi" | 3: Implementation | `04_IMPLEMENTATION_EN.md` |
| "è pronto?" / "test" / "QA" | 4-5: Verification | `05_VERIFICATION_RELEASE_EN.md` |
| "errore in produzione" / "incident" | 6: Ops | `06_OPS_EN.md` |

Questo è il **Progressive Disclosure** descritto nel Capitolo 3, applicato non a una singola Skill ma all'intero ciclo di vita. L'agente sa fare tutto, ma carica solo ciò che serve.

### Modulo Design (`03_DESIGN_EN.md`)

Questo modulo governa la Fase 2 — corrispondente al Design classico dell'SDLC. Contiene:

- **Template di valutazione stack**: Tabella strutturata per confrontare opzioni tecnologiche su 6 criteri pesati (competenza team, performance, sicurezza, scalabilità, community, costo)
- **Template ADR**: Architecture Decision Record — documenta perché ogni decisione è stata presa, non solo cosa è stato deciso
- **Template contratto API**: Definizione delle interfacce prima dell'implementazione
- **Struttura EPIC → Task**: Scomposizione del lavoro in unità atomiche con story point, acceptance criteria e vincoli SEC/PERF applicabili

### Modulo Implementation (`04_IMPLEMENTATION_EN.md`)

La fase più usata. Implementa la **Regola dello Pseudocodice** che hai incontrato nel Capitolo 10:

> Per task che richiedono logica algoritmica > 50 righe, calcoli con edge case, business rules complesse o integrazione con sistemi esterni: **scrivi prima lo pseudocodice**, attendi l'approvazione, poi implementa.

Il workflow di ogni task è codificato:

```text
1. Utente assegna task → "Implementa T-001.3"
2. Agente legge il file task con Acceptance Criteria e vincoli
3. Agente classifica il rischio (LOW/MED/HIGH)
4. Agente propone piano (o esegue direttamente se LOW)
5. Agente implementa → build → test → checkpoint
6. Agente aggiorna lo stato del task: TODO → DONE
7. Agente aggiorna _CONTEXT.md
```

### Modulo Ops (`06_OPS_EN.md`)

Il modulo per gli incidenti in produzione — la Fase 6 dell'ADLC. Copre:
- **Triage degli incidenti**: Classificazione per severità e impatto
- **Root Cause Analysis (RCA)**: Protocollo strutturato per risalire alla causa
- **Post-mortem**: Template per documentare l'incidente e le lezioni apprese
- **Runbook**: Procedure operative standard per scenari ricorrenti

---

## E.4 — Workflow di Interazione: Il Protocollo Uomo-Agente

Il file `WORKFLOW.md` definisce il **protocollo completo di interazione** tra umano e agente, articolato in 5 fasi:

### Fase 0: Setup Iniziale (una tantum)

L'umano prepara l'ambiente:
1. Verifica che `.github/copilot-instructions.md` e `.github/copilot_modules/` siano presenti
2. Crea per ogni progetto: `.copilot/instructions.md`, `.copilot/skills/`, `_CONTEXT.md`
3. Popola `_CONTEXT.md` con fase, stack, vincoli

L'agente non fa nulla in questa fase. Non può modificare `.github/`.

### Fase 1: Inizio Sessione (ogni chat)

L'agente esegue automaticamente il Bootstrap Protocol:
1. Legge `copilot-instructions.md`
2. Cerca e carica `_CONTEXT.md`
3. Carica `.copilot/instructions.md` e la SKILL corrispondente alla fase corrente
4. Conferma: *"Context acquired. Project: X | Phase: Y | Stack: Z | SKILL: S | Mode: M. Proceed?"*

L'umano conferma o corregge.

### Fase 2: Assegnazione Task

L'umano comunica il lavoro. Il framework definisce tre modi:

| Modo | Esempio | Comportamento |
|:--|:--|:--|
| **Per task file** | "Implementa T-001.3" | Carica il file task, estrae AC, implementa |
| **Per epic** | "Lavora su E-001" | Legge l'epic, propone il prossimo task TODO |
| **Libero** | "Aggiungi il modello User" | Classifica rischio, propone piano, esegue |

### Fase 3: Ciclo di Lavoro

L'agente lavora seguendo il flow di implementazione con checkpoint ogni 3-5 azioni significative:

```markdown
## CHECKPOINT [3]
Phase: Implementation | Task: T-001.3
✅ Completato: endpoint GET /api/users, validazione input, test unitari
📋 Prossimo: endpoint POST /api/users
📊 Confidenza: On track
```

### Fase 4: Comandi di Controllo

L'umano può intervenire in qualsiasi momento con comandi espliciti:

| Comando | Effetto |
|:--|:--|
| `@stop` | Arresto immediato |
| `@explain` | L'agente spiega il ragionamento dell'ultima azione |
| `@undo` | Annulla l'ultima modifica |
| `@alternatives` | Propone soluzioni alternative |
| `@confidence` | Dichiara FACT / INFERRED / ASSUMPTION |
| `@context-update` | Aggiorna `_CONTEXT.md` e `PROGRESS.md` con lo stato corrente |
| `@checkpoint` | Salva progresso e propone il prossimo passo |

### Fase 5: Fine Sessione

L'agente genera un blocco aggiornato per `_CONTEXT.md` e `PROGRESS.md`. L'umano copia il blocco nel file locale. La prossima sessione ripartirà da questo stato.

---

## E.5 — Componenti Specializzati

### Workflow Fullstack Parallelo (`07_SPECIAL_LANES_EN.md`)

Per feature che richiedono modifiche simultanee a frontend e backend, il framework definisce **sync point** espliciti:

```text
SYNC POINT 1: Contract Agreement
→ OpenAPI spec finalizzata, DTO condivisi, mock server pronto

SYNC POINT 2: Integration Ready  
→ Backend funzionante, frontend pronto per integrazione, rimozione mock

SYNC POINT 3: E2E Ready
→ Entrambi i layer integrati, feature testabile end-to-end
```

Questo risolve un problema che nel libro hai affrontato nel Capitolo 10 (Integrazione Full-Stack) in modo manuale. In un ambiente professionale, i sync point sono codificati nel framework.

### Librerie di Vincoli

Due file dedicati raccolgono pattern riutilizzabili:

- **`SECURITY_CONSTRAINTS_LIBRARY_EN.md`**: Catalogo di vincoli SEC-XX pronti all'uso (autenticazione, autorizzazione, input validation, encryption, secrets management, CORS, etc.)
- **`PERFORMANCE_CONSTRAINTS_LIBRARY_EN.md`**: Catalogo di vincoli PERF-XX con target specifici (response time, throughput, memory, query optimization, caching, etc.)

Invece di reinventare i vincoli per ogni progetto, il team seleziona dal catalogo quelli applicabili e li inserisce nel `_CONTEXT.md` del progetto.

### Bugfix Playbook (`11_BUGFIX_PLAYBOOK_EN.md`)

Un protocollo strutturato per il debugging che impone:
1. Riproduzione del bug (script o caso di test)
2. Isolamento della causa (restringere il perimetro)
3. Fix minimale (una sola modifica logica)
4. Test di regressione (il bug non si ripresenta)
5. Post-mortem (cosa ha causato il bug, come prevenirlo)

### Contratto Architetturale (`13_ARCH_BACKEND_EXAMPLE_EN.md`)

Un contratto specifico per l'architettura backend (Node.js in questo caso), esplicitamente marcato come **esempio** da adattare al proprio stack. Definisce:
- Layer e responsabilità (API → Application → Domain → Infrastructure)
- Pattern obbligatori (CQRS, Repository, Unit of Work)
- Regole di dipendenza (nessun riferimento dal Domain verso l'Infrastructure)
- Template per ogni componente

### SKILL Files: Competenze per Ogni Fase

Oltre ai 17 moduli in `.github/copilot_modules/`, il framework include **8 SKILL specializzate** nella cartella `.copilot/skills/`. Ogni SKILL conferisce all'agente competenze specifiche per una fase dell'ADLC:

| SKILL | Fase | Competenza |
|:--|:--|:--|
| `SKILL_ANALYSIS_EN.md` | 0-1 | Requisiti, user stories, threat model, NFR |
| `SKILL_DESIGN_EN.md` | 2 | Stack evaluation, ADR, EPIC/task, contratti API |
| `SKILL_REACT_EN.md` | 3-4 | Frontend React + Tailwind + Vite |
| `SKILL_FLUTTER_EN.md` | 3-4 | Mobile Flutter + Riverpod + GoRouter |
| `SKILL_API_DESIGN_EN.md` | 3-4 | REST API design, OpenAPI, versioning |
| `SKILL_DATABASE_EN.md` | 3-4 | PostgreSQL, Prisma, migrazioni, ottimizzazione |
| `SKILL_SECURITY_EN.md` | 3-4 | OAuth 2.0, JWT, OWASP, audit sicurezza |
| `SKILL_OPS_EN.md` | 6 | Incident management, SLA, post-mortem, runbook |

Questo è il **Progressive Disclosure** applicato alle competenze: l'agente non carica tutte le SKILL contemporaneamente, ma attiva solo quella necessaria per la fase corrente, evitando la saturazione del contesto.

---

## E.6 — Dal Libro al Framework: Mappatura

Ogni componente di questo framework è un'evoluzione dei concetti che hai appreso nel libro:

| Concetto del libro | Capitolo | Implementazione nel framework |
|:--|:--|:--|
| `_CONTEXT.md` | 3 | Context Card con template standardizzato + variante minimale (`00_CONTEXT_TEMPLATE_EN.md`) |
| Vincoli SEC/PERF | 3, 14 | Librerie riutilizzabili (`SECURITY_CONSTRAINTS_LIBRARY_EN.md`, `PERFORMANCE_CONSTRAINTS_LIBRARY_EN.md`) |
| Confidence Tagging | 3, 14 | Tag con base probatoria obbligatoria (`copilot-instructions.md` §2) |
| Risk Classification | 14 | Matrice di rischio con Mandatory STOP (`01_CORE_RULES_EN.md` §11-12) |
| Regola Pseudocodice | 10 | Regola obbligatoria per >50 righe (`04_IMPLEMENTATION_EN.md`) |
| Context Engineering | 3 | Progressive Disclosure a 3 livelli: Framework → Progetto → Sessione |
| Pattern Multi-Agente | 16 | Moduli SDLC caricati per fase + Workflow paralleli (`07_SPECIAL_LANES_EN.md`) |
| Checkpoint e @context-update | 10, 16 | Protocollo checkpoint ogni 3-5 azioni (`WORKFLOW.md` §3) |
| Testing e Sicurezza | 14 | Security checklist per PR + SAST/DAST (`05_VERIFICATION_RELEASE_EN.md`) |
| Deploy | 15 | Rollback plan obbligatorio + release planning (`05_VERIFICATION_RELEASE_EN.md`) |
| Codice Legacy | 16 | Protocollo completo con ADR retroattivi (`copilot-instructions.md` §Legacy) |
| Documentazione | 10, 16 | Generazione e automazione unificate (`10_DOCUMENTATION_EN.md`) |

---

## E.7 — Lezioni dal Mondo Reale

Analizzando questo framework emergono alcune lezioni operative che vanno oltre la teoria:

### 1. L'immutabilità del framework è non-negoziabile

Il file principale contiene la nota: *"THIS FILE MUST NEVER BE MODIFIED"* e una **Agent Protection Clause** che vieta esplicitamente all'agente di modificare `.github/copilot_modules/`. Le modifiche al framework seguono un processo di change management separato. Le regole di progetto vivono in `.copilot/` — questo è l'unico livello dove il team può personalizzare.

### 2. Il costo del contesto è gestito con precisione

Ogni modulo dichiara il proprio costo in contesto:

```text
> Size: ~320 lines | Context cost: Medium
```

Questo permette al team di fare scelte consapevoli su quanti moduli caricare simultaneamente, evitando la saturazione del contesto — il problema dell'"ansia da contesto" descritto nel Capitolo 16.

### 3. La gerarchia di priorità è esplicita

```text
1. _CONTEXT.md           ← stato sessione (fase, task, vincoli) — PRIORITÀ MASSIMA
2. .copilot/instructions.md  ← regole progetto (override .github/)
3. .copilot/skills/*.md      ← competenze specializzate per fase
4. .copilot/domain.md        ← conoscenza di dominio
5. .github/copilot_modules/  ← regole framework (read-only) — PRIORITÀ MINIMA
```

In caso di conflitto, il livello più specifico prevale. Il `_CONTEXT.md` del progetto ha priorità assoluta sul framework generico.

### 4. I comandi di controllo sono un sistema operativo per l'IA

I comandi `@stop`, `@explain`, `@undo`, `@checkpoint`, `@context-update` non sono suggerimenti — sono un'interfaccia di controllo che permette all'umano di governare l'agente in tempo reale, come un sistema operativo governa i processi.

---

## Oltre il Contratto Testuale: La Governance Infrastrutturale

Il framework analizzato in questa appendice si basa su **vincoli testuali**: regole scritte in linguaggio naturale che l'agente dovrebbe rispettare. Questo approccio funziona nella maggioranza dei casi, ma ha un limite intrinseco: si affida all'autodisciplina del modello linguistico. Un prompt avversario o un'allucinazione possono violare qualsiasi vincolo testuale.

Nel 2026, l'industria enterprise ha risposto con soluzioni che applicano i vincoli **a livello di runtime**. Il caso più significativo è **NemoClaw** di NVIDIA, uno stack infrastrutturale che implementa il sandboxing a livello di processo tramite il componente **OpenShell**.

### Come funziona

A differenza di un `_CONTEXT.md` che dice "NON usare librerie esterne", NemoClaw utilizza policy scritte in YAML applicate a livello di kernel. L'agente è isolato in una sandbox con:

- Permessi di rete limitati a specifici endpoint
- Accesso al file system ristretto a directory autorizzate
- Blocco fisico di qualsiasi operazione non prevista, indipendentemente dal prompt

Un *Privacy Router* instrada le query con dati sensibili verso modelli locali (come la famiglia NVIDIA Nemotron), inviando al cloud solo i compiti di ragionamento astratto.

### I due approcci si completano

| | Contratto Testuale (ADLC) | Governance Infrastrutturale (NemoClaw) |
|:--|:--|:--|
| **Meccanismo** | Regole in linguaggio naturale | Policy YAML a livello di kernel |
| **Enforcement** | L'agente *dovrebbe* rispettare | L'agente *non può* violare |
| **Costo** | Zero (file di testo) | Infrastruttura dedicata |
| **Ideale per** | Team piccoli, progetti individuali | Enterprise, dati regolamentati |
| **Limite** | Vulnerabile a prompt injection | Richiede infrastruttura NVIDIA |

> 📘 Per i progetti di questo libro e per la maggioranza delle startup, il contratto testuale ADLC è più che sufficiente. La governance infrastrutturale diventa necessaria quando si trattano dati regolamentati (GDPR, HIPAA), si opera in settori critici (finanza, sanità), o si gestiscono team con decine di agenti autonomi.

---

## Conclusione

Il framework che hai analizzato in questa appendice dimostra che il paradigma ADLC non è un concetto accademico — è un metodo di lavoro operativo, testato in produzione, con strumenti concreti e protocolli misurabili.

Partendo dal semplice `_CONTEXT.md` del Capitolo 3, hai visto come lo stesso principio scala fino a un'architettura modulare di 17 moduli e 8 SKILL che governa team professionali su codebase complesse. La distanza tra il tuo primo Hello World e questo framework non è un abisso — è una scala progressiva, e ogni gradino è un concetto che hai già appreso.

Il prossimo passo è tuo: prendi i template da questo framework, adattali al tuo progetto, e inizia a costruire i tuoi contratti per agenti IA.
