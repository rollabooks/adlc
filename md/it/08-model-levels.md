# Capitolo 8 — Model Levels: quale AI per quale task

C'è un errore comune nell'uso degli agenti AI: usare sempre il modello più potente disponibile. È comprensibile — se il modello migliore fa meno errori, perché usarne uno inferiore? — ma è la scelta sbagliata per due motivi.

Il primo è il costo. I modelli più potenti costano di più in token. Un task da 2.000 token totali non richiede lo stesso modello di un task da 100.000 token.

Il secondo è il latency. I modelli più potenti sono più lenti. Per task semplici e frequenti (rinomina, JSDoc, piccoli fix) la differenza di latenza è percepibile e non giustificata.

ADLC introduce i Model Levels per risolvere questo: una scala da 1 a 7 che mappa la complessità del task al modello appropriato.

---

## 8.1 La scala 1-7

| Level | Token range (totali) | A cosa serve |
|---|---|---|
| 1 | < 4k | Piccoli edit, docs, formattazione, domande semplici |
| 2 | 4k-8k | Modifiche localizzate, test semplici, Q&A con contesto |
| 3 | 8k-16k | Implementazione standard, debugging mirato, nuovi endpoint |
| 4 | 16k-32k | Feature multi-file, design con trade-off moderati |
| 5 | 32k-64k | Refactor complessi, integrazioni, lavoro in zone SEC-sensibili |
| 6 | 64k-120k | Architettura, debugging profondo, cambiamenti cross-modulo |
| 7 | > 120k | Mission-critical, alta ambiguità, decisioni architetturali irreversibili |

---

## 8.2 Il mapping ai modelli vendor

I livelli sono astratti — non nominano modelli specifici, perché i modelli cambiano. Il mapping concreto vive in `.adlc/manifest.json#model_levels` e viene aggiornato col framework.

Per vedere il mapping corrente:

```powershell
.\.adlc\tools\show-models.ps1
```

```bash
bash .adlc/tools/show-models.sh
```

Output tipico (il mapping cambia con le versioni del framework):

```
ADLC Model Level Mapping — v3.3.0

Level 1  │ Anthropic: Haiku Low       │ OpenAI: gpt-5.4-nano    │ Gemini: Gemini 3.1 Flash-Lite
Level 2  │ Anthropic: Haiku Medium    │ OpenAI: gpt-5.4-mini low│ Gemini: Gemini 2.5 Flash-Lite
Level 3  │ Anthropic: Sonnet Low      │ OpenAI: gpt-5.4-mini med│ Gemini: Gemini 2.5 Flash
Level 4  │ Anthropic: Sonnet Medium   │ OpenAI: gpt-5.4 medium  │ Gemini: Gemini 3 Flash
Level 5  │ Anthropic: Sonnet High     │ OpenAI: gpt-5.4 high    │ Gemini: Gemini 2.5 Pro
Level 6  │ Anthropic: Opus High       │ OpenAI: gpt-5.5 high    │ Gemini: Gemini 3.1 Pro
Level 7  │ Anthropic: Opus Max        │ OpenAI: gpt-5.5 xhigh   │ Gemini: Gemini 3.1 Pro Max
```

---

## 8.3 Come stimare il livello di un task

Il Model Level si calcola in due passi: prima stimi i token, poi applichi eventuali risk floor.

### Passo 1 — Stima dei token

La stima è `input / output / totale`. L'input include il contesto che l'agente deve leggere; l'output è il codice o testo che produce.

Alcune euristiche pratiche:

| Cosa stai dando all'agente | Token input approssimativi |
|---|---|
| Un singolo file di 100 righe | ~500-800 token |
| Il `_CONTEXT.md` compilato | ~500-1000 token |
| Tre file di 200 righe ciascuno | ~3000-5000 token |
| Un intero modulo da 10 file | ~10.000-20.000 token |
| Una codebase da 500 file | ~100.000+ token |

Per l'output:
- Una funzione di 20-30 righe: ~200-400 token
- Un endpoint completo con validazione e test: ~1500-3000 token
- Un refactor multi-file: ~5000-15.000 token

**Esempio per TaskFlow API:**

Lorenzo deve implementare `GET /tasks` con filtri e paginazione. Ha bisogno di leggere:
- `_CONTEXT.md`: ~700 token
- `src/routes/tasks.ts` (endpoint POST già esistente): ~600 token
- `src/services/taskService.ts`: ~400 token
- `prisma/schema.prisma`: ~300 token

