# OpenClaw Startup — AI-DLC Framework

Load `AGENTS.md` for the shared AI-DLC contract (bootstrap, priority, phase activation, rules, risk, sizing).

This file holds only OpenClaw-specific guidance.

## OpenClaw Specifics

- Keep local OpenClaw personality or runtime overrides outside the shared framework when possible.
- Tag high-stakes output (HIGH-risk, SEC/PERF claims, code matching `.adlc/halt-triggers.yaml`) with `FACT`, `INFERRED`, or `ASSUMPTION`. Optional for routine work.
- Reread active SEC-XX and PERF-XX constraints before generating code.
- Halt when changes touch paths in `.adlc/halt-triggers.yaml`.
- Every created task: token estimate + model level 1-7 (mapping in `.adlc/manifest.json#model_levels`).
