# Revisione Completa — "ADLC: Orchestrare Agenti AI nello Sviluppo Software"

**Data:** 2026-06-27
**Lingua:** it
**Fase:** 4 — Revisione Editoriale
**File analizzati:** `md/it/00-introduzione.md` → `md/it/93-appendice-d-risorse.md` (21 file)

---

## Valutazione complessiva

Il libro è solido nella struttura e nel contenuto tecnico. Il filo conduttore di TaskFlow API funziona: il lettore segue Lorenzo, Giulia e Marco su un progetto realistico e vede ADLC evolversi sessione dopo sessione. Il tono è diretto, tecnico ma non accademico, coerente tra i capitoli.

Le prime tre parti (Framework, Memoria, Sicurezza) sono le più riuscite: ogni capitolo ha un'apertura narrativa, sviluppo con esempi concreti e riepilogo. La Parte IV (Workflow Avanzato) è densa — il Cap 15 comprime tre argomenti che meriterebbero più spazio. Il Cap 16 è funzionale ma ha una chiusura stilisticamente debole.

Problemi tecnici puntuali da correggere (path errati, URL fittizio non segnalato, progressione di fase non esplicitata) e alcune scelte strutturali da rivedere.

**Punteggio complessivo:** ⭐⭐⭐⭐☆ (4/5) — pubblicabile dopo le correzioni critiche e i miglioramenti consigliati.

---

## Mappa del libro

| # | File | Qualità | Note |
|---|------|---------|------|
| 00 | Introduzione | ⭐⭐⭐⭐⭐ | Apertura forte, tre storie efficaci |
| 01 | Cap 1 — Cos'è ADLC | ⭐⭐⭐⭐⭐ | Chiaro, tabella concetti finale ottima |
| 02 | Cap 2 — Setup | ⭐⭐⭐⭐☆ | URL fittizio non segnalato come placeholder |
| 03 | Cap 3 — Sessione reale | ⭐⭐⭐⭐⭐ | Meglio capitolo del libro |
| 04 | Cap 4 — `_CONTEXT.md` | ⭐⭐⭐⭐☆ | Molto completo, leggermente lungo |
| 05 | Cap 5 — `PROGRESS.md` | ⭐⭐⭐⭐⭐ | Conciso, differenza context/progress cristallina |
| 06 | Cap 6 — Fasi e Modes | ⭐⭐⭐⭐☆ | Manca dialogo concreto su cambio Mode |
| 07 | Cap 7 — Rischio | ⭐⭐⭐⭐⭐ | Esempi per livello eccellenti |
| 08 | Cap 8 — Model Levels | ⭐⭐⭐⭐☆ | Calcolo stima token incompleto |
| 09 | Cap 9 — Confidence Tags | ⭐⭐⭐⭐☆ | Formato tag mostrato troppo tardi (§9.6) |
| 10 | Cap 10 — HALT Triggers | ⭐⭐⭐⭐⭐ | Molto solido, yaml reale citato correttamente |
| 11 | Cap 11 — SEC/PERF | ⭐⭐⭐⭐☆ | Lungo ma necessario; sezione 11.7 utile |
| 12 | Cap 12 — Moduli e Skill | ⭐⭐⭐⭐☆ | Path moduli con slash errato |
| 13 | Cap 13 — Comandi | ⭐⭐⭐⭐⭐ | Dettaglio output per comando ottimo |
| 14 | Cap 14 — Multi-agente | ⭐⭐⭐⭐☆ | Personaggi introdotti tardi, Codex note necessarie |
| 15 | Cap 15 — Monorepo/Legacy | ⭐⭐⭐☆☆ | Tre argomenti compressi, legacy sottosviluppato |
| 16 | Cap 16 — Produzione | ⭐⭐⭐⭐☆ | Troubleshooting ottimo, chiusura debole |
| A | Appendice A — Glossario | ⭐⭐⭐⭐⭐ | Definizioni operative precise |
| B | Appendice B — Comandi | ⭐⭐⭐⭐⭐ | Completo e ben strutturato |
| C | Appendice C — Template | ⭐⭐⭐⭐☆ | Template 2 (CONTEXT min) manca vincolo branch |
| D | Appendice D — Risorse | ⭐⭐⭐⭐☆ | URL da verificare, note su obsolescenza |

