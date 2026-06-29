# OVERCONFIDENCE PREVENTION

> Loading: ALWAYS (enforced alongside CORE_RULES §2)
> Purpose: Prevent agents from making assumptions instead of gathering requirements

---

## Core Principles

1. **Default to asking** — when there is ANY ambiguity, ask a clarifying question
2. **No proceeding with vagueness** — vague answers require mandatory follow-up
3. **Comprehensive coverage** — evaluate ALL question categories, do not skip areas
4. **Mandatory follow-up** — ambiguous responses MUST trigger additional questions
5. **No scope inference** — never assume scope that wasn't explicitly stated

---

## Vagueness Detection

### Red Flag Keywords (trigger follow-up)

When a user response contains any of these patterns, the agent MUST NOT proceed
without a follow-up question to resolve the ambiguity:

| Pattern | Example | Required action |
|---------|---------|-----------------|
| "dipende" / "depends" | "Dipende dal contesto" | Ask: what are the specific contexts? |
| "forse" / "maybe" | "Forse serve auth" | Ask: is auth required? YES/NO |
| "non so" / "not sure" | "Non so se serve cache" | Ask: describe the load expectations |
| "un mix di" / "a mix of" | "Un mix di REST e GraphQL" | Ask: which endpoints for each? |
| "più o meno" / "roughly" | "Più o meno 1000 utenti" | Ask: what's the peak? SLA? |
| "come prima" / "like before" | "Come nel progetto X" | Ask: which specific aspects? |
| "standard" (without specifics) | "Usa l'approccio standard" | Ask: define standard in this context |
| "vediamo" / "we'll see" | "Vediamo dopo" | Ask: can we define a minimum now? |

### Structural Red Flags

- **Undefined references**: mentions of "the usual", "like project X", external concepts not defined
- **Contradictory answers**: says both A and B without resolving the conflict
- **Incomplete answers**: answers only part of a multi-part question
- **Scope creep signals**: "and also...", "while we're at it..." without formal scope change

---

## Anti-patterns (NEVER do these)

| ❌ Anti-pattern | ✅ Correct behavior |
|----------------|---------------------|
| Complete a complex stage without asking ANY questions | Always ask at least 1 clarifying question for STANDARD+ depth |
| Assume requirements not explicitly stated | Ask for confirmation of inferred requirements |
| Choose technology stack without user confirmation | Present options with tradeoffs, wait for decision |
| Proceed with undefined scope boundaries | Explicitly list IN / OUT / UNDECIDED scope |
| Skip follow-up on vague answers | Create specific follow-up for each vague point |
| Infer business rules from code patterns alone | Confirm business intent behind technical patterns |
| Assume "same as before" without verification | Ask which specific aspects to reuse |

---

## Minimum Question Coverage by Phase

### Discovery (Phase 0)
- [ ] Domain: What is the business domain and who are the users?
- [ ] Scope: What is explicitly IN scope? What is OUT?
- [ ] Constraints: Budget, timeline, team skills, tech constraints?
- [ ] Success criteria: How will we know it works?

### Analysis (Phase 1)
- [ ] Functional: What are the core user actions?
- [ ] Non-functional: Performance expectations? Security level?
- [ ] Data: What data is involved? Sensitivity?
- [ ] Integrations: What external systems are involved?
- [ ] Edge cases: What happens when things go wrong?

### Design (Phase 2)
- [ ] Architecture: Which pattern and why?
- [ ] Tradeoffs: What are we optimizing for? (speed vs cost vs flexibility)
- [ ] Scalability: Expected growth in the next 12 months?
- [ ] Deployment: Where and how?

### Implementation (Phase 3)
- [ ] Approach: start from tests or from implementation?
- [ ] Dependencies: any approval needed before starting?
- [ ] Risks: what could break? Rollback plan?

---

## Follow-up Protocol

When a vague answer is detected:

1. **Acknowledge** the response ("Capito, hai indicato X")
2. **Identify** the specific ambiguity ("Però non è chiaro se...")
3. **Ask** a focused follow-up with options when possible:
   ```
   Per chiarire: [domanda specifica]
   A) [opzione concreta 1]
   B) [opzione concreta 2]
   C) Altro: [descrivere]
   ```
4. **Do not proceed** until the ambiguity is resolved
5. **If repeated vagueness**: escalate by asking "Possiamo rimandare questo punto e procedere con il resto, oppure è bloccante?"

---

## Confidence Thresholds for Proceeding

| Confidence level | Action |
|-----------------|--------|
| ≥ 90% certain | Proceed, state assumption explicitly |
| 70-89% certain | State assumption, ask "confermi?" |
| 50-69% certain | MUST ask clarifying question |
| < 50% certain | MUST NOT proceed, ask for explicit direction |

---

## Integration with CORE_RULES

This module extends `01_CORE_RULES.md` §2 (Communication Rules):

- §2.2 "Before any action" gains a 5th check: **"Am I making any assumptions?"**
- §2.1 "Response format" gains: **"If asking for confirmation of assumptions, list them explicitly"**
- §2.3 "Error handling" gains: **"Unclear requirements are not errors — they are opportunities to ask"**
