# Capitolo 3 — Una sessione di lavoro reale

È martedì mattina. Lorenzo apre il terminale, avvia Claude Code e inizia la sessione su TaskFlow API. Seguiamo ogni passaggio, dal bootstrap al commit finale, per vedere AI-DLC in azione su un caso concreto.

> *TaskFlow API ha attraversato le fasi 0-2 nelle settimane precedenti. I requisiti sono stati analizzati, l'architettura definita (schema DB, contratto API con 12 endpoint), le decisioni aperte chiuse. Lorenzo ha aggiornato `_CONTEXT.md` a `Phase: 3-Implementation` al termine del design. Da questo punto inizia il lavoro che seguiamo ora.*

Il task di oggi: implementare l'endpoint `POST /tasks` — il cuore dell'API, quello che crea un nuovo task per un utente autenticato.

---

## 3.1 Inizio sessione — il bootstrap

Lorenzo non spiega nulla all'agente. Chiede solo:

> "Carica `_CONTEXT.md` e confermami il contesto."

L'agente risponde:

> `Context: TaskFlow API | Phase: 3-Implementation | Task: T-007 POST /tasks endpoint | Stack: Node.js 22/Fastify 5/PostgreSQL 16 | Constraints: SEC-01 (Zod), SEC-02 (OIDC/JWT), SEC-03 (no PII log), PERF-01 (P95<200ms), PERF-02 (max 1MB). Proceed?`

In tre secondi, l'agente sa tutto. Lorenzo scrive:

> "Procedi."

Questo è il punto in cui, senza AI-DLC, Lorenzo avrebbe passato dieci minuti a riepilogare lo stack, i vincoli e il contesto del task. Con AI-DLC, quella conversazione è già nel file.

> **Prima e dopo — Senza AI-DLC / Con AI-DLC**

| Senza AI-DLC | Con AI-DLC |
|---|---|
| Dieci minuti per riepilogare stack, vincoli e contesto del task | Bootstrap: l'agente conferma tutto in pochi secondi leggendo il file |
| Ripeti a voce "usiamo Zod, auth OIDC, niente PII nei log" | I vincoli SEC/PERF sono già nel contesto: l'agente li cita da solo |

> **Pattern da seguire:** all'inizio di ogni sessione, chiedi sempre la conferma del contesto prima di qualsiasi istruzione. È il modo per verificare che l'agente abbia letto `_CONTEXT.md` correttamente.

---

## 3.2 Task LOW — una modifica senza freni

Lorenzo comincia con un task leggero: aggiungere JSDoc all'interfaccia `Task` già esistente. È una modifica LOW-risk: documentazione, nessun impatto sulla logica.

> "Aggiungi JSDoc all'interfaccia `Task` in `src/types/task.ts`. Segui lo stile già usato in `src/types/user.ts`."

L'agente legge entrambi i file, produce il JSDoc coerente con lo stile del progetto, e notifica:

> `[LOW] Added JSDoc to Task interface (4 fields documented). No risk items. Changes in: src/types/task.ts`

Per i task LOW, l'agente esegue e notifica senza aspettare approvazione. Non c'è cerimonia extra. Il flusso rimane fluido.

Lorenzo guarda il diff, va bene, conferma con un `git add` mentalmente e passa al task reale.

---

## 3.3 Task MEDIUM — proposta e approvazione

È il momento di costruire l'endpoint. Lorenzo chiede:

> "Implementa `POST /tasks`. L'endpoint riceve titolo, descrizione e scadenza, crea il task per l'utente autenticato, e risponde 201 con il task creato."

L'agente classifica la richiesta come MEDIUM (nuova feature, logica di business) e risponde con un piano prima di scrivere codice:

---

*Piano per `POST /tasks`:*

*1. Route handler in `src/routes/tasks.ts`*
*   - Validazione input: Zod schema (titolo obbligatorio, descrizione opzionale, scadenza ISO 8601)*
*   - Estrazione `userId` dal JWT (SEC-02: token verificato dal middleware auth)*
*   - Nessun `userId` nei log (SEC-03)*

*2. Service layer in `src/services/taskService.ts`*
*   - `createTask(userId, data)` che chiama Prisma*
*   - Errore 400 se dati non validi, 401 se non autenticato, 500 per errori DB*
*   - Formato errori: RFC 7807 (da `project/instructions.md`)*

*3. Test di integrazione in `tests/routes/tasks.test.ts`*
*   - Caso felice: utente autenticato, dati validi → 201*
*   - Token mancante → 401*
*   - Titolo mancante → 400*

*Stima: ~80 righe di codice + ~60 righe di test. Token estimate: 4k input / 1.5k output. Model Level: 3.*

*Procedo?*

---

Lorenzo legge il piano. È quello che si aspettava, con una cosa in più: il piano cita esplicitamente SEC-02 e SEC-03. L'agente ha riletto i vincoli dal context e li ha integrati nel design senza che Lorenzo dovesse menzionarli.

Risponde:

> "Sì, procedi. Aggiungi anche il caso di test per titolo troppo lungo (>200 caratteri)."

L'agente implementa, caso aggiunto incluso.

> **Differenza chiave rispetto al lavoro senza AI-DLC:** senza context strutturato, Lorenzo avrebbe dovuto specificare "ricorda che usiamo Zod, che l'auth è OIDC e che non voglio PII nei log" ogni volta. Con AI-DLC, queste informazioni sono già nel piano — l'agente le ha lette dal context.

---

## 3.4 Task HIGH — l'HALT in azione

