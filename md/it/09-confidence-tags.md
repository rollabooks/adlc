# Capitolo 9 — Confidence Tags: FACT, INFERRED, ASSUMPTION

Gli agenti AI hanno un problema strutturale: rispondono con la stessa sicurezza apparente sia quando sanno, sia quando deducono, sia quando inventano. Il tono è uniforme. La certezza è sempre implicita.

Questo crea una trappola sottile. Se un agente ti dice "la funzione `getUserById` restituisce `null` quando l'utente non esiste", potresti prenderlo per vero senza verificare. Se invece ti dice lo stesso con tono ugualmente sicuro aggiungendo in fondo "ma non ho letto il file, è una deduzione dal nome della funzione", cambieresti il tuo comportamento.

I confidence tags sono il meccanismo con cui ADLC rende esplicita questa distinzione.

---

## 9.1 I tre tag

### FACT

L'agente ha verificato l'informazione leggendo direttamente il codice, un file, un output di test, o altra fonte presente nel contesto della sessione.

```
La funzione `getUserById` in src/services/userService.ts
lancia `UserNotFoundError` quando l'utente non esiste (riga 47).

AI CONFIDENCE: FACT
Basis: letto src/services/userService.ts, riga 45-50
```

Un FACT è qualcosa su cui puoi fare affidamento — con la cautela normale che anche la lettura di un file può avere errori (file obsoleto, versione sbagliata). Ma l'agente ha fatto il lavoro di verifica.

### INFERRED

L'agente ha dedotto l'informazione da contesto indiretto: il nome di una funzione, la struttura del codice, convenzioni del framework, pattern tipici. La deduzione è logica ma non verificata direttamente.

```
Il middleware di autenticazione probabilmente usa `express-jwt`
basandosi sull'import in src/app.ts (riga 8) e sul pattern standard
di Fastify per JWT.

AI CONFIDENCE: INFERRED
Basis: import `@fastify/jwt` in src/app.ts; non ho letto la configurazione
       completa del middleware
```

Un INFERRED è una buona ipotesi di lavoro, ma richiede verifica prima di agire su di essa — specialmente in zone HIGH-risk.

### ASSUMPTION

L'agente ha fatto un'assunzione che non è supportata da evidenza diretta nel contesto. Potrebbe essere corretta, ma è un'ipotesi non verificata.

```
Ho assunto che la tabella `tasks` abbia un indice su `user_id`
per supportare le query per utente con le performance richieste
(PERF-01: P95 < 200ms).

AI CONFIDENCE: ASSUMPTION
Basis: non ho letto lo schema Prisma — assunzione basata su buone pratiche
       di database design
TODO: verifica index su prisma/schema.prisma prima di andare in produzione
```

Un ASSUMPTION è un segnale di allerta. Significa che l'agente sta procedendo su terreno non verificato. Se l'assunzione è sbagliata, il codice generato potrebbe non funzionare o essere non sicuro.

---

## 9.2 Quando i tag sono obbligatori

I confidence tags non vanno su ogni output — diventerebbero rumore. Il protocollo stabilisce quando sono richiesti:

**Sempre obbligatori:**
- Output classificati HIGH-risk o superiore
- Claim su vincoli SEC-XX o PERF-XX ("questo codice rispetta SEC-02")
- Codice che modifica path presenti negli HALT trigger
- Qualsiasi affermazione su "cosa fa" il codice esistente senza averlo letto

**Consigliati ma non obbligatori (in Mode LITE):**
- Output MEDIUM superiori a 10 righe
- Qualsiasi deduzione su comportamento di librerie esterne
- Stime di performance o sicurezza

**Non necessari:**
- Task LOW di pura formattazione o documentazione
- Risposte a domande con risposta ovvia dal codice già letto
- Riepilogo di lavoro già completato nella stessa sessione

In Mode STANDARD e AUDIT, la soglia è più bassa: i tag appaiono su qualsiasi output significativo, non solo su HIGH-risk.

---

## 9.3 Il tag come segnale di azione

Il valore dei confidence tags non è solo informativo. Ogni tag implica un'azione diversa da parte tua.

