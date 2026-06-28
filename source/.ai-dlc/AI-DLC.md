# AI-DLC Framework

AI-DLC is a lightweight operating contract for AI-assisted software development.

It separates:
- session state in `_CONTEXT.md`
- project-specific rules in `.ai-dlc/project/`
- enterprise process extensions in `.ai-dlc/company/`
- compatibility rules in `.copilot/`
- reusable framework modules in `.ai-dlc/modules/`
- agent startup files at repository root and `.github/`

Agents must load only the context needed for the active phase, reread active SEC-XX and PERF-XX constraints before technical work, classify risk before acting, and include confidence tags on high-stakes output (HIGH-risk, SEC/PERF claims, or code matching `.ai-dlc/halt-triggers.yaml`).

Every created task must include:
- input, output, and total token estimate
- Anthropic-oriented model level from 1 to 7
- recommended Anthropic, OpenAI, or Gemini model class and effort
- risk floor applied, if any

Default startup files:
- `AGENTS.md` for OpenAI Codex and shared agent rules
- `CLAUDE.md` for Claude Code
- `GEMINI.md` for Gemini
- `OPENCLAW.md` for OpenClaw
- `.github/copilot-instructions.md` for GitHub Copilot

Framework modules are read-only during normal project work. Edit `.ai-dlc/modules/` only when maintaining AI-DLC itself.

Useful files:
- `.ai-dlc/INSTALL.md` for setup
- `.ai-dlc/COMMANDS.md` for conversational command behavior
- `.ai-dlc/MIGRATION.md` for old layout migration
- `.ai-dlc/VERSIONING.md` and `CHANGELOG.md` for release tracking
- `.ai-dlc/examples/` for filled examples
- `.ai-dlc/tools/init.ps1` and `.ai-dlc/tools/init.sh` for project scaffolding
- `.ai-dlc/tools/preprocess-company-docs.ps1` and `.ai-dlc/tools/preprocess-company-docs.sh` for PDF/DOCX company docs
- `.ai-dlc/tools/validate.ps1` and `.ai-dlc/tools/validate.sh` for lightweight repository checks

Monorepos are supported. Keep `.ai-dlc/modules/` at repository root and place `_CONTEXT.md` plus `.ai-dlc/project/` inside each subproject. Agents use the `_CONTEXT.md` closest to the active file.
