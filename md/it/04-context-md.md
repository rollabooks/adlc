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

```
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

**`Phase`** segue la numerazione ADLC da 0 a 6. Non è solo informativa: determina quali moduli il framework suggerisce di caricare. Un agente in Phase 2 (Design) pensa in termini di architettura e contratti API; lo stesso agente in Phase 3 (Implementation) si concentra su codice e test.

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

Le note sono istruzioni generali che non rientrano nello stack o nei vincoli ma che devono essere rispettate sistematicamente. Sono diverse da `.adlc/project/instructions.md` (che contiene regole più strutturate) — qui metti cose che vuoi sempre visibili nella context card.

---

## 4.4 Come aggiornare `_CONTEXT.md`

Il file va aggiornato ogni volta che cambia qualcosa di significativo:

- **Cambio di fase**: da Design a Implementation, da Implementation a Verification.
- **Cambio di task**: quando finisci un task e ne inizi un altro.
- **Cambio di vincoli**: aggiungi un requisito SEC, modifichi un target PERF.
- **Decisione architettuale**: una `Open Decision` viene presa — rimuovila dalla sezione e aggiungila allo stack o alle note.

Il modo più pratico è usare il comando conversazionale `@context-update`:

> "@context-update — ho completato T-007.2, passo a T-008 GET /tasks/:id"

L'agente produce il blocco aggiornato da incollare nel file. Tu rivedi, aggiusti se necessario, e salvi. Il file rimane tuo — l'agente propone, tu decidi.

---

## 4.5 Template minimo vs template completo

Il framework offre due template:

**Template completo** (`.adlc/modules/templates/CONTEXT_TEMPLATE.md`): ha tutti i campi, incluse sezioni per decisioni architetturali, note per l'agente e parametri avanzati. Adatto a progetti di media-grande complessità o a team.

**Template minimo** (`.adlc/modules/templates/CONTEXT_MIN.md`): solo context card, stack e vincoli essenziali. Adatto a spike, POC o progetti personali semplici.

Per TaskFlow API, Lorenzo è partito dal template minimo e ha aggiunto le sezioni man mano che il progetto cresceva.

> **Regola pratica:** inizia sempre dal minimo. Un `_CONTEXT.md` parzialmente compilato è meglio di uno vuoto o inesistente. Aggiungi sezioni quando ne senti la necessità.

---

## 4.6 Errori comuni

**Lasciare i placeholder senza valore.** Il validator segnala warning se `Active Task Token Est.` o `Active Task Model Level` contengono `[placeholder]`. Non blocca il lavoro, ma è un segnale che il contesto è incompleto.

**Scrivere il contesto una volta sola e non aggiornarlo.** `_CONTEXT.md` che non viene aggiornato è un contesto che mente. Dopo una settimana senza aggiornamenti, l'agente lavora su informazioni obsolete.

**Mettere troppe cose nel context.** Il file deve essere conciso. Le regole dettagliate del progetto vanno in `.adlc/project/instructions.md`. Le convenzioni di codice vanno in `.adlc/project/conventions.md`. Il context contiene lo stato attuale, non il manuale del progetto.

**Non committare `_CONTEXT.md`.** Il file deve essere in git. È parte del progetto, non un file temporaneo. Il suo storico di versioni è prezioso: puoi vedere come è evoluto il progetto nel tempo.

---

## Riepilogo

- `_CONTEXT.md` è il singolo file che dà all'agente il contesto strutturato per lavorare correttamente senza istruzioni ripetute.
- Contiene: context card (fase, task, mode), stack, vincoli SEC e PERF, e sezioni opzionali come decisioni aperte e note.
- Va aggiornato a ogni cambio di fase, task o vincolo — idealmente con `@context-update` alla fine di ogni sessione.
- Inizia dal template minimo; aggiungi sezioni man mano che il progetto cresce.
- È un file git come gli altri: committalo, versionalo, non lasciarlo stale.

Nel prossimo capitolo vediamo il compagno di `_CONTEXT.md`: `PROGRESS.md`, il diario di bordo delle sessioni.
