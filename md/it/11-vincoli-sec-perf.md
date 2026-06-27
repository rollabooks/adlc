# Capitolo 11 — Vincoli SEC e PERF

Ogni progetto software ha requisiti di sicurezza e performance. Il problema è che questi requisiti vengono di solito discussi una volta — in una riunione di kickoff, in un documento di architettura, in una conversazione Slack — e poi evaporano dalla pratica quotidiana.

Lo sviluppatore che implementa l'endpoint `POST /tasks` tre settimane dopo quella conversazione non ricorda necessariamente che "i token non devono apparire nei log". Il revisore del PR potrebbe non saperlo. L'agente AI sicuramente non lo sa, a meno che glielo dica.

I vincoli SEC e PERF di AI-DLC risolvono questo. Sono una libreria di requisiti riusabili — definiti una volta nel framework, attivati in `_CONTEXT.md`, riletti dall'agente prima di ogni operazione critica.

---

## 11.1 La libreria SEC (sicurezza)

Il framework include nove vincoli di sicurezza predefiniti, coperti da `SEC_CONSTRAINTS.md`.

### SEC-01 — Input Validation

Validazione di tutti gli input in ingresso: allow-list sui tipi, trim, sanitizzazione, rifiuto di campi inaspettati. La validazione lato server è sempre obbligatoria — non fidarsi mai della sola validazione client.

**Su TaskFlow API:** ogni endpoint usa Zod per la validazione dello schema. Nessun campo raw dal request body raggiunge il service layer senza passare per uno schema Zod.

### SEC-02 — Authentication

Uso di un provider di identità collaudato o di una libreria matura. Token short-lived con refresh flow. Mai loggare secrets o token.

**Su TaskFlow API:** OIDC come provider, `@fastify/jwt` per la verifica del token. Il trigger HALT sull'auth path garantisce che le modifiche al middleware passino per una revisione consapevole.

### SEC-03 — Authorization

Least privilege: ogni risorsa verifica che l'utente autenticato abbia il permesso di accedervi. Validazione dell'ownership (un utente non può modificare task di un altro utente).

**Su TaskFlow API:** ogni endpoint che restituisce o modifica dati di un task verifica `task.userId === authenticatedUser.id` prima di procedere.

### SEC-04 — Secrets & Config

Nessun secret hardcoded nel codice. Uso di variabili d'ambiente o di un secret store. Nessun commit di file `.env` con valori reali. Rotazione regolare delle chiavi.

**Su TaskFlow API:** `.env` è in `.gitignore`. La pipeline CI usa GitHub Secrets per le variabili d'ambiente di produzione.

### SEC-05 — Data Protection

Minimizzazione dei dati personali. Redazione nei log. Cifratura at rest dove supportata. TLS in transito.

**Su TaskFlow API:** Pino (il logger di Fastify) è configurato con una funzione di redaction che rimuove `password`, `token`, `email` da tutti i log prima della scrittura.

### SEC-06 — Dependency Hygiene

Pin delle versioni, SBOM tracciato, scanning per vulnerabilità. Nessuna dipendenza abbandonata.

**Su TaskFlow API:** `npm audit` nel pipeline CI, `package-lock.json` in versione.

### SEC-07 — Threat Modeling (Fase 0-2)

Identificazione degli asset, degli attori e dei trust boundary durante la fase di discovery/design. Lista delle minacce (STRIDE), mitigazioni, rischio residuo documentato.

**Su TaskFlow API:** threat model prodotto in Phase 0, salvato in `docs/security/threat-model.md`.

### SEC-08 — Logging & Monitoring

Log degli eventi di sicurezza rilevanti: login, fallimenti di autenticazione, escalation di privilegi, accesso a dati sensibili. Formato strutturato JSON con correlation ID. Mai loggare secrets o PII.

**Su TaskFlow API:** ogni tentativo di autenticazione fallito genera un log con `userId` (se noto), `ip`, `timestamp`, ma senza il token fallito.

