# Changelog

All notable changes to AI-DLC are documented here.

## 4.0.0 - 2026-06-29

### Added
- Module `12_OVERCONFIDENCE.md`: overconfidence prevention — mandatory vagueness detection, red-flag keywords, anti-patterns, and minimum question coverage by phase.
- Module `13_CONTENT_VALIDATION.md`: pre-write validation checklist for fenced code blocks, Markdown structure, Mermaid/PlantUML diagrams, and embedded structured data.
- Module `14_STRUCTURED_QUESTIONS.md`: protocol for persisting decisions in auditable files (`QUESTIONS_TEMPLATE.md`), traceability rules, and integration with adaptive depth.
- `VISUALSTUDIO.md` agent startup file for Visual Studio 2026 Copilot integration.
- `SKILL_VISUALSTUDIO.md` skill for solution/project navigation and documentation ownership in Visual Studio.
- `AI-DLC.Documentation.csproj` (repo root) shared documentation project for Visual Studio solutions.
- Template `TRACEABILITY_TEMPLATE.md` for requirement-to-code tracing.
- Template `QUESTIONS_TEMPLATE.md` for structured question files.
- Schema `questions.schema.json` for structured questions validation.
- `manifest.json` paths: `visualstudio`, `visualstudio_csproj`.

### Changed
- Architecture upgraded from 3-Level to 4-Level (modules → company → project → session state).
- `manifest.json` version bumped to 4.0.0.
- README version header now uses semantic version (`4.0.0`) instead of date-based format.
- Modules 12-14 marked as ALWAYS-load alongside `00_MODE.md` and `01_CORE_RULES.md`.

### Breaking
- Modules `12_OVERCONFIDENCE.md` and `13_CONTENT_VALIDATION.md` are mandatory (always loaded). Agents that skip them violate the protocol.
- `VISUALSTUDIO.md` introduces `DOC-01` rule: documentation must live in `projects\<ProjectName>\` (repo root), not in application source folders.

## 3.3.0 - 2026-05-13

### Added
- Validators check populated AI Sizing in `T-*.md` and `E-*.md`, populated Active Task fields in `_CONTEXT.md`, and `.ai-dlc/halt-triggers.yaml` structure.
- `--strict` / `-Strict` switch on validators: warnings become failures.
- `.ai-dlc/halt-triggers.yaml` default file with explicit glob patterns for schema, auth, secrets, infra, CI/CD, and framework HALT zones.
- `.ai-dlc/schemas/halt-triggers.schema.json` for halt-triggers validation.
- Mode `LITE` for routine LOW/MEDIUM work in projects with stable `_CONTEXT.md`.
- `risk_floors` map in `manifest.json` exposing minimum model levels per trigger.
- `purpose` and `token_range` fields on each `model_levels` entry in `manifest.json`.
- `.ai-dlc/tools/show-models.{ps1,sh}` prints the model level mapping in table or JSON form.
- `.ai-dlc/tools/sync-copilot.{ps1,sh}` coherence checker for `.github/copilot-instructions.md` vs `AGENTS.md`.
- Smoke tests cover negative cases: unpopulated task, missing epic sections, placeholder `_CONTEXT.md` warn/strict behavior.
- CI example now runs smoke tests in addition to validation.

### Changed
- Vendor model mapping (Anthropic / OpenAI / Gemini) lives only in `.ai-dlc/manifest.json#model_levels`. Docs show a vendor-neutral level/token/purpose table and link to manifest.
- HALT prose in `AGENTS.md`, `GEMINI.md`, `OPENCLAW.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `01_CORE_RULES.md` §12 now points to `.ai-dlc/halt-triggers.yaml` instead of enumerating categories inline.
- Confidence tag scope narrowed from "every output > 5 lines" to high-stakes output (HIGH-risk, SEC/PERF claims, code matching halt-triggers, architectural recommendations). AUDIT mode still requires tags on every output; LITE/FAST/RAPID rules updated accordingly.
- `GEMINI.md` and `OPENCLAW.md` slimmed: dropped duplicated bootstrap section, kept only vendor-specific notes; both refer to `AGENTS.md` for shared rules.
- `CLAUDE.md` plan-mode trigger now points to `.ai-dlc/halt-triggers.yaml` instead of "marked HIGH in _CONTEXT.md".
- `README.md` model and risk tables collapsed to a single vendor-neutral level table; full risk matrix lives in `01_CORE_RULES.md` §11.
- `TASK_TEMPLATE.md` Recommended Model row references `manifest.json#model_levels` instead of duplicating vendor strings.
- `00_MODE.md` reorganized: LITE → STANDARD → AUDIT → RAPID → FAST.
- `CONTEXT.example.md` defaults to `Mode: LITE`.

### Deprecated
- Old prose-only HALT enumeration in startup files (still readable in `CORE_RULES` §12 commentary but `halt-triggers.yaml` is authoritative).

## 3.2.0 - 2026-05-13

### Added
- Monorepo project index at `.ai-dlc/projects.json`.
- Project index template and generators for PowerShell and Bash.
- Structured company preprocessing manifest at `.ai-dlc/company/processed/manifest.json`.
- JSON Schema files for framework manifest, projects index, and processed company docs.
- Cross-platform smoke tests for scaffold, preprocessing, project indexing, and validation.

### Changed
- Init and preprocessing scripts now support project-root targeting for monorepos.

## 3.1.0 - 2026-05-13

### Added
- Neutral `.ai-dlc/` framework layout.
- Multi-agent startup files for Codex, Claude Code, Gemini, OpenClaw, and GitHub Copilot.
- Task token and model sizing levels 1-7 with Anthropic, OpenAI, and Gemini recommendations.
- Risk, approval, and model floor matrix.
- EPIC, TASK, progress, context, project instruction, and decision record templates.
- Filled examples under `.ai-dlc/examples/`.
- PowerShell and Bash validators.
- Install, migration, command, manifest, and version files.
- Optional `.ai-dlc/company/` enterprise process extension.
- PDF/DOCX company document preprocessing scripts for PowerShell and Bash.

### Changed
- Moved framework modules from `copilot_modules/` to `.ai-dlc/modules/`.
- Moved GitHub Copilot startup instructions to `.github/copilot-instructions.md`.
- Preferred project override path is now `.ai-dlc/project/`; `.copilot/` remains compatibility-only.
