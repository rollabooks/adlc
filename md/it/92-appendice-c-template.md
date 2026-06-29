# Appendice C — Template Pronti all'Uso

Template copiabili per i file più usati di AI-DLC. Sostituisci i valori tra `[parentesi]` con quelli reali del tuo progetto.

---

## Catalogo degli artefatti AI-DLC

Il framework produce un insieme definito di documenti. Ognuno ha uno scopo, un momento in cui nasce e un posto dove vive (versionato nel repository). Questa è la mappa; i template seguono.

| Artefatto | Cos'è | Quando nasce | Dove vive |
|---|---|---|---|
| `_CONTEXT.md` | Stato corrente + vincoli invalicabili (fonte di verità) | All'avvio, aggiornato ogni sessione | radice del progetto |
| `PROGRESS.md` | Diario cronologico di sessioni, decisioni, scoperte | Ogni sessione (append) | radice del progetto |
| **Requisiti** (FR/NFR) | Requisiti funzionali e non funzionali | Fase 1 (Analysis) | `docs/01_ANALYSIS/02_SPEC.md`, `03_NFR.md` |
| **Glossario di dominio** | Termini del dominio condivisi | Fase 0–1 | `docs/01_ANALYSIS/01_GLOSSARY.md` |
| **User Story** | Requisito dal punto di vista dell'utente + AC | Fase 1 | backlog |
| **Modello dati concettuale** | Entità e relazioni, tecnologia-agnostico | Fase 1 | `docs/01_ANALYSIS/04_DATA_MODEL.md` |
| **Threat model** | Asset, attori, superfici d'attacco, mitigazioni | Fase 1–2 | `docs/02_DATA_GOVERNANCE/THREAT_MODEL.md` |
| **ADR** (Decision Record) | Decisione architetturale: contesto, opzioni, scelta, conseguenze | Su decisione HIGH/CRITICAL | `docs/` (vicino al codice) |
| **EPIC** | Contenitore di valore con user story, AC e task | Pianificazione di una feature ampia | backlog / `docs/` |
| **TASK** | Unità di implementazione (sizing, AC, test) | Fase 3, prima di scrivere codice | task docs |
| **Analisi codebase** (legacy) | MAP / RISKS / HOTSPOTS / RUN di un codice esistente | Prima di modifiche su codebase esistenti | `docs/` |
| **Company process** | Gate e standard aziendali | Setup enterprise | `.ai-dlc/company/` |
| **Project instructions** | Regole specifiche di progetto | Setup progetto | `.ai-dlc/project/instructions.md` |

I template più usati seguono. I template completi in Markdown sono in `.ai-dlc/modules/templates/`.

---

## Template 1 — `_CONTEXT.md` Completo

