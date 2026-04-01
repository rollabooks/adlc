# PROMPT LIBRARY - Reusable Snippets

> Loading: On-demand, when you need specific templates
> Size: ~320 lines | Context cost: Medium (load only needed sections)

---

## How to use this library

```
@prompt [ID]   -> load the specific prompt
@prompt-list   -> show available prompts
```

---

## TECHNICAL PROMPTS

### T01: Implement Feature
```
Implement [FEATURE_NAME] in module [MODULE].

Context:
- Main file: [path]
- Interfaces involved: [list]
- Dependencies: [list]

Requirements:
- [FR/NFR references]

Acceptance Criteria:
- [ ] [criterion 1]
- [ ] [criterion 2]

Constraints:
- [technical constraints]

Proceed step-by-step, showing each modified file.
```

### T02: Debug Issue
```
I have a problem: [DESCRIPTION]

Expected behavior: [what should happen]
Actual behavior: [what happens]
Context: [where it occurs]

Already tried:
- [attempt 1]
- [attempt 2]

Logs/Error messages:
```
[paste logs here]
```

Analyze and propose solutions.
```

### T03: Refactor Code
```
Refactoring requested for [FILE/MODULE].

Current problem:
- [code smell / issue]

Goal:
- [what to improve]

Constraints:
- Do not change public API
- Maintain backward compatibility
- [other constraints]

Propose the refactor with explanation.
```

### T04: Add Tests
```
Add tests for [COMPONENT/FUNCTION].

Test type: Unit / Integration / E2E
Framework: [xUnit/Jest/Playwright]

Scenarios to cover:
1. Happy path: [description]
2. Edge case: [description]
3. Error case: [description]

Mocking needed: [list dependencies to mock]
```

### T05: API Endpoint
```
Create API endpoint:

Method: [GET/POST/PUT/DELETE]
Path: /api/v1/[resource]
Auth: [Bearer/ApiKey/None]

Request:
- Headers: [list]
- Query params: [list]
- Body: { [schema] }

Responses:
- 200: { [schema] }
- 400: { error: { code, message } }
- [other status codes]

Business logic: [description]
```

---

## DOCUMENTATION PROMPTS

### D01: Document Function
```
Document function [NAME] in [FILE]:

Include:
- Summary (1-2 sentences)
- Parameters with types and description
- Return value
- Possible exceptions
- Usage example

Format: [XML docs .NET / JSDoc / Python docstring]
```

### D02: Architecture Decision
```
Create ADR for: [DECISION]

Context: [situation requiring decision]
Options considered:
1. [option A]
2. [option B]
3. [option C]

Decision: [choice made]
Rationale: [why this choice]
Consequences: [positive and negative impacts]
```

### D03: README Section
```
Write a README section for [PROJECT/MODULE]:

Include:
- Overview (what it is, what it does)
- Quick start (install + first use)
- Code examples
- Configuration
- Common troubleshooting
```

---

## ANALYSIS PROMPTS

### A01: Code Review
```
Review code in [FILE/PR]:

Check:
- [ ] Naming conventions
- [ ] Error handling
- [ ] Performance concerns
- [ ] Security issues
- [ ] Test coverage
- [ ] Documentation

Report: Issues, Suggestions, Questions
```

### A02: Dependency Analysis
```
Analyze dependencies of [PROJECT]:

- List direct dependencies
- Identify outdated versions
- Flag known vulnerabilities (CVE)
- Suggest upgrades/alternatives
```

### A03: Performance Analysis
```
Analyze performance of [COMPONENT]:

Current metrics: [if available]
Target: [SLA/goal]

Identify:
- Potential bottlenecks
- N+1 queries
- Memory leaks
- Caching opportunities
- Optimization suggestions
```

---

## PROJECT MANAGEMENT PROMPTS

### P01: Sprint Planning
```
Plan Sprint [N]:

Capacity: [available story points]
Goal: [sprint objective]

Candidate stories:
[list user stories with points]

Suggest:
- Story selection for sprint
- Priority order
- Risk assessment
- Dependencies to consider
```

### P02: Task Breakdown
```
Break down [USER_STORY] into technical tasks:

For each task:
- ID and title
- Short description
- Estimate (hours)
- Dependencies
- Definition of Done
```

### P03: Status Report
```
Generate status report for [PERIOD]:

Completed:
- [deliverables list]

In progress:
- [items with % completion]

Blockers:
- [impediments]

Next period:
- [plan]

Metrics:
- Velocity: [n] story points
- Bug rate: [n]
- Test coverage: [%]
```

---

## INCIDENT PROMPTS

### I01: Incident Triage
```
Incident: [DESCRIPTION]

Severity assessment:
- User impact: [High/Medium/Low]
- Business impact: [High/Medium/Low]
- Urgency: [Immediate/Same day/Next business day]

Suggested severity: P[1-4]

Immediate actions:
1. [action 1]
2. [action 2]

Investigation areas:
- [area 1]
- [area 2]
```

### I02: Root Cause Analysis
```
Analyze root cause for incident [ID]:

Symptom: [what happened]
Timeline: [event sequence]

Apply 5 Whys:
1. Why? [level 1]
2. Why? [level 2]
...

Identified root cause: [cause]
Contributing factors: [factors]
Preventive actions: [future actions]
```

---

## Quick index

| ID | Name | Use |
|----|------|-----|
| T01 | Implement Feature | New features |
| T02 | Debug Issue | Troubleshooting |
| T03 | Refactor Code | Code improvement |
| T04 | Add Tests | Test writing |
| T05 | API Endpoint | New APIs |
| D01 | Document Function | Code documentation |
| D02 | Architecture Decision | ADR |
| D03 | README Section | Project documentation |
| A01 | Code Review | PR review |
| A02 | Dependency Analysis | Dependency analysis |
| A03 | Performance Analysis | Optimization |
| P01 | Sprint Planning | Planning |
| P02 | Task Breakdown | Task decomposition |
| P03 | Status Report | Reporting |
| I01 | Incident Triage | Incident handling |
| I02 | Root Cause Analysis | Post-mortem |

---

Use `@prompt [ID]` to load a specific prompt into the conversation.
