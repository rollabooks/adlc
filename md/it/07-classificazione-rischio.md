# Capitolo 7 — Classificazione del rischio

Ogni richiesta che fai a un agente AI porta con sé un rischio implicito. Rinominare una variabile è diverso da modificare lo schema del database. Aggiungere un campo a un DTO è diverso da cambiare il sistema di autenticazione. Eppure, senza un sistema di classificazione, l'agente tratta tutto allo stesso modo — o peggio, decide in autonomia cosa merita attenzione e cosa no.

ADLC formalizza questa distinzione in cinque livelli di rischio. Non è una burocrazia aggiuntiva: è il meccanismo che decide quanta cerimonia applicare prima di agire.

---

## 7.1 I cinque livelli

### LOW

**Cos'è:** modifiche a basso impatto, facilmente reversibili, che non toccano logica di business o sistemi condivisi.

Esempi concreti:
- Rinominare una variabile locale
- Correggere un typo in un commento o in un messaggio di errore
- Aggiungere JSDoc a una funzione esistente
- Riformattare codice (indentazione, virgole, ordine degli import)
- Aggiornare un valore in un file di fixture di test

**Cosa fa l'agente:** esegue direttamente e notifica con una riga di log. Nessuna conferma richiesta.

```
[LOW] Fixed typo in error message in src/services/taskService.ts. No risk items.
```

### MEDIUM

**Cos'è:** nuove funzionalità, refactor locali, modifiche che hanno impatto su più file ma che rimangono reversibili con un `git revert`.

Esempi concreti:
- Implementare un nuovo endpoint
- Estrarre una funzione in un modulo separato
- Aggiungere un campo opzionale a un DTO esistente
- Scrivere un nuovo set di test di integrazione
- Modificare la logica di validazione di un form

**Cosa fa l'agente:** propone un piano dettagliato e aspetta la tua approvazione prima di scrivere codice. Dopo l'approvazione, esegue.

```
[MEDIUM] Proposta per GET /tasks con filtri e paginazione:
1. Route handler con query params (status, assignee, cursor)
2. Zod schema per validazione params (SEC-01)
3. Service: query Prisma con where dinamico + take/skip per cursor
4. Risposta: { data: Task[], nextCursor: string | null }
5. Test: 5 casi (200, 400 param non valido, 401, pagina vuota, cursor scaduto)
Procedo?
```

### HIGH

**Cos'è:** modifiche ad alto impatto, difficilmente reversibili o con effetti su sistemi condivisi, dati in produzione, autenticazione, architettura.

Esempi concreti:
- Modificare uno schema database (aggiungere/rimuovere colonne, cambiare tipi)
- Cambiare la logica di autenticazione o autorizzazione
- Modificare l'architettura del sistema (introdurre una coda, cambiare il pattern di error handling globale)
- Aggiornare le configurazioni di deploy
- Eliminare dati o record

**Cosa fa l'agente:** si ferma (HALT), presenta un piano dettagliato con analisi dei rischi e degli effetti collaterali, e aspetta una **conferma esplicita** — non basta "sì", serve un `"Confermato. Procedi."` o equivalente.

```
⚠ HALT — HIGH risk detected

Operazione: aggiunta colonna NOT NULL `completed_at` a tabella `tasks`

Rischi:
- Migration non-reversibile (requires backfill)
- Lock sulla tabella durante la migration su PostgreSQL
- Valori null su record esistenti: serve default o backfill prima del NOT NULL

Piano proposto:
1. Aggiungere colonna come nullable (ALTER TABLE)
2. Backfill: UPDATE tasks SET completed_at = updated_at WHERE status = 'done'
3. Aggiungere constraint NOT NULL in migration separata
4. Test: verificare che i record esistenti abbiano completed_at valorizzato

Conferma esplicita richiesta. Procedi?
```

### HIGH+

**Cos'è:** operazioni su secrets, credenziali, compliance, dati personali in produzione. Il danno potenziale supera quello di un HIGH standard.

Esempi concreti:
- Modificare file `.env` o di configurazione con credenziali
- Toccare codice di autenticazione OAuth/OIDC, gestione token, firma JWT
- Accedere o modificare dati PII
- Modificare policy di sicurezza o configurazioni IAM

**Cosa fa l'agente:** HALT completo. Non propone nemmeno un piano finché non riceve una conferma che vuoi procedere in questa direzione. Poi presenta il piano e aspetta una seconda conferma per eseguire.

```
⛔ HALT — HIGH+ risk: auth/secrets path detected

File rilevato: src/middleware/auth.ts corrisponde al pattern **/middleware/auth*

Prima di procedere: conferma che vuoi modificare il codice di autenticazione.
Risposta attesa: "Sì, voglio modificare l'autenticazione" (o equivalente)
```

### CRITICAL

**Cos'è:** decisioni mission-critical ambigue, dove le alternative hanno implicazioni architetturali profonde e irreversibili, o dove il dominio è abbastanza sensibile da richiedere revisione umana specializzata.

