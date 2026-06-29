# Appendice A — Glossario

Definizioni operative dei termini usati nel libro. Ogni termine è definito in modo concreto, non astratto — con riferimento a dove vive nel framework e a cosa cambia nel comportamento dell'agente.

---

**AI-DLC**
*AI-Driven Development Life Cycle.* Il framework descritto in questo libro. Riprende la nomenclatura introdotta da AWS e la specializza. Non è un'AI, non è un tool da installare — è un insieme di file Markdown e JSON che strutturano il dialogo tra sviluppatore e agente AI.

**ADLC**
Sigla da non confondere con AI-DLC. In ambito enterprise indica *Agent Development Lifecycle* (IBM, Microsoft, Salesforce), cioè il ciclo di vita per costruire e governare sistemi agentici come prodotto; in tradizioni più datate, *Application Development Life Cycle* (quasi sinonimo di SDLC). Questo libro tratta l'uso di agenti per sviluppare software, non la costruzione di agenti.

**Agent Bootstrap**
La sequenza di operazioni che l'agente esegue all'inizio di ogni sessione: legge `_CONTEXT.md`, carica il modulo di fase appropriato, legge le regole di progetto, conferma il contesto. Il bootstrap garantisce che ogni sessione parta dallo stato corretto.

**AI Sizing**
La stima associata a ogni task AI-DLC: token di input, token di output, totale, model level, modello raccomandato e motivazione. Serve a scegliere il modello AI appropriato per il task.

**ASSUMPTION**
Uno dei tre confidence tag. Indica che l'agente ha fatto un'ipotesi non supportata da evidenza diretta nel contesto. Un ASSUMPTION su un output HIGH-risk richiede verifica prima di procedere. Vedi anche: *confidence tag*, *FACT*, *INFERRED*.

**Bootstrap**
Vedi *agent bootstrap*.

**Checkpoint**
Punto fermo fissato con `@checkpoint` ogni 3-5 azioni significative. L'agente produce un riepilogo del lavoro, i prossimi passi, i blocchi e una proposta di aggiornamento per `_CONTEXT.md` e `PROGRESS.md`.

**Comando conversazionale**
Istruzione in formato `@keyword` che l'agente riconosce nella chat e interpreta secondo il protocollo AI-DLC. Non è un comando shell. Esempi: `@checkpoint`, `@show-constraints`, `@stop`. Lista completa in Appendice B.

**Company extension**
Cartella `.ai-dlc/company/` che contiene processi SDLC aziendali, standard ingegneristici e requisiti di governance in formato Markdown. L'agente la carica automaticamente. Le sue regole hanno priorità sul framework.

**Confidence tag**
Classificazione esplicita della certezza dell'agente su un'affermazione ad alto impatto. I tre valori: `FACT` (verificato), `INFERRED` (dedotto), `ASSUMPTION` (ipotesi). Obbligatori su output HIGH-risk, claim SEC/PERF, codice in zone HALT.

**`_CONTEXT.md`**
Il file di stato persistente del progetto. Contiene: fase corrente, task attivo, stack tecnologico, vincoli SEC e PERF. L'agente lo legge a ogni sessione. È la fonte di verità del progetto.

**CRITICAL**
Il livello di rischio più alto nella classificazione AI-DLC. Si applica a decisioni mission-critical ambigue con implicazioni architetturali irreversibili. L'agente produce alternative e un record di decisione, ma non esegue nulla. Model Level minimo: 7.

**Entry point**
Il file che un agente AI legge come prima istruzione in un repository AI-DLC. Ogni agente ha il suo: `CLAUDE.md` (Claude Code), `AGENTS.md` (Codex), `GEMINI.md` (Gemini), `OPENCLAW.md` (OpenClaw), `VISUALSTUDIO.md` (Visual Studio 2026), `.github/copilot-instructions.md` (Copilot).

**FACT**
Uno dei tre confidence tag. Indica che l'agente ha verificato l'informazione leggendo direttamente il codice o un file presente nel contesto. Vedi anche: *confidence tag*, *INFERRED*, *ASSUMPTION*.

**HALT**
L'azione con cui l'agente si ferma prima di modificare un path protetto dagli HALT trigger. Non è un blocco permanente: dopo la conferma esplicita dell'utente, il lavoro riprende.

**HALT trigger**
Pattern di path definiti in `.ai-dlc/halt-triggers.yaml` che richiedono conferma esplicita prima di qualsiasi modifica. I sei trigger predefiniti coprono: schema DB, auth, secrets, infra, CI/CD, file del framework.

