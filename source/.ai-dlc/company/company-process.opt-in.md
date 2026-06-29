# Opt-In: EBIT SUITESTENSA Process Extension

**Extension**: Company Process (SDLC gates, phase mapping, IEC 62304 compliance)
**Files**: `PROCESS.md`, `GOVERNANCE.md`, `STANDARDS.md`, `DEVOPS.md`
**Context cost**: ~HIGH (4 files, ~2500 lines total)

## Opt-In Prompt

```markdown
## Company Extension: EBIT SUITESTENSA Process

This project has an EBIT company process extension that enforces:
- IEC 62304 / MDR compliance gates (G0–G7)
- Mandatory approval matrix (PP, R&D, RdP, STM)
- Medical device risk classification
- Azure DevOps work item traceability

Should company process rules be loaded and enforced?

A) Yes — full load (PROCESS + GOVERNANCE + STANDARDS + DEVOPS) — recommended for regulated projects
B) Partial — load only PROCESS + GOVERNANCE (skip DevOps specifics)
C) Minimal — load only PROCESS gate definitions (lightweight compliance check)
D) No — skip company extension entirely (suitable for PoC, spike, or non-regulated work)
E) Other (describe)

[Answer]:
```

## Load Mapping

| Answer | Files loaded |
|--------|-------------|
| A | README.md + PROCESS.md + GOVERNANCE.md + STANDARDS.md + DEVOPS.md |
| B | README.md + PROCESS.md + GOVERNANCE.md |
| C | README.md + PROCESS.md (gates section only) |
| D | None |
