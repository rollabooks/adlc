# Capitolo 15 — Monorepo, Company Extension e Codebase Legacy

I capitoli precedenti hanno seguito TaskFlow API come progetto singolo. Ma in molte organizzazioni il software non vive in un unico repository: ci sono monorepo con dieci servizi, codebase legacy senza documentazione, processi aziendali SDLC che l'agente deve rispettare.

Questo capitolo copre tre scenari avanzati che emergono quando AI-DLC si incontra con la complessità reale del lavoro di squadra.

---

## 15.1 Monorepo: un framework, più progetti

Un monorepo contiene più servizi o applicazioni nella stessa repository. Per TaskFlow API, supponiamo che la struttura cresca così:

```
taskflow/
├── apps/
│   ├── api/          ← REST API (Node.js/Fastify)
│   ├── worker/       ← Job worker (Node.js)
│   └── dashboard/    ← Frontend admin (React)
├── packages/
│   ├── shared/       ← Tipi e utility condivisi
│   └── ui/           ← Componenti React condivisi
├── AGENTS.md         ← Framework condiviso
├── CLAUDE.md
├── .ai-dlc/            ← Framework condiviso
└── _CONTEXT.md       ← Context di ROOT (opzionale)
```

Ogni sottoprogetto che ha bisogno di un contesto indipendente crea il proprio `_CONTEXT.md`:

```
apps/api/_CONTEXT.md      ← Fase 3, task API corrente, vincoli API
apps/worker/_CONTEXT.md   ← Fase 3, task worker corrente, vincoli worker
apps/dashboard/_CONTEXT.md ← Fase 2, design in corso, vincoli frontend
```

### Come l'agente sceglie il context

Il protocollo di ricerca del `_CONTEXT.md` (visto nel Capitolo 4) sale dalla directory corrente verso la root. Se l'agente sta lavorando su `apps/api/src/routes/tasks.ts`, trova prima `apps/api/_CONTEXT.md` — quello più vicino al file. Usa quello.

Se stai lavorando su `packages/shared/src/types.ts`, non c'è un `_CONTEXT.md` in `packages/shared/`. L'agente sale e trova `_CONTEXT.md` alla radice del monorepo (se esiste), oppure chiede di crearne uno.

### Scaffold di un nuovo sottoprogetto

```powershell
.\.ai-dlc\tools\init.ps1 -ProjectRoot .\apps\worker -FrameworkRoot .
```

```bash
bash .ai-dlc/tools/init.sh --project-root apps/worker --framework-root .
```

Lo script crea `apps/worker/_CONTEXT.md`, `apps/worker/PROGRESS.md` e `apps/worker/.ai-dlc/project/`. Il framework condiviso in `.ai-dlc/` alla radice rimane invariato.

### L'indice dei sottoprogetti

In un monorepo con molti sottoprogetti, tenere traccia di cosa esiste è utile sia per il team sia per l'agente. Il file `.ai-dlc/projects.json` serve a questo:

```json
{
  "projects": [
    {
      "name": "api",
      "path": "apps/api",
      "description": "REST API principale (Node.js/Fastify)",
      "phase": "3-Implementation"
    },
    {
      "name": "worker",
      "path": "apps/worker",
      "description": "Job worker per notifiche e export",
      "phase": "2-Design"
    },
    {
      "name": "dashboard",
      "path": "apps/dashboard",
      "description": "Frontend admin (React)",
      "phase": "3-Implementation"
    }
  ]
}
```

Per aggiornarlo automaticamente dopo aver aggiunto o spostato sottoprogetti:

```bash
bash .ai-dlc/tools/update-projects.sh
```

---

## 15.2 Company extension: processi SDLC aziendali

Molte organizzazioni hanno processi SDLC, standard di sicurezza, gate di governance e checklist di compliance che ogni progetto deve rispettare. Questi processi spesso vivono in documenti Word, PDF, Confluence — luoghi inaccessibili all'agente AI.

La company extension è il meccanismo con cui AI-DLC porta questi processi nel contesto dell'agente.

### La struttura

```
.ai-dlc/
└── company/
    ├── README.md          ← Indice dei documenti
    ├── PROCESS.md         ← SDLC aziendale, fasi, gate
    ├── GOVERNANCE.md      ← Approvazioni, audit trail, compliance
    ├── STANDARDS.md       ← Standard ingegneristici
    ├── source/            ← Documenti originali (PDF, DOCX)
    └── processed/         ← Versioni Markdown generate dal tool
```

