# MODE
MODE: STANDARD   # LITE | STANDARD | AUDIT | RAPID | FAST

---

## Adaptive Depth Assessment (always active)

Before executing any phase or stage, the agent MUST assess the request and derive
the appropriate depth. Manual MODE selection (below) acts as an **override**.

### Assessment Protocol

Evaluate these three dimensions (1-5 each):

| Dimension | 1 (Low) | 3 (Medium) | 5 (High) |
|-----------|---------|------------|----------|
| **Clarity** | Ambiguous, undefined scope | Partial spec, some gaps | Fully specified, clear AC |
| **Complexity** | Single file, <50 LOC | Multi-file, 1 component | Multi-component, integrations |
| **Risk** | No data/auth/infra/money | Touches non-critical data | Auth, PII, infra, payments |

### Derived Depth

| Score (sum) | Depth | Behavior |
|-------------|-------|----------|
| 3–6 | **MINIMAL** | Skip optional stages, minimal docs, proceed fast |
| 7–10 | **STANDARD** | All stages, standard docs, normal confirmations |
| 11–15 | **COMPREHENSIVE** | All stages + extra review, full traceability, explicit approval per step |

### Depth effects on phases

| Phase | MINIMAL | STANDARD | COMPREHENSIVE |
|-------|---------|----------|---------------|
| Discovery | Skip if scope already clear | Full checklist | + stakeholder interviews |
| Analysis | Intent summary only | FR + NFR + user stories | + threat model + data model |
| Design | ADR only | Architecture + API contract | + security arch + perf arch + alternatives |
| Implementation | Code directly (tests first) | Plan → approve → code | + pseudocode → approve → code → review |
| Verification | Unit tests pass | + integration + security scan | + load test + UAT + penetration |

### Conditional Stage Skip Rules

A stage MAY be skipped when ALL conditions are met:

| Stage | Skip conditions |
|-------|----------------|
| Discovery | Scope already defined in `_CONTEXT.md`, no new domain |
| Threat Model | Depth = MINIMAL AND no SEC constraints active |
| Design Review | Depth = MINIMAL AND risk ≤ 2 AND single component |
| Pseudocode | Depth ≤ STANDARD AND logic < 50 lines AND no complex algorithms |
| Performance Testing | No PERF constraints in `_CONTEXT.md` |
| UAT | Depth = MINIMAL AND no user-facing changes |

### Override

Manual MODE selection overrides adaptive depth:
- `FAST` / `RAPID` → forces MINIMAL depth
- `AUDIT` → forces COMPREHENSIVE depth
- `LITE` / `STANDARD` → adaptive depth applies within mode constraints

---

## Rules by mode

### LITE (recommended for daily LOW/MEDIUM work in stable projects)
- Skip session-start confirmation if `_CONTEXT.md` is unchanged since the last session
- Reliability tag required only for output > 10 lines or classified HIGH
- Checkpoint suggested every 5+ significant actions (not mandatory below)
- Reread SEC/PERF only before HIGH-risk code or `.ai-dlc/halt-triggers.yaml` matches
- HALT triggers always respected
- Risk classification and AI sizing still required on every created task

Use case: projects with stable `_CONTEXT.md`, routine LOW/MEDIUM work,
teams that have already internalized SEC/PERF.

### STANDARD (default)
- Apply full CORE RULES
- Always verify SEC/PERF before code
- Reliability tag required for high-stakes output (see CORE_RULES §8)
- Adaptive depth applies fully

### AUDIT
- Full checklists + evidence
- Traceability of decisions
- Reliability tag always required
- Forces COMPREHENSIVE depth on all stages

### RAPID (Spike / Emergency)
- Time-boxed work (e.g., 1–2 hours) and quick POCs
- Minimal checks: naming + obvious errors, no formal docs
- Still honor critical SEC rules (no secrets, no data deletion) and HALT triggers
- Use separate branch; avoid touching production paths
- Reliability tag recommended when output > 5 lines
- Forces MINIMAL depth

### FAST
- Proceed without confirmation loops unless risk is high
- Direct, actionable output
- Reliability tag only if output > 10 lines
- Forces MINIMAL depth
