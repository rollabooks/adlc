# Capitolo 1 — ADLC: cos'è e perché esiste

TaskFlow API nasce da una decisione semplice: il team di tre sviluppatori vuole usare agenti AI per accelerare lo sviluppo, ma senza rinunciare alla qualità e senza perdere il controllo su ciò che viene generato.

Il primo giorno, Lorenzo — il tech lead — apre Claude Code e chiede di impostare il progetto. L'agente risponde subito con una struttura di directory, un `package.json` e i primi endpoint. Funziona. Il team è soddisfatto.

Il terzo giorno, però, Lorenzo nota che il codice generato nel pomeriggio non rispetta la convenzione di gestione degli errori che avevano discusso la mattina. L'agente ha dimenticato.

Il decimo giorno, il team ha tre conversazioni diverse con tre agenti diversi, ognuna con il proprio contesto implicito. Nessuno dei tre agenti sa cosa stanno facendo gli altri.

È a questo punto che Lorenzo decide di adottare ADLC.

---

## 1.1 I quattro problemi che ADLC risolve

ADLC nasce per risolvere quattro problemi specifici, tutti connessi alla natura degli agenti AI attuali.

### Problema 1 — L'AI dimentica

Gli agenti AI non hanno memoria persistente tra sessioni. Ogni conversazione inizia da zero. Se hai discusso la settimana scorsa che il tuo stack usa OIDC per l'autenticazione e che i token non devono mai apparire nei log, dovrai ridirlo la settimana prossima.

**Soluzione ADLC:** `_CONTEXT.md`, un file Markdown alla radice del progetto che contiene tutto il contesto rilevante. L'agente lo legge a ogni sessione. Se cambia qualcosa, lo aggiorni. Non devi ripetere nulla.

### Problema 2 — L'AI ignora i vincoli

Anche quando spieghi i requisiti di sicurezza all'inizio di una conversazione, l'agente può ignorarli o dimenticarli nel corso del lavoro — specialmente in sessioni lunghe o complesse. Un vincolo che non è strutturato in modo esplicito non viene rispettato sistematicamente.

**Soluzione ADLC:** I vincoli `SEC-XX` (sicurezza) e `PERF-XX` (performance) sono definiti una volta in `_CONTEXT.md` e riletti dall'agente prima di ogni operazione critica. Non sono una nota a margine: sono parte del protocollo obbligatorio.

### Problema 3 — L'AI inventa

Gli agenti AI sono progettati per rispondere, non per dire "non lo so". Questo produce output che mischiano fatti verificabili, deduzioni logiche e ipotesi non verificate — il tutto con la stessa sicurezza apparente.

**Soluzione ADLC:** I confidence tag (`FACT` / `INFERRED` / `ASSUMPTION`) obbligano l'agente a classificare esplicitamente la certezza del proprio output su decisioni ad alto impatto. Un `ASSUMPTION` non è un errore — è un segnale che devi verificare prima di procedere.

### Problema 4 — L'AI fa troppo

Un agente senza limiti può modificare lo schema del database mentre aggiusta un bug di UI, o cambiare la configurazione di produzione mentre aggiorna un test. Le operazioni rischiose vengono eseguite senza avvisare.

**Soluzione ADLC:** Gli HALT trigger definiscono i path e le operazioni che richiedono conferma esplicita prima di procedere. L'agente si ferma, spiega cosa sta per fare e aspetta il tuo via libera.

---

## 1.2 Cosa NON è ADLC

Prima di andare avanti, è importante chiarire cosa ADLC non è.

**Non è un'AI.** ADLC non genera codice, non esegue comandi, non decide nulla in autonomia. È un sistema di file che struttura il dialogo tra te e l'agente AI che già usi.

**Non è un tool da installare.** Non c'è un pacchetto npm, una pip install, un binario. Il framework è un insieme di file Markdown e JSON che vivono nel tuo repository. Non c'è un server, non c'è una dashboard, non ci sono dipendenze esterne.

**Non è specifico per un linguaggio o stack.** ADLC funziona identico su un progetto Node.js, Python, Go, Rust, Flutter. Il contenuto dei file cambia (i tuoi vincoli specifici, il tuo stack), ma il sistema è lo stesso.

**Non è un sostituto del processo di sviluppo.** ADLC si inserisce nel processo che già hai — o aiuta a costruirlo, se non ce l'hai. Non è un framework Agile alternativo, non è una metodologia di project management.

