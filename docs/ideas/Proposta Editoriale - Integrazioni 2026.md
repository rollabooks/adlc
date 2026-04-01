# Proposta Editoriale: Integrazioni dallo Stato dell'Arte 2026

## Filosofia di Integrazione

La revisione propone 9 aree di intervento. Come editor, filtro queste raccomandazioni attraverso il **target del libro**: un manuale pratico per sviluppatori in transizione verso il paradigma 0-Code, con progressione didattica dal principiante al professionista.

**Principio guida**: espandere la prospettiva senza snaturare l'identità dell'opera. Il libro si intitola "con VS Code, Copilot e Claude Code" — non si cambia l'IDE di riferimento, si aggiunge consapevolezza. Non si abbandona l'OWASP web, si integra la sicurezza MCP. Non si riscrive il testing, si aggiunge la dimensione probabilistica.

---

## Triage delle Raccomandazioni

| # | Raccomandazione della Revisione | Decisione Editoriale | Motivazione |
|---|--------------------------------|---------------------|-------------|
| 1 | Sostituire VS Code con Cursor/Windsurf | **ADATTARE** — Aggiungere panoramica, non sostituire | VS Code è nel titolo e in tutti gli esempi. Riscrivere tutto sarebbe un libro diverso. |
| 2 | Integrare Vibe Coding / FAAFO | **ACCETTARE** — Sezione critica in Ch16 | Il lettore deve posizionarsi rispetto al dibattito dominante del 2026. |
| 3 | Espandere ecosistema MCP | **ACCETTARE** — Espansione in Ch16 | La trattazione attuale (solo PostgreSQL) è insufficiente. |
| 4 | OWASP MCP Top 10 / Sicurezza Agentica | **ACCETTARE** — Nuova sezione in Ch14 | Lacuna critica: il libro insegna a concedere autonomia all'IA senza trattare i rischi specifici. |
| 5 | NemoClaw / Governance Enterprise | **RIDURRE** — Breve sezione in App-E | Troppo enterprise per il target del libro. Una panoramica basta. |
| 6 | Testing non deterministico | **ADATTARE** — Sottosezione in Ch14 | Il libro insegna test tradizionali (corretti per il livello). Aggiungere consapevolezza, non sostituire. |
| 7 | App Builder AI-Native | **ACCETTARE** — Sezione in Ch16 | Il lettore deve sapere quando NON usare l'orchestrazione manuale. |
| 8 | Aggiornare bibliografia | **ACCETTARE** — Nuove voci in App-D | Doveroso. |
| 9 | "Software a perdere" / throwaway | **ACCETTARE** — Integrato nella sezione Vibe Coding | Concetto controverso ma necessario da discutere. |

---

## Piano Interventi per Capitolo

### 1. Capitolo 2 — "L'Ambiente di Sviluppo" (~40 righe)
**Nuova sezione dopo "Alternativa: Claude Code da Terminale":**
- "Oltre VS Code: Gli IDE AI-Nativi del 2026"
- Tabella comparativa: VS Code + Copilot / Cursor / Windsurf / Claude Code CLI
- Spiegazione di perché il libro usa VS Code (ecosistema, costo, universalità)
- `warnbox` sulla velocità di evoluzione degli strumenti

### 2. Capitolo 14 — "Testing e Sicurezza" (~70 righe)
**Due nuove sezioni dopo "Security Checklist Finale":**

**a) "Sicurezza Agentica: Oltre l'OWASP Web"**
- Le 3 vulnerabilità MCP critiche: Tool Poisoning, Shadow MCP, Context Injection
- Checklist di sicurezza per l'infrastruttura agentica
- Come validare i server MCP prima di installarli

**b) "Testing di Sistemi Non Deterministici" (sottosezione)**
- Il limite dei test tradizionali per output probabilistici
- Piattaforme di valutazione (Maxim AI, Testim)
- Osservabilità con tracing (Arize Phoenix / OpenTelemetry)

### 3. Capitolo 16 — "Pattern Avanzati e Oltre" (~100 righe)
**Tre interventi:**

**a) Espansione "Multi-Tool con MCP"** (+30 righe)
- Tassonomia server MCP per categoria (docs, sandbox, infra, CI/CD, automazione)
- Tabella con server consigliati per tipo di progetto
- Nota sul bilanciamento della finestra di contesto

**b) Nuova sezione "Vibe Coding e il Dibattito FAAFO"** (+40 righe)
- Posizionamento critico: cosa il Vibe Coding fa bene, dove il metodo strutturato resta necessario
- Il concetto di "software a perdere" e i suoi limiti
- Come bilanciare velocità esplorativa (FAAFO) e rigore architetturale (ADLC)

**c) Nuova sezione "Piattaforme App Builder AI-Native"** (+30 righe)
- Base44, Lovable, Bolt.new, Vybe
- Matrice decisionale: quando orchestrare manualmente vs. usare un builder
- Posizionamento rispetto al metodo del libro

### 4. Appendice D — "Bibliografia e Risorse" (~25 righe)
- Sezione "IDE e Strumenti di Nuova Generazione" (Cursor, Windsurf)
- Sezione "Vibe Coding e Approcci Emergenti" (Kim & Yegge)
- Espansione "Sicurezza" con OWASP MCP Top 10, CoSAI
- Aggiunta NemoClaw/OpenShell

### 5. Appendice E — "Framework ADLC Reale" (~35 righe)  
**Nuova sezione "Oltre il Contratto Testuale: La Governance Infrastrutturale":**
- I limiti dei vincoli in linguaggio naturale
- NemoClaw e OpenShell: policy a livello di runtime
- Come i due approcci (testuale + infrastrutturale) si completano

---

## Interventi NON proposti (con motivazione)

| Intervento escluso | Motivazione |
|-------------------|-------------|
| Riscrivere tutti gli esempi per Cursor | Cambierebbe l'identità del libro. Il lettore può applicare i concetti su qualsiasi IDE. |
| Trattazione esaustiva NemoClaw | Troppo enterprise. Un manuale pratico non è un white paper infrastrutturale. |
| Abbandonare unit test per "Evaluator Agents" | I unit test sono fondamentali e il lettore deve impararli. Gli evaluator agents sono un PLUS. |
| Capitoli dedicati su singoli app builder | Il libro insegna a orchestrare manualmente — il metodo ha più valore didattico. I builder vanno *menzionati*, non *insegnati*. |
| Trattazione approfondita del Privacy Router | Concetto enterprise troppo specifico per il target. |

---

## Stima Impatto

- **Righe aggiunte totale**: ~270 righe LaTeX (~8 pagine stampate)
- **File modificati**: 5 (ch02, ch14, ch16, app-d, app-e)
- **File markdown da sincronizzare**: 5 corrispondenti in `libro/`
- **Struttura libro**: invariata (nessun nuovo capitolo/appendice)
- **Titolo libro**: invariato
- **Progressione didattica**: preservata (le aggiunte sono alla fine dei rispettivi capitoli)
