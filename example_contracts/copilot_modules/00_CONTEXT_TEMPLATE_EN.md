# PROJECT CONTEXT CARD
> Last Updated: [YYYY-MM-DD]
> Status: [ACTIVE / PAUSED / MAINTENANCE]

---

## 1. CURRENT STATE
| Param | Value |
|-------|-------|
| Phase | [0-Discovery / 1-Analysis / 2-Design / 3-Impl / 4-Verif / 5-Rel / 6-Ops] |
| Sprint | [N] - [Sprint Goal] |
| Active Task | [TASK-ID] [Task Title] |
| Active SKILL | [analysis.md / design.md / react.md / flutter.md / api-design.md / database.md / security.md / ops.md / none] |
| Current Branch | [feature/branch-name] |
| Blockers | [None / Description] |

---

## 2. TECH STACK (Defined in Design Phase)
| Layer | Technology |
|-------|------------|
| Backend | [Language/Framework, e.g., .NET 8, Node/NestJS, Python/FastAPI] |
| Frontend | [Framework, e.g., Angular, React, Vue, Blazor] |
| Database | [Type + ORM, e.g., PostgreSQL + EF Core, MongoDB] |
| Cache | [e.g., Redis, In-Memory] |
| Message Queue | [e.g., RabbitMQ, Azure Service Bus, N/A] |
| Infra | [e.g., Docker, Kubernetes, Azure App Service] |
| CI/CD | [e.g., GitHub Actions, Azure DevOps] |
| Testing | [e.g., xUnit, Jest, Playwright] |

Key Libraries:
- [lib1]: [purpose]
- [lib2]: [purpose]

---

## 3. CRITICAL CONSTRAINTS
> The AI must reread these constraints before generating code.

### Security (Must Have)
| ID | Constraint | Details |
|----|------------|---------|
| SEC-01 | Authentication | [e.g., JWT Bearer, OAuth2, no cookie session] |
| SEC-02 | Authorization | [e.g., RBAC, roles: Admin, User, Guest] |
| SEC-03 | Data Protection | [e.g., PII encrypted at rest, TLS 1.3 in transit] |
| SEC-04 | Input Validation | [e.g., strict DTO validation, whitelist] |
| SEC-05 | Secrets | [e.g., never hardcoded, env vars / vault] |
| SEC-06 | Audit | [e.g., log critical events, no PII in logs] |

### Performance (Must Have)
| ID | Constraint | Target |
|----|------------|--------|
| PERF-01 | Response Time | [e.g., P95 < 200ms, P99 < 500ms] |
| PERF-02 | Database | [e.g., no N+1, indexes on FK, pooling] |
| PERF-03 | Async | [e.g., I/O always async/await] |
| PERF-04 | Memory | [e.g., max 512MB per instance, no leaks] |
| PERF-05 | Caching | [e.g., cache TTL 5 min for static data] |

### Compliance (If Applicable)
| Requirement | Details |
|-------------|---------|
| GDPR | [e.g., EU data residency, right to deletion] |
| HIPAA | [e.g., N/A or specific requirements] |
| Other | [e.g., SOC2, PCI-DSS] |

---

## 4. PROJECT STRUCTURE & CONVENTIONS

Root Path: [absolute or relative path]

Architecture Pattern: [Clean Architecture / Hexagonal / MVC / Layered]

```
project-root/
  src/
    [project-specific structure]
  tests/
  docs/
  api-specs/
  scripts/
```

Conventions:
- Language: [English / Italian] for naming
- Commits: [Conventional Commits: feat, fix, docs, etc.]
- Branching: [GitFlow / Trunk-based / Feature branches]
- Code Style: [link to CONVENTIONS.md or inline rules]

---

## 5. AI INTERACTION RULES

### Reliability Classification
Classify each technical output as:
- FACT: Verifiable from provided input and safe to use
- INFERRED: Logical deduction, requires review
- ASSUMPTION: Unverified hypothesis; stop and ask

### Behavior Rules
- If unsure about requirements or security, stop and ask
- Do not invent libraries, APIs, or files not listed here or in the filesystem
- Always reread CRITICAL CONSTRAINTS before generating code

---

## 6. SCRATCHPAD / RECENT DECISIONS

| Date | Decision | Rationale |
|------|----------|-----------|
| [YYYY-MM-DD] | [Decision] | [Reason] |
| [YYYY-MM-DD] | [Decision] | [Reason] |

Open Questions:
- [ ] [Open question 1]
- [ ] [Open question 2]

Deferred Items:
- [Deferred item]: [reason, when to revisit]

---

## 7. SESSION HISTORY (Optional)

| Session | Date | Focus | Outcome |
|---------|------|-------|---------|
| #1 | [date] | [what was done] | [result] |
| #2 | [date] | [what was done] | [result] |

---

Usage:
1. Fill this file progressively during the project phases.
2. At the start of each AI chat, paste this content together with `01_CORE_RULES_EN.md`.
3. Update the file when phase, stack, or constraints change.
4. The agent will load the relevant SKILL from `.copilot/skills/` based on the Active SKILL field.
5. You can request updates with `@context-update`.

---

## MINIMAL VERSION

For quick sessions, POCs, or when context budget is tight, use this condensed format instead of the full template above:

```markdown
# PROJECT CONTEXT MIN
Last Updated: YYYY-MM-DD

## State
Phase: [0-Discovery | 1-Analysis | 2-Design | 3-Impl | 4-Verif | 5-Release | 6-Ops]
Active Task: [TASK-ID] - [Title]
Active SKILL: [analysis.md / design.md / react.md / api-design.md / ops.md / none]
Repo/Branch: [repo / branch]

## Stack (only what is needed now)
Backend:
Frontend:
Database:
Infra:

## Critical Constraints (max 3+3)
### Security
- SEC-01:
- SEC-02:
- SEC-03:
### Performance
- PERF-01:
- PERF-02:
- PERF-03:

## Recent Decisions (last 3)
- [YYYY-MM-DD] ...
- [YYYY-MM-DD] ...
- [YYYY-MM-DD] ...

## Definition of Done (Lean)
- Tests pass
- No SEC/PERF violations
- Docs updated if API or schema changes
```
