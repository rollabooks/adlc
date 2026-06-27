# Appendice C — Template Pronti all'Uso

Template copiabili per i file più usati di ADLC. Sostituisci i valori tra `[parentesi]` con quelli reali del tuo progetto.

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

## Template 4 — Task ADLC

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
# .adlc/project/halt-triggers.yaml
# Override e estensioni dei trigger predefiniti del framework.
# Questo file si aggiunge (non sostituisce) a .adlc/halt-triggers.yaml

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
