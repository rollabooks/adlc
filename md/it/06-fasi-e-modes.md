# Capitolo 6 — Fasi e Modes

Uno degli errori più comuni nell'uso degli agenti AI è trattarli come strumenti uniformi: la stessa configurazione, lo stesso livello di cerimonia, lo stesso tipo di dialogo — per qualsiasi task, in qualsiasi momento del progetto.

Un agente in fase di discovery dovrebbe ragionare in termini di requisiti e alternative. Lo stesso agente in fase di deploy dovrebbe ragionare in termini di rischi e rollback. Se non sa in che fase è, il suo comportamento è arbitrario.

I **Modes** aggiungono un'altra dimensione: quanta cerimonia vuoi per questa sessione? Un task di rinomina variabile non ha bisogno dello stesso overhead di una modifica al sistema di autenticazione.

Fasi e Modes lavorano insieme per rendere l'agente contestuale, non generico.

---

## 6.1 Le sette fasi del ciclo AI-Driven

AI-DLC divide il ciclo di sviluppo in sette fasi numerate da 0 a 6. Non sono rigide — puoi saltare fasi, tornare indietro, sovrapporre — ma hanno un significato preciso che influenza il comportamento dell'agente.

### Fase 0 — Discovery

**Obiettivo:** capire il problema da risolvere.

In questa fase l'agente dovrebbe aiutarti a raccogliere requisiti, identificare stakeholder, esplorare il dominio. Non produce codice — produce domande, mappe concettuali, elenchi di vincoli.

Per TaskFlow API, Lorenzo ha passato la Fase 0 a rispondere a domande come:
- Chi usa l'API? Sviluppatori interni, clienti esterni, o entrambi?
- Quali sono i casi d'uso principali? Solo lettura, o anche scrittura massiva?
- Ci sono requisiti di compliance (GDPR, SOC2)?

L'agente in Fase 0 carica il modulo `02_DISCOVERY_ANALYSIS.md`. Se gli chiedi di scrivere codice, lo fa (non è bloccante) — ma ti avvisa che stai saltando la fase.

### Fase 1 — Analysis

**Obiettivo:** analizzare i requisiti raccolti e scegliere l'approccio.

Qui si passa dai requisiti alle scelte tecniche di alto livello. Quale database? Quale strategia di autenticazione? Quale architettura (monolite, microservizi, edge functions)?

L'agente in Fase 1 produce analisi comparative, evidenzia trade-off, cita i vincoli SEC e PERF per valutare le opzioni.

### Fase 2 — Design

**Obiettivo:** definire l'architettura e i contratti.

Schema del database, contratto API (endpoint, request/response), struttura delle cartelle, pattern da adottare. È la fase dove si prendono le decisioni architetturali che poi è costoso cambiare.

L'agente in Fase 2 produce diagrammi, schemi, specifiche. Le decisioni aperte in `_CONTEXT.md` (`Open Decisions`) vengono chiuse qui. Se non sei sicuro di una scelta, l'agente ti propone alternative con pro e contro.

### Fase 3 — Implementation

**Obiettivo:** scrivere il codice.

La fase più lunga. L'agente produce codice, test, documentazione inline. Rispetta SEC e PERF attivamente. Classifica il rischio di ogni modifica. Attiva gli HALT trigger quando tocca path sensibili.

Per TaskFlow API, il team ci ha passato tre settimane.

### Fase 4 — Verification

**Obiettivo:** verificare che il codice faccia ciò che deve fare.

Test di integrazione, test end-to-end, review di sicurezza, analisi delle performance. L'agente in Fase 4 cerca problemi, non li nasconde. I confidence tag diventano particolarmente importanti: ogni claim su "questo è corretto" deve essere verificabile.

### Fase 5 — Release

**Obiettivo:** portare il codice in produzione.

Documentazione finale, changelog, deployment. L'agente in Fase 5 è attento ai rischi di rollback e alle procedure di deploy sicuro. Le operazioni di questa fase sono quasi tutte HIGH-risk per definizione — uno schema sbagliato in produzione è molto più costoso di uno sbagliato in dev.

