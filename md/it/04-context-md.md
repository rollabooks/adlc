# Capitolo 4 — `_CONTEXT.md`: la fonte di verità

In un progetto software tradizionale, il contesto vive nelle teste delle persone: lo stack tecnologico, i vincoli di sicurezza, le decisioni architetturali, le convenzioni del team. Funziona finché il team è piccolo e stabile. Appena entra qualcuno di nuovo — o appena torni su un progetto dopo tre settimane — il contesto deve essere ricostruito da zero.

Con gli agenti AI il problema è amplificato: ogni sessione è un "ingresso di qualcuno di nuovo". L'agente non ha memoria. Senza un documento strutturato, sei tu che ricostruisci il contesto a voce ogni volta.

`_CONTEXT.md` è la risposta a questo problema. È la fonte di verità del progetto: un singolo file Markdown che l'agente legge all'inizio di ogni sessione e che contiene tutto ciò che serve per lavorare correttamente.

---

## 4.1 Dove vive e come viene trovato

`_CONTEXT.md` vive alla radice del tuo progetto. In un monorepo con più sottoprogetti, ogni sottoprogetto può avere il suo (il Capitolo 15 copre questo scenario).

Quando apri una sessione, l'agente segue questo protocollo di ricerca:

1. Cerca `_CONTEXT.md` nella directory corrente.
2. Se non lo trova, risale nelle directory padre fino alla radice del repository.
3. Se ne trova più di uno (monorepo), usa quello più vicino al file su cui sta lavorando.
4. Se non trova nulla, chiede di crearne uno.

Per TaskFlow API, la struttura è semplice:

```text
taskflow-api/
├── _CONTEXT.md          ← unico context, radice del progetto
├── prisma/
├── src/
└── tests/
```

---

## 4.2 La struttura del file

Un `_CONTEXT.md` completo ha quattro sezioni principali. Vediamo quella di TaskFlow API a metà progetto.

### Sezione 1 — Context card (obbligatoria)

La prima tabella è la parte più letta dall'agente: contiene lo stato corrente del progetto.

```markdown
| Param                    | Value                                           |
|--------------------------|-------------------------------------------------|
| Project                  | TaskFlow API                                    |
| Phase                    | 3-Implementation                                |
| Mode                     | STANDARD                                        |
| Active Task              | T-007.2 GET /tasks con filtri e paginazione     |
| Active Task Token Est.   | 5000/1500/6500                                  |
| Active Task Model Level  | 3 Sonnet Low                                    |
| Active Branch            | feat/T-007-tasks-endpoints                      |
| Last Checkpoint          | 2026-06-27 10:47 — POST /tasks completato       |
```

**`Phase`** segue la numerazione AI-DLC da 0 a 6. Non è solo informativa: determina quali moduli il framework suggerisce di caricare. Un agente in Phase 2 (Design) pensa in termini di architettura e contratti API; lo stesso agente in Phase 3 (Implementation) si concentra su codice e test.

**`Mode`** controlla il livello di cerimonia. È il parametro su cui tornerai più spesso nel corso del progetto — il Capitolo 6 lo spiega in dettaglio.

**`Active Task`** è la cosa su cui stai lavorando adesso. L'ID (`T-007.2`) è la chiave che collega il context ai file di task e al diario in `PROGRESS.md`. Non deve essere perfetto — può essere anche solo una descrizione in prosa se non hai un sistema di task strutturato.

**`Active Task Token Est.`** è la stima `input/output/totale` in token. Serve per scegliere il modello AI giusto: un task da 5k token totali non ha senso eseguirlo sul modello più costoso. Il Capitolo 8 spiega come stimare.

**`Active Task Model Level`** va da 1 a 7. È il livello di "potenza AI" necessario per il task. Anche questa è una stima — si affina nel tempo man mano che impari a valutare la complessità dei task.

### Sezione 2 — Stack (obbligatoria)

