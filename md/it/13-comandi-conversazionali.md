# Capitolo 13 — Comandi conversazionali

I comandi conversazionali sono istruzioni che dai all'agente nella chat, precedute dal prefisso `@`. Non sono comandi shell — non aprono un terminale, non eseguono script. Sono segnali semantici che l'agente riconosce e interpreta secondo il protocollo AI-DLC.

La loro utilità è nella velocità: invece di spiegare in prosa cosa vuoi fare, scrivi `@checkpoint` e l'agente sa esattamente cosa produrre. Invece di dire "mostrami i vincoli di sicurezza attivi", scrivi `@show-constraints`.

---

## 13.1 La lista completa

| Comando | Scopo | Output atteso |
|---|---|---|
| `@checkpoint` | Fissa il punto di avanzamento corrente | Completato, prossimi passi, blocchi, proposta update `_CONTEXT.md` e voce `PROGRESS.md` |
| `@context-update` | Propone un aggiornamento al context | Blocco Markdown da incollare in `_CONTEXT.md` |
| `@show-constraints` | Mostra i vincoli SEC/PERF attivi | Tabella con vincoli e spec |
| `@security-check` | Verifica il piano/codice corrente contro i SEC attivi | Finding, rischi, fix richiesti |
| `@perf-check` | Verifica il piano/codice corrente contro i PERF attivi | Finding, rischi, fix richiesti |
| `@load-phase [N]` | Carica il modulo della fase N | Nome modulo + riepilogo regole attive |
| `@set-phase [N]` | Propone il cambio di fase | Modifiche necessarie + richiesta conferma |
| `@prompt-list` | Lista i prompt riusabili disponibili | ID e descrizione breve di ogni prompt |
| `@prompt [ID]` | Applica un template di prompt | Prompt compilato o domande di chiarimento |
| `@alternatives` | Genera 2-3 opzioni alternative | Opzioni con trade-off e raccomandazione |
| `@simplify` | Riduce scope o complessità | Piano ridotto e scope rimosso |
| `@rollback` | Propone un piano di rollback | Path di revert, rischio, validazione |
| `@stop` | Ferma immediatamente il lavoro | Stato corrente e prossimo passo sicuro |

---

## 13.2 I comandi più usati in dettaglio

### `@checkpoint`

Il più usato. Ogni 3-5 azioni significative, o quando vuoi fissare un punto fermo prima di una pausa.

> "@checkpoint"

```text
Checkpoint — TaskFlow API | 2026-06-27 14:32

Completato:
- POST /tasks: route, service, validazione Zod, RFC 7807 errors, 4 test passanti
- GET /tasks: filtri status/assignee, paginazione cursor-based, 6 test passanti
- Migration: add-task-userid-index (applicata in dev)

In corso: niente di sospeso

Blocchi: nessuno

Aggiornamento _CONTEXT.md consigliato:
- Active Task → T-008 GET /tasks/:id
- Active Task Token Est. → 3000/1000/4000
- Active Task Model Level → 3 Sonnet Low

Voce PROGRESS.md proposta:
---
## 2026-06-27 — T-007 POST e GET /tasks (completati)
- Implementati POST e GET /tasks con filtri, paginazione cursor, errori RFC 7807
- 10 test di integrazione passanti
- Migration: add-task-userid-index
---

Applico gli aggiornamenti?
```

Lorenzo risponde "sì" per l'update del context, "sì" per la voce di progress, e continua.

---

### `@context-update`

Quando sai che il context è cambiato ma non vuoi fare un checkpoint completo. Utile a metà sessione quando finisci un task e inizi il successivo.

> "@context-update — ho finito T-007, passo a T-008 GET /tasks/:id"

```text
Proposta aggiornamento _CONTEXT.md:

| Active Task              | T-008 GET /tasks/:id                    |
| Active Task Token Est.   | 3000/1000/4000                          |
| Active Task Model Level  | 3 Sonnet Low                            |

Nessun cambio di fase o vincoli. Applico?
```

---

### `@security-check`

Chiedi esplicitamente una revisione del piano o del codice prodotto contro i vincoli SEC attivi. Particolarmente utile prima di fare il PR su endpoint nuovi.

> "@security-check — controlla l'endpoint POST /tasks appena implementato"

```text
@security-check — POST /tasks

SEC-01 Input Validation: ✅
  Zod schema con titolo obbligatorio, descrizione opzionale, dueDate ISO 8601.
  Campo userId non accettato dall'input (estratto dal JWT). [FACT]

SEC-02 Authentication: ✅
  Middleware auth.ts verifica il JWT prima del handler. Token expiry controllato. [FACT]

SEC-03 Authorization: ✅
  userId estratto dal JWT, non dall'input utente. Nessun rischio di IDOR. [FACT]

SEC-04 Secrets & Config: ✅
  Nessun secret hardcoded. JWT_SECRET da process.env. [FACT]

SEC-05 Data Protection: ⚠ DA VERIFICARE
  Pino è configurato con redaction, ma non ho verificato che il log
  dell'endpoint POST non esponga il body completo prima della validazione.
  [ASSUMPTION — TODO: verifica src/app.ts configurazione Pino]

Azione richiesta: verifica SEC-05 prima del merge.
```