```markdown
# PROJECT CONTEXT CARD
> Ultimo aggiornamento: [YYYY-MM-DD]
> Stato: ACTIVE

---

## Stato Corrente

| Param                     | Value                                      |
|---------------------------|--------------------------------------------|
| Project                   | [Nome progetto]                            |
| Phase                     | [0-Discovery / 1-Analysis / 2-Design /     |
|                           |  3-Implementation / 4-Verification /        |
|                           |  5-Release / 6-Ops]                        |
| Mode                      | [LITE / STANDARD / AUDIT / RAPID / FAST]   |
| Active Task               | [TASK-ID] [Titolo del task]                |
| Active Task Token Est.    | [input/output/totale]                      |
| Active Task Model Level   | [1-7] [modello raccomandato]               |
| Active Branch             | [nome branch]                              |
| Blockers                  | [None / descrizione]                       |

---

## Stack Tecnologico

| Layer      | Technology                  |
|------------|-----------------------------|
| Runtime    | [es. Node.js 22]            |
| Framework  | [es. Fastify 5]             |
| Database   | [es. PostgreSQL 16 + Prisma]|
| Auth       | [es. OIDC + JWT]            |
| Testing    | [es. Vitest + Supertest]    |
| Deploy     | [es. Docker + Railway]      |
| CI         | [es. GitHub Actions]        |

---

## Vincoli di Sicurezza

| ID     | Nome              | Specifica                                |
|--------|-------------------|------------------------------------------|
| SEC-01 | Input Validation  | [approccio di validazione]               |
| SEC-02 | Authentication    | [meccanismo e provider]                  |
| SEC-03 | Authorization     | [modello, ruoli, ownership]              |
| SEC-04 | Secrets & Config  | [gestione secrets]                       |
| SEC-05 | Data Protection   | [PII, cifratura, log redaction]          |

---

## Vincoli di Performance

| ID      | Nome              | Target                                   |
|---------|-------------------|------------------------------------------|
| PERF-01 | Latency Targets   | [es. P95 < 200ms]                        |
| PERF-02 | Throughput        | [es. 50 RPS sustained, 200 RPS peak]     |
| PERF-03 | DB Efficiency     | [es. max 3 query per request]            |

---

## Struttura e Convenzioni

Root path: [path relativo]
Pattern architetturale: [Clean / MVC / Layered / Hexagonal]

Convenzioni:
- Lingua codice: [Italiano / English]
- Commit: [Conventional Commits]
- Branching: [Feature branches / Trunk-based]
- Naming: [snake_case DB, camelCase TS, kebab-case file]

---

## Comandi Build e Run

| Azione   | Comando                 |
|----------|-------------------------|
| Install  | [npm install]           |
| Build    | [npm run build]         |
| Test     | [npm test]              |
| Run dev  | [npm run dev]           |
| Migrate  | [npx prisma migrate dev]|

---

## Decisioni Aperte

| ID    | Decisione                    | Opzioni          | Scadenza   |
|-------|------------------------------|------------------|------------|
| AD-01 | [descrizione decisione]      | [opzione A / B]  | [data]     |

---

## Note per l'Agente

- [Regola specifica che vuoi sempre visibile nel context]
- [Altra regola]
```

---

## Template 2 — `_CONTEXT.md` Minimo (spike/POC)

```markdown
# PROJECT CONTEXT — MINIMAL
> Ultimo aggiornamento: [YYYY-MM-DD]

| Param                   | Value                                |
|-------------------------|--------------------------------------|
| Project                 | [Nome]                               |
| Phase                   | [fase]                               |
| Mode                    | RAPID                                |
| Active Task             | [descrizione task]                   |
| Active Task Token Est.  | 0/0/0                                |
| Active Task Model Level | 3                                    |

## Stack
| Layer     | Technology    |
|-----------|---------------|
| Runtime   | [tecnologia]  |
| Framework | [framework]   |
| Database  | [db]          |

## Vincoli Essenziali
| SEC-01 | Input Validation | [approccio] |
| SEC-02 | Auth             | [meccanismo] |

## Note per l'Agente
- Mode RAPID: lavora su branch dedicato, non toccare path di produzione
- Obiettivo time-boxed: [descrivi cosa stai esplorando e entro quando]
```

---

## Template 3 — Voce `PROGRESS.md`

```markdown
## [YYYY-MM-DD] — [ID Task] [Titolo Task]

**Fatto:**
- [cosa è stato implementato o modificato]
- [altro]

**Scoperto:**
- [comportamento inaspettato di una libreria, bug latente trovato, assunzione sbagliata]

**Decisione:**
[DECISIONE: descrizione della scelta fatta]
Motivazione: [perché questa opzione invece delle altre]

**Prossima sessione:** [cosa fare nella sessione successiva]

---
```

---

## Template 4 — Task AI-DLC

