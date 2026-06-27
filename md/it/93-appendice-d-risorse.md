# Appendice D — Risorse e Letture Consigliate

Riferimenti per approfondire i temi trattati nel libro. Organizzati per area tematica con una nota sul perché ogni risorsa è rilevante per chi usa AI-DLC.

---

## Fondamenti: dove AI-DLC incontra la letteratura

AI-DLC, come spiegato nel Capitolo 1, non è uno standard accademico consolidato nella sua forma specifica, ma una sintesi operativa di filoni già documentati. Questa sezione mappa ciascun pilastro del framework alla letteratura che lo sostiene — utile sia per approfondire, sia per difendere le scelte di design del libro davanti a un lettore esigente.

**Fasi, checkpoint e controllo dell'azione** → *Assistance to Autonomy: A Systematic Literature Review of Agentic AI across the Software Development Life Cycle* (arXiv 2605.15245, 2026). La review, costruita su 92 studi primari, identifica la verificabilità degli output come principale fattore abilitante per gli agenti nello SDLC e riconosce il pattern Planner–Executor–Reviewer come dominante: una corrispondenza diretta con le fasi, i checkpoint e gli HALT trigger di AI-DLC.

**Delegated execution under human supervision** → *Agentic AI in the Software Development Lifecycle: Architecture, Empirical Evidence, and the Reshaping of Software Engineering* (arXiv 2604.26275, 2026). Sposta il focus dalla generazione di codice alla supervisione dell'esecuzione delegata — esattamente il ruolo che AI-DLC assegna allo sviluppatore.

**Planning before action** → Wei et al., *Chain-of-Thought Prompting Elicits Reasoning in Large Language Models* (arXiv 2201.11903) e Yao et al., *ReAct: Synergizing Reasoning and Acting in Language Models* (arXiv 2210.03629). Fondano l'idea che l'agente debba esplicitare un piano prima di agire — il cuore dei task MEDIUM e HIGH di AI-DLC.

**Contesto persistente nel repository** → la documentazione vendor è già pratica prodotto: `AGENTS.md` (OpenAI Codex), memoria di progetto `CLAUDE.md` (Anthropic), e il *persistent context across all phases* di AWS AI-DLC. Sono l'equivalente industriale di `_CONTEXT.md` e `PROGRESS.md`.

**Context rot e disciplina del contesto** → *Context Rot in AI-Assisted Software Development* (arXiv 2606.09090, 2026) documenta l'invecchiamento degli artefatti di contesto rispetto al codice. *Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?* (arXiv 2602.11988, 2026) mostra evidenza empirica mista: i file di contesto non sono "magici" e il loro valore dipende da qualità, minimalità e aggiornamento. Sono la base del Capitolo 4 §4.7.

**Confidence tag** → la pratica degli Architecture Decision Record con livello di confidenza esplicito (Microsoft) e la letteratura su metacognizione ed epistemologia degli LLM giustificano la tassonomia FACT/INFERRED/ASSUMPTION.

**Classificazione del rischio e governance** → NIST *AI Risk Management Framework: Generative AI Profile* (NIST.AI.600-1) per i livelli di human oversight e i controlli risk-based; OWASP *Top 10 for LLM Applications* per i rischi (prompt injection, excessive agency, overreliance) che HALT trigger e confidence tag mitigano.

**Vincoli e DevSecOps** → NIST *Secure Software Development Framework* (SSDF) per l'integrazione della sicurezza nel lifecycle; i vincoli SEC/PERF di AI-DLC ne sono la versione operativa per agenti.

**Lifecycle vendor per agenti (per confronto)** → IBM *Agent Development Lifecycle*, Microsoft Foundry *Agent development lifecycle*, Salesforce Agentforce. Trattano il ciclo di vita degli agenti *come prodotto* — il complemento, non il sostituto, dell'AI-DLC di questo libro.

---

## Il Framework AI-DLC

**Repository ufficiale**
`https://github.com/rollaradio/adlc-framework`
Sorgente del framework, CHANGELOG, MIGRATION.md per gli aggiornamenti, issue tracker per segnalazioni.

**`source/.adlc/MANUAL.md`** (in questo repository)
Il manuale tecnico del framework in formato compatto — utile come riferimento rapido quando hai già letto questo libro e cerchi il dettaglio di un campo o di un modulo.

**`source/.adlc/COMMANDS.md`**
La specifica formale di tutti i comandi conversazionali, con output atteso e file aggiornati. Complementare all'Appendice B di questo libro.

---

## Prompt Engineering e Contesto

**"The Prompt Report" — Schulhoff et al. (2024)**
Survey sistematica delle tecniche di prompt engineering. Rilevante per capire perché il contesto strutturato (come `_CONTEXT.md`) funziona meglio delle istruzioni inline ripetute.

**"Chain-of-Thought Prompting Elicits Reasoning in Large Language Models" — Wei et al. (2022)**
Il paper fondamentale sul CoT. Spiega perché chiedere all'agente di "pianificare prima di agire" (come fa AI-DLC con i task MEDIUM/HIGH) produce output migliori rispetto alla risposta diretta.

**"Software Design for AI" (SDD) — Fowler, martinfowler.com**
La prospettiva di Fowler sull'integrazione degli agenti AI nei processi di sviluppo software. Complementare alla visione AI-DLC — SDD enfatizza il design collaborativo, AI-DLC il framework operativo.

---

## Sicurezza