| Tag | Azione suggerita |
|---|---|
| FACT | Usa l'informazione. Verifica solo se la fonte potrebbe essere obsoleta. |
| INFERRED | Verifica prima di agire su operazioni MEDIUM o superiori. Per LOW, puoi accettare l'inferenza. |
| ASSUMPTION | **Stop.** Verifica l'assunzione prima di procedere — specialmente se è in zona HIGH-risk. |

Quando vedi un ASSUMPTION in un output HIGH-risk, la risposta corretta non è "ok, procedi lo stesso". È verificare l'assunzione, aggiornare il context con l'informazione corretta, e far rigenerare l'output.

---

## 9.4 In pratica su TaskFlow API

Lorenzo chiede all'agente di rivedere la gestione degli errori dell'endpoint `POST /tasks`. L'agente risponde:

---

*Analisi della gestione errori in `POST /tasks`:*

*1. Validazione Zod: lancia `ZodError` su input non valido — gestito correttamente con risposta 400 RFC 7807 (riga 34-41).*

*AI CONFIDENCE: FACT*
*Basis: letto src/routes/tasks.ts righe 30-45*

*2. Auth middleware: il token viene estratto da `Authorization: Bearer` e verificato con la chiave pubblica OIDC prima di raggiungere il handler.*

*AI CONFIDENCE: INFERRED*
*Basis: pattern standard di @fastify/jwt; non ho letto src/middleware/auth.ts — consiglio di verificare che il middleware sia registrato prima della route*

*3. Errori Prisma: le eccezioni `PrismaClientKnownRequestError` con codice P2002 (unique violation) vengono mappate a 409 Conflict.*

*AI CONFIDENCE: ASSUMPTION*
*Basis: non ho letto il catch block nel service — ho assunto che il mapping sia implementato perché è una best practice comune*
*TODO: verificare src/services/taskService.ts, sezione error handling*

---

Guardando questo output, Lorenzo sa esattamente:
- La validazione Zod è corretta — verificato.
- Il middleware è probabilmente ok, ma vale la pena controllare che sia registrato nell'ordine giusto.
- Il mapping degli errori Prisma potrebbe non esistere — deve verificarlo prima di andare in staging.

Senza i confidence tags, Lorenzo avrebbe ricevuto lo stesso testo ma senza sapere cosa è stato verificato e cosa no.

---

## 9.5 Confidence tags e codebase legacy

I confidence tags diventano particolarmente preziosi quando l'agente lavora su codice che non ha mai letto — specialmente una codebase legacy senza documentazione.

In quella situazione, quasi tutto è INFERRED o ASSUMPTION. Il valore non è nella certezza, ma nella trasparenza: l'agente ti sta dicendo esplicitamente "sto navigando a vista". È un segnale che devi leggere il codice con lui, non delegargli ciecamente la comprensione.

---

## 9.6 Il formato dei tag

Il formato standard è in coda all'output:

```markdown
---
AI CONFIDENCE: [FACT | INFERRED | ASSUMPTION]
Basis: [motivazione — file letto, pattern riconosciuto, o ipotesi]
[TODO: azione suggerita se ASSUMPTION]
```

Su output con più claim di certezza diversa (come nell'esempio di Lorenzo), il tag appare dopo ogni claim con il suo livello specifico.

---

## Riepilogo

- I tre confidence tags — FACT (verificato), INFERRED (dedotto), ASSUMPTION (ipotesi) — rendono esplicita la certezza dell'agente su ogni affermazione ad alto impatto.
- FACT: usa l'informazione. INFERRED: verifica prima di operazioni MEDIUM+. ASSUMPTION: stop, verifica prima di qualsiasi operazione.
- Sono obbligatori su output HIGH-risk, claim su SEC/PERF e codice che tocca path HALT. In Mode LITE, si riducono ai soli casi critici.
- Il loro valore è trasformare il "l'AI ha detto così" in "l'AI lo ha verificato / dedotto / ipotizzato" — tre cose molto diverse che richiedono azioni diverse da parte tua.

Nel prossimo capitolo vediamo gli HALT trigger: il sistema che forza l'agente a fermarsi prima di toccare le zone più sensibili del tuo progetto.
