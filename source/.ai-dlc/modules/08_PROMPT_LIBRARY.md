# PROMPT LIBRARY — Reusable Templates

> Loading: On-demand via `@prompt [ID]`

---

## TECHNICAL PROMPTS

### T01: Implement Feature
```
Implement [FEATURE] in [MODULE].
File: [path] | Interfaces: [list] | Dependencies: [list]
Requirements: [FR/NFR refs]
Acceptance Criteria:
- [ ] [criterion]
Constraints: [SEC/PERF]
Proceed step-by-step.
```

### T02: Debug Issue
```
Problem: [DESCRIPTION]
Expected: [what should happen]
Actual: [what happens]
Already tried: [attempts]
Logs: [paste]
Analyze and propose solutions.
```

### T03: Refactor
```
Refactor [FILE/MODULE].
Problem: [code smell]
Goal: [improvement]
Constraints: no public API change, backward compatible
```

### T04: Add Tests
```
Add [unit/integration/E2E] tests for [COMPONENT].
Scenarios: happy path, edge case, error case
Mocking: [dependencies to mock]
```

### T05: API Endpoint
```
Method: [GET/POST/PUT/DELETE]
Path: /api/[resource]
Auth: [type]
Request: [schema]
Responses: [status codes + schemas]
Business logic: [description]
```

---

## DOCUMENTATION PROMPTS

### D01: Document Function
```
Document [NAME] in [FILE]:
Summary, parameters, return value, exceptions, usage example.
Format: [doc format for your stack]
```

### D02: Architecture Decision Record
```
ADR for: [DECISION]
Context: [situation]
Options: [A, B, C]
Decision: [choice]
Rationale: [why]
Consequences: [positive + negative]
Use template: .ai-dlc/modules/templates/DECISION_RECORD_TEMPLATE.md
```

### D03: README
```
Write README for [PROJECT/MODULE]:
Overview, quick start, examples, config, troubleshooting.
```

---

## ANALYSIS PROMPTS

### A01: Code Review
```
Review [FILE/PR]:
Check: naming, error handling, performance, security, tests, docs.
Report: issues, suggestions, questions.
```

### A02: Dependency Analysis
```
Analyze dependencies of [PROJECT]:
Outdated? Vulnerabilities? Alternatives?
```

### A03: Performance Analysis
```
Analyze [COMPONENT] performance:
Bottlenecks, N+1, memory, caching opportunities.
Target: [SLA/goal]
```

---

## PROJECT MANAGEMENT PROMPTS

### P01: Sprint Planning
```
Sprint [N] | Capacity: [SP] | Goal: [objective]
Candidates: [stories with points]
Suggest selection, priority, risks.
```

### P02: Task Breakdown
```
Break [USER_STORY] into tasks:
ID, title, description, estimate, dependencies, DoD.
```

### P03: Status Report
```
Period: [dates]
Completed: [deliverables]
In progress: [items + %]
Blockers: [impediments]
Metrics: velocity, bugs, coverage.
```

---

## INCIDENT PROMPTS

### I01: Triage
```
Incident: [DESCRIPTION]
User impact: H/M/L | Business impact: H/M/L
Suggested severity: P[1-4]
Immediate actions + investigation areas.
```

### I02: Root Cause Analysis
```
Symptom: [what happened]
Timeline: [events]
5 Whys analysis.
Root cause + contributing factors + preventive actions.
```

---

## REVIEW PROMPTS

### R01: Code Self-Review
```
Self-review [FILES/MODULE] across 6 dimensions.
For each dimension, score 1-5 and list specific findings:

1. SECURITY: secrets exposure, input validation, auth gaps, injection risks
2. SCALABILITY: bottlenecks, N+1 queries, unbounded growth, missing pagination
3. EFFICIENCY: redundant operations, unnecessary allocations, blocking I/O
4. COMPLEXITY: cyclomatic complexity > 10, deep nesting, god classes
5. LOGGING & OBSERVABILITY: missing audit logs, PII leakage, no correlation IDs
6. STRUCTURE: SRP violations, tight coupling, unclear naming, missing abstractions

Output format:
| Dimension | Score | Findings | Suggested Fix |
|-----------|-------|----------|---------------|

Active SEC/PERF constraints: [from _CONTEXT.md]
Halt triggers matched: [Y/N — list if Y]
```

### R02: Design Self-Review
```
Self-review design artifacts for [FEATURE/MODULE]:

Check:
1. COMPLETENESS: all FR/NFR addressed? Missing endpoints? Missing entities?
2. CONSISTENCY: API contract matches data model? Naming aligned across layers?
3. SECURITY ARCH: threat model covers all surfaces? Auth on every endpoint?
4. PERFORMANCE ARCH: caching strategy? Query patterns? Latency budget?
5. TRACEABILITY: every FR maps to a component? Every component has a test strategy?
6. ALTERNATIVES: were other options considered? ADR captures why-not?

For each gap found:
- Severity: CRITICAL / IMPORTANT / SUGGESTION
- Location: [artifact + section]
- Proposed fix: [specific action]

Reference: _CONTEXT.md constraints, active ADRs, TRACEABILITY_TEMPLATE.md
```

### R03: Traceability Generation
```
Generate traceability matrix for [PROJECT/MODULE].

Sources to scan:
- Requirements: [path to FR/NFR docs]
- User stories: [path or backlog reference]
- Design: [path to architecture/API docs]
- Code: [src/ path]
- Tests: [test/ path]

Output: populated TRACEABILITY_TEMPLATE.md with:
- Full trace table (Req → Story → Design → Code → Test)
- Gap analysis (orphaned reqs, orphaned code, missing tests)
- Metrics summary

Depth: [MINIMAL = trace table only | STANDARD = + gaps | COMPREHENSIVE = + metrics + actions]
```

### R04: Pre-Merge Checklist
```
Pre-merge review for [BRANCH/PR]:

Verify:
- [ ] All acceptance criteria from task met
- [ ] SEC-XX constraints verified (list which)
- [ ] PERF-XX constraints verified (list which)
- [ ] No halt-trigger files modified without approval
- [ ] Tests pass (unit + integration)
- [ ] No regressions in existing tests
- [ ] Documentation updated (API docs, README, ADR if needed)
- [ ] PROGRESS.md entry drafted

Report: PASS / FAIL with blocking items listed.
```