**OWASP Top 10 (2021)**
`https://owasp.org/www-project-top-ten/`
La lista delle vulnerabilità web più critiche. I vincoli SEC-01, SEC-02, SEC-03, SEC-08 e SEC-09 del framework AI-DLC derivano direttamente da OWASP. Indispensabile come riferimento per compilare i vincoli SEC in `_CONTEXT.md`.

**OWASP ASVS (Application Security Verification Standard)**
`https://owasp.org/www-project-application-security-verification-standard/`
Standard più dettagliato di OWASP Top 10, organizzato per livelli di verifica. Utile per definire vincoli SEC più precisi in progetti con requisiti di compliance.

**OWASP Logging Cheat Sheet**
`https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html`
Riferimento diretto per SEC-08 (Logging & Monitoring). Copre struttura del log, eventi da registrare, protezione dei log.

**OWASP SSRF Prevention Cheat Sheet**
`https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html`
Riferimento per SEC-09. Utile per qualsiasi progetto che accetta URL forniti dall'utente o fa chiamate HTTP verso sistemi esterni.

---

## Testing e Qualità

**"The Testing Pyramid" — Martin Fowler**
`https://martinfowler.com/articles/practical-test-pyramid.html`
Il modello che guida la strategia di test nei capitoli di implementazione di questo libro. Spiega perché AI-DLC privilegia integration test su DB reale invece di mock.

**"EPAM Testing Pyramid for AI-Assisted Development" — EPAM Systems (2024)**
Adattamento della piramide di test per i contesti con agenti AI. Discute il testing non deterministico e come gestire output che variano tra run.

---

## AI-Assisted Development

**"GitHub Copilot Impact Study" — GitHub/Accenture (2024)**
Ricerca quantitativa sull'impatto di Copilot sulla produttività degli sviluppatori. Dati citati nel Capitolo 1 per motivare l'adozione di framework strutturati (contesto condiviso, regole condivise) rispetto all'uso non strutturato degli agenti.

**"Salesforce AI Developer Survey" — Salesforce (2024)**
Survey su come gli sviluppatori usano gli agenti AI in produzione. Evidenzia i problemi di context drift e vincoli dimenticati — le stesse motivazioni alla base di AI-DLC.

**"Cycode State of AI-Assisted Development" — Cycode (2024)**
Analisi dei rischi di sicurezza introdotti dall'uso non strutturato di agenti AI per la generazione di codice. Supporta l'approccio AI-DLC ai vincoli SEC come primo-cittadino del contesto.

**"Arthur AI — Guardrails for LLM Applications" — Arthur AI (2024)**
Prospettiva enterprise sui sistemi di guardrail per LLM. Complementare agli HALT trigger di AI-DLC — entrambi affrontano il problema di "quando l'agente deve fermarsi", con approcci diversi (file statici vs monitoring dinamico).

---

## Architettura e Decisioni

**"Architectural Decision Records" — Michael Nygard**
`https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions`
Il formato ADR citato nel Capitolo 7 per le decisioni CRITICAL. Spiega struttura e utilità dei record di decisione architetturale.

**"Forrester AI Developer Tools Report" — Forrester (2026)**
Analisi del mercato degli strumenti AI per sviluppatori. Utile per capire il panorama competitivo in cui AI-DLC si inserisce e per confrontare approcci alternativi.

---

## Agenti AI: documentazione ufficiale

**Claude Code — Anthropic**
`https://docs.anthropic.com/claude-code`
Documentazione ufficiale di Claude Code — l'agente AI usato come riferimento principale in questo libro.

**GitHub Copilot**
`https://docs.github.com/en/copilot`
Documentazione ufficiale di GitHub Copilot, inclusa la configurazione di `.github/copilot-instructions.md`.

**OpenAI CLI / Codex**
`https://github.com/openai/openai-codex`
L'agente che legge `AGENTS.md` nella root del progetto.

---

## Standard di riferimento

**NIST SP 800-53** (National Institute of Standards and Technology)
Standard di controlli di sicurezza per sistemi informativi. Rilevante per chi lavora in contesti con requisiti di compliance US federale. I vincoli SEC di AI-DLC sono ispirati parzialmente a questo standard.

**Google SRE Book**
`https://sre.google/sre-book/table-of-contents/`
Disponibile gratuitamente online. Capitoli su SLO, SLI e error budget sono la base teorica di PERF-01 e PERF-02. Capitoli su incident response informano il modulo `06_OPS.md`.

---

**OpenAI Codex CLI**
`https://github.com/openai/openai-codex`
Repository del Codex CLI.

> **Nota:** OpenAI Codex CLI è stato soggetto a variazioni di stato (deprecazione, rinomina) nel 2025-2026. Verifica lo stato attuale del prodotto prima di usarlo come riferimento — potrebbe essere stato sostituito da "OpenAI CLI" o da un'interfaccia equivalente. La documentazione AI-DLC in `AGENTS.md` rimane applicabile indipendentemente dal nome del prodotto.

---

## Note sull'aggiornamento di questa lista

Le risorse elencate erano accurate al momento della redazione (giugno 2026). Il panorama degli agenti AI evolve rapidamente: nuovi modelli, nuovi tool, nuovi studi. Prima di usare uno dei link o riferimenti sopra, verifica che la risorsa sia ancora disponibile e aggiornata.

Per la documentazione degli agenti AI in particolare, le versioni cambiano frequentemente — fai sempre riferimento alla documentazione ufficiale più recente piuttosto che a versioni archiviate.
