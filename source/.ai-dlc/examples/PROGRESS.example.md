# PROGRESS — Session Journal
> Project: Customer Portal
> Purpose: Persistent memory across sessions. Append new entries, never overwrite.

## Session 3 — 2026-05-13

### Completed
- T-001.1: Drafted profile API contract | Tokens: 9000/2000/11000 | Model: 6 Opus High | Risk floor: HIGH+=6

### Decisions Made
- Profile updates will use PATCH with an allowlist schema to reduce accidental PII mutation.

### Lessons Learned
- Authorization rules must be written in the contract before implementation starts.

### Blockers / Open Issues
- Need confirmation from product on editable profile fields.

### Next Steps
- [ ] T-001.2 Implement profile read endpoint | Tokens: 18000/4500/22500 | Model: 6 Opus High | Risk floor: HIGH+=6

### Metrics
- Build: not run
- Tests: not run
