# AI-DLC (AI-Driven Development Life Cycle)

> **Version:** 4.0.0 · **License:** MIT · **Platform:** Any IDE, any agent, any language

A modular operating contract for AI-assisted software development. Technology-agnostic, context-driven, security and performance by design.

> **Note on naming:** AI-DLC is the methodology name (AI-Driven Development Life Cycle). The on-disk directory is `.ai-dlc/`, the package ID is `ai-dlc-framework`, and all tool paths use the `.ai-dlc/` prefix.

---

## What Problem Does It Solve?

| Problem | AI-DLC Solution |
|---------|-----------------|
| AI forgets context between sessions | `_CONTEXT.md` = persistent state |
| AI ignores security/performance constraints | SEC-XX / PERF-XX always visible |
| Unreliable AI output quality | FACT / INFERRED / ASSUMPTION confidence tags |
| Context window overload | Modular loading: only what's needed per phase |
| Overconfident agents that assume instead of asking | Overconfidence prevention module (always active) |
| Decisions lost in chat history | Structured questions persisted in auditable files |

---

## Table of Contents

- [Quick Start](#quick-start)
- [Agent Compatibility](#agent-compatibility)
- [Directory Structure](#directory-structure)
- [4-Level Architecture](#4-level-architecture)
- [Six-Phase Workflow](#six-phase-workflow)
- [What to Load by Phase](#what-to-load-by-phase)
- [Essential Commands](#essential-commands)
- [Task Token and Model Sizing](#task-token-and-model-sizing)
- [Risk Classification](#risk-classification)
- [Extensions](#extensions)
- [Tools](#tools)
- [Monorepo Support](#monorepo-support)
- [Tenets](#tenets)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [License](#license)

---

## Quick Start

### 1. Copy framework files to your repository

```
AGENTS.md
CLAUDE.md
GEMINI.md
OPENCLAW.md
VISUALSTUDIO.md
.github/copilot-instructions.md
.ai-dlc/
```

### 2. Scaffold project files

```powershell
.\.ai-dlc\tools\init.ps1
```

```bash
bash .ai-dlc/tools/init.sh
```

This creates `_CONTEXT.md`, `PROGRESS.md`, `.ai-dlc/project/instructions.md`, and `.ai-dlc/project/skills/`.

### 3. Fill `_CONTEXT.md`

At minimum: Project name, Phase, Mode, Stack, and 2-3 SEC/PERF constraints.

### 4. Start chatting

The AI discovers `_CONTEXT.md` automatically and loads the relevant phase module.

For small projects or spikes, use `--context minimal` for a leaner `_CONTEXT.md`.

---

## Agent Compatibility

| Tool | Entry Point | Notes |
|------|-------------|-------|
| **GitHub Copilot** (IDE + Coding Agent) | `.github/copilot-instructions.md` | Loaded automatically |
| **Copilot CLI** (`gh copilot`) | `.github/copilot-instructions.md` | Same file |
| **Claude Code** | `CLAUDE.md` → imports `@AGENTS.md` | No rule duplication |
| **OpenAI Codex CLI** | `AGENTS.md` | Root entry point |
| **Gemini** | `GEMINI.md` | Loads shared `AGENTS.md` rules |
| **OpenClaw** | `OPENCLAW.md` | Loads shared `AGENTS.md` rules |
| **Visual Studio 2026** | `VISUALSTUDIO.md` → imports `@AGENTS.md` | DOC-01 rule; `AI-DLC.Documentation` project |
| **Other agents** | `AGENTS.md` | Universal fallback |

---

## Directory Structure

```
.
├── AGENTS.md                          ← Shared agent contract (Codex entry point)
├── CLAUDE.md                          ← Claude Code (imports AGENTS.md)
├── GEMINI.md                          ← Gemini
├── OPENCLAW.md                        ← OpenClaw
├── VISUALSTUDIO.md                    ← Visual Studio 2026
├── AI-DLC.Documentation.csproj        ← VS solution docs project (repo root)
├── CHANGELOG.md                       ← Release history
├── .github/
│   └── copilot-instructions.md        ← GitHub Copilot (always loaded)
└── .ai-dlc/
    ├── AI-DLC.md                      ← Framework manifesto
    ├── COMMANDS.md                    ← Conversational commands spec
    ├── INSTALL.md                     ← Setup guide
    ├── MANUAL.md / MANUAL.it.md       ← User manuals (EN/IT)
    ├── MIGRATION.md                   ← Migration from old layouts
    ├── VERSION                        ← Current version (4.0.0)
    ├── VERSIONING.md                  ← Versioning policy
    ├── manifest.json                  ← Machine-readable metadata
    ├── halt-triggers.yaml             ← HALT zone glob patterns
    ├── projects.json                  ← Monorepo project index
    ├── schemas/                       ← JSON Schema files
    ├── tests/                         ← Cross-platform smoke tests
    ├── company/                       ← Enterprise process extension
    ├── examples/                      ← Filled examples
    ├── tools/
    │   ├── init.ps1 / init.sh         ← Project scaffold
    │   ├── validate.ps1 / validate.sh ← Validator
    │   ├── show-models.ps1 / .sh      ← Model level table
    │   ├── sync-copilot.ps1 / .sh     ← Copilot alignment check
    │   ├── update-projects.ps1 / .sh  ← Monorepo index updater
    │   └── preprocess-company-docs.*  ← PDF/DOCX preprocessor
    └── modules/
        ├── 00_MODE.md                 ← Operating modes (always loaded)
        ├── 01_CORE_RULES.md           ← Base rules (always loaded)
        ├── 02_DISCOVERY_ANALYSIS.md   ← Phase 0-1
        ├── 03_DESIGN.md              ← Phase 2
        ├── 04_IMPLEMENTATION.md       ← Phase 3
        ├── 05_VERIFICATION_RELEASE.md ← Phase 4-5
        ├── 06_OPS.md                  ← Phase 6
        ├── 07_SPECIAL_LANES.md        ← Hotfix, spike, parallel
        ├── 08_PROMPT_LIBRARY.md       ← Reusable prompts
        ├── 09_CODEBASE_ANALYSIS.md    ← Legacy intake
        ├── 10_DOCUMENTATION.md        ← Doc generation
        ├── 11_BUGFIX_PLAYBOOK.md      ← Structured debugging
        ├── 12_OVERCONFIDENCE.md       ← Overconfidence prevention (always loaded)
        ├── 13_CONTENT_VALIDATION.md   ← Pre-write validation (always loaded)
        ├── 14_STRUCTURED_QUESTIONS.md ← Decision persistence (always loaded)
        ├── SEC_CONSTRAINTS.md         ← Security constraints
        ├── PERF_CONSTRAINTS.md        ← Performance constraints
        ├── templates/                 ← All templates
        └── skills/                    ← Reusable skill files
```

---

## 4-Level Architecture

```
Level 1: .ai-dlc/modules/            → Universal framework (read-only)
Level 2: .ai-dlc/company/            → Enterprise process extension
Level 3: .ai-dlc/project/            → Project rules + domain expertise
Level 4: _CONTEXT.md + PROGRESS.md   → Session state + history
```

**Priority** (highest → lowest):

1. `_CONTEXT.md` — current state, constraints
2. `.ai-dlc/project/` — project-specific rules and skills
3. `.ai-dlc/company/` — enterprise process docs
4. `.copilot/` — compatibility (GitHub Copilot legacy)
5. `.ai-dlc/modules/` — framework (generic, read-only)

---

## Six-Phase Workflow

| Phase | Name | Module | Skills |
|-------|------|--------|--------|
| 0 | Discovery | `02_DISCOVERY_ANALYSIS.md` | `SKILL_ANALYSIS.md` |
| 1 | Analysis | `02_DISCOVERY_ANALYSIS.md` | `SKILL_ANALYSIS.md` |
| 2 | Design | `03_DESIGN.md` | `SKILL_DESIGN.md`, `SKILL_API_DESIGN.md` |
| 3 | Implementation | `04_IMPLEMENTATION.md` | `SKILL_API_DESIGN.md`, `SKILL_SECURITY.md`, `SKILL_UI.md` |
| 4-5 | Verification & Release | `05_VERIFICATION_RELEASE.md` | `SKILL_TESTING.md` |
| 6 | Operations | `06_OPS.md` | `SKILL_OPS.md` |

Agents load the phase module automatically based on `Phase:` in `_CONTEXT.md`.

---

## What to Load by Phase

| Activity | Load Module | Load Skill |
|----------|-------------|------------|
| New project / requirements | `02_DISCOVERY_ANALYSIS.md` | `SKILL_ANALYSIS.md` |
| Architecture decisions | `03_DESIGN.md` | `SKILL_DESIGN.md` + `SKILL_API_DESIGN.md` |
| Coding / implementation | `04_IMPLEMENTATION.md` | `SKILL_API_DESIGN.md` / `SKILL_SECURITY.md` / `SKILL_UI.md` |
| Testing / deploy | `05_VERIFICATION_RELEASE.md` | `SKILL_TESTING.md` |
| Production issues | `06_OPS.md` | `SKILL_OPS.md` |
| Bug investigation | `11_BUGFIX_PLAYBOOK.md` | — |
| Documentation from code | `10_DOCUMENTATION.md` | — |
| Visual Studio solution work | (any phase) | `SKILL_VISUALSTUDIO.md` |
| Quick POC / spike | `01_CORE_RULES.md` + RAPID mode | — |

---

## Essential Commands

Conversational controls typed in the chat. Not shell commands.

| Command | Purpose |
|---------|---------|
| `@Task [goal]` | Create test-driven implementation task with AI Sizing |
| `@checkpoint` | Save state, summarize progress |
| `@context-update` | Propose updated `_CONTEXT.md` block |
| `@show-constraints` | List active SEC/PERF constraints |
| `@security-check` | Verify against SEC-XX |
| `@perf-check` | Verify against PERF-XX |
| `@load-phase [N]` | Load phase module without changing context |
| `@set-phase [N]` | Propose phase transition |
| `@alternatives` | Generate 2-3 options with tradeoffs |
| `@simplify` | Reduce scope or complexity |
| `@rollback` | Propose rollback plan |
| `@stop` | Stop immediately |

Full specification: [`.ai-dlc/COMMANDS.md`](.ai-dlc/COMMANDS.md)

---

## Task Token and Model Sizing

Every created task must include AI sizing:

| Level | Token Range | Typical Use |
|-------|-------------|-------------|
| 1 | < 4k | Small edits, docs, formatting |
| 2 | 4k–8k | Localized code changes, simple tests |
| 3 | 8k–16k | Standard implementation, focused debugging |
| 4 | 16k–32k | Multi-file features, moderate design tradeoffs |
| 5 | 32k–64k | Complex refactors, security-sensitive work |
| 6 | 64k–120k | Architecture, deep debugging, cross-module changes |
| 7 | > 120k | Mission-critical architecture, high ambiguity |

Vendor model mapping: [`.ai-dlc/manifest.json#model_levels`](.ai-dlc/manifest.json)

```powershell
.\.ai-dlc\tools\show-models.ps1       # Print current mapping
```

---

## Risk Classification

| Risk | Examples | Action | Min Level |
|------|----------|--------|-----------|
| LOW | naming, docs, format | Execute → notify | 1 |
| MEDIUM | new feature, refactor | Propose plan → wait | 3 |
| HIGH | schema, auth, arch, delete | Detailed plan + confirmation | 5 |
| HIGH+ | secrets, compliance, production data | HALT → plan + confirmation | 6 |
| CRITICAL | ambiguous mission-critical decisions | HALT → alternatives + ADR | 7 |

HALT zones are defined in [`.ai-dlc/halt-triggers.yaml`](.ai-dlc/halt-triggers.yaml) (glob patterns for schema, auth, secrets, infra, CI/CD, framework files).

---

## Extensions

### Company Process Extension

For enterprise SDLC, governance, or compliance standards:

```bash
mkdir -p .ai-dlc/company/docs
cp .ai-dlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md .ai-dlc/company/README.md
```

Preprocess PDF/DOCX sources:

```powershell
.\.ai-dlc\tools\preprocess-company-docs.ps1
```

### Project-Specific Rules

```bash
# Already created by init.sh:
.ai-dlc/project/instructions.md    # Project conventions
.ai-dlc/project/skills/            # Domain-specific skills
.ai-dlc/project/halt-triggers.yaml # Project-specific HALT overrides
```

---

## Tools

| Tool | Purpose |
|------|---------|
| `init.ps1` / `init.sh` | Scaffold project files |
| `validate.ps1` / `validate.sh` | Validate framework setup |
| `show-models.ps1` / `show-models.sh` | Print model level mapping |
| `sync-copilot.ps1` / `sync-copilot.sh` | Check Copilot alignment with AGENTS.md |
| `update-projects.ps1` / `update-projects.sh` | Update monorepo project index |
| `preprocess-company-docs.*` | Convert PDF/DOCX to agent-readable Markdown |

Run validators after setup or migration:

```bash
bash .ai-dlc/tools/validate.sh       # or .ps1 on Windows
```

---

## Monorepo Support

Each subproject can have its own `_CONTEXT.md`, `PROGRESS.md`, and `.ai-dlc/project/`. The framework modules stay at repository root.

```powershell
# Scaffold a subproject
.\.ai-dlc\tools\init.ps1 -ProjectRoot .\apps\app-a -FrameworkRoot .

# Update project index
.\.ai-dlc\tools\update-projects.ps1
```

Agents use the `_CONTEXT.md` closest to the active file as the project root.

---

## Tenets

1. **Context is king.** `_CONTEXT.md` is the single source of truth for the session. Everything else is derived.
2. **Modular by design.** Load only what the active phase needs. No context waste.
3. **Security and performance are non-negotiable.** SEC-XX and PERF-XX are always visible, always enforced.
4. **Human in the loop.** Critical decisions require explicit confirmation. Agents propose, humans approve.
5. **Agent-agnostic.** Works with any IDE, any coding agent, any model. No vendor lock-in.
6. **Reproducible.** Clear rules minimize variance across different models and sessions.
7. **Read-only framework.** Customize in `.ai-dlc/project/`, never in `.ai-dlc/modules/`.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Agent doesn't follow rules | Verify `_CONTEXT.md` exists and has correct Phase |
| Validator fails | Run `validate.ps1` / `validate.sh` and fix reported issues |
| Copilot out of sync | Run `sync-copilot.ps1` / `sync-copilot.sh` |
| Modules not loading | Check file paths match `.ai-dlc/modules/` structure |
| Old layout conflicts | Follow `.ai-dlc/MIGRATION.md` |

---

## `_CONTEXT.md` vs `PROGRESS.md`

| | `_CONTEXT.md` | `PROGRESS.md` |
|---|---|---|
| **Purpose** | Current state | Session journal |
| **Contains** | Phase, stack, constraints, active task | Completed work, decisions, lessons |
| **Updated** | Every session (overwrite) | Every session (append) |
| **Lifetime** | Project lifetime | Grows over project lifetime |

---

## Additional Resources

| Resource | Link |
|----------|------|
| Framework manifesto | [`.ai-dlc/AI-DLC.md`](.ai-dlc/AI-DLC.md) |
| User manual (English) | [`.ai-dlc/MANUAL.md`](.ai-dlc/MANUAL.md) |
| User manual (Italian) | [`.ai-dlc/MANUAL.it.md`](.ai-dlc/MANUAL.it.md) |
| Conversational commands | [`.ai-dlc/COMMANDS.md`](.ai-dlc/COMMANDS.md) |
| Installation guide | [`.ai-dlc/INSTALL.md`](.ai-dlc/INSTALL.md) |
| Migration guide | [`.ai-dlc/MIGRATION.md`](.ai-dlc/MIGRATION.md) |
| Versioning policy | [`.ai-dlc/VERSIONING.md`](.ai-dlc/VERSIONING.md) |
| Release history | [`CHANGELOG.md`](CHANGELOG.md) |
| Filled examples | [`.ai-dlc/examples/`](.ai-dlc/examples/) |
| JSON Schemas | [`.ai-dlc/schemas/`](.ai-dlc/schemas/) |

---

## License

MIT

The validators always check JSON syntax and use `.ai-dlc/schemas/` for schema validation when a local JSON Schema runtime is available.

## Tests

Run script smoke tests:

```powershell
.\.ai-dlc\tests\test.ps1
```

```bash
bash .ai-dlc/tests/test.sh
```

## Versioning

Version changes follow `.ai-dlc/VERSIONING.md` and are recorded in `CHANGELOG.md`.