---

## Punti di forza

- **Il filo narrativo di TaskFlow API** funziona in modo coerente dall'inizio alla fine. Il lettore non deve fare sforzi per contestualizzare gli esempi.
- **Cap 3 (Sessione reale)** è il capitolo migliore: mostra LOW/MEDIUM/HIGH/HALT/checkpoint in sequenza su un task reale. È il capitolo di riferimento per chi vuole capire ADLC velocemente.
- **Cap 7 (Classificazione rischio)** con gli esempi concreti per ogni livello, inclusa la tabella "distribuzione tipica su una settimana", è eccellente didatticamente.
- **Cap 13 (Comandi)** con l'output atteso per ogni comando è una risorsa di riferimento di alta qualità.
- **Introduzione**: le tre storie (Marco/Giulia/Luca) sono concrete, riconoscibili e collegano direttamente i problemi alle soluzioni di ADLC.
- **Appendici A e B**: glossario con definizioni operative (non astratte) e riferimento comandi con tabella rapida sono strumenti di consultazione genuinamente utili.

---

## Problemi trovati

### 🔴 Critici (da correggere prima della revisione LaTeX)

**1. Path moduli con slash iniziale errato — Cap 12 (§12.1)**

Nel testo: `` `/adlc/modules/NN_*.md` `` e `` `/.ai-dlc/modules/skills/SKILL_*.md` ``

Corretto: `.ai-dlc/modules/NN_*.md` e `.ai-dlc/modules/skills/SKILL_*.md`

I path usano uno slash iniziale che implica un path assoluto. Tutti gli altri capitoli usano la forma corretta con il punto iniziale (path relativo alla root del repo). Va corretto per coerenza e correttezza tecnica.

**Correzione:** rimuovere il `/` iniziale in entrambe le occorrenze in §12.1.

---

**2. URL fittizio non segnalato come placeholder — Cap 2 (§2.1)**

Il testo cita `https://github.com/rollaradio/adlc-framework` come URL reale da cui clonare il framework, senza segnalare che è un placeholder. Se il repo non esiste o ha un URL diverso, il lettore proverà a clonare e fallirà senza capire perché.

**Correzione:** aggiungere una nota esplicita:
```
> **Nota:** l'URL del repository ufficiale è indicativo — verifica quello
> corretto nella documentazione aggiornata del framework.
```
Oppure sostituire con il path corretto al momento della pubblicazione.

---

**3. Salto di fase non esplicitato tra Cap 2 e Cap 3**

Nel Cap 2, Lorenzo imposta `Phase: 0-Discovery` nel `_CONTEXT.md`. Nel Cap 3, il bootstrap mostra `Phase: 3-Implementation` per il task T-007. Non viene mai spiegato quando e come è avvenuta la transizione attraverso le fasi 0→1→2→3.

Il lettore potrebbe chiedersi: "ho saltato qualcosa?" Il libro ha bisogno di un raccordo — anche solo un paragrafo di transizione all'inizio del Cap 3.

**Correzione:** aggiungere a inizio Cap 3, prima del §3.1:

> *TaskFlow API ha attraversato le fasi 0-2 in tre settimane. I requisiti sono stati analizzati, l'architettura definita (schema DB, contratto API), le decisioni aperte chiuse. Lorenzo ha aggiornato `_CONTEXT.md` a `Phase: 3-Implementation` al termine del design. Da quel punto, inizia il lavoro che seguiamo in questo capitolo.*

---

**4. "Contribuire al framework" citato nel riepilogo ma non sviluppato — Cap 16 (§16.2)**

Il riepilogo di Cap 16 include "Contribuire al framework (per team che condividono ADLC)" come bullet, ma questo argomento non è trattato nel capitolo. Il lettore si aspetta contenuto che non trova.

**Correzione:** rimuovere la voce dal riepilogo, oppure aggiungere un breve paragrafo §16.3.X che descriva il processo base di contribuzione (fork → modifica in `.ai-dlc/modules/` → PR → test con validate.sh).

---

### 🟡 Miglioramenti consigliati

**5. Introduzione dei personaggi — Cap 2, 3 e 14**