### Fase 6 — Ops

**Obiettivo:** mantenere il sistema in salute.

Monitoraggio, incident response, aggiornamenti di dipendenze, gestione della technical debt. L'agente in Fase 6 ragiona in termini di impatto sul sistema in produzione — ogni modifica deve avere un piano di rollback.

---

## 6.2 Come le fasi cambiano il comportamento dell'agente

Il campo `Phase` in `_CONTEXT.md` non è solo informativo. Indica all'agente quale modulo caricare e come interpretare le richieste.

| Fase | Modulo caricato | Skill suggerite |
|---|---|---|
| 0 Discovery | `02_DISCOVERY_ANALYSIS.md` | `SKILL_ANALYSIS.md` |
| 1 Analysis | `02_DISCOVERY_ANALYSIS.md` | `SKILL_ANALYSIS.md` |
| 2 Design | `03_DESIGN.md` | `SKILL_DESIGN.md`, `SKILL_API_DESIGN.md` |
| 3 Implementation | `04_IMPLEMENTATION.md` | `SKILL_API_DESIGN.md`, `SKILL_SECURITY.md`, `SKILL_UI.md` |
| 4 Verification | `05_VERIFICATION_RELEASE.md` | `SKILL_TESTING.md` |
| 5 Release | `05_VERIFICATION_RELEASE.md` | `SKILL_OPS.md` |
| 6 Ops | `06_OPS.md` | `SKILL_OPS.md` |

Se sei in Fase 3 e chiedi di progettare un'architettura, l'agente lo farà — ma citerà il modulo di design come riferimento e probabilmente ti suggerirà di tornare in Fase 2 se la decisione è significativa. Il sistema non ti blocca: ti orienta.

---

![Le sette fasi del ciclo AI-Driven e il modulo caricato in ciascuna](figures/it/ch06-fasi-moduli.png)

## 6.3 I cinque Modes

I Modes controllano **quanta cerimonia** applica l'agente. La stessa richiesta può ricevere risposte molto diverse a seconda del Mode attivo.

### LITE

Il mode per il lavoro quotidiano su un progetto stabile. Riduce l'overhead senza rinunciare alla sicurezza.

```
- Conferma di sessione: saltata se _CONTEXT.md non è cambiato
- Confidence tags: solo per output >10 righe o classificati HIGH
- Checkpoint: suggerito ogni 5+ azioni (non obbligatorio per LOW/MEDIUM)
- SEC/PERF: riletti solo prima di operazioni HIGH-risk
- HALT trigger: sempre rispettati (non si disattivano mai)
- Risk classification: sempre richiesta per ogni task
```

**Quando usarlo:** progetto con più di qualche settimana di vita, team che ha già interiorizzato SEC/PERF, task routine LOW/MEDIUM. Lorenzo ha usato LITE per tutta la Fase 3 dopo la prima settimana.

### STANDARD

Il mode di default. Applica il protocollo completo senza eccezioni.

```
- Conferma di sessione: sempre
- Confidence tags: su tutti gli output HIGH-risk
- Checkpoint: ogni 3-5 azioni significative
- SEC/PERF: riletti prima di qualsiasi codice
- HALT trigger: sempre rispettati
```

**Quando usarlo:** progetti nuovi, team nuovo, task con vincoli di compliance, lavoro in zone del codice mai toccate prima. Lorenzo ha usato STANDARD per tutta la Fase 0-2 e la prima settimana di Fase 3.

### AUDIT

Il mode per lavoro con tracciabilità completa: compliance, sicurezza, revisioni formali.

```
- Tutto di STANDARD più:
- Confidence tags su ogni output, non solo HIGH-risk
- Ogni decisione documentata con reasoning esplicito
- Checklist di completamento per ogni task
```

**Quando usarlo:** audit di sicurezza, lavoro su codice regolamentato (fintech, healthcare, GDPR), revisione formale pre-release.

