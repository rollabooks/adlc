# Capitolo 14 — Multi-agente: Claude, Copilot, Codex, Gemini

La maggior parte degli sviluppatori usa un agente AI alla volta. Apri Claude Code per un task, chiudi, apri Copilot per un altro. O magari usi sempre lo stesso agente per tutto.

AI-DLC è progettato per funzionare diversamente: più agenti, simultaneamente o in sequenza, sullo stesso progetto, con lo stesso `_CONTEXT.md` come fonte di verità. Ognuno legge le regole dal file di startup specifico per la sua piattaforma, ma le regole sostanziali sono le stesse.

In questo capitolo vediamo come funziona questa architettura e perché, in pratica, la combinazione di più agenti può essere più efficace di uno solo.

---

## 14.1 Uno stesso progetto, più entry point

Ogni agente AI ha il suo file di startup nella radice del repository. AI-DLC li fornisce tutti:

| Agente | File di startup | Note |
|---|---|---|
| **Claude Code** | `CLAUDE.md` | Importa `AGENTS.md` con `@AGENTS.md` |
| **OpenAI Codex CLI** | `AGENTS.md` | Entry point principale |
| **Google Gemini** | `GEMINI.md` | Importa e delega ad `AGENTS.md` |
| **OpenClaw** | `OPENCLAW.md` | Importa e delega ad `AGENTS.md` |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Caricato automaticamente dall'IDE, non può importare |
| **Visual Studio 2026** | `VISUALSTUDIO.md` | Importa `AGENTS.md`; regola DOC-01 per il progetto documentazione |

La struttura è a stella: `AGENTS.md` è il centro, gli altri file orbitano intorno. Il contenuto sostanziale del protocollo — le regole di rischio, i confidence tag, gli HALT trigger, il bootstrap — vive in `AGENTS.md`. Gli altri file lo importano o ne adottano i principi.

![Architettura multi-agente a stella: AGENTS.md al centro, _CONTEXT.md come fonte di verità condivisa](figures/it/ch14-stella-multiagente.png)

**Copilot è l'eccezione:** non può importare file esterni, quindi `.github/copilot-instructions.md` contiene una versione adattata delle stesse regole. Il tool `sync-copilot` (lo vedremo tra poco) serve proprio a mantenere l'allineamento.

---

## 14.2 La regola d'oro del multi-agente

**Modifica solo `AGENTS.md`.** Non modificare `CLAUDE.md`, `GEMINI.md`, `OPENCLAW.md` per aggiungere regole — aggiornali solo se hai bisogno di comportamenti specifici per quel singolo agente. Tieni le regole comuni in `AGENTS.md`.

Perché? Perché in un sistema multi-agente, le divergenze tra i file di startup diventano rapidamente ingestibili. Aggiungi una regola in `CLAUDE.md`, dimentichi di aggiungerla in `GEMINI.md`, e i due agenti iniziano a comportarsi diversamente sullo stesso progetto. La regola d'oro previene questo.

---

## 14.3 Un workflow multi-agente concreto su TaskFlow API

Lorenzo, Giulia e Marco lavorano su TaskFlow API. Ognuno ha il suo agente preferito:

- **Lorenzo** usa Claude Code in terminale per il lavoro di design e architettura
- **Giulia** usa GitHub Copilot in VS Code per lo sviluppo quotidiano degli endpoint
- **Marco** usa Claude Code per code review e debugging, Codex CLI per script di automazione

Il file `_CONTEXT.md` è condiviso in git. Ogni mattina, quando Lorenzo fa il bootstrap:

> "Carica `_CONTEXT.md` e confermami il contesto."

Claude Code legge lo stesso file che Giulia ha aggiornato ieri sera con la voce di PROGRESS.md. Il contesto è allineato anche se i due non si sono parlati.

Quando Giulia apre VS Code, Copilot carica automaticamente `.github/copilot-instructions.md` e `_CONTEXT.md`. Sa che il progetto è in Fase 3-Implementation, che i vincoli SEC-01..05 sono attivi, che si sta lavorando su T-009. Stessa fonte di verità, agente diverso.

---

## 14.4 Dividere il lavoro tra agenti

Il fatto che più agenti leggano le stesse regole permette di dividersi il lavoro in base ai punti di forza di ciascun agente — senza perdere la coerenza.

