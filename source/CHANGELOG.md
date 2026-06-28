# Changelog

All notable changes to AI-DLC are documented here.

## 3.3.0 - 2026-05-13

### Added
- Validators check populated AI Sizing in `T-*.md` and `E-*.md`, populated Active Task fields in `_CONTEXT.md`, and `.adlc/halt-triggers.yaml` structure.
- `--strict` / `-Strict` switch on validators: warnings become failures.
- `.adlc/halt-triggers.yaml` default file with explicit glob patterns for schema, auth, secrets, infra, CI/CD, and framework HALT zones.
- `.adlc/schemas/halt-triggers.schema.json` for halt-triggers validation.
- Mode `LITE` for routine LOW/MEDIUM work in projects with stable `_CONTEXT.md`.
- `risk_floors` map in `manifest.json` exposing minimum model levels per trigger.
- `purpose` and `token_range` fields on each `model_levels` entry in `manifest.json`.
- `.adlc/tools/show-models.{ps1,sh}` prints the model level mapping in table or JSON form.
- `.adlc/tools/sync-copilot.{ps1,sh}` coherence checker for `.github/copilot-instructions.md` vs `AGENTS.md`.
- Smoke tests cover negative cases: unpopulated task, missing epic sections, placeholder `_CONTEXT.md` warn/strict behavior.
- CI example now runs smoke tests in addition to validation.

### Changed
- Vendor model mapping (Anthropic / OpenAI / Gemini) lives only in `.adlc/manifest.json#model_levels`. Docs show a vendor-neutral level/token/purpose table and link to manifest.
- HALT prose in `AGENTS.md`, `GEMINI.md`, `OPENCLAW.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `01_CORE_RULES.md` §12 now points to `.adlc/halt-triggers.yaml` instead of enumerating categories inline.
- Confidence tag scope narrowed from "every output > 5 lines" to high-stakes output (HIGH-risk, SEC/PERF claims, code matching halt-triggers, architectural recommendations). AUDIT mode still requires tags on every output; LITE/FAST/RAPID rules updated accordingly.
- `GEMINI.md` and `OPENCLAW.md` slimmed: dropped duplicated bootstrap section, kept only vendor-specific notes; both refer to `AGENTS.md` for shared rules.
- `CLAUDE.md` plan-mode trigger now points to `.adlc/halt-triggers.yaml` instead of "marked HIGH in _CONTEXT.md".
- `README.md` model and risk tables collapsed to a single vendor-neutral level table; full risk matrix lives in `01_CORE_RULES.md` §11.
- `TASK_TEMPLATE.md` Recommended Model row references `manifest.json#model_levels` instead of duplicating vendor strings.
- `00_MODE.md` reorganized: LITE → STANDARD → AUDIT → RAPID → FAST.
- `CONTEXT.example.md` defaults to `Mode: LITE`.

### Deprecated
- Old prose-only HALT enumeration in startup files (still readable in `CORE_RULES` §12 commentary but `halt-triggers.yaml` is authoritative).

## 3.2.0 - 2026-05-13

### Added
- Monorepo project index at `.adlc/projects.json`.
- Project index template and generators for PowerShell and Bash.
- Structured company preprocessing manifest at `.adlc/company/processed/manifest.json`.
- JSON Schema files for framework manifest, projects index, and processed company docs.
- Cross-platform smoke tests for scaffold, preprocessing, project indexing, and validation.

### Changed
- Init and preprocessing scripts now support project-root targeting for monorepos.

## 3.1.0 - 2026-05-13

### Added
- Neutral `.adlc/` framework layout.
- Multi-agent startup files for Codex, Claude Code, Gemini, OpenClaw, and GitHub Copilot.
- Task token and model sizing levels 1-7 with Anthropic, OpenAI, and Gemini recommendations.
- Risk, approval, and model floor matrix.
- EPIC, TASK, progress, context, project instruction, and decision record templates.
- Filled examples under `.adlc/examples/`.
- PowerShell and Bash validators.
- Install, migration, command, manifest, and version files.
- Optional `.adlc/company/` enterprise process extension.
- PDF/DOCX company document preprocessing scripts for PowerShell and Bash.

### Changed
- Moved framework modules from `copilot_modules/` to `.adlc/modules/`.
- Moved GitHub Copilot startup instructions to `.github/copilot-instructions.md`.
- Preferred project override path is now `.adlc/project/`; `.copilot/` remains compatibility-only.
