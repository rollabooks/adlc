# BUGFIX PLAYBOOK - Triage -> Fix -> Verify -> Release

> When to use: whenever a bug must be fixed (especially in prod/staging).
> Loading: often (FAST or STANDARD). For prod: AUDIT recommended.
> Prerequisites: `00_MODE_EN.md` + `00_CONTEXT_MIN_EN.md` + (optional) Ops and Verification/Release modules

---

## Goal
Fix bugs without introducing regressions, with a minimal and verifiable trail.

---

## Required input (minimum)
- Symptom (what happens) + impact (who/how much)
- Repro steps or logs
- Version/commit/env
- Sample data (if possible) without PII

---

## Triage (10 minutes, time-box)
Checklist:
- [ ] Repro? (Yes/No/Partial)
- [ ] Severity: P1/P2/P3/P4
- [ ] Surface: API/UI/DB/Job/Integration
- [ ] Recent changes (churn): recent PRs, dependency updates
- [ ] Possible regressions: feature flag, config, env diff

Triage output:
```md
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

## Root Cause Analysis (RCA) - guided path
1) Locate: files/classes involved (stack trace, grep, tracing)
2) Isolate: minimal failing case / reproducible unit test
3) Explain: why it happens (one sentence)
4) Confirm: fix makes the test pass

RCA template:
```md
## RCA
- Trigger:
- Fault:
- Why now:
- Impacted components:
- Fix strategy:
- Risks:
```

---

## Fix strategy (recommended order)
1. Test first (if possible): add a failing test
2. Minimal fix: change as little as possible
3. Guardrails: input validation, error handling, nullability
4. Perf/Sec check: avoid bad queries or info leaks
5. Refactor later (only if needed, and separate)

---

## Verification
- [ ] Unit tests
- [ ] Integration/E2E (if relevant)
- [ ] Repro steps (manual)
- [ ] Logs: no PII, safe error messages
- [ ] Performance sanity: queries/allocations/timeouts

---

## Release & rollback (if applicable)
- Deploy to staging
- Smoke tests
- Controlled rollout
- Rollback plan (commands / tag / feature flag)

---

## Operating prompt (for the AI)
```text
Help me fix a bug.

Data:
- Symptom:
- Expected vs Actual:
- Repro steps / logs:
- Env/version:

SEC/PERF constraints: [from context]

Goal:
1) Quick triage (P-level + suspected area)
2) RCA with hypothesis and how to verify
3) Minimal patch + test that fails then passes
4) Verification checklist + rollback plan

Do not invent: if data is missing, list questions and assumptions.
```

---

AI CONFIDENCE: INFERRED
Basis: procedural playbook; severity and RCA depend on the real case.