**Scenario tipico su TaskFlow API:**

Lorenzo apre una sessione di design con Claude Code:

> "Carica `SKILL_API_DESIGN.md` e progetta il sistema di webhook per notifiche esterne."

Claude produce la specifica API, il data model, i vincoli di sicurezza rilevanti (SEC-09 per SSRF, SEC-02 per l'autenticazione del webhook). Lorenzo approva il design, aggiorna `_CONTEXT.md` con la decisione e commita.

Giulia apre VS Code lo stesso pomeriggio. Copilot ha già letto `_CONTEXT.md` aggiornato. Quando Giulia inizia a implementare il webhook, i suggerimenti di Copilot sono già allineati con il design di Lorenzo — stessa struttura dati, stessi pattern di validazione, stessa gestione degli errori.

Marco, il giorno dopo, fa code review con Claude Code:

> "Leggi il PR #47 e fai @security-check sull'implementazione dei webhook."

Claude legge il codice e verifica contro SEC-09 (validazione URL webhook, blocco IP privati) e SEC-02 (autenticazione delle chiamate webhook). Trova che la validazione dell'URL non blocca i redirect — aggiunge un finding.

Tre agenti, tre sviluppatori, stesso progetto, stesso contesto. Nessun briefing manuale tra una sessione e l'altra.

---

## 14.5 Mantenere Copilot allineato con `sync-copilot`

Copilot è il caso speciale: non può importare `AGENTS.md` automaticamente, quindi il suo file di istruzioni deve essere mantenuto manualmente allineato.

Il tool `sync-copilot` verifica che `.github/copilot-instructions.md` sia concettualmente allineato con `AGENTS.md` — non che sia identico (i due hanno strutture diverse), ma che non manchi nessun concetto chiave.

```bash
bash .ai-dlc/tools/sync-copilot.sh
```

```powershell
.\.ai-dlc\tools\sync-copilot.ps1
```

Output tipico:

```
sync-copilot — AI-DLC v4.0.0

Checking alignment: AGENTS.md ↔ .github/copilot-instructions.md

✅ Risk classification: present in both
✅ HALT trigger reference: present in both
✅ SEC/PERF constraints: present in both
✅ Confidence tags: present in both
⚠  @alternatives command: present in AGENTS.md, missing in copilot-instructions.md
⚠  @rollback command: present in AGENTS.md, missing in copilot-instructions.md

2 warnings. Consider adding missing commands to copilot-instructions.md.
```

I warning non bloccano il lavoro — Copilot funziona comunque. Ma segnalano che Giulia non può usare `@alternatives` in Copilot perché non è definito nel suo file di istruzioni. Lorenzo aggiorna il file per includerlo.

Quando eseguire `sync-copilot`:
- Dopo ogni modifica a `AGENTS.md`
- Prima di aggiungere un nuovo membro al team che usa Copilot
- Come step nella pipeline CI (opzionale ma consigliato)

---

## 14.6 Regole di priorità tra file di startup

Se ci sono conflitti tra le regole di `AGENTS.md` e quelle di `.github/copilot-instructions.md`, quale prevale?

Per Copilot: prevale `.github/copilot-instructions.md`. È il suo file di startup diretto.

Per Claude Code: `CLAUDE.md` può contenere override di `AGENTS.md`. Le regole specifiche per Claude (`CLAUDE.md`) si sovrappongono a quelle generali (`AGENTS.md`).

In pratica, gli override specifici per agente dovrebbero essere minimi e giustificati. Se trovi che stai scrivendo molto in `CLAUDE.md` che non è in `AGENTS.md`, probabilmente quella regola appartiene al file comune.

---

## 14.7 Il limite del multi-agente

Il multi-agente funziona bene per il lavoro asincrono e per la divisione di ruoli stabili. Ha limiti che vale la pena conoscere.

**Non è collaborazione in tempo reale.** Gli agenti non si parlano tra loro. La coerenza è garantita dal `_CONTEXT.md` condiviso, non da un canale di comunicazione diretto. Se Lorenzo e Giulia lavorano contemporaneamente sullo stesso file, ci sono conflitti git come in qualsiasi lavoro in parallelo — AI-DLC non li risolve.

**La qualità del contesto condiviso determina la qualità del risultato.** Se `_CONTEXT.md` è obsoleto o incompleto, tutti gli agenti lavorano su informazioni sbagliate. La responsabilità di mantenere il context aggiornato è del team, non degli agenti.

**Non tutti gli agenti sono equivalenti.** Claude Code e Copilot hanno capacità diverse. Alcuni task (analisi di architettura complessa, ragionamento multi-step) funzionano meglio con modelli di livello 6-7. Altri (completion di codice nel flusso di scrittura) sono il terreno naturale di Copilot. Usare lo strumento giusto per il task giusto è ancora responsabilità tua.

---

## 14.8 Visual Studio 2026 e la regola DOC-01

La versione 4.0.0 introduce `VISUALSTUDIO.md`, il file di startup per Visual Studio 2026 con la sua integrazione di GitHub Copilot. Funziona come `CLAUDE.md` — importa `AGENTS.md` con `@AGENTS.md` e aggiunge solo le specificità dell'ambiente Visual Studio.

La differenza principale rispetto a VS Code è che Visual Studio lavora con **solution e project** (`.sln` e `.csproj`). Questo richiede una convenzione aggiuntiva su dove vivono i file di documentazione.

### La regola DOC-01

In un workspace Visual Studio, AI-DLC impone una regola chiamata **DOC-01**:

> Ogni progetto deve avere la propria documentazione in `projects\<ProjectName>\` (nella radice del repository). Nessun file di documentazione va nelle cartelle del codice sorgente.

In pratica, la solution include un progetto condiviso `AI-DLC.Documentation`: il file `AI-DLC.Documentation.csproj` sta nella radice del repository e raccoglie le cartelle di documentazione, anch'esse in radice:

```
.                          ← radice del repository
├── AI-DLC.Documentation.csproj
├── docs\
│   └── _solution\         ← documentazione a livello di solution
└── projects\
    ├── MyApi\
    │   ├── _CONTEXT.md
    │   ├── PROGRESS.md
    │   └── instructions.md
    ├── MyWorker\
    │   ├── _CONTEXT.md
    │   ├── PROGRESS.md
    │   └── instructions.md
    └── shared\            ← documentazione cross-progetto
```

La priorità dei file rimane quella standard AI-DLC, ma adattata al contesto Visual Studio:

1. `projects\<Project>\_CONTEXT.md` — stato del progetto
2. `projects\<Project>\instructions.md` — regole del progetto
3. `.ai-dlc\company\` — processi aziendali
4. `.ai-dlc\modules\` — framework (read-only)

### Quando si usa

`VISUALSTUDIO.md` si carica automaticamente quando si lavora in Visual Studio 2026 con l'integrazione Copilot. La `SKILL_VISUALSTUDIO.md` va caricata esplicitamente quando si lavora su struttura della solution, riferimenti `.csproj`, o organizzazione della documentazione.

Non è necessario usare `VISUALSTUDIO.md` se il tuo progetto non ha una solution Visual Studio — è completamente opzionale. Se usi VS Code con Copilot, il file di riferimento rimane `.github/copilot-instructions.md`.

---

## Riepilogo

- AI-DLC fornisce file di startup per ogni agente principale: `AGENTS.md` (Codex), `CLAUDE.md`, `GEMINI.md`, `OPENCLAW.md`, `VISUALSTUDIO.md` (Visual Studio 2026), `.github/copilot-instructions.md` (Copilot).
- La regola d'oro: modifica solo `AGENTS.md` per le regole comuni. Gli altri file sono wrapper o eccezioni.
- Il `_CONTEXT.md` condiviso in git è il meccanismo di coerenza: tutti gli agenti leggono lo stesso stato del progetto.
- `sync-copilot` verifica l'allineamento di Copilot con `AGENTS.md` — eseguilo dopo ogni modifica alle regole comuni.
- Visual Studio 2026 introduce la regola DOC-01: documentazione separata dal codice in un progetto `AI-DLC.Documentation` condiviso.
- Il multi-agente funziona bene per lavoro asincrono e ruoli distinti; non risolve i conflitti di edit concorrenti.

Nel prossimo capitolo affrontiamo gli scenari più complessi: monorepo con più sottoprogetti, estensione aziendale con processi SDLC aziendali, e analisi di codebase legacy.