```markdown
## Stack
| Layer      | Technology                  |
|------------|-----------------------------|
| Runtime    | Node.js 22                  |
| Framework  | Fastify 5                   |
| Database   | PostgreSQL 16 + Prisma ORM  |
| Auth       | OIDC + JWT (jose library)   |
| Testing    | Vitest + Supertest          |
| Deploy     | Docker + Railway            |
| CI         | GitHub Actions              |
```

L'agente usa questa tabella per fare scelte coerenti senza dover chiedere. Se proponi di aggiungere un endpoint, non ti chiede "usi Express o Fastify?" — lo sa già. Se vuole scrivere un test, scrive Vitest, non Jest.

### Sezione 3 — Vincoli di sicurezza (obbligatoria se applicabile)

```markdown
## Security Constraints
| ID     | Name              | Spec                                        |
|--------|-------------------|---------------------------------------------|
| SEC-01 | Input Validation  | Zod schema obbligatorio su ogni endpoint    |
| SEC-02 | Authentication    | OIDC, JWT con rotazione refresh token       |
| SEC-03 | Logging           | Nessun token, password o dato PII nei log   |
| SEC-04 | Rate Limiting     | Max 100 req/min per IP su /auth/*           |
| SEC-05 | CORS              | Whitelist esplicita, no wildcard in prod    |
```

Questi vincoli vengono riletti dall'agente prima di generare codice in zone sensibili. Se l'agente sta scrivendo un handler di autenticazione, controlla SEC-02 e SEC-03 prima di produrre output. Non perché glielo dici ogni volta — perché è nel protocollo obbligatorio del framework.

I codici `SEC-XX` sono riusabili: se lavori a più progetti con requisiti simili, il significato di `SEC-02` (autenticazione) è sempre lo stesso. Cambia solo la `Spec` specifica.

### Sezione 4 — Vincoli di performance (obbligatoria se applicabile)

```markdown
## Performance Constraints
| ID      | Name           | Target                         |
|---------|----------------|--------------------------------|
| PERF-01 | Latency        | P95 < 200ms per endpoint API   |
| PERF-02 | Payload Size   | Max 1MB per risposta           |
| PERF-03 | DB Queries     | Max 3 query per request        |
```

---

## 4.3 Sezioni opzionali utili

Oltre alle quattro sezioni base, ci sono alcune sezioni opzionali che diventano essenziali su progetti di una certa complessità.

### Decisioni architetturali aperte

```markdown
## Open Decisions
| ID    | Decision                        | Options              | Deadline   |
|-------|---------------------------------|----------------------|------------|
| AD-01 | Paginazione cursor vs offset    | cursor / offset      | 2026-07-05 |
| AD-02 | Strategia di cache              | Redis / in-memory    | TBD        |
```

Le decisioni aperte sono quelle che non hai ancora preso e che l'agente non deve prendere da solo. Se trova `AD-01` qui, non sceglierà una strategia di paginazione arbitrariamente — ti chiederà di decidere.

### Note per l'agente

```markdown
## Agent Notes
- Priorità: qualità del codice > velocità. Mai sacrificare la leggibilità per brevità.
- Per i test: integration test su DB reale, no mock di Prisma.
- Naming: snake_case per DB, camelCase per TypeScript, kebab-case per file.
```

Le note sono istruzioni generali che non rientrano nello stack o nei vincoli ma che devono essere rispettate sistematicamente. Sono diverse da `.ai-dlc/project/instructions.md` (che contiene regole più strutturate) — qui metti cose che vuoi sempre visibili nella context card.

---

## 4.4 Come aggiornare `_CONTEXT.md`

Il file va aggiornato ogni volta che cambia qualcosa di significativo:

- **Cambio di fase**: da Design a Implementation, da Implementation a Verification.
- **Cambio di task**: quando finisci un task e ne inizi un altro.
- **Cambio di vincoli**: aggiungi un requisito SEC, modifichi un target PERF.
- **Decisione architetturale**: una `Open Decision` viene presa — rimuovila dalla sezione e aggiungila allo stack o alle note.

Il modo più pratico è usare il comando conversazionale `@context-update`:

> "@context-update — ho completato T-007.2, passo a T-008 GET /tasks/:id"

L'agente produce il blocco aggiornato da incollare nel file. Tu rivedi, aggiusti se necessario, e salvi. Il file rimane tuo — l'agente propone, tu decidi.

---

## 4.5 Template minimo vs template completo

Il framework offre due template:

**Template completo** (`.ai-dlc/modules/templates/CONTEXT_TEMPLATE.md`): ha tutti i campi, incluse sezioni per decisioni architetturali, note per l'agente e parametri avanzati. Adatto a progetti di media-grande complessità o a team.

**Template minimo** (`.ai-dlc/modules/templates/CONTEXT_MIN.md`): solo context card, stack e vincoli essenziali. Adatto a spike, POC o progetti personali semplici.

Per TaskFlow API, Lorenzo è partito dal template minimo e ha aggiunto le sezioni man mano che il progetto cresceva.

> **Regola pratica:** inizia sempre dal minimo. Un `_CONTEXT.md` parzialmente compilato è meglio di uno vuoto o inesistente. Aggiungi sezioni quando ne senti la necessità.

---

## 4.6 Errori comuni

**Lasciare i placeholder senza valore.** Il validator segnala warning se `Active Task Token Est.` o `Active Task Model Level` contengono `[placeholder]`. Non blocca il lavoro, ma è un segnale che il contesto è incompleto.

**Scrivere il contesto una volta sola e non aggiornarlo.** `_CONTEXT.md` che non viene aggiornato è un contesto che mente. Dopo una settimana senza aggiornamenti, l'agente lavora su informazioni obsolete.

**Mettere troppe cose nel context.** Il file deve essere conciso. Le regole dettagliate del progetto vanno in `.ai-dlc/project/instructions.md`. Le convenzioni di codice vanno in `.ai-dlc/project/conventions.md`. Il context contiene lo stato attuale, non il manuale del progetto.

**Non committare `_CONTEXT.md`.** Il file deve essere in git. È parte del progetto, non un file temporaneo. Il suo storico di versioni è prezioso: puoi vedere come è evoluto il progetto nel tempo.

---

## 4.7 Il contesto non è magia

Vale la pena essere onesti su un punto che la ricerca recente ha messo in evidenza. Gli studi empirici sui file di contesto (`_CONTEXT.md`, `AGENTS.md`, `CLAUDE.md`) danno risultati misti: un file mal progettato, troppo lungo o non aggiornato può aumentare il costo in token e perfino peggiorare l'aderenza dell'agente invece di migliorarla. Un `_CONTEXT.md` non è un talismano — è una scelta di design che vale solo se trattata con disciplina ingegneristica.

Tre principi che la letteratura conferma:

- **Minimalità.** Più contesto non è meglio. Includi solo ciò che cambia il comportamento dell'agente; rimuovi il resto. Le panoramiche generiche del progetto sono poco utili — i vincoli concreti, i comandi esatti e le modalità di fallimento note sono ciò che fa la differenza.
- **Aggiornamento.** Il fenomeno del *context rot* — l'invecchiamento del contesto rispetto al codice reale — è documentato in letteratura: un `_CONTEXT.md` che diverge dal repository diventa una fonte di errori, non di verità. È lo stesso problema della documentazione che non viene mantenuta, applicato agli artefatti per agenti.
- **Specificità.** Un vincolo vago (`usa buone pratiche di sicurezza`) non orienta l'agente. Un vincolo specifico (`SEC-03: redaction di password, token, email nei log con Pino`) sì.