### SEC-09 — Server-Side Request Forgery (SSRF)

Validazione e allow-list degli URL in uscita. Blocco delle richieste verso IP privati o interni. Nessun redirect cieco da URL forniti dall'utente.

**Su TaskFlow API:** se in futuro vengono aggiunte funzionalità di webhook, SEC-09 deve essere applicato alla validazione dell'URL del webhook.

---

## 11.2 La libreria PERF (performance)

Sette vincoli di performance predefiniti, coperti da `PERF_CONSTRAINTS.md`.

### PERF-01 — Latency Targets

SLO per endpoint: P50, P95, P99. Budget di latency per layer (rete, applicazione, database).

**Su TaskFlow API:** P95 < 200ms per tutti gli endpoint API. Monitorato con Grafana + Railway metrics.

### PERF-02 — Throughput & Concurrency

RPS atteso e carico di picco. I/O asincrono. Nessun blocco sui path critici.

**Su TaskFlow API:** carico stimato 50 RPS in produzione iniziale, picco 200 RPS. Connection pool Prisma configurato a 10 connessioni.

### PERF-03 — Database Efficiency

Indici sulle query critiche. Niente N+1. Query plan analizzato per le query principali. Risultati limitati in size.

**Su TaskFlow API:** le query per userId hanno l'indice (migration aggiunta nel Capitolo 3). Prisma è configurato con `take: 50` di default su tutte le query di lista.

### PERF-04 — Resource Utilization

Limiti di CPU e memoria definiti. Nessuna allocazione eccessiva in loop. Profiling nei percorsi caldi.

### PERF-05 — Caching & CDN

Layer di cache appropriato per il pattern di accesso. TTL definiti. Invalidazione corretta.

### PERF-06 — Startup & Warm-up

Lazy loading dei componenti non critici. Health check che segnala readiness solo dopo il warm-up.

### PERF-07 — Build & Bundle Size (Frontend)

Code splitting, tree shaking, ottimizzazione immagini. Budget di bundle size. (Specifico per progetti frontend.)

---

## 11.3 Come attivare i vincoli in `_CONTEXT.md`

Non tutti i vincoli si applicano a ogni progetto. Attivi solo quelli rilevanti nel `_CONTEXT.md`, specificando la configurazione specifica del tuo contesto.

```markdown
## Security Constraints
| ID     | Name              | Spec                                          |
|--------|-------------------|-----------------------------------------------|
| SEC-01 | Input Validation  | Zod schema obbligatorio su ogni endpoint      |
| SEC-02 | Authentication    | OIDC + JWT short-lived, refresh rotation      |
| SEC-03 | Authorization     | Ownership check: task.userId === auth.userId  |
| SEC-04 | Secrets & Config  | .env in .gitignore, GitHub Secrets per CI     |
| SEC-05 | Data Protection   | Pino redaction: password, token, email        |

## Performance Constraints
| ID      | Name           | Target                              |
|---------|----------------|-------------------------------------|
| PERF-01 | Latency        | P95 < 200ms — monitored via Grafana |
| PERF-02 | Throughput     | 50 RPS sustained, 200 RPS peak      |
| PERF-03 | DB Efficiency  | Max 3 query per request, take: 50   |
```

La colonna `Spec` è la parte più importante: non scrivere "usa autenticazione" (è ovvio) — scrivi la specifica concreta che l'agente deve rispettare.

---

## 11.4 Come l'agente usa i vincoli

Il protocollo AI-DLC prevede che l'agente rilegga i vincoli attivi in due momenti:

**Prima di generare codice in zone SEC-sensibili:** qualsiasi codice che tocca autenticazione, input utente, logging, chiamate esterne.

**Prima di piani HIGH o superiori:** il piano deve citare esplicitamente quali vincoli sono rilevanti e come vengono rispettati.