Input totale: ~2000 token. L'agente produrrà il nuovo endpoint + service + test: ~2500 token.
Totale: ~4500 token → **Livello 2**.

Ma aspetta — c'è il risk floor.

### Passo 2 — Applica il risk floor

Il task è classificato MEDIUM (nuovo endpoint). Il risk floor per MEDIUM è livello 3. Anche se la stima token suggerisce livello 2, il level sale a 3.

```
Active Task Token Est.   | 2000/2500/4500
Active Task Model Level  | 3 Sonnet Low
```

Il risk floor non è un override arbitrario: garantisce che le task MEDIUM vengano gestite da un modello con capacità di ragionamento adeguate, indipendentemente dalla quantità di token.

---

## 8.4 I risk floor in dettaglio

| Condizione | Minimum Level | Perché |
|---|---|---|
| Task MEDIUM | 3 | Ragionamento sufficiente per pianificare e valutare trade-off |
| Task HIGH | 5 | Capacità analitiche per valutare rischi e effetti collaterali |
| Auth, secrets, compliance, dati produzione | 6 | Precisione e ragionamento necessari per operazioni irreversibili su sistemi critici |
| Architettura o cambiamenti cross-modulo | 6 | Visione sistemica richiesta |
| CRITICAL | 7 | Massima capacità di ragionamento per decisioni mission-critical ad alta ambiguità |

Il risk floor è *cumulativo*: se un task è HIGH (floor 5) e tocca codice di autenticazione (floor 6), si usa il massimo tra i due — livello 6.

---

## 8.5 Dove vivono le stime

Ogni task ADLC deve includere la stima. Nel `_CONTEXT.md`:

```markdown
| Active Task Token Est.   | 2000/2500/4500 |
| Active Task Model Level  | 3 Sonnet Low   |
```

Nei file di task (se li usi):

```markdown
## AI Sizing
| Field                 | Value                         |
|-----------------------|-------------------------------|
| Token Estimate        | 2000 input / 2500 output / 4500 total |
| Model Level           | 3                             |
| Risk Floor Applied    | MEDIUM → min 3                |
| Recommended Model     | vedi manifest.json#model_levels |
| Rationale             | Nuovo endpoint con validazione e test |
```

---

## 8.6 La stima migliora con la pratica

La prima volta che stimi un task da 0 probabilmente sbaglierai. Va bene. Tre settimane di lavoro su TaskFlow API hanno dato a Lorenzo un'intuizione abbastanza precisa:

- Endpoint singolo con test: livello 3
- Feature con più endpoint e modifiche al service layer: livello 4
- Refactor del sistema di autenticazione: livello 6 (risk floor auth)
- Analisi della codebase dopo 3 mesi di sviluppo: livello 6-7

Se le tue stime sono sistematicamente sbagliate in una direzione, aggiustale. Il validator non fa fallire la build per stime imprecise — sono informazioni per te e per l'agente, non SLA.

---

## 8.7 Perché questo sistema esiste

Potresti chiederti: perché non usare sempre il livello 7 e non pensarci più?

La risposta è che il costo non è solo economico. Su molti sistemi di agenti AI, usare un modello più potente del necessario aumenta la latency, può introdurre verbosità inutile e — su task semplici — può paradossalmente produrre output peggiori perché il modello cerca di essere più "creativo" dove la soluzione era ovvia.

Più in profondità: il sistema di Model Levels ti forza a *pensare* alla complessità del task prima di delegarlo. Quella pausa da dieci secondi in cui stimi il livello è spesso sufficiente per accorgerti che stai per chiedere all'agente qualcosa che non hai ancora definito con sufficiente chiarezza.

---

## Riepilogo

- I Model Levels (1-7) mappano la complessità del task al modello AI appropriato, bilanciando costo, latency e capacità di ragionamento.
- La stima è `input/output/totale` in token; il mapping vendor concreto è in `manifest.json` e si legge con `show-models`.
- Il risk floor forza un minimum level indipendentemente dalla stima token: HIGH → 5, auth/secrets/produzione → 6, CRITICAL → 7.
- La stima migliora con la pratica; le prime settimane è normale sbagliare — l'importante è avere una stima, non che sia perfetta.

Nel prossimo capitolo affrontiamo uno dei meccanismi più sottili di ADLC: i confidence tags, il sistema con cui l'agente dichiara esplicitamente quanto è certo di ciò che dice.
