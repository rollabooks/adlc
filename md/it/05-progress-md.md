# Capitolo 5 — `PROGRESS.md` e il cambio di fase

`_CONTEXT.md` fotografa il presente: dove sei adesso, cosa stai facendo, quali vincoli rispettare. Ma non risponde a domande come "perché abbiamo scelto Prisma invece di Drizzle?" o "cosa è successo nella sessione di giovedì scorso quando il deploy è andato storto?"

Quelle risposte vivono in `PROGRESS.md`.

---

## 5.1 La differenza tra context e progress

La distinzione è semplice ma importante:

| `_CONTEXT.md` | `PROGRESS.md` |
|---|---|
| Stato attuale | Storia del progetto |
| Si sovrascrive | Cresce solo in avanti |
| L'agente lo legge sempre | L'agente lo legge su richiesta o a inizio sessione |
| Fotografa dove sei | Registra da dove sei venuto |
| Conciso per design | Può essere lungo |

Pensa a `_CONTEXT.md` come al cruscotto di un'auto — mostra la velocità attuale, il carburante, la temperatura. Pensa a `PROGRESS.md` come al libretto di manutenzione — registra ogni intervento, ogni anomalia, ogni decisione presa nel tempo.

---

## 5.2 Struttura di `PROGRESS.md`

Il file cresce dall'alto verso il basso: le voci più recenti sono in cima. Ogni voce corrisponde a una sessione o a un evento significativo.

```markdown
# PROGRESS — TaskFlow API

---

## 2026-07-03 — T-009 Auth middleware refactor

- Estratto il middleware JWT da `src/routes/tasks.ts` in `src/middleware/auth.ts`
- Aggiunto test unitario per token scaduto (copriva un bug latente)
- Identificato: il validator Zod eseguiva dopo il middleware auth — corretto l'ordine
- Prossima sessione: applicare stesso refactor a /projects endpoints

DECISIONE: mantenere un singolo middleware condiviso invece di per-route.
Motivazione: riduce duplicazione e rende il comportamento coerente per futuri endpoint.

---

## 2026-07-01 — T-008 GET /tasks/:id

- Implementato endpoint con gestione 404 esplicita (RFC 7807)
- Scoperto: Prisma lancia `PrismaClientKnownRequestError` su record non trovato,
  non restituisce null. Aggiunto `catch` specifico.
- 3 test passanti: 200, 404, 401

---

## 2026-06-27 — T-007 POST /tasks (70%)

- Implementato POST /tasks: validazione Zod, auth JWT, errori RFC 7807
- 4 test di integrazione passanti
- Migration: add-task-userid-index (dev only, staging pending)
- HALT trigger attivato per schema.prisma → confermato e proceduto

---

## 2026-06-25 — Setup iniziale AI-DLC

- Aggiunto framework AI-DLC v3.3.0 al repository
- Compilato _CONTEXT.md con stack, SEC-01..SEC-05, PERF-01..PERF-03
- Validazione: 2 warning risolti (placeholder token est.)
- Prima sessione di lavoro: bootstrap confermato correttamente
```

---

## 5.3 Cosa scrivere in ogni voce

Una voce di PROGRESS.md utile contiene tre tipi di informazioni:

**Fatto** — cosa è stato prodotto o modificato concretamente.
> "Implementato endpoint POST /tasks con validazione Zod e gestione errori RFC 7807."

**Scoperta** — qualcosa di non ovvio trovato durante il lavoro. Bug latenti, comportamenti inaspettati delle librerie, assunzioni sbagliate.
> "Scoperto: Prisma lancia `PrismaClientKnownRequestError` su record non trovato, non restituisce null."

**Decisione** — una scelta architetturale, di design o di processo, con la motivazione.
> "DECISIONE: middleware JWT condiviso invece che per-route. Motivazione: riduce duplicazione e garantisce comportamento coerente."

Le scoperte e le decisioni sono le più preziose. Sono le cose che non si deducono dal codice — sono il contesto dietro al codice. Senza `PROGRESS.md`, quella conoscenza evapora alla fine della sessione.

---

## 5.4 Come `PROGRESS.md` accelera le sessioni future

Immagina che il giorno dopo, Giulia — un'altra sviluppatrice del team — apra una sessione su TaskFlow API. Non era presente giovedì quando Lorenzo ha fatto il refactor del middleware. Chiede all'agente:

> "Carica `_CONTEXT.md` e `PROGRESS.md`, poi dimmi cosa è cambiato nell'autenticazione nelle ultime due settimane."

L'agente legge entrambi i file e risponde:

> "Dal PROGRESS.md: il 3 luglio è stato estratto il middleware JWT in `src/middleware/auth.ts` (era in `src/routes/tasks.ts`). È stata presa la decisione architetturale di usare un singolo middleware condiviso. È stato trovato e corretto un bug nell'ordine Zod/auth. Il middleware deve ancora essere applicato a `/projects` (prossima sessione)."

Giulia ha il contesto completo in trenta secondi. Non ha bisogno di leggere la git history, non ha bisogno di chiedere a Lorenzo.

---

## 5.5 Il cambio di fase

Una delle voci più importanti in `PROGRESS.md` è il cambio di fase. Quando passi da Design a Implementation, da Implementation a Verification, da Verification a Release, va registrato.

```markdown
## 2026-07-15 — CAMBIO FASE: Design → Implementation

Stack confermato: Node.js 22 / Fastify 5 / PostgreSQL 16 / Prisma
Decisioni architetturali prese:
- Paginazione: cursor-based (AD-01 chiusa)
- Cache: nessuna al primo rilascio (AD-02 rimandata)
- Struttura: monolite modulare, non microservizi

API contract definito: 12 endpoint (vedi docs/api-contract.md)
Schema DB v1 migrato in dev

Primo task in Phase 3: T-001 Setup struttura cartelle e dipendenze
```

Questa voce serve da spartiacque: tutto sopra è storia di design, tutto sotto è storia di implementazione. Quando qualcuno (umano o agente) cerca il "perché" di una scelta strutturale, sa dove guardare.

---

## 5.6 Aggiornare `PROGRESS.md` senza sforzo

Il rischio con i diari di progetto è che vengano abbandonati perché richiedono troppo sforzo. AI-DLC risolve questo problema delegando la stesura all'agente.

Alla fine di ogni sessione (o dopo un `@checkpoint`), chiedi:

> "@checkpoint — proponi una voce per PROGRESS.md"

L'agente produce una voce pronta. Tu la revisioni, magari aggiungi una riga di contesto che solo tu conosci, e la incolli nel file. Trenta secondi di lavoro.

La voce generata sarà nei fatti accurata — l'agente sa cosa ha fatto in quella sessione. Le scoperte e le decisioni invece richiedono spesso il tuo intervento: l'agente può registrare che hai scelto il middleware condiviso, ma solo tu puoi aggiungere "perché avevamo visto questo schema fallire in un progetto precedente".

---

## 5.7 PROGRESS.md in team

In un team di tre persone, `PROGRESS.md` diventa il canale di comunicazione asincrona sul progetto. Ogni sviluppatore scrive la propria voce alla fine della sessione. Il file cresce come un log.

L'agente, quando lavora con un membro del team che non era presente in una sessione precedente, legge automaticamente le voci recenti per aggiornare il contesto. Non c'è bisogno di sincronizzare a voce o di mettere nota su Slack — il PROGRESS.md è già lì.

> **Attenzione:** `PROGRESS.md` non sostituisce la comunicazione di team. Non è una board kanban, non è un sistema di ticket, non è un sistema di review. È un diario tecnico che integra il contesto degli agenti AI. Tenete separati i due strumenti.

---

## Riepilogo

- `PROGRESS.md` registra la storia del progetto: cosa è stato fatto, cosa è stato scoperto, quali decisioni sono state prese e perché.
- Si aggiorna a fine sessione — tipicamente con `@checkpoint` che genera la voce, poi tu la revisioni.
- Le voci più preziose sono le **scoperte** (bug, comportamenti inaspettati) e le **decisioni** (con motivazione): sono il contesto che il codice da solo non trasmette.
- Il cambio di fase è una voce speciale che documenta lo spartiacque tra una fase e l'altra.
- In team, `PROGRESS.md` permette agli agenti di ricostruire il contesto delle sessioni di altri membri senza sincronizzazione manuale.

Nel prossimo capitolo completiamo la Parte II con le Fasi e i Modes: come calibrare il comportamento dell'agente in base a dove sei nel progetto e a quanto overhead vuoi.