### RAPID

Il mode per spike, POC ed emergenze. Minimizza la cerimonia, massimizza la velocità.

```
- Nessuna conferma formale a meno che il rischio sia HIGH
- Nessuna documentazione obbligatoria
- Confidence tags raccomandati per output >5 righe
- HALT trigger: sempre rispettati
- SEC critici: sempre rispettati (no secrets, no data deletion)
- Usa un branch separato; evita i path di produzione
```

**Quando usarlo:** esperimenti di 1-2 ore, prototipi usa-e-getta, hotfix in emergenza (con branch dedicato). Non per lavoro che va in produzione senza revisione.

### FAST

Per task semplici dove vuoi output diretto e immediato.

```
- Nessun loop di conferma a meno che il rischio non sia HIGH
- Output conciso e actionable
- Confidence tags solo per output >10 righe
```

**Quando usarlo:** task genuinamente semplici — rinomina di variabili, aggiunta di JSDoc, fix di typo — dove il dialogo di conferma sarebbe più lento del task stesso.

---

## 6.4 Cambiare Mode durante il progetto

Il Mode non è fisso per tutta la vita del progetto. È normale che cambi spesso.

**Scenario tipico su TaskFlow API:**

| Periodo | Mode | Motivazione |
|---|---|---|
| Fase 0-2 (Discovery/Design) | STANDARD | Decisioni architetturali ad alto impatto |
| Prima settimana Fase 3 | STANDARD | Nuovo territorio, stabilire le convenzioni |
| Settimane 2-N Fase 3 | LITE | Pattern rodati, team allineato sui vincoli |
| Audit di sicurezza pre-release | AUDIT | Tracciabilità completa richiesta |
| Hotfix urgente in produzione | RAPID | Velocità, branch dedicato, review immediata dopo |
| Refactor di naming | FAST | Task basso rischio, nessuna logica coinvolta |

Per cambiare mode, basta aggiornare il campo `Mode:` in `_CONTEXT.md`. Il cambio ha effetto dalla prossima sessione (o dal prossimo turno se sei già in sessione).

**Esempio concreto:** Lorenzo, dopo due settimane in STANDARD, passa a LITE. Aggiorna `_CONTEXT.md`:
```markdown
| Mode | LITE |
```
Alla sessione successiva, l'agente non chiede la conferma di bootstrap — la presuppone invariata rispetto all'ultima sessione. Lorenzo lo nota: scrive "Implementa `DELETE /tasks/:id`" e l'agente propone subito il piano (MEDIUM) senza il passaggio di conferma contesto. Il flusso è più fluido, le regole di sicurezza sono le stesse.

---

## 6.5 Il comando `@load-phase`

Se vuoi caricare esplicitamente il modulo di una fase senza cambiare `_CONTEXT.md`, puoi usare il comando conversazionale:

> "@load-phase 4"

L'agente carica `05_VERIFICATION_RELEASE.md` e ti conferma le regole attive per la fase di verifica. Utile quando stai facendo un task di verifica mentre sei tecnicamente ancora in Fase 3 — non vuoi cambiare il context per un task singolo.

---

## 6.6 Errori comuni con Fasi e Modes

**Tenere STANDARD per tutta la vita del progetto.** Dopo le prime settimane, STANDARD su task LOW/MEDIUM diventa rumore. Il team inizia a ignorare le conferme perché ci sono sempre. Abbassa a LITE quando il progetto è stabile.

**Usare RAPID per lavoro che va in produzione.** RAPID è per esperimenti. Se il codice prodotto in RAPID finisce in main senza review, stai usando il mode sbagliato.

**Non aggiornare la fase in `_CONTEXT.md` quando si cambia fase.** L'agente in Fase 3 con il context che dice Fase 2 carica i moduli sbagliati. Il cambio di fase nel progress (visto nel capitolo precedente) deve essere accompagnato dall'aggiornamento del campo `Phase` nel context.