```markdown
# [TASK-ID] — [Titolo del Task]

## AI Sizing
| Campo                 | Valore                              |
|-----------------------|-------------------------------------|
| Token Estimate        | [input] / [output] / [totale]       |
| Model Level           | [1-7]                               |
| Risk Floor Applied    | [LOW/MEDIUM/HIGH → min livello]     |
| Recommended Model     | vedi manifest.json#model_levels     |
| Rationale             | [perché questo livello]             |

## Goal
[Descrizione in 1-3 frasi di cosa deve produrre questo task]

## Acceptance Criteria
- [ ] [criterio verificabile 1]
- [ ] [criterio verificabile 2]
- [ ] [criterio verificabile 3]

## Test Plan (TDD)
Test da scrivere PRIMA dell'implementazione (codificano gli AC):
- [ ] [test caso nominale]
- [ ] [test caso d'errore]
- [ ] [test edge case / sicurezza]

Definizione di "fatto": test del task verdi **e** regressione completa verde.

## Deliverable
- [file o componente 1]
- [file o componente 2]

## Vincoli rilevanti
- [SEC-XX o PERF-XX applicabili a questo task]

## Note
[Informazioni contestuali, dipendenze da altri task, rischi noti]
```

---

## Template 5 — Override HALT Trigger di Progetto

```yaml
# .ai-dlc/project/halt-triggers.yaml
# Override e estensioni dei trigger predefiniti del framework.
# Questo file si aggiunge (non sostituisce) a .ai-dlc/halt-triggers.yaml

version: 1

# Per disattivare un trigger predefinito (usa con cautela):
# disable:
#   - schema

triggers:
  - id: billing
    patterns:
      - "**/billing/**"
      - "**/payments/**"
      - "**/stripe/**"
    reason: Logica di pagamento — impatto finanziario
    risk: HIGH+

  - id: custom-config
    patterns:
      - "config/production/**"
      - "config/staging/**"
    reason: Configurazioni ambiente non-dev
    risk: HIGH
```

---

## Template 6 — Skill di Progetto Personalizzata

```markdown
# SKILL — [Nome Skill]

> Carica quando: [descrizione del tipo di lavoro]

## Identità
Sei [ruolo specializzato]. Priorità: [principio 1], [principio 2].

## Regole di Dominio
- [regola di business 1]
- [regola di business 2]
- [invariante critica]

## Pattern Richiesti
- [pattern obbligatorio 1 — es. formato di risposta, naming]
- [pattern obbligatorio 2]

## Anti-pattern
- NON fare [cosa da evitare] — [perché]
- NON fare [cosa da evitare] — [perché]

## Checklist di Verifica
- [ ] [controllo 1]
- [ ] [controllo 2]
```

---

## Template 7 — Company Extension (`PROCESS.md`)

```markdown
# [Nome Azienda] — Processo SDLC

> Versione: [X.Y]
> Ultimo aggiornamento: [YYYY-MM-DD]
> Autore: [Team/Persona]

## Gate obbligatori per fase

### Prima di Design → Implementation
- [ ] Architecture Review Board approval
- [ ] Security threat model completato (SEC-07)
- [ ] Stima capacità infrastrutturale

### Prima di Implementation → Release
- [ ] Security Review Document firmato
- [ ] Performance baseline misurato
- [ ] Rollback plan documentato
- [ ] Comunicazione stakeholder

## Standard ingegneristici

### Code review
- Minimo 2 approvatori per modifiche HIGH-risk
- Nessun merge con test in failure
- PR aperto per minimo 24h per modifiche architetturali

### Test coverage
- Unit test: minimo 80% per nuovi moduli
- Integration test: obbligatorio per tutti gli endpoint pubblici
- E2E: obbligatorio per i critical path

## Compliance

### GDPR
- [requisiti specifici]

### [Altro standard]
- [requisiti specifici]
```

---

## Template 8 — EPIC