L'agente legge i file Markdown in `company/` — non i binari in `source/`. Per convertire i documenti aziendali in Markdown leggibile:

```bash
bash .ai-dlc/tools/preprocess-company-docs.sh
```

```powershell
.\.ai-dlc\tools\preprocess-company-docs.ps1
```

Lo script converte PDF e DOCX da `company/source/` in Markdown in `company/processed/`, mantenendo la struttura del documento originale.

### Un esempio pratico

Supponiamo che TaskFlow API venga adottato da un'azienda con un processo SDLC che include un gate di sicurezza obbligatorio prima di ogni release. Il documento aziendale dice:

> "Ogni release deve includere un Security Review Document firmato dal Security Lead. Il documento deve attestare la verifica dei controlli OWASP Top 10 applicabili."

Il team mette il documento in `company/source/security-review-process.pdf`, esegue il preprocessor, e ottiene `company/processed/security-review-process.md`.

Da quel momento, quando l'agente lavora in Fase 5 (Release), legge automaticamente la company extension e sa che c'è un gate obbligatorio. Propone il documento di security review come parte del checklist di release, non come opzione.

### Priorità: company override framework

Se c'è un conflitto tra le regole del framework AI-DLC e le regole aziendali, vincono quelle aziendali. È un principio esplicito del framework: `.ai-dlc/company/` ha priorità su `.ai-dlc/modules/`.

Questo significa che se l'azienda richiede un confidence tag su ogni singolo output (non solo su HIGH-risk), la regola aziendale sovrascrive quella di AI-DLC che lo richiederebbe solo in certi casi.

### Company extension condivisa vs per-progetto

In un monorepo, la company extension può vivere:
- Alla **radice** (`.ai-dlc/company/`): condivisa tra tutti i sottoprogetti — processi aziendali universali.
- **Per sottoprogetto** (`apps/api/.ai-dlc/company/`): specifica per quel servizio — per esempio, se l'API ha requisiti di compliance diversi dal worker.

L'agente carica prima la company extension del sottoprogetto (se esiste), poi quella della radice. Il sottoprogetto può estendere o fare override della root.

---

## 15.3 Codebase legacy: analisi e documentazione

Uno dei casi d'uso più comuni di AI-DLC nelle organizzazioni è l'analisi di codice legacy: sistemi esistenti senza documentazione, scritti anni fa, con dipendenze obsolete e comportamenti non ovvi.

Il framework copre questo flusso con due moduli in sequenza: prima si analizza (`09_CODEBASE_ANALYSIS.md`), poi si documenta (`10_DOCUMENTATION.md`). L'ordine è importante — documentare senza aver prima capito produce documentazione inventata.

### Step 0 — Prepara il contesto

Prima di iniziare, aggiorna `_CONTEXT.md`:

```markdown
| Phase | 0-Discovery |
| Mode  | STANDARD    |
| Active Task | T-DOC-001 Analisi e documentazione modulo auth legacy |
| Active Task Model Level | 5 |
```

Mode STANDARD (non LITE) perché la documentazione è un output ad alto impatto a lungo termine. Model Level 5 minimo — 6 se la codebase supera i 50.000 LOC.

### Step 1 — Analisi con il modulo 09

```
Carica .ai-dlc/modules/09_CODEBASE_ANALYSIS.md e analizza il modulo
in src/auth/ di questo repository.

Goal: capire l'architettura e i flussi di autenticazione per poterla
documentare e poi refactorare in sicurezza.

Produci in docs/_analysis/:
1) MAP.md     — struttura moduli, dipendenze, entry point
2) RISKS.md   — rischi tecnici (sicurezza, performance, debito)
3) HOTSPOTS.md — 10 file più critici con motivazione
4) RUN.md     — come eseguire, testare, debuggare

Non inventare: se ti mancano informazioni, elenca domande e assunzioni
con tag ASSUMPTION + TODO.
```

L'agente fa quattro pass:

1. **Entry point e runtime path**: dove inizia il flusso di autenticazione, com'è configurato, quali environment esistono.
2. **Architecture snapshot**: pattern usato (layered? hexagonal?), domini, data store, integrazioni esterne.
3. **Dependency & risk scan**: dove viene fatto l'AuthN/AuthZ, gestione degli errori, rischi di PII nei log, performance.
4. **Change map**: quali file toccare per modificare il flusso, quali test esistono, quali test mancano.

