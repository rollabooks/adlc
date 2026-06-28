# MODE
MODE: STANDARD   # LITE | STANDARD | AUDIT | RAPID | FAST

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

### AUDIT
- Full checklists + evidence
- Traceability of decisions
- Reliability tag always required

### RAPID (Spike / Emergency)
- Time-boxed work (e.g., 1–2 hours) and quick POCs
- Minimal checks: naming + obvious errors, no formal docs
- Still honor critical SEC rules (no secrets, no data deletion) and HALT triggers
- Use separate branch; avoid touching production paths
- Reliability tag recommended when output > 5 lines

### FAST
- Proceed without confirmation loops unless risk is high
- Direct, actionable output
- Reliability tag only if output > 10 lines
