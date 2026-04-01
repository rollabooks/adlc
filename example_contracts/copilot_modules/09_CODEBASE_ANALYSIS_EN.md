# CODEBASE ANALYSIS - Existing Code Intake

> When to use: when you need to quickly understand an existing repo (legacy or new), map architecture, dependencies, risks, and "where to change".
> Loading: On-demand (typically before major bugfixes or refactors)
> Prerequisites: `00_MODE_EN.md` + `00_CONTEXT_MIN_EN.md` (or `_CONTEXT.md` if already in use)

---

## Goal
1. Understand structure, modules, dependencies, runtime path
2. Identify hotspots (complexity, churn, frequent incidents)
3. Produce a minimal knowledge pack for safe changes

---

## Required input (minimum)
- Repo path / folder structure
- Stack (if known) or build/CI output
- Goal: "understand X" or "fix bug Y"

---

## Deliverables (output)
- MAP.md: module map + dependencies + entry points
- RISKS.md: technical risks (security/perf) + debt
- HOTSPOTS.md: critical files/classes + rationale
- RUN.md: how to build/test/run (commands)

---

## Workflow (4 passes)

### Pass 1 - Entry points & runtime path
Checklist:
- Where does the app start? (main / Program.cs / server.ts / app.py / etc.)
- How is it configured? (env, config files, secrets)
- What are the "perimeters"? (API, UI, jobs, worker, scheduler)
- Which environments exist? (dev/staging/prod)

### Pass 2 - Architecture snapshot (1 page)
Template:
```md
## Architecture Snapshot
- Pattern: [layered / clean / hex / modular monolith / microservices]
- Entry points: [...]
- Core domains/modules: [...]
- Data stores: [...]
- External integrations: [...]
- Cross-cutting: auth, logging, caching, messaging
```

### Pass 3 - Dependency & risk scan (manual + tooling)
Manual (always):
- AuthN/AuthZ: where is it? how is it enforced?
- Logging: PII risks? error leakage?
- Error handling: exceptions propagated? retries?
- Performance: queries, N+1, caching, blocking I/O

Tooling (optional but recommended):
- Static analysis: Sonar/Semgrep
- Dependency scan: OWASP dependency-check / npm audit / dotnet list package --vulnerable
- Test discovery: coverage and test types

### Pass 4 - Change map ("where to intervene")
Template:
```md
## Change Map
### Feature/bug target: [X]
- Primary code path: [file/class/function]
- Secondary impacts: [list]
- Tests to touch: [list]
- Config to verify: [list]
- Rollback plan: [short]
```

---

## Operating prompt (for the AI)
```text
Analyze this existing repository.

Goal: [understand architecture | prepare docs | fix bug XYZ]
Constraints (SEC/PERF): [from _CONTEXT(_MIN).md]

Produce:
1) Architecture Snapshot (1 page)
2) MAP.md: modules + dependencies + entry points
3) HOTSPOTS: 10 most critical files/classes with rationale
4) RUN: build/test/run commands and prerequisites
Do not invent: if info is missing, list questions/assumptions.
```

---

AI CONFIDENCE: INFERRED
Basis: procedural framework; the concrete map depends on the real repo.
