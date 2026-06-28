# PROJECT CONTEXT CARD
> Last Updated: [YYYY-MM-DD]
> Status: [ACTIVE / PAUSED / MAINTENANCE]

---

## 1. CURRENT STATE
| Param | Value |
|-------|-------|
| Phase | [0-Discovery / 1-Analysis / 2-Design / 3-Impl / 4-Verif / 5-Rel / 6-Ops] |
| Mode | [LITE / STANDARD / AUDIT / RAPID / FAST] |
| Sprint | [N] - [Sprint Goal] |
| Active Task | [TASK-ID] [Task Title] |
| Active Task Token Estimate | [input/output/total] |
| Active Task Model Level | [1-7] [recommended model] |
| Active SKILL | [ANALYSIS / DESIGN / API_DESIGN / DATA_ACCESS / SECURITY / TESTING / UI / OPS / none] |
| Current Branch | [branch-name] |
| Blockers | [None / Description] |

---

## 2. TECH STACK (Defined in Design Phase)
| Layer | Technology |
|-------|------------|
| Backend | [Language/Framework] |
| Frontend | [Framework] |
| Database | [Type + ORM] |
| Cache | [Technology] |
| Message Queue | [Technology / N/A] |
| Infra | [Container/Cloud platform] |
| CI/CD | [Tool] |
| Testing | [Framework] |

Key Libraries:
- [lib1]: [purpose]
- [lib2]: [purpose]

---

## 3. CRITICAL CONSTRAINTS
> The AI must reread these before generating code.

### Security (Must Have)
| ID | Constraint | Details |
|----|------------|---------|
| SEC-01 | Input Validation | [validation approach] |
| SEC-02 | Authentication | [mechanism, provider] |
| SEC-03 | Authorization | [model, roles] |
| SEC-04 | Secrets & Config | [management approach] |
| SEC-05 | Data Protection | [encryption, PII handling] |

### Performance (Must Have)
| ID | Constraint | Target |
|----|------------|--------|
| PERF-01 | Latency Targets | [P95 target] |
| PERF-02 | Throughput & Concurrency | [req/s target] |
| PERF-03 | Database Efficiency | [optimization approach] |
| PERF-04 | Resource Utilization | [memory/CPU limits] |
| PERF-05 | Caching & CDN | [strategy] |

### Compliance (If Applicable)
| Requirement | Details |
|-------------|---------|
| [GDPR/HIPAA/Other] | [specifics] |

---

## 4. PROJECT STRUCTURE & CONVENTIONS

Root Path: [path]
Architecture Pattern: [Clean / Hexagonal / MVC / Layered / Other]

```
project-root/
  src/
    [project-specific structure]
  tests/
  docs/
```

Conventions:
- Language: [English / Other]
- Commits: [Conventional Commits]
- Branching: [GitFlow / Trunk-based / Feature branches]
- Code Style: [reference]

---

## 5. BUILD & RUN COMMANDS
| Action | Command |
|--------|---------|
| Build | [command] |
| Test | [command] |
| Run | [command] |
| Lint | [command] |
| Migrate | [command] |

---

## 6. SCRATCHPAD
> Recent decisions and open questions (max 5 each).
> For full history, see PROGRESS.md.

| Date | Decision | Rationale |
|------|----------|-----------|
| [YYYY-MM-DD] | [Decision] | [Reason] |

Open Questions:
- [ ] [question 1]

Deferred Items:
- [item]: [reason, when to revisit]

---

Usage:
1. Fill progressively during project phases.
2. Agent discovers this file automatically (see `01_CORE_RULES.md` §1.1).
3. Update when phase, stack, or constraints change.
4. For session history, use `PROGRESS.md` (see `templates/PROGRESS_TEMPLATE.md`).