**Pensare che i Modes disattivino i HALT trigger.** Non è così. In nessun mode gli HALT trigger vengono disattivati. La cerimonia cambia, la sicurezza no.

---

## 6.7 Dal task al codice: il ciclo test-driven

Nella Fase 3 (Implementation) il lavoro non procede "a tema libero": procede **un task alla volta**. Il **task** è l'unità da cui parte l'implementazione del codice. Ogni task ha un identificativo (`T-NNN`), un obiettivo in una-tre frasi, criteri di accettazione verificabili, i deliverable attesi, i vincoli SEC/PERF rilevanti e l'AI Sizing (stima token, model level, risk floor). Il template completo è nell'Appendice C; lo si crea e avvia con il comando `@Task` (Capitolo 13).

Perché passare per i task invece di chiedere genericamente "implementa la feature X"? Perché un task ben definito è un **contratto verificabile**: stabilisce *cosa* significa "fatto" prima che l'agente scriva una riga. È la differenza tra dirigere un collaboratore disciplinato e sperare che il prototipo regga.

### Ogni task è guidato dai test

In AI-DLC ogni task segue un ciclo **test-driven**, e i test sono di due tipi:

1. **I test del task.** Prima dell'implementazione si scrivono (o si concordano) i test che codificano i criteri di accettazione del task. Sono la definizione *eseguibile* di "fatto": finché non passano, il task non è completo.
2. **La regressione di tutto ciò che è stato fatto prima.** Un task è completo solo se i suoi test passano *e* nessun test precedente si rompe. La suite completa gira a ogni task.

Questo secondo punto è la differenza tra AI-DLC e il vibe coding lasciato a sé stesso. Nel Capitolo 1 abbiamo visto il pattern *two steps back* (l'agente corregge un bug e ne introduce due) e il *house of cards code* (codice che crolla alla prima pressione). La regressione completa a ogni task è proprio la barriera che li previene: l'agente non può "sistemare" qualcosa rompendo silenziosamente qualcos'altro, perché la suite lo rivela subito.

Il ciclo, in pratica:

1. **`@Task`** — l'agente genera il task (sizing, AC, vincoli) e propone i test che ne verificano i criteri.
2. **Approvi** il piano e i test (per task MEDIUM o superiori l'approvazione è obbligatoria — è il pattern Planner–Executor–Reviewer).
3. L'agente **implementa** finché i test del task passano.
4. Gira **l'intera** suite: i test del task *più* tutta la regressione.
5. **`@checkpoint`** — si fissa lo stato e si aggiorna `PROGRESS.md`.

Se al punto 4 si rompe un test precedente, il task non è "fatto": si torna al punto 3. Niente "due passi avanti e due indietro".

---

## Riepilogo

- Le **sette fasi** (0-Discovery, 1-Analysis, 2-Design, 3-Implementation, 4-Verification, 5-Release, 6-Ops) definiscono in che punto del ciclo sei e quale modulo del framework l'agente carica.
- I **cinque Modes** (LITE, STANDARD, AUDIT, RAPID, FAST) controllano quanta cerimonia applica l'agente — dalla conferma di sessione ai confidence tag ai checkpoint.
- Mode e Fase sono indipendenti: puoi essere in Fase 3 con Mode LITE, o in Fase 0 con Mode AUDIT.
- I HALT trigger non vengono mai disattivati, indipendentemente dal Mode.
- Cambia Mode liberamente durante il progetto: STANDARD per partire, LITE per il lavoro quotidiano rodato, AUDIT per revisioni formali, RAPID solo per spike su branch dedicati.
- In Fase 3 l'implementazione procede **un task alla volta**: ogni task (`@Task`) è test-driven e si chiude solo se i suoi test passano *e* la regressione completa resta verde.

Con questo chiudiamo la Parte II. Nelle prossime cinque sessioni costruiremo il sistema di sicurezza di AI-DLC: classificazione del rischio, model levels, confidence tag, HALT trigger e vincoli SEC/PERF.