La risposta non è un semplice "tutto ok" — è un'analisi con confidence tag. Lorenzo sa che deve verificare il logging prima di fare merge.

---

### `@alternatives`

Quando hai un dubbio su quale approccio scegliere e vuoi opzioni strutturate invece di una conversazione aperta.

> "@alternatives — per implementare la paginazione di GET /tasks"

```text
Opzione A — Cursor-based (raccomandato)
Pro: performance costante con tabelle grandi, no page drift con insert frequenti
Contro: non supporta jump a pagina N, cursor opaco per il client
Adatta a: TaskFlow API (PERF-01: P95 < 200ms, dataset potenzialmente grande)

Opzione B — Offset-based
Pro: supporta jump a pagina N, semantica familiare per i client
Contro: degrada con tabelle grandi (OFFSET su 50k righe è lento), page drift con insert concorrenti
Adatta a: dataset piccoli (<10k righe), UI con navigazione a pagina N

Opzione C — Keyset con filtro composito
Pro: performance ottima, più flessibile del cursor semplice
Contro: implementazione più complessa, richiede indici compositi
Adatta a: dataset molto grandi con filtri multipli frequenti

Raccomandazione: Opzione A (cursor-based). Rispetta PERF-01, semplice da implementare con Prisma, best practice per API moderne.

Procedo con A?
```

---

### `@simplify`

Quando ti accorgi che il task sta diventando troppo grande o complesso per una singola sessione.

> "@simplify — il task T-010 sta diventando troppo grande"

```text
T-010 attuale: sistema di notifiche real-time (WebSocket, queue Redis, worker)

Scope ridotto proposto:
T-010.1 — Notifiche in-app (polling ogni 30s) — questa sessione
  - Tabella notifications nel DB
  - Endpoint GET /notifications (ultime 20, non lette)
  - Endpoint POST /notifications/:id/read
  
T-010.2 — WebSocket real-time — sessione successiva
T-010.3 — Queue Redis e worker — dopo T-010.2

Motivazione: T-010 completo richiederebbe >3 sessioni. T-010.1 da valore
immediato e non blocca T-010.2.

Accetti lo split?
```

---

### `@stop`

In qualsiasi momento, per fermare immediatamente qualsiasi operazione in corso.

> "@stop"

```text
Lavoro fermato.

Stato corrente:
- Stavo implementando: src/services/notificationService.ts (file non ancora scritto)
- Nessuna modifica irreversibile eseguita

Prossimo passo sicuro: fai @checkpoint per fissare lo stato prima di chiudere.
```

---

## 13.3 Regole che i comandi non possono violare

I comandi conversazionali non sono una scorciatoia per bypassare il protocollo di sicurezza.

**`@stop` non undo le modifiche già fatte.** Se l'agente ha già scritto un file, `@stop` ferma il lavoro ma non ripristina il file. Usa git per questo.

**Nessun comando bypassa gli HALT trigger.** Non esiste un `@force` o `@override`. Se un path richiede conferma esplicita, la conferma deve arrivare nella forma corretta.

**`@security-check` e `@perf-check` citano sempre i vincoli da `_CONTEXT.md`.** Non inventa vincoli — verifica quelli che hai dichiarato. Se `_CONTEXT.md` non ha SEC-XX, il check non ha nulla da verificare.

**`@context-update` propone, non esegue.** Il file `_CONTEXT.md` non viene mai modificato automaticamente dall'agente — ti dà il blocco da incollare e aspetta la tua approvazione.

---

## 13.4 Comandi personalizzati di progetto

I comandi standard del framework sono generici. Se il tuo progetto ha workflow ricorrenti che si traducono sempre nelle stesse istruzioni, puoi definire shortcut personalizzati in `.adlc/project/instructions.md`.

Per TaskFlow API:

```markdown
## Project Commands

@deploy-check
  Esegui in sequenza prima di qualsiasi deploy:
  1. @security-check sull'endpoint modificato
  2. Verifica che tutti i test passino
  3. Controlla che la migration sia compatibile con il DB di staging
  4. Proponi la voce di changelog

@domain-check
  Carica SKILL_TASKFLOW_DOMAIN.md e verifica che
  le modifiche rispettino le business invariant del dominio.
```

Quando Lorenzo scrive `@deploy-check`, l'agente esegue tutti e quattro gli step in sequenza, senza che Lorenzo debba ricordarli ogni volta.

---

## Riepilogo

- I comandi conversazionali (`@`) sono segnali semantici che l'agente riconosce e interpreta secondo il protocollo AI-DLC — non comandi shell.
- I più usati: `@checkpoint` (fissa stato), `@context-update` (aggiorna il context), `@security-check` / `@perf-check` (verifica vincoli), `@alternatives` (opzioni strutturate), `@simplify` (riduce scope), `@stop` (ferma tutto).
- Non bypassano il protocollo di sicurezza: nessun comando disattiva gli HALT trigger o modifica `_CONTEXT.md` senza approvazione.
- Comandi personalizzati di progetto in `.adlc/project/instructions.md` trasformano workflow ricorrenti in shortcut.

Nel prossimo capitolo vediamo come usare più agenti AI sullo stesso progetto: Claude Code, GitHub Copilot, Codex e Gemini insieme, con un unico `_CONTEXT.md` come fonte di verità condivisa.