Il valore di `_CONTEXT.md` non è automatico: dipende interamente da quanto bene lo mantieni. I capitoli sulla classificazione del rischio e sui confidence tag (Parte III) e il ciclo di checkpoint (Capitolo 3) esistono proprio per imporre questa disciplina.

---

## 4.8 Context engineering: perché meno contesto rende di più

I tre principi del paragrafo precedente non sono regole arbitrarie: discendono da una disciplina che nel 2026 ha un nome preciso, il **context engineering**. Se il *prompt engineering* ottimizza la singola istruzione, il context engineering progetta l'**architettura minima di informazioni, vincoli e strumenti** che permette all'agente di lavorare bene per un'intera sessione. Anthropic lo descrive come l'evoluzione naturale del prompt engineering, resa necessaria dagli agenti che operano in cicli lunghi. In fondo, AI-DLC è context engineering applicato: `_CONTEXT.md`, il caricamento modulare per fase e il ciclo di `@checkpoint` sono tutte sue mosse.

Capire *perché* il contesto minimale rende di più aiuta ad applicarlo bene. Tre meccanismi, tutti documentati:

- **Budget di attenzione.** Il modello ha un'attenzione finita: ogni token irrilevante diluisce quella disponibile per i token che contano. Una sessione che si riempie di rumore — scambi ridondanti, riletture degli stessi file, output prolissi dei tool — degrada le prestazioni *anche molto prima* di saturare il limite teorico della finestra di contesto. È il lato dinamico del *context rot*.
- **"Lost in the middle".** I modelli Transformer tendono a "vedere" meglio l'inizio e la fine dell'input che la sua parte centrale: un vincolo di sicurezza sepolto a metà di un contesto gonfio rischia di essere ignorato. Tradotto: tieni `_CONTEXT.md` corto e i vincoli in evidenza.
- **Costo.** L'attenzione cresce in modo quadratico con la lunghezza del contesto. Un prompt gonfio non è solo più lento e costoso (gli studi misurano oltre il 20% di costo in più con file di contesto mal progettati): è anche più rumoroso.

Per questo AI-DLC non carica tutto in una volta. Tiene sempre attivo solo `_CONTEXT.md` (stato e vincoli invalicabili) e include il modulo di fase (es. `04_IMPLEMENTATION.md`) o la skill tematica solo quando servono, scaricandoli dopo. Lo stesso vale per `@checkpoint`: comprimere periodicamente il lavoro svolto in uno stato pulito è una tecnica di *context compaction* che riporta il rapporto segnale-rumore a livelli sani.

> **E l'MCP?** Il *Model Context Protocol* (MCP), molto diffuso nel 2026, permette agli agenti di connettersi a fonti dati e strumenti esterni (database, API, log). Non sostituisce i file di contesto: i due livelli sono complementari. File come `_CONTEXT.md` e `AGENTS.md` danno all'agente il **discernimento** (cosa fare, perché, con quali vincoli); l'MCP fornisce gli **strumenti** per agire (come accedere ai dati). Il cervello resta nei file versionati nel repository; l'MCP sono i muscoli.

---

## Riepilogo

- `_CONTEXT.md` è il singolo file che dà all'agente il contesto strutturato per lavorare correttamente senza istruzioni ripetute.
- Contiene: context card (fase, task, mode), stack, vincoli SEC e PERF, e sezioni opzionali come decisioni aperte e note.
- Va aggiornato a ogni cambio di fase, task o vincolo — idealmente con `@context-update` alla fine di ogni sessione.
- Inizia dal template minimo; aggiungi sezioni man mano che il progetto cresce.
- È un file git come gli altri: committalo, versionalo, non lasciarlo stale.
- Tienilo **minimale**: il valore del contesto dipende dal rapporto segnale-rumore (*context engineering*), non dalla quantità.

Nel prossimo capitolo vediamo il compagno di `_CONTEXT.md`: `PROGRESS.md`, il diario di bordo delle sessioni.
