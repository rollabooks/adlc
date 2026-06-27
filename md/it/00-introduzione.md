# Introduzione — Il problema senza nome

Hai già lavorato con un agente AI per qualche ora e hai visto come può essere straordinariamente utile. Gli chiedi di progettare un endpoint, lui risponde con codice pulito, test inclusi. Gli chiedi di rivedere un modulo, individua tre problemi che non avevi notato. Sembra quasi troppo bello.

Poi riapri il progetto il giorno dopo.

L'agente non ricorda nulla. Devi rispiegare lo stack tecnologico, i vincoli di sicurezza, il contesto del task. Riesci a farlo ricominciare, ma spendi venti minuti a ricostruire il contesto che ieri era già lì. La prossima settimana, un'altra mezz'ora. Nel giro di un mese, hai trascorso ore a "riportare l'AI al punto in cui eravamo".

Questo è il problema senza nome. La maggior parte degli sviluppatori lo subisce, ci si abitua e lo mette in conto come "costo dell'AI". Ma non deve essere così.

---

## Tre storie vere

**Storia 1 — La sessione dimenticata**

Marco sta costruendo un'API per un'applicazione fintech. Ha discusso con Claude Code i requisiti di sicurezza: autenticazione OIDC, token JWT con rotazione, nessun segreto nei log. Ha passato un'ora a spiegare le scelte architetturali. L'agente ha prodotto codice eccellente.

Il giorno dopo, Marco riapre la sessione e chiede di aggiungere un endpoint. L'agente genera codice con `console.log(token)` per il debugging. Il vincolo sui log era stato discusso il giorno prima. L'agente non se lo ricorda.

Marco corregge manualmente. Non è un dramma, ma è evitabile.

**Storia 2 — La modifica silenziosa**

Giulia lavora con Copilot su uno schema PostgreSQL. Ha detto all'inizio che le migrazioni vanno sempre revisionate prima di essere eseguite — è una regola del team. Copilot lo sa, per ora.

Tre settimane dopo, nel bel mezzo di una funzionalità nuova, Copilot propone di aggiornare direttamente lo schema per "semplificare". Giulia non se ne accorge subito. Lo schema viene modificato senza migration. Il deploy di venerdì diventa un problema.

La regola c'era. Nessuno la stava rispettando.

**Storia 3 — La certezza inventata**

Luca usa Codex per documentare un modulo legacy che nessuno tocca da tre anni. L'agente produce una documentazione ottima: architettura, dipendenze, flusso dati. Luca la distribuisce al team.

Due settimane dopo si scopre che tre delle funzioni documentate non esistono più. L'agente le aveva "inferite" dal contesto circostante, senza segnalare che stava facendo un'ipotesi. La documentazione era sbagliata dall'inizio.

---

## Il problema comune

Queste tre storie hanno una radice comune: **gli agenti AI non hanno un sistema per mantenere il contesto tra sessioni, rispettare regole non scritte nel codice e segnalare l'incertezza in modo esplicito.**

Non è un problema degli agenti in sé — è strutturale. Un agente AI, per sua natura, inizia ogni sessione da zero a meno che non gli venga fornito un contesto esplicito. Se il contesto non è stato scritto da qualche parte in modo sistematico, va perso.

La soluzione non è trovare un agente "migliore". La soluzione è costruire un sistema che sopravvive tra una sessione e l'altra.

---

## Cos'è ADLC

**ADLC** — *AI-Driven Software Development Life Cycle* — è quel sistema. Non è un'AI, non è un tool da installare, non è un framework specifico per un linguaggio. È un insieme di file Markdown e JSON che vivono nel tuo repository e che dicono all'agente:

- dove sei nel progetto (fase, task attivo)
- cosa deve rispettare (vincoli di sicurezza e performance)
- quando deve fermarsi e chiedere (operazioni ad alto rischio)
- come classificare il proprio output quando non è certo

Il risultato è un agente che lavora *in continuità*: ogni sessione parte dal punto in cui la precedente si è fermata. Non perché l'agente "ricordi" — ma perché il contesto è scritto, strutturato e sempre disponibile.

---

## Come leggere questo libro

Questo libro è diviso in cinque parti.

**Parte I — Il Framework** (Capitoli 1-3) ti porta da zero a una prima sessione di lavoro funzionante. Se vuoi testare ADLC subito, puoi leggere solo questa parte e tornare al resto quando ne hai bisogno.

**Parte II — La Memoria del Progetto** (Capitoli 4-6) spiega in dettaglio `_CONTEXT.md` e `PROGRESS.md`, i due file che costruiscono la continuità tra sessioni.

**Parte III — Il Sistema di Sicurezza** (Capitoli 7-11) copre la classificazione del rischio, i livelli di modello, i confidence tags, gli HALT trigger e i vincoli SEC/PERF.

**Parte IV — Workflow Avanzato** (Capitoli 12-15) affronta scenari più complessi: multi-agente, monorepo, codebase legacy, integrazione aziendale.

**Parte V — In Produzione** (Capitolo 16) chiude il ciclo con CI/CD, troubleshooting e manutenzione del framework nel tempo.

---

## Il progetto di esempio

Per tutta la durata del libro useremo un progetto realistico: **TaskFlow API**, una REST API per la gestione di task e progetti, costruita con Node.js e Fastify. Il progetto è volutamente familiare — chiunque abbia già costruito una REST API riconoscerà i pattern — ma abbastanza ricco da far emergere i problemi reali che ADLC risolve.

Il team è composto da tre sviluppatori: **Lorenzo**, tech lead con esperienza backend, che usa Claude Code in terminale; **Giulia**, sviluppatrice full-stack che lavora in VS Code con GitHub Copilot; e **Marco**, che si occupa di DevOps e code review, e usa Claude Code e Codex CLI. Li seguiremo in sessioni diverse nel corso del libro.

Seguiremo TaskFlow API dall'analisi dei requisiti fino al deploy, passando per design, implementazione, test e release. A ogni capitolo vedremo come ADLC cambia il modo in cui l'agente AI lavora su quel progetto.

Non importa se il tuo stack è diverso. ADLC è agnostico rispetto alla tecnologia. Ciò che impari su TaskFlow API si applica identico a un progetto Python, Go, Flutter o qualsiasi altra combinazione.

---

Cominciamo.
