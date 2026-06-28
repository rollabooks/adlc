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
