# STRUCTURED QUESTIONS PROTOCOL

> Loading: ALWAYS (integrated in CORE_RULES §2, enforced by `12_OVERCONFIDENCE.md`)
> Purpose: Persist decisions in auditable files instead of losing them in chat

---

## When to Use Structured Questions

| Situation | Format | Mandatory? |
|-----------|--------|------------|
| Architectural decisions (stack, pattern, infra) | File (`QUESTIONS_TEMPLATE.md`) | ✅ Yes |
| Scope definition (IN/OUT/MVP) | File | ✅ Yes |
| Security/compliance choices | File | ✅ Yes |
| Tradeoff selection with multiple options | File | ✅ Yes |
| Simple clarification (naming, formatting) | Chat inline | ❌ Optional |
| LOW-risk, single-answer question | Chat inline | ❌ Optional |
| Emergency/RAPID mode questions | Chat inline | ❌ Optional |

**Rule of thumb**: if the answer will influence code structure, data model, or system behavior → use file.

---

## File Placement

| Context | Path |
|---------|------|
| Project-level decisions | `docs/decisions/` |
| Phase-specific questions | `docs/decisions/<phase>/` |
| Task-specific questions | alongside the task artifact |

Naming: `QS-<NN>-<short-description>.md` (e.g., `QS-01-auth-strategy.md`)

---

## Agent Workflow

### Creating questions

1. Identify decision points or ambiguities
2. For each, formulate as multiple-choice (A/B/C/D/E) with concrete options
3. Fill the `QUESTIONS_TEMPLATE.md` with:
   - Clear title per question
   - "Why this matters" rationale
   - Concrete options (not abstract)
   - Option E always = "Altro (descrivere)"
4. Save file with appropriate naming
5. Present to user: "Ho preparato [N] domande in `[path]`. Rispondi con le lettere."

### Processing answers

1. Read the file after user fills `[Answer]:` tags
2. Check for vagueness (see `12_OVERCONFIDENCE.md` red flags)
3. If vague → add Follow-up section, re-present
4. If clear → fill "Summary of Decisions" table
5. Reference decisions in subsequent artifacts (link to file + Q#)

### Answer format accepted

```
[Answer]: B
[Answer]: A — con la variante che usiamo PostgreSQL invece di MySQL
[Answer]: E — vogliamo un approccio ibrido: REST per CRUD, GraphQL per query complesse
```

---

## Traceability

Every decision made via structured questions MUST be traceable:

- In ADRs: "See `QS-03-caching.md` Q2"
- In `_CONTEXT.md` constraints: "Ref: QS-01 Q1"
- In design docs: link to decision file

---

## Integration with Adaptive Depth

| Depth | Question behavior |
|-------|-------------------|
| MINIMAL | Only blocking questions, inline chat allowed |
| STANDARD | File-based for architectural + scope decisions |
| COMPREHENSIVE | File-based for ALL decisions, full audit trail |
