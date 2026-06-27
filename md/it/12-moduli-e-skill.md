# Capitolo 12 — Moduli e Skill: caricare solo ciò che serve

Nei capitoli precedenti abbiamo usato termini come "il modulo di implementazione" o "la skill di API design" senza spiegarli in dettaglio. È il momento di farlo.

Il framework ADLC è composto da file che non vengono caricati tutti insieme all'inizio di ogni sessione. Vengono caricati selettivamente, in base alla fase in cui sei e al tipo di task che stai svolgendo. Questo è il meccanismo che evita il "context overload" — la situazione in cui l'agente ha così tante regole in testa da non riuscire ad applicarne nessuna bene.

---

## 12.1 La distinzione tra moduli e skill

**I moduli** (`/adlc/modules/NN_*.md`) definiscono le regole operative del framework per ciascuna fase del ciclo di sviluppo. Sono le istruzioni strutturali: come comportarsi, cosa verificare, quando fermarsi. Sono read-only — non li modifichi mai per personalizzare il tuo progetto.

**Le skill** (`/.adlc/modules/skills/SKILL_*.md`) sono guide tematiche specializzate. Definiscono come affrontare un tipo specifico di lavoro: progettare un'API REST, gestire la sicurezza, scrivere test, costruire un'interfaccia UI, gestire le operazioni. Puoi caricare una skill senza necessariamente essere in una fase specifica.

La differenza pratica: il modulo dice "sei in fase di implementazione, segui questo protocollo". La skill dice "stai progettando un'API REST, segui questi principi".

---

## 12.2 La mappa dei moduli

| File | Fase | Quando si carica |
|---|---|---|
| `00_MODE.md` | Sempre | Definisce le regole per ogni Mode (LITE, STANDARD, AUDIT, RAPID, FAST) |
| `01_CORE_RULES.md` | Sempre | Regole base: identity, context management, risk, halt, confidence tags |
| `02_DISCOVERY_ANALYSIS.md` | Fase 0-1 | Discovery e analisi dei requisiti |
| `03_DESIGN.md` | Fase 2 | Architettura e design API/DB |
| `04_IMPLEMENTATION.md` | Fase 3 | Implementazione e test |
| `05_VERIFICATION_RELEASE.md` | Fase 4-5 | QA, release e documentazione finale |
| `06_OPS.md` | Fase 6 | Operazioni, monitoring, incident response |
| `07_SPECIAL_LANES.md` | Su richiesta | Hotfix, spike, parallel track, refactor largo |
| `08_PROMPT_LIBRARY.md` | Su richiesta | Template di prompt riusabili |
| `09_CODEBASE_ANALYSIS.md` | Su richiesta | Analisi di codebase esistenti |
| `10_DOCUMENTATION.md` | Su richiesta | Generazione documentazione |
| `11_BUGFIX_PLAYBOOK.md` | Su richiesta | Debug strutturato |
| `SEC_CONSTRAINTS.md` | Su richiesta | Libreria vincoli di sicurezza |
| `PERF_CONSTRAINTS.md` | Su richiesta | Libreria vincoli di performance |

I moduli `00` e `01` sono sempre caricati — sono le fondamenta del protocollo. Gli altri vengono caricati in base alla fase o su richiesta esplicita.

---

## 12.3 La mappa delle skill

| File | Tipo di lavoro |
|---|---|
| `SKILL_ANALYSIS.md` | Analisi di requisiti, scenari d'uso, identificazione rischi |
| `SKILL_DESIGN.md` | Architettura software, pattern, decisioni strutturali |
| `SKILL_API_DESIGN.md` | Design di API REST: naming, status code, paginazione, error format |
| `SKILL_DATA_ACCESS.md` | Schema DB, ORM, query, migration strategy |
| `SKILL_SECURITY.md` | Revisione sicurezza, threat modeling, SEC-XX in pratica |
| `SKILL_TESTING.md` | Strategie di test, piramide, integration vs unit, mocking |
| `SKILL_UI.md` | Componenti frontend, accessibilità, UX patterns |
| `SKILL_OPS.md` | CI/CD, monitoring, alerting, incident response, runbook |

Le skill sono spesso più utili dei moduli nella pratica quotidiana, perché sono tematiche — non fasi. Puoi essere in Fase 3 e caricare `SKILL_SECURITY.md` per una revisione di sicurezza puntuale, senza cambiare la fase.

---

## 12.4 Come si caricano in una sessione

Il caricamento avviene in due modi.

**Automatico per fase:** quando l'agente legge `Phase: 3-Implementation` in `_CONTEXT.md`, sa che deve usare `04_IMPLEMENTATION.md` come riferimento per le regole di questa sessione. Non devi chiederlo esplicitamente.

**Su richiesta esplicita:** per i moduli non-fase (07-11) e per le skill, puoi chiedere il caricamento direttamente:

> "Carica `SKILL_API_DESIGN.md` — devo progettare il sistema di paginazione di TaskFlow API."

L'agente risponde confermando le regole attive dalla skill:

```
SKILL_API_DESIGN caricata.

Principi attivi:
- Consistency over creativity: tutti gli endpoint seguono gli stessi pattern
- Paginazione per default: mai rispondere con liste non delimitate
- HTTP status code corretti per ogni scenario
- Auth su ogni endpoint non pubblico

Format risposta: { success, data, meta } per successo; { success, error } per errore
Procedo con il design della paginazione?
```

**Con il comando `@load-phase`:** come visto nel Capitolo 6, puoi caricare esplicitamente il modulo di una fase senza cambiare `_CONTEXT.md`:

