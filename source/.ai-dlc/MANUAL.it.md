# AI-DLC — Manuale d'uso (italiano)

> Versione framework: 3.3.0
> Pubblico: sviluppatori che vogliono usare AI-DLC per orchestrare uno o più agenti AI in un progetto software, anche senza esperienza precedente con sistemi simili.

---

## Indice

1. [Cos'è AI-DLC e perché esiste](#1-cosè-adlc-e-perché-esiste)
2. [Quando usarlo (e quando no)](#2-quando-usarlo-e-quando-no)
3. [Prerequisiti di conoscenza](#3-prerequisiti-di-conoscenza)
4. [I concetti fondamentali](#4-i-concetti-fondamentali)
5. [Setup del primo progetto](#5-setup-del-primo-progetto)
6. [Workflow tipico di una sessione](#6-workflow-tipico-di-una-sessione)
7. [I tool del framework](#7-i-tool-del-framework)
8. [Generare documentazione dal codice legacy](#8-generare-documentazione-dal-codice-legacy)
9. [Lavorare con più agenti](#9-lavorare-con-più-agenti)
10. [Monorepo](#10-monorepo)
11. [Estensione aziendale (company)](#11-estensione-aziendale-company)
12. [Errori comuni e risoluzione problemi](#12-errori-comuni-e-risoluzione-problemi)
13. [Glossario rapido](#13-glossario-rapido)

---

## 1. Cos'è AI-DLC e perché esiste

**AI-DLC** sta per *AI-Driven Development Life Cycle*. È un framework leggero, fatto di file Markdown e JSON, che mette ordine tra te e gli agenti AI con cui lavori (Claude Code, Copilot, Codex, Gemini, OpenClaw, ecc.).

Risolve quattro problemi quotidiani:

| Problema | Soluzione AI-DLC |
|----------|----------------|
| L'AI dimentica il contesto tra una sessione e l'altra | `_CONTEXT.md`, un file di stato persistente che l'agente rilegge a ogni sessione |
| L'AI ignora o dimentica requisiti di sicurezza e performance | Vincoli `SEC-XX` e `PERF-XX` sempre visibili nel context |
| L'AI inventa o tira a indovinare | Tag di confidenza (`FACT` / `INFERRED` / `ASSUMPTION`) su output critici |
| L'AI carica troppe regole insieme | Moduli caricati solo quando servono (per fase di progetto) |

**Cosa NON è AI-DLC:**
- Non è un'AI: non genera codice da solo. È un contratto operativo che gli agenti seguono.
- Non è un tool da installare: non c'è un eseguibile. Sono file di testo in una cartella.
- Non è specifico per un linguaggio o stack: vale per qualunque tecnologia.

---

## 2. Quando usarlo (e quando no)

**Usalo quando:**
- Lavori a un progetto reale (non spike di 30 minuti) con un agente AI.
- Ti serve continuità tra sessioni o tra team member.
- Il progetto ha vincoli di sicurezza, performance o compliance.
- Vuoi usare più agenti AI senza dover ripetere le stesse regole.
- Lavori in team e vuoi che l'agente segua convenzioni condivise.

**Non serve quando:**
- Stai facendo un esperimento di 1 ora.
- Stai chiedendo a un agente di rispondere a una domanda diretta.
- Il progetto è già governato da un framework agente più stringente.

**Costo di adozione:** ~15 minuti per uno scaffold iniziale, poi 1-2 minuti a sessione per aggiornare `_CONTEXT.md`.

---

## 3. Prerequisiti di conoscenza

### Indispensabili
- **Riga di comando**: saper aprire un terminale (PowerShell o Bash) e lanciare comandi.
- **Markdown base**: saper leggere e modificare un file `.md` (titoli, tabelle, liste).
- **Git base**: `clone`, `commit`, `push`, branching. (Opzionale per progetti locali, ma consigliato.)

### Utili ma non obbligatori
- **JSON e YAML**: il framework usa entrambi (`manifest.json`, `halt-triggers.yaml`). Saper leggerli aiuta.
- **PowerShell o Bash scripting**: per modificare i tool. Non serve per usarli.
- **Glob patterns**: tipo `**/migrations/**`. Servono per personalizzare gli HALT trigger.
- **JSON Schema**: solo se vuoi modificare gli schemi di validazione.

### Concettuali
- **SDLC** (Software Development Life Cycle): le fasi tipiche di un progetto (Discovery → Design → Implementation → Verification → Release → Ops). AI-DLC le numera 0-6 e ti chiede di sapere in che fase sei.
- **Conventional Commits**: convenzione `feat:`/`fix:`/`refactor:` per i messaggi git. AI-DLC la consiglia ma non la impone.
- **Risk management base**: distinguere "rinominare una variabile" (LOW) da "modificare uno schema database" (HIGH).

**Se sei junior:** parti da mode `LITE` (vedi sezione modes), un solo skill (`SKILL_API_DESIGN.md` o simile), e ignora company extension finché non ti serve. Il framework si adatta al tuo livello.

---

## 4. I concetti fondamentali

### 4.1 `_CONTEXT.md` — la memoria del progetto

È il cuore di AI-DLC. Un singolo file Markdown alla radice del progetto che dice all'agente:
- **dove sei** (fase del progetto, task attivo, branch)
- **cosa devi rispettare** (stack tecnologico, vincoli SEC e PERF)
- **come comportarti** (mode: LITE/STANDARD/AUDIT/RAPID/FAST)

L'agente lo legge a ogni sessione. Se cambi fase o vincoli, lo aggiorni.

**Esempio minimo:**

```markdown
| Param | Value |
|-------|-------|
| Phase | 3-Impl |
| Mode | LITE |
| Active Task | T-001.2 Implement profile read endpoint |
| Active Task Model Level | 5 |

### Security
| SEC-02 | Authentication | OIDC access tokens |
| SEC-03 | Authorization | RBAC per resource owner |
```

Vai con `.ai-dlc/modules/templates/CONTEXT_TEMPLATE.md` per la versione completa, `CONTEXT_MIN.md` per spike/POC.

### 4.2 `PROGRESS.md` — il diario di bordo

Compagno di `_CONTEXT.md`. Mentre il context fotografa lo stato corrente, `PROGRESS.md` registra cosa è successo nelle sessioni precedenti: lavoro completato, decisioni prese, lezioni imparate. Cresce nel tempo, non si sovrascrive.

### 4.3 Phases — le 7 fasi di progetto

| Fase | Nome | Quando ci sei |
|------|------|---------------|
| 0 | Discovery | Capire il problema, raccogliere requisiti |
| 1 | Analysis | Analizzare requisiti, scegliere approccio macro |
| 2 | Design | Architettura, API contract, schema DB |
| 3 | Implementation | Codice, test |
| 4 | Verification | QA, integration testing |
| 5 | Release | Deploy, documentazione finale |
| 6 | Ops | Monitoraggio, incident response, manutenzione |

L'agente carica moduli e skill diversi a seconda della fase (vedi 4.5).

### 4.4 Modes — quanta cerimonia vuoi

| Mode | Quando usarlo |
|------|----------------|
| `LITE` | Lavoro quotidiano LOW/MEDIUM in progetto stabile (consigliato di default) |
| `STANDARD` | Default storico, applica tutte le CORE RULES |
| `AUDIT` | Per change con tracciabilità completa (compliance, sicurezza) |
| `RAPID` | Spike, POC, emergenze (timeboxed) |
| `FAST` | Hai bisogno di velocità su task semplici |

Cambia il `Mode:` in `_CONTEXT.md` per scalare l'overhead.

### 4.5 Modules e Skills — caricamento per fase

I **moduli** (`.ai-dlc/modules/00_MODE.md`, `01_CORE_RULES.md`, ecc.) sono il framework. Read-only. Si caricano solo quando servono per la fase corrente.

Le **skill** (`SKILL_API_DESIGN.md`, `SKILL_SECURITY.md`, ecc.) sono guide tematiche. Caricale una alla volta a seconda del tipo di task.

**Esempio:** se sei in Phase 3 e stai progettando endpoint REST, l'agente carica `04_IMPLEMENTATION.md` + `SKILL_API_DESIGN.md`. Non carica il modulo Ops né lo skill Testing.

### 4.6 SEC e PERF constraints — la guardia

`SEC_CONSTRAINTS.md` definisce 9 vincoli di sicurezza riusabili (SEC-01 Input Validation, SEC-02 Authentication, ...). `PERF_CONSTRAINTS.md` definisce 7 vincoli di performance.

In `_CONTEXT.md` elenchi solo quelli attivi nel tuo progetto. L'agente li rilegge prima di generare codice.

**Esempio:**
```markdown
| SEC-02 | Authentication | OIDC, JWT con refresh |
| PERF-01 | Latency Targets | P95 < 250ms |
```

### 4.7 HALT trigger — quando l'agente deve fermarsi

`.ai-dlc/halt-triggers.yaml` definisce pattern di file che richiedono **conferma esplicita** prima di essere modificati: schema DB, codice di autenticazione, secrets, infrastruttura, CI/CD, framework files.

L'agente quando tocca uno di questi path si ferma e ti chiede prima di procedere. Puoi sovrascrivere il default mettendo `.ai-dlc/project/halt-triggers.yaml` nel tuo progetto.

### 4.8 Risk classification — non tutti i task sono uguali

| Risk | Esempi | Cosa fa l'agente |
|------|--------|------------------|
| LOW | Rinomina, typo, format | Esegue e notifica |
| MEDIUM | Nuova feature, refactor | Propone un piano e aspetta ok |
| HIGH | Schema, auth, architettura | Piano dettagliato + conferma esplicita |
| HIGH+ | Secrets, compliance, produzione | HALT prima di pianificare |
| CRITICAL | Decisioni mission-critical ambigue | HALT + alternative + decision record |

Il livello di rischio determina anche il **minimum model level** richiesto (vedi 4.10).

### 4.9 Confidence tags — l'AI ammette quando non è sicura

Per output ad alto impatto (HIGH-risk, claim su SEC/PERF, codice in zone HALT) l'agente chiude con:

```markdown
---
AI CONFIDENCE: FACT | INFERRED | ASSUMPTION
Basis: [perché lo afferma — file, test, fonte]
```

| Tag | Significato | Azione |
|-----|-------------|--------|
| FACT | Verificabile dall'input | Si può usare |
| INFERRED | Deduzione logica | Da revisionare |
| ASSUMPTION | Ipotesi non verificata | STOP e chiedi |

In mode `LITE` i tag servono solo per output critici (così non diventano rumore).

### 4.10 Model levels — quale AI per quale task

Ogni task creato in AI-DLC include una **AI Sizing**: stima token, model level 1-7, modello consigliato.

| Level | Token range | A cosa serve |
|-------|-------------|--------------|
| 1 | < 4k | Piccoli edit, docs, formattazione |
| 2 | 4k-8k | Modifiche localizzate, test semplici |
| 3 | 8k-16k | Implementazione standard, debugging mirato |
| 4 | 16k-32k | Feature multi-file, design moderato |
| 5 | 32k-64k | Refactor complessi, integrazioni, sicurezza |
| 6 | 64k-120k | Architettura, debugging profondo |
| 7 | > 120k | Mission-critical, alta ambiguità |

Il mapping vendor (Anthropic/OpenAI/Gemini) per ogni livello vive in `.ai-dlc/manifest.json#model_levels`. Per stamparlo:

```powershell
.\.ai-dlc\tools\show-models.ps1
```

```bash
bash .ai-dlc/tools/show-models.sh
```

**Risk floor:** alcuni rischi forzano un livello minimo. Auth/secrets/produzione → minimo livello 6. Anche se la stima token suggerisce livello 3.

### 4.11 Comandi conversazionali

Sono "comandi" che digiti nella chat con l'agente. Non sono shell command. Esempi:

| Comando | Cosa fa |
|---------|---------|
| `@checkpoint` | L'agente salva lo stato corrente e propone aggiornamenti |
| `@show-constraints` | Stampa i vincoli SEC/PERF attivi |
| `@security-check` | Verifica codice/piano contro i SEC |
| `@stop` | Ferma immediatamente |
| `@alternatives` | Propone 2-3 opzioni alternative |
| `@simplify` | Riduce scope/complessità |

Lista completa: `.ai-dlc/COMMANDS.md`.

---

## 5. Setup del primo progetto

### 5.1 Scenario: aggiungere AI-DLC a un repo esistente

**Passo 1 — copia il framework**

Se non hai i file AI-DLC nel repo, copiali da una sorgente esistente (questo repo o template):

```text
AGENTS.md
CLAUDE.md
GEMINI.md
OPENCLAW.md
.github/copilot-instructions.md
.ai-dlc/
```

**Passo 2 — scaffold dello stato di progetto**

```powershell
.\.ai-dlc\tools\init.ps1
```

```bash
bash .ai-dlc/tools/init.sh
```

Per progetti piccoli o spike usa `--context minimal`. Crea: `_CONTEXT.md`, `PROGRESS.md`, `.ai-dlc/project/instructions.md`, cartella `.ai-dlc/project/skills/`.

**Passo 3 — compila `_CONTEXT.md`**

Apri il file. Per ogni riga con `[placeholder]` metti il valore reale:
- `Phase` → in che fase sei (es. `3-Impl`)
- `Mode` → `LITE` se è un progetto stabile, altrimenti `STANDARD`
- `Active Task` → ID e titolo del task corrente
- `Active Task Token Estimate` → es. `12000/2500/14500`
- `Active Task Model Level` → es. `5 Sonnet High`
- `Stack`, `SEC`, `PERF` → quello che si applica al tuo progetto

**Passo 4 — verifica**

```powershell
.\.ai-dlc\tools\validate.ps1
```

```bash
bash .ai-dlc/tools/validate.sh
```

Se vedi `AI-DLC validation passed`, sei pronto. Se ci sono warning su `_CONTEXT.md` non popolato, completa i campi mancanti.

**Passo 5 — primo turno con l'agente**

Apri l'agente (Claude Code, Copilot, Codex…). Chiedi:

> "Carica `_CONTEXT.md` e conferma il contesto: fase, task, stack, vincoli attivi."

L'agente leggerà tutto e ti darà una riga di conferma tipo:
> `Context: <Project> | Phase: 3 | Task: T-001.2 | Stack: Node.js/Fastify | Constraints: SEC-02,SEC-03,PERF-01. Proceed?`

Da qui parte il dialogo.

### 5.2 Scenario: progetto nuovo da zero

Crea cartella, entra nella directory, lancia `init`, poi segui da Passo 3.

---

## 6. Workflow tipico di una sessione

### Inizio sessione
1. Apri l'agente.
2. L'agente legge `_CONTEXT.md` e `PROGRESS.md` (se l'host lo supporta in automatico) o tu lo chiedi.
3. L'agente conferma stato → fase, task, vincoli.
4. Tu dici cosa vuoi fare oggi.

### Durante la sessione
- Per task **LOW** (rinomina, typo): l'agente esegue e notifica.
- Per task **MEDIUM** (nuova feature): l'agente propone un piano, tu approvi.
- Per task **HIGH** (schema, auth): l'agente **HALT**, presenta piano dettagliato, aspetta conferma esplicita.
- Ogni 3-5 azioni significative → `@checkpoint` per fissare un punto fermo.

### Fine sessione
- L'agente propone un blocco aggiornato di `_CONTEXT.md` (se phase/task/stack è cambiato).
- L'agente propone una voce per `PROGRESS.md` con riepilogo.
- Tu confermi o aggiusti, poi committi.

### Cambio fase
Quando passi da Design a Implementation, aggiorni `Phase` in `_CONTEXT.md` e l'agente carica i moduli/skill diversi alla prossima sessione.

---

## 7. I tool del framework

Tutti in `.ai-dlc/tools/`. Funzionano sia in PowerShell (`.ps1`) sia in Bash (`.sh`).

| Tool | A cosa serve |
|------|--------------|
| `init.ps1/sh` | Crea i file di stato per un nuovo progetto |
| `validate.ps1/sh` | Verifica che il repo abbia tutto il framework + check su task/epic/context |
| `validate.ps1/sh --strict` | Come sopra ma fa fallire anche i warning |
| `show-models.ps1/sh` | Stampa il mapping model level → vendor (Anthropic/OpenAI/Gemini) |
| `sync-copilot.ps1/sh` | Verifica che `copilot-instructions.md` sia allineato ai concetti di `AGENTS.md` |
| `preprocess-company-docs.ps1/sh` | Converte PDF/DOCX aziendali in Markdown leggibile per agenti |
| `update-projects.ps1/sh` | In monorepo, aggiorna l'indice dei progetti |

### Esempio: aggiungere un nuovo SEC al progetto
1. Apri `_CONTEXT.md` → aggiungi una riga `| SEC-04 | Secrets & Config | ... |`
2. Lancia `validate` per sanity check
3. Nella prossima sessione l'agente lo rispetterà

---

## 8. Generare documentazione dal codice legacy

Uno dei casi d'uso più comuni di AI-DLC è prendere una codebase esistente senza (o con scarsa) documentazione e produrre una base utile e verificabile. Il framework copre questo flusso con due moduli che vanno usati in sequenza: prima si **analizza**, poi si **documenta**.

### 8.1 Quando serve

- Erediti un progetto legacy senza README significativo.
- Devi onboardare nuovi sviluppatori (umani o agenti AI) su una codebase complessa.
- Stai per fare un refactor importante e ti serve una mappa stabile prima.
- Vuoi un audit di sicurezza/performance documentato.
- Compliance richiede architecture overview, data model, runbook.

### 8.2 I due moduli AI-DLC coinvolti

| Modulo | Fase | Scopo |
|--------|------|-------|
| `.ai-dlc/modules/09_CODEBASE_ANALYSIS.md` | Intake | Capire struttura, dipendenze, hotspot, rischi |
| `.ai-dlc/modules/10_DOCUMENTATION.md` | Output | Produrre Markdown navigabile da template |

L'analisi è un prerequisito: senza una `MAP.md` solida, la documentazione finisce per inventare. AI-DLC è esplicito su questo: se l'agente non può verificare una cosa, deve etichettarla `ASSUMPTION` + `TODO`.

### 8.3 Workflow consigliato (4 step + 1)

**Step 0 — Prepara il contesto**

Crea (o aggiorna) `_CONTEXT.md`. Imposta:
- `Phase`: `0-Discovery` (per analisi) poi `5-Release` (per documentazione)
- `Mode`: `STANDARD` (le decisioni qui hanno impatto a lungo termine, niente `LITE`)
- `Active Task`: es. `T-DOC-001 Document legacy auth module`
- `Active Task Model Level`: minimo `5` (Sonnet High) — `6` se la codebase supera i 50k LOC

**Step 1 — Analisi della codebase (modulo 09)**

Apri l'agente e chiedi (adatta il path e gli obiettivi):

```
Carica .ai-dlc/modules/09_CODEBASE_ANALYSIS.md e analizza questo repository.
Goal: capire architettura, preparare documentazione completa.
Constraints: leggi _CONTEXT.md per SEC/PERF.

Produci in cartella docs/_analysis/:
1) MAP.md  — moduli + dipendenze + entry point
2) RISKS.md — rischi tecnici (sicurezza/performance) + technical debt
3) HOTSPOTS.md — 10 file più critici con motivazione
4) RUN.md — comandi build/test/run
Non inventare: se ti mancano informazioni, elenca domande e assunzioni.
```

L'agente esegue 4 pass:
1. **Entry point & runtime path** — dove parte l'app, come si configura
2. **Architecture snapshot** — pattern, domini, data store, integrazioni
3. **Dependency & risk scan** — auth, logging, error handling, performance
4. **Change map** — primary code path, secondary impact, test da toccare

Output atteso: 4 file in `docs/_analysis/`. Rivedili manualmente. Le domande/assunzioni dell'agente sono il segnale più importante: rispondile prima di passare allo step 2.

**Step 2 — Generazione documentazione (modulo 10)**

Quando `MAP.md` è approvato, chiedi:

```
Carica .ai-dlc/modules/10_DOCUMENTATION.md e genera la documentazione
per [modulo o intero progetto] usando docs/_analysis/ come fonte.

Produci in cartella docs/:
- 00_OVERVIEW.md
- 01_ARCHITECTURE.md (con diagrammi Mermaid)
- 02_API.md
- 03_DATA_MODEL.md
- 04_SECURITY_PERF.md
- 05_RUNBOOK.md
- 99_GLOSSARY.md

Applica le anti-noise rules:
- 1 pagina per concetto (max 2)
- Ogni sezione: scopo + posizione nel codice + come verificare
- Se non verificabile: ASSUMPTION + TODO
- No duplicazione fra file
Concludi con un report di validazione.
```

**Step 3 — Verifica**

Per ogni file generato controlla:
- Gli endpoint API esistono davvero (apri il codice citato)
- Le entità nel data model corrispondono a tabelle/schema reali
- I diagrammi Mermaid renderizzano (apri su GitHub o usa un viewer)
- I `TODO` e `ASSUMPTION` sono giustificati o vanno risolti

**Step 4 — Committa e aggiorna `PROGRESS.md`**

Un'entry tipica:

```markdown
## 2026-05-13 — Legacy documentation pass
- Analizzato modulo auth (12 file, ~3200 LOC)
- Prodotti docs/00..05_*.md
- 7 ASSUMPTION da risolvere (vedi docs/_analysis/RISKS.md)
- Coverage stimata: ~80% del codice mappato
```

**Step 5 (opzionale) — Mantenimento**

La documentazione invecchia. Due opzioni:

- **Manuale**: a ogni PR che tocca un'area documentata, l'agente in mode `STANDARD` propone le righe da aggiornare in `docs/`.
- **Automatico**: aggiungi al CI un job che usa `sync-copilot` come riferimento e che fallisce se un PR cambia file in `src/api/` senza aggiornare `docs/02_API.md` (regex semplice).

### 8.4 Cosa NON fare

- **Non saltare lo step 1**: documentare senza analisi produce contenuti inventati che peggiorano la situazione.
- **Non usare mode `LITE` o `RAPID`**: la documentazione è output ad alto impatto, serve cerimonia piena (confidence tags inclusi).
- **Non lasciare `ASSUMPTION` senza data-prossima-verifica**: marcalo con `<!-- TODO: verify by YYYY-MM-DD -->`.
- **Non auto-generare diagrammi da tool che non capiscono il dominio**: i Mermaid scritti dall'agente leggendo il codice valgono di più dei generatori automatici.
- **Non documentare ciò che `git log` o `README` già spiegano**: AI-DLC privilegia la doc sul **come usare** rispetto alla cronologia.

### 8.5 Template di task

Per tenere traccia del lavoro, crea un task AI-DLC standard. Esempio:

```markdown
# T-DOC-001 — Documentation pass for legacy auth module

## AI Sizing
| Field | Value |
|-------|-------|
| Token Estimate | 40k input / 12k output / 52k total |
| Model Level | 5 |
| Risk Floor Applied | none (documentazione, no codice in prod) |
| Recommended Model | vedi manifest.json#model_levels |
| Rationale | refactor analysis su modulo SEC-sensible |

## Goal
Produrre docs/* completi per modulo auth, partendo da analisi codebase.

## Deliverable
- docs/_analysis/{MAP,RISKS,HOTSPOTS,RUN}.md
- docs/{00..05,99}_*.md
- Report di validazione con elenco ASSUMPTION
```

### 8.6 Quick reference

| Vuoi… | Comando all'agente | Modulo |
|-------|---------------------|--------|
| Solo capire il codice | "Esegui 09 sull'intero repo" | 09 |
| Documentare un modulo specifico | "Esegui 09 su src/auth/, poi 10 limitato ad auth" | 09 + 10 |
| Aggiornare docs dopo un PR | "Confronta diff con docs/, proponi update" | 10 |
| Audit completo | "09 + 10 + cross-check con SEC_CONSTRAINTS.md" | 09 + 10 + SEC |

---

## 9. Lavorare con più agenti

AI-DLC è multi-agente per design. Ogni agente ha un file di startup al root:

| Agente | File startup |
|--------|--------------|
| Claude Code | `CLAUDE.md` (importa `AGENTS.md`) |
| OpenAI Codex CLI | `AGENTS.md` |
| Gemini | `GEMINI.md` (rimanda a `AGENTS.md`) |
| OpenClaw | `OPENCLAW.md` (rimanda a `AGENTS.md`) |
| GitHub Copilot | `.github/copilot-instructions.md` (autonomo) |

**Regola pratica:** modifica solo `AGENTS.md`. Gli altri lo importano o vanno tenuti minimali. Per Copilot (che non può importare) usa `sync-copilot` per verificare l'allineamento.

Puoi usare Claude per il design e Copilot per scrivere codice: leggono lo stesso `_CONTEXT.md`, applicano le stesse regole.

---

## 10. Monorepo

In un monorepo (più app/servizi nella stessa repo) tieni il framework condiviso a livello root e scaffolda ogni sottoprogetto:

```powershell
.\.ai-dlc\tools\init.ps1 -ProjectRoot .\apps\app-a -FrameworkRoot .
```

```bash
bash .ai-dlc/tools/init.sh --project-root apps/app-a --framework-root .
```

Ogni sottoprogetto ha il suo `_CONTEXT.md`, `PROGRESS.md`, `.ai-dlc/project/`. L'agente usa il `_CONTEXT.md` più vicino al file su cui sta lavorando.

Aggiorna l'indice dei sottoprogetti dopo aggiunte/spostamenti:

```bash
bash .ai-dlc/tools/update-projects.sh
```

---

## 11. Estensione aziendale (company)

Se il progetto deve seguire processi SDLC aziendali, governance, compliance, standard interni, crea `.ai-dlc/company/`. L'agente lo carica automaticamente.

Struttura tipica:

```text
.ai-dlc/company/
├── README.md         (indice)
├── PROCESS.md        (SDLC interna)
├── GOVERNANCE.md     (approvazioni, audit, compliance)
├── STANDARDS.md      (standard ingegneristici)
├── source/           (PDF/DOCX originali)
└── processed/        (versione Markdown generata)
```

Per PDF/DOCX: metti in `source/`, poi:

```bash
bash .ai-dlc/tools/preprocess-company-docs.sh
```

L'agente leggerà `processed/`, non i binari.

---

## 12. Errori comuni e risoluzione problemi

### "L'agente non rispetta i vincoli SEC"
Probabile causa: `_CONTEXT.md` non li ha popolati o l'agente non ha letto il file all'inizio della sessione. Verifica con `@show-constraints`.

### "L'agente continua a chiedere conferma anche per task LOW"
Sei probabilmente in mode `STANDARD` o `AUDIT`. Passa a mode `LITE` se il progetto è stabile.

### "L'agente ha fatto modifiche che non doveva fare"
Controlla `.ai-dlc/halt-triggers.yaml`: il path interessato è coperto? Se no, aggiungilo come override in `.ai-dlc/project/halt-triggers.yaml`.

### "Il validator fallisce su un task"
Apri il task `T-NNN.N.md`. Controlla che `| Model Level |` e `| Risk Floor Applied |` non contengano placeholder tipo `[1-7]`. Riempi con valori reali.

### "Validator fallisce su un epic"
L'epic deve avere `## Risk and Model Floor` e `## Task Breakdown`. Usa `.ai-dlc/modules/templates/EPIC_TEMPLATE.md` come riferimento.

### "Warning su `_CONTEXT.md` non popolato"
È solo un warning di default — passa quando popoli i campi `Active Task`, `Active Task Token Estimate`, `Active Task Model Level`. In CI puoi forzare il fallimento con `--strict`.

### "Voglio modificare `.ai-dlc/modules/...`"
Non farlo. I moduli sono read-only durante l'uso normale. Per personalizzazioni metti regole in `.ai-dlc/project/instructions.md` o skill in `.ai-dlc/project/skills/`.

### "L'agente carica troppe cose"
Stai forse in mode `STANDARD` o `AUDIT` su un task LOW. Cambia mode a `LITE` o `FAST`.

### "Voglio bypassare un HALT"
Non scavalcare. Cambia il path interessato in `.ai-dlc/project/halt-triggers.yaml` (rimuovi quel pattern dal trigger) o accetta che il path richiede conferma — è lì per buoni motivi.

---

## 13. Glossario rapido

- **AI-DLC**: AI-Driven Development Life Cycle. Questo framework.
- **AI Sizing**: stima token + model level + modello consigliato per un task.
- **Bootstrap**: sequenza che l'agente esegue a inizio sessione (legge `_CONTEXT.md`, carica skill, ecc.).
- **Checkpoint**: punto fermo dopo 3-5 azioni significative, in cui si fissa lo stato.
- **Company extension**: cartella `.ai-dlc/company/` con regole aziendali aggiuntive.
- **Confidence tag**: `FACT` / `INFERRED` / `ASSUMPTION`, l'autovalutazione di affidabilità dell'AI.
- **Conversational command**: `@checkpoint`, `@stop`, ecc. Comandi conversazionali per l'agente.
- **HALT trigger**: pattern di path che obbliga l'agente a chiedere conferma prima di modificare.
- **Mode**: livello di cerimonia. `LITE`/`STANDARD`/`AUDIT`/`RAPID`/`FAST`.
- **Model level**: 1-7, livello di "potenza AI" richiesto per un task.
- **Module**: file `.ai-dlc/modules/NN_*.md`, regola framework caricata per fase.
- **PERF-XX**: vincolo di performance riusabile (es. PERF-01 latency).
- **Phase**: 0-6, in che punto del ciclo di sviluppo sei.
- **Risk floor**: livello model minimo forzato da certi rischi (es. auth → minimo 6).
- **SEC-XX**: vincolo di sicurezza riusabile (es. SEC-02 authentication).
- **Skill**: file `.ai-dlc/modules/skills/SKILL_*.md`, guida tematica caricata su richiesta.
- **Strict mode (validator)**: i warning diventano failure. Si usa in CI.

---

## Per saperne di più

- `README.md` — quick-start
- `.ai-dlc/INSTALL.md` — checklist setup
- `.ai-dlc/COMMANDS.md` — comandi conversazionali completi
- `.ai-dlc/modules/01_CORE_RULES.md` — regole base dettagliate
- `.ai-dlc/modules/SEC_CONSTRAINTS.md`, `PERF_CONSTRAINTS.md` — librerie di vincoli
- `.ai-dlc/examples/` — esempi compilati di context, epic, task, progress
- `.ai-dlc/VERSIONING.md` — policy di versioning
- `CHANGELOG.md` — storico modifiche

Per dubbi: parti sempre da `_CONTEXT.md`. È la verità del progetto.
