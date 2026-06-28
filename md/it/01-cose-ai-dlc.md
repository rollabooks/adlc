# Capitolo 1 — AI-DLC: cos'è e perché esiste

TaskFlow API nasce da una decisione semplice: il team di tre sviluppatori vuole usare agenti AI per accelerare lo sviluppo, ma senza rinunciare alla qualità e senza perdere il controllo su ciò che viene generato.

Il primo giorno, Lorenzo — il tech lead — apre Claude Code e chiede di impostare il progetto. L'agente risponde subito con una struttura di directory, un `package.json` e i primi endpoint. Funziona. Il team è soddisfatto.

Il terzo giorno, però, Lorenzo nota che il codice generato nel pomeriggio non rispetta la convenzione di gestione degli errori che avevano discusso la mattina. L'agente ha dimenticato.

Il decimo giorno, il team ha tre conversazioni diverse con tre agenti diversi, ognuna con il proprio contesto implicito. Nessuno dei tre agenti sa cosa stanno facendo gli altri.

È a questo punto che Lorenzo decide di adottare AI-DLC.

---

## 1.1 I quattro problemi che AI-DLC risolve

AI-DLC nasce per risolvere quattro problemi specifici, tutti connessi alla natura degli agenti AI attuali.

### Problema 1 — L'AI dimentica

Gli agenti AI non hanno memoria persistente tra sessioni. Ogni conversazione inizia da zero. Se hai discusso la settimana scorsa che il tuo stack usa OIDC per l'autenticazione e che i token non devono mai apparire nei log, dovrai ridirlo la settimana prossima.

**Soluzione AI-DLC:** `_CONTEXT.md`, un file Markdown alla radice del progetto che contiene tutto il contesto rilevante. L'agente lo legge a ogni sessione. Se cambia qualcosa, lo aggiorni. Non devi ripetere nulla.

### Problema 2 — L'AI ignora i vincoli

Anche quando spieghi i requisiti di sicurezza all'inizio di una conversazione, l'agente può ignorarli o dimenticarli nel corso del lavoro — specialmente in sessioni lunghe o complesse. Un vincolo che non è strutturato in modo esplicito non viene rispettato sistematicamente.

**Soluzione AI-DLC:** I vincoli `SEC-XX` (sicurezza) e `PERF-XX` (performance) sono definiti una volta in `_CONTEXT.md` e riletti dall'agente prima di ogni operazione critica. Non sono una nota a margine: sono parte del protocollo obbligatorio.

### Problema 3 — L'AI inventa

Gli agenti AI sono progettati per rispondere, non per dire "non lo so". Questo produce output che mischiano fatti verificabili, deduzioni logiche e ipotesi non verificate — il tutto con la stessa sicurezza apparente.

**Soluzione AI-DLC:** I confidence tag (`FACT` / `INFERRED` / `ASSUMPTION`) obbligano l'agente a classificare esplicitamente la certezza del proprio output su decisioni ad alto impatto. Un `ASSUMPTION` non è un errore — è un segnale che devi verificare prima di procedere.

### Problema 4 — L'AI fa troppo

Un agente senza limiti può modificare lo schema del database mentre aggiusta un bug di UI, o cambiare la configurazione di produzione mentre aggiorna un test. Le operazioni rischiose vengono eseguite senza avvisare.

**Soluzione AI-DLC:** Gli HALT trigger definiscono i path e le operazioni che richiedono conferma esplicita prima di procedere. L'agente si ferma, spiega cosa sta per fare e aspetta il tuo via libera.

---

## 1.2 Dal vibe coding all'ingegneria: dove si colloca AI-DLC

I quattro problemi del paragrafo precedente non sono difetti isolati di un singolo strumento. Sono la faccia ingegneristica di un cambiamento più ampio nel modo di scrivere software, che nel 2025 ha preso un nome: **vibe coding**.

### La promessa del vibe coding

Il termine è stato coniato da Andrej Karpathy all'inizio del 2025 e poi formalizzato nel libro *Vibe Coding* di Gene Kim e Steve Yegge (2025, con prefazione di Dario Amodei, CEO di Anthropic). Descrive il passaggio dalla scrittura manuale del codice alla **direzione conversazionale di un agente AI**: lo sviluppatore smette di digitare ogni riga e si concentra sulla visione e sulla verifica, mentre l'agente genera, propone, corregge.

Il valore è reale e misurabile. Kim e Yegge lo riassumono in cinque dimensioni — *Fast, Ambitious, Autonomous, Fun, Optionality* (FAAFO): si va più veloci, si tentano progetti più ambiziosi, si delega di più, ci si diverte di più e si tengono aperte più opzioni. Nella prefazione, Amodei arriva a definirlo «l'unico gioco in città» per chi scrive codice oggi. AI-DLC parte da qui: non vuole spegnere questo entusiasmo, vuole renderlo sostenibile in produzione.