---

## 1.3 Quando usarlo (e quando no)

ADLC è uno strumento per progetti reali. Ha senso adottarlo quando:

- Stai lavorando su un progetto che dura più di qualche giorno.
- Usi agenti AI regolarmente, non solo per domande occasionali.
- Il progetto ha vincoli di sicurezza, performance o compliance che devono essere rispettati sistematicamente.
- Vuoi usare più agenti diversi (Claude, Copilot, Codex) sullo stesso progetto senza duplicare le regole.
- Lavori in team e vuoi che tutti gli agenti seguano le stesse convenzioni.

Non serve quando:

- Stai facendo un esperimento di un'ora o un prototipo usa-e-getta.
- Hai solo una domanda veloce da fare all'agente.
- Il progetto è talmente semplice che non ha vincoli significativi.

> **Costo di adozione:** circa 15 minuti per lo scaffold iniziale, poi 1-2 minuti a sessione per mantenere `_CONTEXT.md` aggiornato. Il tempo si recupera entro la prima settimana di lavoro continuativo.

---

## 1.4 I prerequisiti

Per usare ADLC non servono competenze avanzate, ma tre basi sono necessarie.

**Riga di comando.** Devi saper aprire un terminale (PowerShell o Bash) e lanciare comandi. I tool del framework (`init.ps1`, `validate.ps1`) sono script da eseguire, non interfacce grafiche.

**Markdown base.** I file del framework sono Markdown: titoli, tabelle, liste. Devi saper aprire, leggere e modificare un `.md`. Non serve sapere tutto il Markdown — bastano i costrutti di base.

**Git base.** `clone`, `commit`, `push`, branching di base. Tecnicamente puoi usare ADLC senza Git su un progetto locale, ma è fortemente sconsigliato — il versionamento del contesto è parte del valore.

Utili ma non obbligatori: YAML (per gli HALT trigger), JSON (per il manifest), PowerShell scripting (per modificare i tool). Capirai questi file leggendoli; non è necessario scriverli da zero.

---

## 1.5 I concetti fondamentali in sintesi

Prima di entrare nel dettaglio nei capitoli successivi, ecco una mappa dei concetti principali del framework.

| Concetto | File/Meccanismo | A cosa serve |
|---|---|---|
| **Stato del progetto** | `_CONTEXT.md` | Fase, task attivo, stack, vincoli attivi |
| **Storia del progetto** | `PROGRESS.md` | Registro di sessioni, decisioni, lavoro fatto |
| **Fasi** | `Phase:` in `_CONTEXT.md` | In che punto del ciclo di sviluppo sei (0-6) |
| **Modes** | `Mode:` in `_CONTEXT.md` | Quanta cerimonia vuoi (LITE / STANDARD / AUDIT) |
| **Rischio** | Classificazione interna | LOW / MEDIUM / HIGH / CRITICAL |
| **Model Level** | Campo nel task | Quale "potenza" AI serve (1-7) |
| **Confidence tag** | `FACT / INFERRED / ASSUMPTION` | Quanto è certo l'output dell'agente |
| **HALT Trigger** | `halt-triggers.yaml` | Path che richiedono conferma prima di modificare |
| **Vincoli SEC** | `SEC-XX` in `_CONTEXT.md` | Requisiti di sicurezza riusabili |
| **Vincoli PERF** | `PERF-XX` in `_CONTEXT.md` | Requisiti di performance riusabili |
| **Moduli** | `.adlc/modules/` | Regole specifiche per ogni fase, caricati su richiesta |
| **Skill** | `.adlc/modules/skills/` | Guide tematiche (API, Security, Testing, UI, Ops) |

Nei prossimi due capitoli vedremo tutto questo in pratica, su TaskFlow API.

---

## Riepilogo

- ADLC risolve quattro problemi: la dimenticanza, l'ignoranza dei vincoli, l'invenzione e l'eccesso di autonomia degli agenti AI.
- Non è un tool, non è un'AI, non è specifico per uno stack tecnologico.
- Funziona tramite file Markdown e JSON che vivono nel repository e danno all'agente un contesto strutturato e persistente.
- Ha senso su progetti reali con continuità tra sessioni; non serve per esperimenti brevi.
- Costo di adozione: ~15 minuti iniziali, poi 1-2 minuti per sessione.

Nel prossimo capitolo installiamo ADLC su TaskFlow API.