L'output sono quattro file in `docs/_analysis/`. **Revisionali prima di procedere.** Le domande e le ASSUMPTION dell'agente sono il segnale più importante: indicano dove la codebase è oscura o dove l'agente ha dovuto ipotizzare. Rispondi a quelle domande prima di passare allo Step 2.

### Step 2 — Documentazione con il modulo 10

Quando `MAP.md` è stato approvato:

```
Carica .ai-dlc/modules/10_DOCUMENTATION.md e genera la documentazione
del modulo src/auth/ usando docs/_analysis/ come fonte.

Produci in docs/auth/:
- 00_OVERVIEW.md     (panoramica e contesto)
- 01_ARCHITECTURE.md (con diagrammi Mermaid)
- 02_API.md          (endpoint e contratti)
- 03_DATA_MODEL.md   (strutture dati e DB)
- 04_SECURITY.md     (vincoli SEC applicati)
- 05_RUNBOOK.md      (operazioni comuni, debug, incident)

Anti-noise rules:
- 1 pagina per concetto, max 2
- Ogni sezione: scopo + posizione nel codice + come verificare
- Se non verificabile: ASSUMPTION + TODO
- No duplicazione tra file

Concludi con un report di validazione.
```

### Step 3 — Verifica

Per ogni file generato, apri il codice citato e verifica:
- Gli endpoint API esistono davvero
- Le entità nel data model corrispondono allo schema reale
- I diagrammi Mermaid renderizzano
- Ogni TODO e ASSUMPTION è giustificato o va risolto

### Step 4 — Committa e aggiorna PROGRESS.md

```markdown
## 2026-07-10 — T-DOC-001 Analisi auth legacy

- Analizzato src/auth/ (8 file, ~2.400 LOC)
- Prodotti docs/_analysis/{MAP,RISKS,HOTSPOTS,RUN}.md
- Prodotti docs/auth/00..05_*.md
- 5 ASSUMPTION da risolvere (vedi RISKS.md)
- Coverage stimata: ~85% del codice documentato
- Trovato: il middleware verifica il token ma non controlla l'audience — SEC-02 violato
```

Nota l'ultimo punto: l'analisi ha trovato un problema reale di sicurezza che non era documentato. Questo è uno dei valori non ovvi dell'analisi strutturata — non produce solo documentazione, ma surfacing di problemi latenti.

### Cosa non fare

**Non saltare l'analisi.** Documentare direttamente senza MAP.md produce documentazione inventata — l'agente deduce il comportamento dal nome delle funzioni invece di verificarlo. Dopo tre mesi, quella documentazione è un ostacolo, non un aiuto.

**Non usare Mode LITE o RAPID.** La documentazione è output ad alto impatto: gli errori si propagano nel tempo e nel team.

**Non lasciare ASSUMPTION senza scadenza.** Ogni `ASSUMPTION + TODO` deve avere una data: `<!-- TODO: verify by 2026-07-20 -->`. Altrimenti resta lì per anni.

---

## Riepilogo

- **Monorepo:** ogni sottoprogetto ha il proprio `_CONTEXT.md`. L'agente usa quello più vicino al file su cui lavora. Lo scaffold per nuovi sottoprogetti è `init.ps1/sh --project-root`. `.ai-dlc/projects.json` mantiene l'indice aggiornato con `update-projects`.

- **Company extension:** `.ai-dlc/company/` porta i processi SDLC aziendali nel contesto dell'agente. I documenti binari vengono preprocessati in Markdown con `preprocess-company-docs`. Le regole aziendali hanno priorità sul framework. Può essere condivisa (root) o per-progetto.

- **Codebase legacy:** il flusso è sempre analisi (`09_CODEBASE_ANALYSIS`) → documentazione (`10_DOCUMENTATION`). Non invertire l'ordine. Mode STANDARD, livello 5 minimo. Le ASSUMPTION dell'agente rivelano dove la codebase è oscura — sono il materiale di lavoro più prezioso dell'analisi.

Nel capitolo finale chiudiamo il ciclo con CI/CD, troubleshooting e come mantenere il framework aggiornato nel tempo.