> "@load-phase 4"

Utile quando fai un task di verifica mentre sei ancora tecnicamente in Fase 3.

---

## 12.5 La skill `SKILL_API_DESIGN` in dettaglio

Per capire concretamente cosa fornisce una skill, vediamo `SKILL_API_DESIGN.md` applicata a TaskFlow API.

Quando Lorenzo carica questa skill e chiede di progettare l'endpoint `GET /tasks`, la skill impone:

**Formato di risposta uniforme:**
```json
{
  "success": true,
  "data": [{ "id": "...", "title": "...", "status": "..." }],
  "meta": {
    "total": 42,
    "limit": 20,
    "nextCursor": "eyJpZCI6MTAwfQ=="
  }
}
```

**Codici HTTP corretti:**
- `200 OK` per lista (anche vuota)
- `400 Bad Request` per params non validi
- `401 Unauthorized` per token mancante
- `403 Forbidden` per ownership violation

**Regole di naming:**
- Sostantivi al plurale per le collection: `/tasks`, non `/task` o `/getTask`
- Sub-resource per le relazioni: `/tasks/:id/comments`, non `/getTaskComments`
- Query params per filtri: `?status=open&assignee=user-123`

Senza la skill, l'agente potrebbe produrre endpoint con convenzioni incoerenti — `getTask` in un posto, `fetchTaskById` in un altro, `200` dove dovrebbe essere `204`. Con la skill attiva, la coerenza è garantita dal protocollo.

---

## 12.6 Skill personalizzate di progetto

Le skill del framework sono generiche. Il tuo progetto può avere esigenze specifiche che meritano una skill dedicata.

Le skill personalizzate vanno in `.adlc/project/skills/`. Per TaskFlow API, Lorenzo ha creato `SKILL_TASKFLOW_DOMAIN.md`:

```markdown
# SKILL — TaskFlow Domain

> Load when working on core domain logic (tasks, projects, assignments).

## Domain Rules
- A Task belongs to exactly one Project
- A Task can be assigned to at most one User at a time
- Status transitions: draft → open → in_progress → done | cancelled
  - Only done and cancelled are terminal states
  - A task in cancelled cannot be re-opened
- The `completed_at` field is set automatically when status → done
- Overdue tasks: dueDate < now AND status NOT IN (done, cancelled)

## Business Invariants
- A user cannot be assigned to a task they don't have access to (Project membership)
- Bulk operations (createMany, updateMany) must validate each item individually
- Deleting a Project cascades to soft-delete its Tasks (isDeleted = true, not physical delete)
```

Quando l'agente lavora sulle entity di dominio, Lorenzo carica questa skill:

> "Carica `SKILL_TASKFLOW_DOMAIN.md` — implementa la logica di transizione di stato per i task."

L'agente sa immediatamente che `cancelled → open` non è una transizione valida, che `completed_at` deve essere settato automaticamente e che le cancellazioni sono soft delete. Non deve chiederlo.

---

## 12.7 Il modulo `07_SPECIAL_LANES`: workflow fuori dal ciclo normale

Alcune situazioni non rientrano nel ciclo Discovery → Ops. Il modulo `07_SPECIAL_LANES.md` copre tre casi speciali:

**Hotfix lane:** bug critico in produzione. Branch da `main`, fix minimale, test, deploy, merge back. Il modulo impone: nessuna feature aggiuntiva nel fix, review obbligatoria anche in emergenza, rollback plan documentato prima del deploy.

**Spike lane:** esplorazione time-boxed (1-2 ore). Branch dedicato, nessun codice che va in produzione senza revisione, obiettivo dichiarato all'inizio ("capire se X è fattibile in Y ore"), risultato documentato in `PROGRESS.md` anche se lo spike fallisce.

**Parallel track:** feature che richiede cambiamenti su più layer contemporaneamente (es. API + frontend). Il modulo definisce tre sync point obbligatori: accordo sul contratto API, integrazione, test end-to-end. Ogni layer sviluppa su un branch separato.

Per attivarlo:

> "Carica `07_SPECIAL_LANES.md` — dobbiamo fare un hotfix su TaskFlow API per il bug #347."

---

## 12.8 Non modificare i moduli del framework

Una regola importante, già menzionata ma vale la pena ribadire: i file in `.adlc/modules/` sono **read-only** durante l'uso normale del framework.

Se vuoi sovrascrivere una regola del framework per il tuo progetto, non modificare il modulo — scrivi la regola alternativa in `.adlc/project/instructions.md`. Le regole di progetto hanno priorità sulle regole del framework.

Modificare i moduli direttamente rompe l'aggiornabilità: quando esce una nuova versione del framework, non puoi aggiornare i moduli senza perdere le tue personalizzazioni.

---

## Riepilogo

- I **moduli** (`modules/NN_*.md`) sono le regole operative per ogni fase — caricati automaticamente in base a `Phase` in `_CONTEXT.md`.
- Le **skill** (`modules/skills/SKILL_*.md`) sono guide tematiche — caricate su richiesta in base al tipo di task.
- Le skill personalizzate di progetto vanno in `.adlc/project/skills/` e hanno priorità sulle skill del framework.
- `07_SPECIAL_LANES.md` copre hotfix, spike e parallel track — attivato su richiesta esplicita.
- I moduli del framework sono read-only: personalizza in `.adlc/project/`, non modificando i file del framework.

Nel prossimo capitolo vediamo i comandi conversazionali: i "comandi" che puoi digitare nella chat con l'agente per controllare il flusso di lavoro senza uscire dalla conversazione.