Lorenzo compare nel Cap 2 senza presentazione ("Lorenzo — il tech lead — apre Claude Code"). Nel Cap 14 Giulia e Marco compaiono per la prima volta. I personaggi sono funzionali ma la loro comparsa è brusca.

**Suggerimento:** nell'introduzione della sezione "Il progetto di esempio", aggiungere dopo la presentazione di TaskFlow API:

> *Il team è composto da tre sviluppatori: **Lorenzo**, tech lead con esperienza backend, **Giulia**, sviluppatrice full-stack che usa VS Code e Copilot per il lavoro quotidiano, e **Marco**, che si occupa di DevOps e code review. Li seguiremo in sessioni diverse nel corso del libro.*

---

**6. Formato dei confidence tag mostrato troppo tardi — Cap 9 (§9.6)**

La sezione 9.6 "Il formato dei tag" appare dopo gli esempi pratici (§9.3 e §9.4). Il lettore legge esempi come:
```
AI CONFIDENCE: FACT
Basis: letto src/services/userService.ts, riga 45-50
```
senza che il formato sia stato introdotto formalmente. La §9.6 dovrebbe diventare §9.1 o essere incorporata nella presentazione dei tre tag.

**Suggerimento:** spostare il contenuto di §9.6 alla fine di §9.1, subito dopo la presentazione di FACT/INFERRED/ASSUMPTION, con il titolo "Come appaiono in pratica".

---

**7. Calcolo stima token incompleto — Cap 8 (§8.3)**

L'esempio di calcolo mostra i dati (2000 token input, 2500 output, totale 4500) e poi conclude "→ Livello 2. Ma aspetta — c'è il risk floor". Il percorso logico 4500 → livello 2 non è esplicitato (il lettore deve fare il collegamento con la tabella in §8.1 da solo).

**Suggerimento:** aggiungere dopo la stima:
> *4.500 token totali rientrano nel range 4k-8k → **Livello 2** (dalla tabella §8.1). Ma prima di concludere, si applica il risk floor.*

---

**8. Cap 6 manca un dialogo concreto sul cambio Mode**

Il capitolo sui Modes è l'unico dei fondamentali (cap 4-6) senza un esempio di dialogo agente/utente. La tabella "Scenario tipico su TaskFlow API" è utile ma astratta.

**Suggerimento:** aggiungere in §6.4 un breve esempio:

> *Lorenzo, dopo due settimane in STANDARD, vuole passare a LITE. Aggiorna `_CONTEXT.md`:*
> ```markdown
> | Mode | LITE |
> ```
> *All'inizio della sessione successiva, l'agente non chiede la conferma del contesto — lo presuppone invariato. Lorenzo lo nota subito: "Procedi con GET /tasks" e l'agente inizia il piano senza il passo di bootstrap esplicito.*

---

**9. Cap 15 — tre argomenti in un capitolo, legacy sottosviluppato**

Il Cap 15 copre monorepo, company extension e codebase legacy in circa 1.500 parole. La sezione legacy (§15.3) è quella più importante operativamente ma è compressa. Mancano dettagli come:
- Come gestire gli halt-triggers in un monorepo (trigger root vs per-progetto)
- Come verificare la documentazione generata in pratica (esempio di diff tra MAP.md generato e codice reale)

Questa è una limitazione dell'impostazione a capitolo unico. Se il libro viene espanso in una seconda edizione, questi tre argomenti meriterebbero capitoli separati.

**Per questa versione:** aggiungere in §15.3 Step 3 (Verifica) un esempio concreto di discrepanza trovata tra MAP.md e codice, per rendere la verifica meno astratta.

---

**10. Terminologia "confidence tag" — uniformare**

Il libro usa indifferentemente "confidence tag" (it-ish), "confidence tags" (en), "tag di confidenza" (it). Nel glossario è voce principale come "Confidence tag" (singolare), ma nel testo del Cap 9 si alterna tra le forme.

**Suggerimento:** adottare "confidence tag" (invariato, senza traduzione, singolare e plurale) come forma unica, coerente con come vengono citati i valori FACT/INFERRED/ASSUMPTION. Applicare uniformemente in tutti i capitoli e appendici.

---

### 🟢 Minori / stilistici

