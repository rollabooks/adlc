# Glossario Terminologico — ADLC: Orchestrare Agenti AI

> Versione: 1.0
> Data: 2026-06-27
> Scope: edizione italiana

Questo file documenta le decisioni terminologiche prese durante il copy editing. Ogni voce riporta il termine adottato, le varianti trovate nel manoscritto e la motivazione della scelta.

---

## Termini tecnici del framework

| Termine adottato | Varianti trovate | Decisione |
|---|---|---|
| **confidence tag** (invariante) | confidence tags, tag di confidenza | Invariante: italiano usa articolo (i confidence tag, il confidence tag). Trattato come termine tecnico non tradotto. |
| **HALT trigger** | halt trigger, Halt Trigger | Iniziali maiuscole come nome proprio del meccanismo. Invariante in IT. |
| **bootstrap** | Bootstrap | Minuscolo nel testo corrente; maiuscolo solo come titolo. Confermato. |
| **checkpoint** | Checkpoint | Minuscolo nel testo. Confermato. |
| **mode** / **Mode** | mode, Mode | Minuscolo nel testo (`mode LITE`), maiuscolo quando è il campo in `_CONTEXT.md` (`| Mode | LITE |`). |
| **model level** | Model Level, livello di modello | "Model Level" come nome del campo; "livello" nella prosa informale. |
| **risk floor** | risk floor, floor di rischio | Mantenuto in inglese invariante. |
| **skill** | Skill | Minuscolo nel testo tranne quando è il nome del file (`SKILL_*.md`). |
| **modulo** | module, modulo | Tradotto: "modulo" nella prosa; `module` solo nei nomi file. |

## Nomi di tecnologie (capitalizzazione)

| Forma corretta | Forme errate da evitare |
|---|---|
| PostgreSQL | Postgresql, POSTGRESQL, postgres |
| Node.js | NodeJS, node.js, nodejs |
| JavaScript | Javascript, javascript |
| TypeScript | Typescript, typescript |
| GitHub | Github, GITHUB |
| GitHub Actions | Github Actions |
| Fastify | fastify |
| Prisma | prisma (quando nome del prodotto) |
| Zod | zod (quando nome del prodotto) |
| Vitest | vitest (quando nome del prodotto) |
| Markdown | markdown (nella prosa; `md` nei nomi file) |

## Termini di processo

| Termine adottato | Note |
|---|---|
| **sessione** | Non "conversazione" o "chat". Una sessione è il periodo di lavoro con un agente. |
| **agente AI** | Non "modello AI" (il modello è il motore; l'agente è l'interfaccia). |
| **contesto** | Non "context" nella prosa italiana; `_CONTEXT.md` è il nome del file. |
| **fase** | Non "stage" o "step". Le fasi ADLC sono 0-6. |
| **vincolo** | Non "constraint" nella prosa. SEC-XX e PERF-XX sono "vincoli". |
| **deployment** / **deploy** | "deploy" come verbo e sostantivo informale; "deployment" nella prosa formale. Entrambi accettati. |
| **pull request** / **PR** | Accettati entrambi. Prima occorrenza: "pull request (PR)". |
| **refactor** | Non tradotto. Accettato come sostantivo e verbo invariante. |

## Punteggiatura e stile

| Regola | Applicazione |
|---|---|
| Trattino em (—) | Separatore in apposizioni: "ADLC — il framework". Non spazio prima. |
| Virgolette | Doppi apici tipografici per citazioni dirette: "testo". Backtick per codice inline. |
| Elenchi puntati | Terminano senza punto se sono frammenti; con punto se sono frasi complete. Nel libro prevalgono i frammenti senza punto. |
| Numeri | Cifre per valori tecnici (3 query, 200ms, livello 5). Lettere per contesti narrativi ("tre storie", "cinque livelli"). |
| Parentesi quadre in markdown | Riservate ai link `[testo](url)`. I placeholder usano parentesi graffe: `[placeholder]` è eccezione accettata nei template. |