Esempi concreti:
- Scegliere tra due strategie di sharding del database senza dati sufficienti
- Decidere l'architettura di sicurezza di un sistema finanziario
- Valutare la migrazione da un provider cloud a un altro

**Cosa fa l'agente:** HALT. Presenta le alternative con pro, contro e trade-off. Produce un record di decisione (ADR) bozza. **Non esegue nulla** — la decisione spetta a te, eventualmente con il supporto di esperti di dominio.

```
⛔ HALT — CRITICAL: architectural decision required

Questione: strategia di paginazione per GET /tasks (AD-01 aperta)
- Cursor-based: performante su grandi dataset, non supporta jump a pagina N
- Offset-based: supporta jump, degrada con tabelle grandi

Raccomandazione: cursor-based (FACT — basato su PERF-01: P95 < 200ms)
ma la scelta dipende da requisiti UI non ancora definiti.

Azione: chiudi AD-01 in _CONTEXT.md e aggiorna PROGRESS.md con la decisione.
Non procedo con l'implementazione finché AD-01 è aperta.
```

---

## 7.2 Come l'agente classifica le richieste

La classificazione avviene prima di qualsiasi azione. L'agente esamina tre fattori:

**Path del file:** il file che verrà modificato corrisponde a un pattern negli HALT trigger? (Capitolo 10)

**Tipo di operazione:** è una modifica additiva (basso rischio) o distruttiva/strutturale (alto rischio)?

**Ambito dell'effetto:** la modifica è locale (un file, una funzione) o sistemica (tutta l'autenticazione, lo schema DB, il sistema di logging)?

Il risultato è la classificazione dichiarata prima di procedere. In Mode LITE la classificazione è sempre presente nel task, ma il flusso di conferma si riduce per LOW e MEDIUM.

---

## 7.3 Il rischio minimo per il modello AI

La classificazione del rischio non influenza solo la cerimonia — influenza anche quale modello AI è appropriato per il task.

| Livello | Minimum Model Level |
|---|---|
| LOW | 1 |
| MEDIUM | 3 |
| HIGH | 5 |
| HIGH+ (auth, secrets, compliance, produzione) | 6 |
| CRITICAL | 7 |

Questo è il **risk floor**: anche se stimi che un task HIGH richieda pochi token (e quindi sarebbe un livello 2), il risk floor forza almeno il livello 5. Non perché servano più token — ma perché le operazioni ad alto rischio richiedono un modello con capacità di ragionamento superiori.

Il Capitolo 8 spiega i livelli di modello in dettaglio.

---

## 7.4 La classificazione in pratica su TaskFlow API

Vediamo come si distribuisce il rischio su una settimana tipo di lavoro su TaskFlow API.

| Task | Classificazione | Motivazione |
|---|---|---|
| Aggiungere JSDoc a `TaskService` | LOW | Documentazione, nessun impatto sulla logica |
| Implementare `GET /tasks/:id` | MEDIUM | Nuovo endpoint, reversibile |
| Aggiungere indice su `userId` | HIGH | Schema DB, migration richiesta |
| Refactor del middleware JWT | HIGH+ | Path auth, codice di sicurezza |
| Scegliere strategia di caching | CRITICAL | Decisione architetturale con dipendenze UI |

Una settimana normale su un progetto maturo è composta principalmente da LOW e MEDIUM. I task HIGH sono meno frequenti ma sempre presenti — ogni sprint ha almeno una migration, una modifica architetturale, un aggiustamento ai permessi. I task CRITICAL sono rari e spesso coincidono con i momenti di cambio fase.

---

## 7.5 Quando la classificazione è sbagliata

L'agente può classificare erroneamente un task — tipicamente per difetto (LOW dove è MEDIUM) più che per eccesso. Se noti una classificazione che non ti convince:

> "Classifica questo come HIGH, non MEDIUM — stiamo toccando la logica di autorizzazione."

L'agente reclassifica e applica il protocollo del livello superiore. La classificazione è sempre comunicata prima di agire, proprio per darti la possibilità di correggerla.

In Mode LITE, le classificazioni LOW/MEDIUM vengono eseguite senza aspettare la tua conferma. Se vuoi forzare una revisione su un task che l'agente ha classificato come MEDIUM, chiedi esplicitamente:

> "Prima di procedere, voglio vedere il piano."

---

## Riepilogo

- ADLC classifica ogni richiesta in cinque livelli: LOW (esegui), MEDIUM (piano → approva → esegui), HIGH (HALT → piano → conferma esplicita), HIGH+ (HALT → conferma intenzione → piano → conferma esecuzione), CRITICAL (HALT → alternative → ADR → nessuna esecuzione).
- La classificazione considera il path del file (HALT trigger), il tipo di operazione e l'ambito dell'effetto.
- Ogni livello ha un risk floor che forza un minimum model level indipendentemente dalla stima token.
- La classificazione è sempre comunicata prima di agire — puoi correggerla se non ti convince.

Nel prossimo capitolo vediamo i Model Levels: come scegliere il modello AI giusto per ogni task e perché non ha sempre senso usare il più potente.