**HIGH**
Livello di rischio per modifiche ad alto impatto o difficilmente reversibili: schema DB, autenticazione, architettura, eliminazione dati, configurazioni di deploy. L'agente produce un piano dettagliato e aspetta conferma esplicita. Model Level minimo: 5.

**HIGH+**
Sottolivello di HIGH per operazioni su secrets, credenziali, compliance e dati in produzione. L'agente non propone nemmeno un piano finché non riceve una conferma di intento. Model Level minimo: 6.

**INFERRED**
Uno dei tre confidence tag. Indica che l'agente ha dedotto l'informazione da contesto indiretto (nome di funzione, pattern del framework, struttura del codice) senza verifica diretta. Vedi anche: *confidence tag*, *FACT*, *ASSUMPTION*.

**LOW**
Il livello di rischio più basso: modifiche facilmente reversibili, nessun impatto su logica di business o sistemi condivisi (rinomina, typo, formattazione, JSDoc). L'agente esegue direttamente e notifica.

**MEDIUM**
Livello di rischio per nuove funzionalità, refactor locali, modifiche multi-file reversibili. L'agente propone un piano e aspetta l'approvazione prima di eseguire. Model Level minimo: 3.

**Mode**
Parametro in `_CONTEXT.md` che controlla il livello di cerimonia dell'agente. Cinque valori: LITE (lavoro quotidiano su progetto stabile), STANDARD (default), AUDIT (tracciabilità completa), RAPID (spike/emergenze), FAST (task semplici veloci). Gli HALT trigger non vengono mai disattivati da nessun Mode.

**Model Level**
Scala da 1 a 7 che mappa la complessità di un task al modello AI appropriato. Il livello è determinato dalla stima dei token e dal risk floor. Il mapping a modelli concreti (Anthropic, OpenAI, Gemini) vive in `manifest.json` e si legge con `show-models`.

**Modulo**
File in `.ai-dlc/modules/NN_*.md` che definisce le regole operative del framework per una fase del ciclo di sviluppo. I moduli `00` (MODE) e `01` (CORE_RULES) sono sempre caricati; gli altri vengono caricati in base alla fase o su richiesta. Sono read-only.

**Monorepo**
Repository con più sottoprogetti. In AI-DLC, ogni sottoprogetto ha il proprio `_CONTEXT.md` e `PROGRESS.md`. Il framework è condiviso alla radice. L'agente usa il `_CONTEXT.md` più vicino al file su cui lavora.

**PERF-XX**
Vincolo di performance riusabile definito in `PERF_CONSTRAINTS.md`. Si attiva in `_CONTEXT.md`. L'agente lo rilega prima di generare codice in zone performance-sensitive. Sette vincoli predefiniti: PERF-01 (latency) a PERF-07 (bundle size).

**Phase**
Una delle sette fasi del ciclo AI-Driven: 0-Discovery, 1-Analysis, 2-Design, 3-Implementation, 4-Verification, 5-Release, 6-Ops. Determina quale modulo il framework carica e come l'agente interpreta le richieste.

**`PROGRESS.md`**
Il diario di bordo del progetto. Registra in ordine cronologico inverso: cosa è stato fatto, cosa è stato scoperto, quali decisioni sono state prese e perché. Cresce solo in avanti, non si sovrascrive.

**Risk floor**
Il model level minimo imposto da certi livelli di rischio, indipendentemente dalla stima token. HIGH → 5, auth/secrets/produzione → 6, CRITICAL → 7.

**SEC-XX**
Vincolo di sicurezza riusabile definito in `SEC_CONSTRAINTS.md`. Si attiva in `_CONTEXT.md`. L'agente lo rilega prima di generare codice in zone SEC-sensibili. Nove vincoli predefiniti: SEC-01 (input validation) a SEC-09 (SSRF).

**Skill**
File in `.ai-dlc/modules/skills/SKILL_*.md` che fornisce una guida tematica specializzata (API design, sicurezza, testing, UI, ops). Si carica su richiesta, indipendentemente dalla fase. Può essere personalizzata con skill di progetto in `.ai-dlc/project/skills/`.

**Strict mode**
Modalità del validator (`validate.sh --strict`) in cui i warning diventano failure. Usato in CI per garantire che `_CONTEXT.md` sia sempre aggiornato.

**sync-copilot**
Tool che verifica l'allineamento concettuale tra `AGENTS.md` e `.github/copilot-instructions.md`. Copilot non può importare file esterni, quindi il suo file di istruzioni deve essere mantenuto manualmente allineato. Si esegue con `.ai-dlc/tools/sync-copilot.sh`.

**Validator**
Script cross-platform (`.ai-dlc/tools/validate.ps1` / `validate.sh`) che verifica la presenza e validità del framework. Può girare in CI. Con `--strict` fa fallire anche i warning.