### Il problema del 70%

L'entusiasmo per la velocità generativa si scontra però con un muro ingegneristico ben documentato. Addy Osmani, nel suo *Vibe Coding: The Future of Programming* (O'Reilly, 2025), lo chiama **il problema del 70%**: lasciata libera, l'AI completa circa il 70% di un progetto con una velocità sbalorditiva, generando prototipi che sembrano funzionare. Ma il restante 30% — casi limite, architettura, manutenibilità a lungo termine, sicurezza — diventa un *last mile* frustrante, dove la velocità iniziale si trasforma in rendimenti decrescenti.

La spiegazione è classica: nei termini di Fred Brooks, l'AI eccelle sulla **complessità accidentale** (il lavoro ripetitivo e meccanico) ma non sulla **complessità essenziale** (capire e governare la difficoltà intrinseca del problema), che resta sulle spalle umane. Steve Yegge descrive gli LLM di oggi come *«junior developer incredibilmente produttivi, ma potenzialmente sotto l'effetto di sostanze»*: rapidi, entusiasti e a volte fuori strada. Il problema non è la competenza, è che **la loro sicurezza apparente supera di gran lunga la loro affidabilità**.

Da qui i pattern di fallimento che Osmani cataloga e a cui ogni team che ha provato il vibe coding "puro" sa dare un nome:

- **House of cards code** — codice che sembra completo ma crolla alla prima pressione del mondo reale.
- **Two steps back** — provi a correggere un bug banale, l'agente propone una modifica plausibile che ne rompe un'altra; chiedi di sistemare quella e ne nascono due nuove. Avanti così.
- **Demo-quality trap** — il prototipo impressiona nella demo, ma è lontanissimo dall'essere *production-ready*.

### Il "middle loop" e l'amnesia tra sessioni

Kim e Yegge distinguono tre cicli di lavoro dello sviluppatore: l'**inner loop** (secondi: completamento, micro-iterazione), il **middle loop** (una sessione o un task: progettare, implementare, testare una funzionalità) e l'**outer loop** (il rilascio). Il vibe coding brilla nell'inner loop, ma soffre cronicamente nel **middle loop**: al passaggio di consegne tra una sessione e l'altra l'agente dimentica il contesto, e lo sviluppatore perde tempo a ricostruirlo.

È esattamente *il problema senza nome* descritto nell'Introduzione. Non è un dettaglio: è il punto in cui il vibe coding smette di scalare e dove un metodo diventa indispensabile.

### AI-DLC: il vibe coding diventato ingegneria

AI-DLC non si oppone al vibe coding: ne è l'**evoluzione disciplinata**. Mantiene la velocità e il piacere della direzione conversazionale, e vi aggiunge le barriere che trasformano un prototipo *demo-quality* in software solido. Ogni fallimento documentato del vibe coding "puro" ha un meccanismo corrispondente nel framework:

| Limite del vibe coding | Meccanismo AI-DLC |
|---|---|
| Amnesia del *middle loop* | `_CONTEXT.md` + `PROGRESS.md`: stato e storia persistenti e versionati |
| Il 30% difficile (edge case, sicurezza, performance) | Vincoli `SEC-XX` / `PERF-XX` riletti prima di ogni operazione critica |
| *Two steps back* ed eccesso di autonomia | HALT trigger + classificazione del rischio + pianificazione prima dell'azione |
| Allucinazione sicura di sé | Confidence tag `FACT` / `INFERRED` / `ASSUMPTION` |

Questa corrispondenza non è un'intuizione isolata. La più ampia revisione sistematica della letteratura sul tema — *Assistance to Autonomy* (arXiv 2605.15245, 2026), costruita su oltre 1.600 fonti — conclude che l'industria converge sul confinare gli agenti in **spazi d'azione verificabili e delimitati** e sul pattern **Planner–Executor–Reviewer**: l'agente prima pianifica, poi esegue su approvazione, mentre l'umano resta revisore. AI-DLC è precisamente l'operazionalizzazione di questo pattern dentro un repository reale. L'Appendice D mappa ciascun pilastro del framework alla letteratura che lo sostiene.

> **In una frase:** il vibe coding ha reso evidente *quanto* gli agenti AI possono accelerare lo sviluppo; AI-DLC risponde alla domanda successiva — *come* farlo senza che il 30% difficile, l'amnesia e l'eccesso di autonomia distruggano ciò che il primo 70% ha costruito.

---

## 1.3 Cosa NON è AI-DLC

Prima di andare avanti, è importante chiarire cosa AI-DLC non è.

