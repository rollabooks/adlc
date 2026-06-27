# Proposta di Indice — "ADLC: Orchestrare Agenti AI"

> Fase 2 — Pianificazione  
> Data: 2026-06-27  
> Stato: proposta iniziale, in attesa di approvazione

---

## Titolo

**"ADLC — Orchestrare Agenti AI nello Sviluppo Software"**  
*Guida pratica al ciclo di vita AI-Driven per team e sviluppatori singoli*

---

## Scheda editoriale

| Campo | Valore |
|---|---|
| Lingua principale | Italiano (traduzione EN opzionale in Fase 8) |
| Pubblico target | Sviluppatori che già usano un agente AI (Claude Code, Copilot, Codex, Gemini) e vogliono strutturare il lavoro su progetti reali |
| Livello | Intermedio (non è un'introduzione agli agenti AI — presuppone che il lettore li usi già) |
| Dimensione stimata | 16 capitoli + introduzione + 4 appendici, ~250-300 pagine |
| Sorgente principale | `source/.adlc/MANUAL.it.md` + tutti i moduli in `source/.adlc/modules/` |
| Promessa editoriale | "Smetti di ripetere le stesse istruzioni all'AI a ogni sessione. Impara a costruire un sistema che ricorda, valuta il rischio e sa quando fermarsi." |

---

## Struttura

### Introduzione — Il problema senza nome

Tre storie concrete di lavoro con agenti AI che va storto:
1. L'AI che dimentica il contesto a ogni sessione
2. L'AI che ignora i requisiti di sicurezza già discussi
3. L'AI che "inventa" con la stessa confidenza di quando sa

La soluzione: un contratto operativo tra sviluppatore e agente. Cos'è ADLC e come si legge questo libro.

---

### Parte I — Il Framework

**Capitolo 1 — ADLC: cos'è e perché esiste**
- I quattro problemi quotidiani con gli agenti AI
- Cosa NON è ADLC (non è un tool, non è un'AI, non è stack-specific)
- Quando usarlo e quando non serve
- Prerequisiti: riga di comando, Markdown, Git base

**Capitolo 2 — Setup del primo progetto in 15 minuti**
- Copiare il framework in un repo esistente
- `init.ps1` / `init.sh`: scaffold dello stato di progetto
- Compilare `_CONTEXT.md` la prima volta
- Validare con `validate.ps1` / `validate.sh`
- Primo turno con l'agente: il dialogo di conferma

**Capitolo 3 — Una sessione di lavoro reale**
- Inizio sessione: il bootstrap dell'agente
- Durante la sessione: task LOW, MEDIUM, HIGH in pratica
- Fine sessione: aggiornare `_CONTEXT.md` e `PROGRESS.md`
- Esempio completo dall'apertura del terminale al commit finale

---

### Parte II — La Memoria del Progetto

**Capitolo 4 — `_CONTEXT.md`: la fonte di verità**
- Struttura del file e campi obbligatori vs opzionali
- Cosa mettere in `Phase`, `Mode`, `Active Task`
- Token estimate e Model Level: perché sono lì
- Vincoli SEC e PERF inline
- Template minimo (spike/POC) vs template completo
- Errori comuni nella compilazione

**Capitolo 5 — `PROGRESS.md`: il diario di bordo**
- La differenza tra context (stato corrente) e progress (storia)
- Quando aggiornare e cosa scrivere
- Come il progress accelera il bootstrap nella sessione successiva
- Esempio di una settimana di lavoro in PROGRESS.md

**Capitolo 6 — Fasi (0-6) e Modes**
- Le 7 fasi del ciclo AI-Driven: Discovery → Ops
- Cosa cambia all'agente al cambio di fase
- I cinque Modes: LITE, STANDARD, AUDIT, RAPID, FAST
- Quando usare ciascuno: regola pratica
- Come cambiare Mode senza rompere il flusso

---

### Parte III — Il Sistema di Sicurezza

**Capitolo 7 — Classificazione del rischio**
- I cinque livelli: LOW, MEDIUM, HIGH, HIGH+, CRITICAL
- Esempi concreti per ogni livello
- Cosa fa l'agente a ogni livello (esegue, propone, halt)
- La regola del "piano prima di agire"

**Capitolo 8 — Model Levels: quale AI per quale task**
- Perché non tutti i task richiedono il modello più potente
- I sette livelli (1-7) e i range di token
- Mapping vendor: Anthropic, OpenAI, Gemini
- Risk floor: livelli minimi forzati (auth, compliance, architettura)
- `show-models.ps1` / `show-models.sh` in pratica

**Capitolo 9 — Confidence Tags: FACT, INFERRED, ASSUMPTION**
- Il problema dell'AI che non segnala l'incertezza
- I tre tag e il loro significato operativo
- Quando sono obbligatori e quando opzionali (mode LITE)
- Come rispondere a un ASSUMPTION: escalare o accettare il rischio
- Esempi reali di output con confidence tags

**Capitolo 10 — HALT Triggers: il freno di emergenza**
- Cosa sono e come funzionano
- Il file `halt-triggers.yaml` e la sua struttura
- Pattern predefiniti: schema DB, auth, secrets, CI/CD, infra
- Override di progetto in `.adlc/project/halt-triggers.yaml`
- Come aggiungere pattern personalizzati
- Cosa NON fare (bypassare un HALT)

**Capitolo 11 — Vincoli SEC e PERF**
- `SEC_CONSTRAINTS.md`: i nove vincoli di sicurezza (SEC-01..SEC-09)
- `PERF_CONSTRAINTS.md`: i sette vincoli di performance (PERF-01..PERF-07)
- Come popolare la sezione vincoli in `_CONTEXT.md`
- Il ciclo di vita di un vincolo: aggiungere, aggiornare, rimuovere
- `@security-check` e `@perf-check` in pratica

---

### Parte IV — Workflow Avanzato

**Capitolo 12 — Moduli e Skill: caricare solo ciò che serve**
- La logica del caricamento per fase
- I moduli del framework (00_MODE → 11_BUGFIX_PLAYBOOK)
- Le Skill tematiche (API Design, Security, Testing, UI, Ops, ecc.)
- Come l'agente sceglie cosa caricare
- Aggiungere Skill personalizzate in `.adlc/project/skills/`

**Capitolo 13 — Comandi conversazionali**
- La lista completa: `@checkpoint`, `@show-constraints`, `@security-check`, `@alternatives`, `@simplify`, `@rollback`, `@stop` e altri
- Come e quando usarli
- Regole: i comandi non bypassano la classificazione del rischio
- Creare shortcut di progetto in `.adlc/project/instructions.md`

**Capitolo 14 — Multi-agente: Claude, Copilot, Codex, Gemini**
- Come ogni agente legge il framework (entry point diversi)
- La regola di modifica: edita solo `AGENTS.md`
- `sync-copilot`: verificare l'allineamento con Copilot
- Workflow ibrido: Claude per design, Copilot per implementazione
- Coerenza garantita dal `_CONTEXT.md` condiviso

**Capitolo 15 — Monorepo, company extension e codebase legacy**
- Monorepo: `_CONTEXT.md` per sottoprogetto, indice globale con `update-projects`
- Company extension (`.adlc/company/`): SDLC aziendale, governance, compliance
- `preprocess-company-docs`: da PDF/DOCX a Markdown leggibile
- Analisi codebase legacy: i moduli 09 e 10 in sequenza
- Output: MAP.md, RISKS.md, HOTSPOTS.md, documentazione navigabile

---

### Parte V — In Produzione

**Capitolo 16 — Troubleshooting, CI/CD e manutenzione del framework**
- Errori comuni e le loro cause (con soluzione)
- `validate.ps1 --strict` in CI: cosa controlla e come fallisce
- GitHub Actions: template pronto all'uso
- Evolvere il framework: quando aggiornare i moduli, policy di versioning
- Contribuire al framework (per team che condividono ADLC)

---

### Appendici

**Appendice A — Glossario**  
Tutti i termini tecnici ADLC con definizione operativa.

**Appendice B — Comandi conversazionali completi**  
Tabella con tutti i comandi, output atteso e file aggiornati.

**Appendice C — Template pronti all'uso**  
`_CONTEXT.md` completo, `_CONTEXT.md` minimal, EPIC, TASK, PROGRESS, company extension.

**Appendice D — Risorse e letture consigliate**  
Framework correlati, articoli chiave, link alla repo ufficiale ADLC.

---

## Piano di lavoro (Fasi 3-7)

| Fase | Azioni | Stima |
|---|---|---|
| Fase 3 — Scrittura | 16 capitoli + intro + 4 appendici | ~10 sessioni |
| Fase 4 — Revisione | Revisione editoriale struttura e contenuto | 2-3 sessioni |
| Fase 5 — Copy Editing | Terminologia, fact-check, uniformità | 1-2 sessioni |
| Fase 6 — Correzione Bozze | Refusi, grammatica, formattazione | 1 sessione |
| Fase 7 — LaTeX + Build | Conversione + compilazione PDF/EPUB | 1-2 sessioni |

## Domande aperte per l'utente

1. **Struttura repo**: il nuovo libro va in `md/adlc-it/` (aggiunto al repo corrente) o in un repo separato?
2. **Lingua**: solo italiano o pianificare la traduzione EN fin dall'inizio?
3. **Livello di dettaglio**: coprire anche i moduli interni (es. `09_CODEBASE_ANALYSIS.md`) o fermarsi al workflow utente?
4. **Esempi di codice**: usare un progetto fittizio come filo conduttore o esempi indipendenti per capitolo?