```markdown
# EPIC: [E-NNN] [Titolo]

Status: Proposed | Active | Done | Deferred
Owner: [team/persona]
Target: [sprint/release]

## Summary
[Valore di business in 2-3 frasi]

## Scope
In scope:
- [funzionalità]
Out of scope:
- [esclusione esplicita]

## User Stories
- [US-001]: Come [ruolo], voglio [capacità], così da [risultato].

## Acceptance Criteria
- [ ] [AC a livello epic]

## Risk e Model Floor
| Risk | Esempi nell'epic | Azione | Model Level min | Approvazione |
|------|------------------|--------|-----------------|--------------|
| [LOW/MEDIUM/HIGH] | [perché] | [esegui/pianifica/halt] | [1-7] | [sessione/task/esplicita] |

## Security & Performance
- SEC-XX: [vincolo o N/A]
- PERF-XX: [vincolo o N/A]

## Task Breakdown
| ID | Task | Tipo | Token Est. | Model Level | Risk | Dipendenze |
|----|------|------|------------|-------------|------|------------|
| T-NNN.1 | [descrizione] | dev/test/docs/ops | [in/out/tot] | [1-7] | [none/livello] | [none] |

## Definition of Done
- [ ] Tutti i task collegati completati
- [ ] Test verdi (test del task + regressione)
- [ ] SEC/PERF verificati
- [ ] Documentazione aggiornata
```

---

## Template 9 — ADR (Architecture Decision Record)

```markdown
# ADR-NNN: [Titolo decisione]

Status: Proposed | Accepted | Deprecated | Superseded
Date: YYYY-MM-DD
Owner: [team/persona]
Risk: LOW | MEDIUM | HIGH | HIGH+ | CRITICAL
Model Level: [1-7] [modello raccomandato]

## Contesto
[Problema, vincoli e riferimenti FR/NFR/SEC/PERF rilevanti]

## Opzioni
| Opzione | Descrizione | Pro | Contro | Rischio |
|---------|-------------|-----|--------|---------|
| A | [descrizione] | [pro] | [contro] | [rischio] |
| B | [descrizione] | [pro] | [contro] | [rischio] |

## Decisione
[Opzione scelta e motivazione concisa]

## Conseguenze
Positive:
- [beneficio]
Negative:
- [costo/rischio]
Mitigazioni:
- [mitigazione]

## Follow-up
- [ ] [task/riferimento]
```

---

## Template 10 — Requisiti (Fase Analysis)

```markdown
## Requisiti Funzionali
| ID   | Descrizione | Priorità          | Fonte |
|------|-------------|-------------------|-------|
| FR01 | ...         | Must/Should/Could | ...   |

## User Story
[US-XXX] Titolo

Come [ruolo]
Voglio [azione]
Così da [beneficio]

Acceptance Criteria:
- [ ] GIVEN [contesto] WHEN [azione] THEN [risultato]

Security: [aspetti rilevanti]
Performance: [aspetti rilevanti]
Priorità: Must/Should/Could
Story Points: [1-13]

## Requisiti Non Funzionali (NFR)
- Sicurezza: vincoli SEC-01..SEC-09 applicabili
- Performance: vincoli PERF-01..PERF-05 (target P95, throughput, ...)
```

---

## Template 11 — Analisi di codebase esistente (legacy)

Prodotti dal modulo `09_CODEBASE_ANALYSIS.md` prima di modificare codice esistente:

- **MAP.md** — mappa dei moduli, dipendenze, entry point
- **RISKS.md** — rischi tecnici (sicurezza/performance) e debito
- **HOTSPOTS.md** — file/classi critici con motivazione
- **RUN.md** — comandi build/test/run

```markdown
## Architecture Snapshot
- Pattern: [layered / clean / hex / monolite modulare / microservizi]
- Entry point: [...]
- Domini/moduli core: [...]
- Data store: [...]
- Integrazioni esterne: [...]
- Cross-cutting: auth, logging, caching, messaging

## Change Map (per una modifica specifica)
Target: [feature/bug X]
- Percorso primario: [file/classe/funzione]
- Impatti secondari: [...]
- Test da toccare: [...]
- Config da verificare: [...]
- Piano di rollback: [...]
```
