# BUGFIX PLAYBOOK — Triage → Fix → Verify

> Loading: When a bug must be fixed
> Prerequisites: `01_CORE_RULES.md`

---

## Goal
Fix bugs without introducing regressions, with a minimal and verifiable trail.

> **Related**: For production incidents (P1/P2 outages), see `06_OPS.md` incident response.
> This playbook covers **developer-driven** bug investigation and fix workflow.

## Required Input
- Symptom (what happens) + impact (who/how much)
- Repro steps or logs
- Version/commit/environment
- Sample data (if possible, without PII)

---

## Triage (10 min time-box)

Checklist:
- [ ] Reproducible? (Yes / No / Partial)
- [ ] Severity: P1 / P2 / P3 / P4
- [ ] Surface: API / UI / DB / Job / Integration
- [ ] Recent changes: recent PRs, dependency updates
- [ ] Possible regressions: feature flags, config, env diffs

Output:
```markdown
## BUG-[ID] Triage
- Severity: P?
- Repro steps:
- Observed:
- Expected:
- Suspected area:
- Logs:
- Immediate mitigation (if needed):
```

---

## Root Cause Analysis (RCA)

1. **Locate**: files/classes involved (stack trace, grep, tracing)
2. **Isolate**: minimal failing case / reproducible test
3. **Explain**: why it happens (one sentence)
4. **Confirm**: fix makes the test pass

Template:
```markdown
## RCA
- Trigger:
- Fault:
- Why now:
- Impacted components:
- Fix strategy:
- Risks:
```

---

## Fix Strategy (recommended order)
1. **Test first**: add a failing test (if possible)
2. **Minimal fix**: change as little as possible
3. **Guardrails**: input validation, error handling
4. **SEC/PERF check**: no bad queries, no info leaks
5. **Refactor later**: only if needed, in a separate change

---

## Verification
- [ ] Unit tests pass
- [ ] Integration/E2E (if relevant)
- [ ] Repro steps verified manually
- [ ] Logs: no PII, safe error messages
- [ ] Performance: queries/allocations/timeouts

## Release (if applicable)
- Deploy to staging → smoke tests → controlled rollout
- Rollback plan: [commands / tag / feature flag]

---

## Operating Prompt
```
Help me fix a bug.

Data:
- Symptom:
- Expected vs Actual:
- Repro steps / logs:
- Env/version:

SEC/PERF constraints: [from _CONTEXT.md]

Goal:
1) Triage (P-level + suspected area)
2) RCA with hypothesis
3) Minimal patch + test
4) Verification checklist + rollback plan

If data is missing, list questions and assumptions.
```
