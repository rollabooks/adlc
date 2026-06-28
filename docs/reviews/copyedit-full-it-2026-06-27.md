# Copy Editing Completo — "ADLC: Orchestrare Agenti AI"

**Data:** 2026-06-27
**Lingua:** it
**Fase:** 5 — Copy Editing
**File analizzati:** tutti i 21 file in `md/it/`

---

## Stato complessivo

⚠️ Correzioni necessarie — applicate direttamente. Testo pronto per Fase 6 (Correzione Bozze).

---

## Correzioni applicate

### Terminologia — "confidence tag" uniformato

**Problema:** il testo usava sia "confidence tags" (con 's') che "confidence tag" (invariante). Il glossario e l'Appendice A usavano la forma invariante come voce principale.

**Decisione:** adottato "confidence tag" invariante (singolare e plurale) come forma unica — trattamento standard in italiano tecnico per termini composti inglesi.

**File modificati:** 00-introduzione.md, 01-cose-adlc.md, 06-fasi-e-modes.md, 08-model-levels.md, 09-confidence-tags.md, 11-vincoli-sec-perf.md, 12-moduli-e-skill.md, 16-produzione.md

**Occorrenze corrette:** 14

---

### Errore fattuale — `express-jwt` → `@fastify/jwt` (Cap 09)

**Problema:** nell'esempio INFERRED (§9.1), il testo citava `express-jwt` come libreria JWT per il middleware di autenticazione. `express-jwt` è una libreria per Express, non per Fastify. TaskFlow API usa Fastify con `@fastify/jwt` — libreria già citata correttamente nella Basis dello stesso esempio.

**Correzione applicata:**
- Prima: "Il middleware di autenticazione probabilmente usa `express-jwt` basandosi sull'import in src/app.ts (riga 8) e sul pattern standard di Fastify per JWT."
- Dopo: "Il middleware di autenticazione probabilmente usa `@fastify/jwt` basandosi sull'import in src/app.ts (riga 8)."