**Non è un'AI.** AI-DLC non genera codice, non esegue comandi, non decide nulla in autonomia. È un sistema di file che struttura il dialogo tra te e l'agente AI che già usi.

**Non è un tool da installare.** Non c'è un pacchetto npm, una pip install, un binario. Il framework è un insieme di file Markdown e JSON che vivono nel tuo repository. Non c'è un server, non c'è una dashboard, non ci sono dipendenze esterne.

**Non è specifico per un linguaggio o stack.** AI-DLC funziona identico su un progetto Node.js, Python, Go, Rust, Flutter. Il contenuto dei file cambia (i tuoi vincoli specifici, il tuo stack), ma il sistema è lo stesso.

**Non è un sostituto del processo di sviluppo.** AI-DLC si inserisce nel processo che già hai — o aiuta a costruirlo, se non ce l'hai. Non è un framework Agile alternativo, non è una metodologia di project management.

**Non è (ancora) uno standard accademico consolidato.** AI-DLC, in questo libro, indica un framework pratico di *AI-Driven Development Life Cycle*. Non viene presentato come uno standard già codificato in letteratura nella sua forma specifica, ma come una sintesi originale e operativa di filoni maturi: software lifecycle engineering, agentic AI, prompt engineering e planning, contesto persistente nel repository, human-in-the-loop, governance del rischio, DevSecOps e architecture decision record. Il contributo di questo libro non è inventare il ciclo di vita degli agenti, ma renderlo concreto e disciplinato per chi sviluppa software con coding agent dentro un repository reale.

> **Nota terminologica:** il termine *AI-Driven Development Life Cycle* (AI-DLC) riprende la nomenclatura introdotta da AWS per descrivere uno sviluppo software guidato dall'AI con contesto persistente nel repository. Questo libro adotta quel termine e lo specializza in un framework operativo per coding agent, centrato su artefatti persistenti, continuità del contesto e checkpoint di controllo umano. AI-DLC va distinto dalla sigla **ADLC**, usata in ambito enterprise soprattutto come *Agent Development Lifecycle* (IBM, Microsoft, Salesforce) per descrivere come si costruiscono e si governano sistemi agentici *come prodotto* — e, in tradizioni professionali più datate, come *Application Development Life Cycle*, quasi sinonimo di SDLC. Qui il focus è l'opposto del primo significato: usare agenti AI per *sviluppare* software, non costruire agenti.

---

## 1.4 Quando usarlo (e quando no)

AI-DLC è uno strumento per progetti reali. Ha senso adottarlo quando:

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

## 1.5 I prerequisiti

Per usare AI-DLC non servono competenze avanzate, ma tre basi sono necessarie.

**Riga di comando.** Devi saper aprire un terminale (PowerShell o Bash) e lanciare comandi. I tool del framework (`init.ps1`, `validate.ps1`) sono script da eseguire, non interfacce grafiche.

**Markdown base.** I file del framework sono Markdown: titoli, tabelle, liste. Devi saper aprire, leggere e modificare un `.md`. Non serve sapere tutto il Markdown — bastano i costrutti di base.

**Git base.** `clone`, `commit`, `push`, branching di base. Tecnicamente puoi usare AI-DLC senza Git su un progetto locale, ma è fortemente sconsigliato — il versionamento del contesto è parte del valore.

Utili ma non obbligatori: YAML (per gli HALT trigger), JSON (per il manifest), PowerShell scripting (per modificare i tool). Capirai questi file leggendoli; non è necessario scriverli da zero.

---

## 1.6 I concetti fondamentali in sintesi

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
| **Moduli** | `.ai-dlc/modules/` | Regole specifiche per ogni fase, caricati su richiesta |
| **Skill** | `.ai-dlc/modules/skills/` | Guide tematiche (API, Security, Testing, UI, Ops) |

Nei prossimi due capitoli vedremo tutto questo in pratica, su TaskFlow API.

---

## Riepilogo

- AI-DLC risolve quattro problemi: la dimenticanza, l'ignoranza dei vincoli, l'invenzione e l'eccesso di autonomia degli agenti AI.
- Si colloca come evoluzione disciplinata del vibe coding: ne mantiene la velocità, ma affronta il "problema del 70%", l'amnesia del *middle loop* e l'eccesso di autonomia con meccanismi verificabili — in linea con il pattern Planner–Executor–Reviewer riconosciuto in letteratura.
- Non è un tool, non è un'AI, non è specifico per uno stack tecnologico.
- Funziona tramite file Markdown e JSON che vivono nel repository e danno all'agente un contesto strutturato e persistente.
- Ha senso su progetti reali con continuità tra sessioni; non serve per esperimenti brevi.
- Costo di adozione: ~15 minuti iniziali, poi 1-2 minuti per sessione.

Nel prossimo capitolo installiamo AI-DLC su TaskFlow API.
