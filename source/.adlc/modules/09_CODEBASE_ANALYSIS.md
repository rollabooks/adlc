# CODEBASE ANALYSIS — Existing Code Intake

> Loading: On-demand, before major changes on existing codebases
> Prerequisites: `01_CORE_RULES.md`

---

## Goal
1. Understand structure, modules, dependencies, runtime paths
2. Identify hotspots (complexity, churn, frequent incidents)
3. Produce a minimal knowledge pack for safe changes

## Required Input
- Repo path / folder structure
- Stack (if known) or build/CI output
- Goal: "understand X" or "fix Y"

## Deliverables
- **MAP.md**: module map + dependencies + entry points
- **RISKS.md**: technical risks (security/perf) + debt
- **HOTSPOTS.md**: critical files/classes + rationale
- **RUN.md**: build/test/run commands

---

## Workflow (4 passes)

### Pass 1 — Entry Points & Runtime Path
- Where does the app start?
- How is it configured? (env, config, secrets)
- What are the perimeters? (API, UI, jobs, workers)
- Which environments exist?

### Pass 2 — Architecture Snapshot
```markdown
## Architecture Snapshot
- Pattern: [layered / clean / hex / modular monolith / microservices]
- Entry points: [...]
- Core domains/modules: [...]
- Data stores: [...]
- External integrations: [...]
- Cross-cutting: auth, logging, caching, messaging
```

### Pass 3 — Dependency & Risk Scan

**Manual (always)**:
- AuthN/AuthZ: where? how enforced?
- Logging: PII risks? error leakage?
- Error handling: propagation? retries?
- Performance: queries, N+1, caching, blocking I/O

**Tooling (recommended)**:
- Static analysis
- Dependency vulnerability scan
- Test discovery: coverage and types

### Pass 4 — Change Map
```markdown
## Change Map
Target: [feature/bug X]
- Primary code path: [file/class/function]
- Secondary impacts: [list]
- Tests to touch: [list]
- Config to verify: [list]
- Rollback plan: [short]
```

---

## Operating Prompt
```
Analyze this repository.
Goal: [understand architecture | prepare docs | fix bug XYZ]
Constraints: [from _CONTEXT.md]

Produce:
1) Architecture Snapshot (1 page)
2) MAP.md: modules + dependencies + entry points
3) HOTSPOTS: 10 most critical files with rationale
4) RUN: build/test/run commands
Do not invent: list questions/assumptions if info is missing.
```