**11. §16.5 "Quando il framework non serve più" — posizione e tono**

La sezione che descrive la disadozione del framework è l'ultima del capitolo e del libro (prima delle appendici). È utile ma chiude su una nota laterale anziché sul ciclo di vita.

**Suggerimento:** spostare §16.5 prima di §16.4 (Ops), così l'Ops rimane la chiusura operativa. Oppure rinominarla "Ciclo di vita del framework: da adozione a disadozione consapevole" per renderla più naturale nel flusso.

---

**12. Appendice C — Template 2 (CONTEXT minimo): manca vincolo branch RAPID**

Il template 2 imposta `Mode: RAPID` ma non include il vincolo esplicito "usa branch separato, evita path di produzione" che nel Cap 6 è descritto come obbligatorio per il mode RAPID.

**Correzione:** aggiungere nel Template 2:
```markdown
## Note per l'Agente
- Mode RAPID: lavora su branch dedicato, non toccare path di produzione
```

---

**13. Appendice D — URL da marcare come "verifica prima dell'uso"**

Due URL sono a rischio di obsolescenza rapida:
- `https://docs.anthropic.com/claude-code`
- `https://github.com/openai/openai-codex` (Codex CLI è stato deprecato; il repo potrebbe essere archiviato)

**Suggerimento:** aggiungere una nota a inizio Appendice D:
> *I link a documentazione ufficiale di agenti AI cambiano frequentemente. Verifica che gli URL siano ancora validi prima di seguirli.*

E per OpenAI Codex CLI, aggiungere una nota specifica che il prodotto potrebbe essere stato deprecato o rinominato al momento della lettura.

---

**14. Cap 1 — tabella "concetti fondamentali in sintesi": colonna A cosa serve non uniforme**

La terza colonna della tabella mescola forme diverse: alcune voci descrivono lo scopo ("Fase, task attivo, stack, vincoli attivi"), altre descrivono il meccanismo ("Classificazione interna"), altre ancora una scala ("1-7"). Va uniformata verso la descrizione dello scopo operativo.

---

## Coerenza globale

**Positivo:**
- Il nome del progetto (TaskFlow API) e i personaggi (Lorenzo principalmente) sono coerenti in tutti i capitoli della Parte I-III.
- I vincoli SEC-01..05 e PERF-01..03 citati nel Cap 2 appaiono coerentemente in tutti i capitoli successivi dove sono rilevanti.
- I comandi conversazionali (`@checkpoint`, `@context-update`, ecc.) sono introdotti nel Cap 3 e poi usati naturalmente nei capitoli successivi senza ridefinizione.

**Da correggere:**
- I path `.ai-dlc/` sono coerenti in tutti i capitoli eccetto Cap 12 §12.1 (problema #1).
- I personaggi non sono introdotti in modo uniforme (problema #5).
- "Confidence tag" ha varianti terminologiche (problema #10).

---

## Prossimi passi (Fase 5 — Copy Editing)

- [ ] Correggere path con slash iniziale in Cap 12 §12.1 (**critico**)
- [ ] Aggiungere nota su URL fittizio in Cap 2 §2.1 (**critico**)
- [ ] Aggiungere raccordo di fase a inizio Cap 3 (**critico**)
- [ ] Risolvere "Contribuire al framework" in Cap 16 riepilogo (**critico**)
- [ ] Introdurre personaggi in Intro sezione "Il progetto di esempio" (**importante**)
- [ ] Spostare §9.6 a inizio §9.1 in Cap 9 (**importante**)
- [ ] Completare calcolo stima token in Cap 8 §8.3 (**importante**)
- [ ] Aggiungere dialogo cambio Mode in Cap 6 §6.4 (**importante**)
- [ ] Aggiungere esempio verifica MAP.md in Cap 15 §15.3 (**importante**)
- [ ] Uniformare "confidence tag" in tutto il libro (**copy editing**)
- [ ] Spostare §16.5 prima di §16.4 o rinominare (**stilistico**)
- [ ] Aggiungere nota branch RAPID nel Template 2, App C (**copy editing**)
- [ ] Aggiungere note URL obsolescenza in App D (**copy editing**)
- [ ] Uniformare colonna "A cosa serve" in tabella Cap 1 (**stilistico**)