Mentre lavora, Lorenzo nota che il Prisma schema non ha un indice su `userId` nella tabella `tasks`. Senza indice, le query per utente diventano full table scan al crescere dei dati. Chiede all'agente di aggiungerlo.

> "Aggiungi un indice su `userId` nella tabella `tasks` in `prisma/schema.prisma`."

L'agente si ferma.

> `⚠ HALT — schema/migrations path detected`
>
> *Il file `prisma/schema.prisma` corrisponde al pattern `**/schema.prisma` negli HALT trigger.*
>
> *Proposta di modifica:*
> *Aggiunta di `@@index([userId])` in `model Task`. Richiede una migration (`prisma migrate dev --name add-task-userid-index`).*
>
> *Risk: MEDIUM. La migration è non-destructive (solo aggiunta indice). Nessun dato a rischio.*
> *Attenzione: in ambiente di produzione la migration applica un lock temporaneo sulla tabella.*
>
> *Conferma esplicita richiesta. Procedo?*

Lorenzo ha due informazioni che senza AI-DLC avrebbe potuto non considerare: che la migration richiede un lock temporaneo in produzione, e che la modifica è classificata come HALT perché tocca lo schema. Sa che è non-distruttiva, sa il rischio.

Risponde:

> "Confermato. Procedi con schema e migration."

L'agente aggiunge l'indice allo schema e genera il file di migration. Non aveva bisogno di essere fermato — l'operazione era sicura — ma il processo di HALT ha reso espliciti i dettagli che meritavano attenzione.

---

## 3.5 Il checkpoint

Dopo circa un'ora di lavoro, Lorenzo ha implementato l'endpoint, i test, e aggiunto l'indice. Manda un checkpoint:

> "@checkpoint"

L'agente risponde con un riepilogo:

> *Checkpoint — TaskFlow API | 2026-06-27 10:47*
>
> *Completato:*
> *- POST /tasks: route, service, validazione Zod, gestione errori RFC 7807*
> *- Test di integrazione: 4 casi (201, 400 titolo mancante, 400 titolo troppo lungo, 401 no auth)*
> *- Migration: add-task-userid-index*
>
> *In corso: niente di sospeso*
>
> *Blocchi: nessuno*
>
> *Aggiornamento `_CONTEXT.md` consigliato: T-007 avanzato al 70%. Prossimo sotto-task: query endpoint GET /tasks.*
>
> *Vuoi che proponga il blocco aggiornato per `_CONTEXT.md`?*

Lorenzo dice sì. L'agente produce il blocco da incollare. Lorenzo fa `@context-update` e incolla il testo nel file. Il contesto è aggiornato.

---

## 3.6 Fine sessione

È quasi l'ora di pranzo. Lorenzo non ha finito il task, ma ha fatto un lavoro solido. Chiede all'agente di chiudere la sessione:

> "@checkpoint — chiudo la sessione."

L'agente produce due cose:

**Aggiornamento `_CONTEXT.md`:**
```markdown
| Active Task | T-007.2 GET /tasks endpoint (prossima sessione)  |
| Active Task Token Est. | 5000/1500/6500 |
```

**Voce per `PROGRESS.md`:**
```markdown
## 2026-06-27 — T-007 POST /tasks (70%)
- Implementato endpoint POST /tasks con validazione Zod, auth JWT, errori RFC 7807
- 4 test di integrazione passanti
- Migration: add-task-userid-index (applicata in dev, non ancora in staging)
- Prossima sessione: GET /tasks con filtri e paginazione (T-007.2)
```

Lorenzo copia i due blocchi nei rispettivi file, fa il commit, chiude il terminale.

Domani, quando riaprirà la sessione, l'agente saprà esattamente dove erano rimasti. Il contesto è lì, nel file.

---

## 3.7 Il ciclo completo in sintesi

Una sessione AI-DLC segue sempre lo stesso schema:

```
INIZIO SESSIONE
    └─ Chiedi conferma contesto → l'agente legge _CONTEXT.md

DURANTE LA SESSIONE
    ├─ Task LOW     → agente esegue + notifica
    ├─ Task MEDIUM  → agente propone piano → tu approvi → agente esegue
    ├─ Task HIGH    → agente HALT → spiega rischi → tu confermi → agente esegue
    └─ @checkpoint  → ogni 3-5 azioni significative

FINE SESSIONE
    └─ @checkpoint → aggiorna _CONTEXT.md + voce PROGRESS.md → commit
```

![Il ciclo di una sessione AI-DLC, dal bootstrap al checkpoint](figures/it/ch03-ciclo-sessione.png)

Il tempo extra che spendi in questo ciclo — i checkpoint, le conferme, il bootstrap — è di pochi minuti per sessione. Il tempo che risparmi è tutto quello che normalmente spendi a ripetere le stesse istruzioni, a correggere vincoli dimenticati e a ricostruire il contesto perduto.

---

## Riepilogo

- Il **bootstrap** (conferma contesto all'inizio della sessione) assicura che l'agente abbia letto `_CONTEXT.md` prima di qualsiasi lavoro.
- I task **LOW** vengono eseguiti direttamente; i task **MEDIUM** richiedono approvazione del piano; i task **HIGH** richiedono conferma esplicita dopo un HALT.
- Il **checkpoint** ogni 3-5 azioni fissa un punto fermo e mantiene `_CONTEXT.md` e `PROGRESS.md` aggiornati.
- La **fine sessione** è un checkpoint esplicito che produce gli aggiornamenti da committare.

Nei prossimi capitoli esploriamo in dettaglio i meccanismi che rendono possibile tutto questo, a partire dal cuore del sistema: `_CONTEXT.md`.