La seconda frase era ridondante (ripeteva l'import) ed è stata rimossa.

**File:** md/it/09-confidence-tags.md

---

### Tag lingua ai blocchi di codice

**Problema:** numerosi blocchi ```` ``` ```` senza linguaggio specificato. Rilevante per la sintassi highlighting nella compilazione LaTeX/EPUB e per la chiarezza tipografica.

**Convenzione adottata:**
- `text` — output dell'agente, log di sistema, messaggi di testo
- `markdown` — esempi di file Markdown (già presenti nella maggior parte dei blocchi)
- `yaml` — file YAML (già presenti)
- `bash` / `powershell` — comandi shell (già presenti)
- `json` — strutture JSON (già presenti)

**Blocchi corretti con aggiunta di `text`:**

| File | Contenuto del blocco |
|---|---|
| Cap 04 §4.1 | Directory tree `taskflow-api/` |
| Cap 07 §7.1 LOW | `[LOW] Fixed typo...` |
| Cap 07 §7.1 MEDIUM | `[MEDIUM] Proposta per GET /tasks...` |
| Cap 07 §7.1 HIGH | `⚠ HALT — HIGH risk detected` |
| Cap 07 §7.1 HIGH+ | `⛔ HALT — HIGH+ risk: auth/secrets` |
| Cap 07 §7.1 CRITICAL | `⛔ HALT — CRITICAL: architectural decision` |
| Cap 09 §9.1 (formato) | `AI CONFIDENCE: [FACT | INFERRED | ASSUMPTION]` |
| Cap 09 §9.1 FACT | Esempio confidence tag FACT |
| Cap 09 §9.1 INFERRED | Esempio confidence tag INFERRED |
| Cap 09 §9.1 ASSUMPTION | Esempio confidence tag ASSUMPTION |
| Cap 16 §16.1 | `@show-constraints` (comando) |
| Cap 16 §16.1 | `"Rileggi _CONTEXT.md..."` (prompt) |
| Cap 16 §16.1 | `✗ T-009.1.md: missing required field` |

**File modificati:** 04-context-md.md, 07-classificazione-rischio.md, 09-confidence-tags.md, 16-produzione.md

---

## Verifiche completate senza correzioni necessarie

### Nomi tecnologie — capitalizzazione
Tutti corretti nel manoscritto:
- ✅ PostgreSQL (12 occorrenze)
- ✅ Node.js (8 occorrenze)
- ✅ Fastify (11 occorrenze)
- ✅ GitHub / GitHub Actions (6 occorrenze)
- ✅ Prisma (15 occorrenze)
- ✅ Zod (9 occorrenze)
- ✅ TypeScript (3 occorrenze)

### Versioni software
- ✅ Node.js 22 — versione LTS attuale, coerente
- ✅ Fastify 5 — versione corrente
- ✅ PostgreSQL 16 — versione corrente
- ✅ Prisma (senza numero di versione) — scelta intenzionale per evitare obsolescenza

### Riferimenti incrociati
Verificati tutti i riferimenti "Capitolo N" e "§N.N":
- ✅ Cap 04 §4.1 → "il Capitolo 15 copre questo scenario" — Cap 15 tratta il monorepo ✓
- ✅ Cap 07 §7.3 → "Il Capitolo 8 spiega i model level in dettaglio" ✓
- ✅ Cap 08 §8.1 → tabella §8.1 citata correttamente in §8.3 ✓
- ✅ Cap 09 titolo §9.6 rimosso (spostato in §9.1 durante Fase 4) — nessun riferimento orfano ✓
- ✅ Cap 10 → non ci sono riferimenti a sezioni inesistenti ✓
- ✅ Cap 12 §12.8 → riferimento a `.ai-dlc/project/instructions.md` coerente con Cap 2 ✓

### Livelli intestazione
- ✅ Tutti i capitoli: `#` (h1) per titolo, `##` (h2) per sezioni, `###` (h3) per sottosezioni
- ✅ Nessun salto di livello (h1→h3 senza h2) rilevato
- ✅ Appendici: stessa struttura dei capitoli

### Formattazione codice inline
- ✅ Nomi file in backtick: `_CONTEXT.md`, `PROGRESS.md`, `AGENTS.md`
- ✅ Comandi in backtick: `@checkpoint`, `@show-constraints`
- ✅ Path in backtick: `.ai-dlc/modules/`, `src/routes/tasks.ts`
- ✅ Nomi di tecnologie nei path in backtick: `@fastify/jwt`, `zod`
- ✅ Valori di campo in backtick: `Phase: 3-Implementation`, `Mode: LITE`

---

## Correzioni da confermare dall'autore

Nessuna correzione richiede decisione dell'autore — tutte le modifiche applicate erano oggettivamente corrette (errore fattuale, tag lingua mancanti, terminologia stabilita nella Fase 4).

---

## Statistiche

| Tipo | Conteggio |
|---|---|
| Errori fattuali corretti | 1 (`express-jwt` → `@fastify/jwt`) |
| Occorrenze terminologiche uniformate | 14 (confidence tag/s) |
| Blocchi di codice con tag lingua aggiunto | 13 |
| Riferimenti incrociati verificati | 6 ✅ |
| Nomi tecnologie verificati | 7 ✅ |
| File modificati totali | 12 |
| File verificati senza modifiche | 9 |

---

## Prossimi passi (Fase 6 — Correzione Bozze)

- [ ] Lettura lineare di ogni capitolo per refusi e typo residui
- [ ] Verifica punteggiatura: virgole, punto e virgola, trattini em
- [ ] Controllo spaziatura: doppie righe vuote, spazi finali di riga
- [ ] Verifica intestazioni: maiuscole coerenti nei titoli di sezione
- [ ] Controllo formattazione Markdown: link, bold, italic non chiusi
