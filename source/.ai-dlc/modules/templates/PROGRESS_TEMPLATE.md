# PROGRESS — Session Journal

> Project: [Project Name]
> Purpose: Persistent memory across sessions. Machine-readable state + human-readable log.

---

## Current State

<!-- Machine-readable section — agent parses this on session resume -->

| Field | Value |
|-------|-------|
| Phase | [0-5] |
| Stage | [Discovery / Analysis / Design / Implementation / Verification / Release] |
| Depth | [MINIMAL / STANDARD / COMPREHENSIVE] |
| Last completed | [Step or task ID] |
| Next step | [Step or task ID] |
| Active task | [TASK-ID or "none"] |
| Blockers | [Description or "none"] |
| Company ext | [A/B/C/D — or "not loaded"] |

### Artifacts to load on resume

<!-- Agent reads this list and loads these files automatically at session start -->

- [ ] `_CONTEXT.md` — always
- [ ] [path/to/artifact-1] — [why needed]
- [ ] [path/to/artifact-2] — [why needed]

---

## Session Resume Protocol

<!--
When resuming a session, the agent MUST:
1. Parse "Current State" table above
2. Load all checked artifacts in "Artifacts to load on resume"
3. Present brief summary: "Riprendiamo: fase [X], stage [Y], prossimo step: [Z]"
4. Ask: "Proseguiamo da qui o vuoi cambiare direzione?"
5. Do NOT re-ask company opt-in if already recorded
-->

---

## Session Log

<!-- Append new entries at the TOP. Never delete old entries. -->

### Session [N] — YYYY-MM-DD

**Completed**:
- [TASK-ID]: [what was done] | Model: [level] | Risk: [LOW/MED/HIGH]

**Decisions made**:
- [Decision]: [rationale] | Ref: [QS-file or ADR if applicable]

**Lessons learned**:
- [What worked / what didn't]

**State change**:
- Phase: [from] → [to]
- Stage: [from] → [to]
- Artifacts added: [list new files to load on next resume]

**Next steps**:
- [ ] [Next task] | Est. model: [level] | Risk: [LOW/MED/HIGH]

---

<!-- Copy the "Session [N]" block above for each new session -->