In pratica, in una sessione di lavoro su TaskFlow API potresti vedere:

```
[Piano per POST /tasks/bulk — MEDIUM]

Vincoli attivi rilevanti:
- SEC-01: Zod schema su input bulk (array di task, max 50 elementi)
- SEC-02: JWT verificato dal middleware prima del handler
- PERF-02: limit 50 elementi per request per evitare picchi di carico
- PERF-03: upsert batch con Prisma createMany (singola query)

Proposta:
1. Zod schema: z.array(TaskCreateSchema).max(50)
2. Handler: delega a taskService.createMany(userId, tasks)
3. Service: Prisma.createMany in transaction
4. Risposta: 201 con array di ID creati
Procedo?
```

I vincoli non sono note a piè di pagina — sono parte integrante del ragionamento.

---

## 11.5 Il comando `@show-constraints`

In qualsiasi momento di una sessione puoi chiedere all'agente di mostrare i vincoli attivi:

> "@show-constraints"

```
Vincoli SEC attivi (da _CONTEXT.md):
✅ SEC-01 Input Validation — Zod schema obbligatorio su ogni endpoint
✅ SEC-02 Authentication — OIDC + JWT short-lived, refresh rotation
✅ SEC-03 Authorization — task.userId === auth.userId
✅ SEC-04 Secrets & Config — .env in .gitignore
✅ SEC-05 Data Protection — Pino redaction: password, token, email

Vincoli PERF attivi:
✅ PERF-01 Latency — P95 < 200ms
✅ PERF-02 Throughput — 50 RPS / 200 RPS peak
✅ PERF-03 DB Efficiency — max 3 query, take: 50
```

Utile per verificare che `_CONTEXT.md` sia aggiornato dopo un cambio di fase o dopo aver aggiunto nuovi requisiti.

---

## 11.6 Aggiungere un nuovo vincolo

I vincoli evolvono col progetto. Quando aggiungi un nuovo requisito di sicurezza o performance:

1. Aggiungi una riga nella sezione appropriata di `_CONTEXT.md`
2. Esegui `validate` per verificare la sintassi
3. Nella prossima sessione, l'agente lo legge automaticamente

Non devi fare nulla di speciale — basta che sia nel file. L'agente lo rileva al bootstrap.

---

## 11.7 Vincoli personalizzati

I codici `SEC-XX` e `PERF-XX` sono standard del framework. Se hai un requisito non coperto dalla libreria predefinita, puoi usare un ID personalizzato:

```markdown
| SEC-10 | API Rate Limiting | Max 100 req/min per IP su /auth/*, sliding window |
| PERF-08 | Export Timeout   | Report exports: timeout a 30s, async se >5s       |
```

L'agente tratta qualsiasi riga nella sezione Security o Performance come un vincolo da rispettare, indipendentemente dall'ID.

---

## Riepilogo

- SEC-01..SEC-09 coprono le principali categorie di sicurezza: input, autenticazione, autorizzazione, secrets, dati, dipendenze, threat modeling, logging, SSRF.
- PERF-01..PERF-07 coprono latency, throughput, database, risorse, cache, startup, bundle size.
- Si attivano in `_CONTEXT.md` specificando, per ogni vincolo, la configurazione concreta del progetto — non il principio generico.
- L'agente li rilegge prima di generare codice SEC-sensibile e li cita nei piani HIGH+.
- `@show-constraints` mostra in qualsiasi momento i vincoli attivi nella sessione corrente.
- I vincoli personalizzati si aggiungono liberamente con ID arbitrari.

Con questo capitolo chiudiamo la Parte III. Abbiamo costruito il sistema di sicurezza completo: dalla classificazione del rischio ai model levels, dai confidence tag agli HALT trigger, fino alla libreria di vincoli riusabili. Nella Parte IV entriamo nel workflow avanzato: moduli e skill, comandi conversazionali, multi-agente, monorepo e codebase legacy.
