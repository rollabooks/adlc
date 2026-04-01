# MODE
MODE: STANDARD   # FAST | STANDARD | AUDIT | RAPID

## Rules by mode

### FAST
- Proceed without confirmation loops unless risk is high
- Direct, actionable output
- Reliability tag only if output > 10 lines

### STANDARD
- Apply full CORE RULES
- Always verify SEC/PERF
- Reliability tag required for outputs > 5 lines

### AUDIT
- Full checklists + evidence
- Traceability of decisions
- Reliability tag always required

### RAPID (Spike / Emergency)
- Time-boxed work (e.g., 1–2 hours) and quick POCs
- Minimal checks: naming + obvious errors, no formal docs
- Still honor critical SEC rules (no secrets, no data deletion)
- Use separate branch; avoid touching production paths
- Reliability tag recommended when output > 5 lines
