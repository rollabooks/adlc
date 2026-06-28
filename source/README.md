# AI-DLC Framework — Operating Guide

> Quick-start guide for the AI-Driven Development Life Cycle framework.
> **Version:** 26.4.22

> **Note on naming:** the methodology is named **AI-DLC** (AI-Driven Development Life Cycle).
> For backward compatibility the on-disk directory remains `.adlc/`, the package id stays
> `adlc-framework`, and tool paths are unchanged — renaming them would break every agent
> entry point, tool and documented path. The short name in code and folders is historical;
> the methodology name is AI-DLC.

---

## What is this?

A modular contract system that standardizes AI-assisted software development.
Technology-agnostic. Works with any language, framework, or architecture.

| Problem | Solution |
|---------|----------|
| AI forgets context between sessions | `_CONTEXT.md` = persistent state |
| AI ignores security/performance | SEC-XX / PERF-XX constraints always visible |
| Unreliable AI output | FACT / INFERRED / ASSUMPTION classification |
| Context overload | Modular loading: only what's needed per phase |

---

## Agent Compatibility

| Tool | Entry point | Notes |
|------|-------------|-------|
| **GitHub Copilot** (IDE + Coding Agent) | `.github/copilot-instructions.md` | Loaded automatically |
| **Copilot CLI** (`gh copilot`) | `.github/copilot-instructions.md` | Conversational; same file |
| **Claude Code** | `CLAUDE.md` → imports `@AGENTS.md` | No rule duplication |
| **OpenAI Codex CLI** | `AGENTS.md` | Root of the project |
| **Gemini** | `GEMINI.md` | Loads shared `AGENTS.md` rules |
| **OpenClaw** | `OPENCLAW.md` | Loads shared `AGENTS.md` rules |

---

## Directory Structure

```
.
├── AGENTS.md                        ← OpenAI Codex CLI shared entry point
├── CLAUDE.md                        ← Claude Code entry point (imports AGENTS.md)
├── GEMINI.md                        ← Gemini entry point
├── OPENCLAW.md                      ← OpenClaw entry point
├── README.md                        ← This file
├── .github/
│   └── copilot-instructions.md      ← GitHub Copilot entry point (always loaded)
└── .adlc/
    ├── ADLC.md                      ← Short framework manifesto
    ├── COMMANDS.md                  ← Conversational command specification
    ├── INSTALL.md                   ← New repository setup guide
    ├── MIGRATION.md                 ← Old layout migration guide
    ├── VERSION                      ← Framework version
    ├── VERSIONING.md                ← Versioning policy
    ├── manifest.json                ← Machine-readable framework metadata
    ├── projects.json                ← Optional monorepo project index
    ├── schemas/                     ← JSON Schema files
    ├── tests/                       ← Cross-platform script tests
    ├── company/                     ← Optional enterprise process extension
    ├── examples/                    ← Filled examples
    ├── tools/
    │   ├── init.ps1                 ← PowerShell project scaffold
    │   ├── init.sh                  ← Bash project scaffold
    │   ├── preprocess-company-docs.ps1
    │   ├── preprocess-company-docs.sh
    │   ├── validate.ps1             ← PowerShell validator
    │   └── validate.sh              ← Bash validator
    └── modules/
        ├── 00_MODE.md               ← Operating modes (LITE/STANDARD/AUDIT/RAPID/FAST)
        ├── 01_CORE_RULES.md         ← Base rules + state tracking (always loaded)
        ├── 02_DISCOVERY_ANALYSIS.md ← Phase 0-1: Discovery & Analysis
        ├── 03_DESIGN.md             ← Phase 2: Architecture & Design
        ├── 04_IMPLEMENTATION.md     ← Phase 3: Coding & Testing
        ├── 05_VERIFICATION_RELEASE.md
        ├── 06_OPS.md
        ├── SEC_CONSTRAINTS.md
        ├── PERF_CONSTRAINTS.md
        ├── templates/
        │   ├── CONTEXT_TEMPLATE.md
        │   ├── CONTEXT_MIN.md
        │   ├── PROGRESS_TEMPLATE.md
        │   ├── EPIC_TEMPLATE.md
        │   ├── TASK_TEMPLATE.md
        │   ├── DECISION_RECORD_TEMPLATE.md
        │   ├── COMPANY_PROCESS_TEMPLATE.md
        │   └── PROJECT_INSTRUCTIONS_TEMPLATE.md
        └── skills/
            ├── SKILL_ANALYSIS.md
            ├── SKILL_DESIGN.md
            └── ...
```

---

## 3-Level Architecture

```
Level 1: .adlc/modules/               → Universal framework (read-only)
Level 2: .adlc/company/                → Enterprise process extension
Level 3: .adlc/project/                → Project rules + domain expertise
Level 4: _CONTEXT.md + PROGRESS.md     → Session state + history
```

**Priority** (highest → lowest):
1. `_CONTEXT.md` — current state, constraints
2. `.adlc/project/` — project-specific rules and skills
3. `.adlc/company/` — enterprise process extension docs
4. `.copilot/` — compatibility project rules and skills
5. `.adlc/modules/` — framework (generic)

In monorepos, each subproject can have its own `_CONTEXT.md`, `PROGRESS.md`, `.adlc/project/`, and optional `.adlc/company/`. Agents use the `_CONTEXT.md` closest to the active file as the project root, while `.adlc/modules/` can stay at repository root as the shared framework.

---

## Quick Start (5 minutes)

### 1. Scaffold project files:
```powershell
.\.adlc\tools\init.ps1
```

Or:

```bash
bash .adlc/tools/init.sh
```

### 2. Create `_CONTEXT.md` manually if not using scaffold:
```bash
cp .adlc/modules/templates/CONTEXT_TEMPLATE.md ./_CONTEXT.md
```

### 3. Fill the essential sections:
- Phase, Active Task, Stack, SEC/PERF constraints

### 4. Optionally create `.adlc/project/instructions.md`:
Project-specific conventions that override framework defaults. Use `.copilot/` only when GitHub Copilot compatibility requires it.

### 5. Start chatting:
The AI discovers `_CONTEXT.md` automatically and loads the relevant phase module.

### Optional: Add company process documentation
Create `.adlc/company/` when the repository must follow enterprise SDLC, governance, compliance, or engineering standards. Agents load it automatically when present.

For PDF/DOCX sources, put files in `.adlc/company/source/` and run:

```powershell
.\.adlc\tools\preprocess-company-docs.ps1
```

```bash
bash .adlc/tools/preprocess-company-docs.sh
```

Agents should use `.adlc/company/processed/` for normal loading.
Preprocessing also writes `.adlc/company/processed/manifest.json`.

---

## What to Load by Phase

| Activity | Load Module | Load SKILL |
|----------|-------------|------------|
| New project / requirements | `02_DISCOVERY_ANALYSIS.md` | `SKILL_ANALYSIS.md` |
| Architecture decisions | `03_DESIGN.md` | `SKILL_DESIGN.md` + `SKILL_API_DESIGN.md` / `SKILL_DATA_ACCESS.md` |
| Coding / implementation | `04_IMPLEMENTATION.md` | `SKILL_API_DESIGN.md` / `SKILL_DATA_ACCESS.md` / `SKILL_SECURITY.md` / `SKILL_UI.md` |
| Testing / deploy | `05_VERIFICATION_RELEASE.md` | `SKILL_TESTING.md` |
| Production issues | `06_OPS.md` | `SKILL_OPS.md` |
| Bug investigation | `11_BUGFIX_PLAYBOOK.md` | (none) |
| Documentation from code | `10_DOCUMENTATION.md` | (none) |
| Quick POC / spike | Only `01_CORE_RULES.md` + RAPID mode | (none) |

---

## Essential Commands

See `.adlc/COMMANDS.md` for inputs, expected outputs, and files usually updated.

| Command | Purpose |
|---------|---------|
| `@checkpoint` | Save state, summarize progress |
| `@context-update` | Generate updated `_CONTEXT.md` block |
| `@show-constraints` | List active SEC/PERF constraints |
| `@security-check` | Verify against SEC-XX |
| `@perf-check` | Verify against PERF-XX |
| `@stop` | Stop immediately |
| `@explain` | Explain reasoning |
| `@alternatives` | Propose 2-3 alternative solutions |

---

## Task Token and Model Sizing

Every created task must include AI sizing: input/output/total tokens, model level (1-7), recommended model, and rationale.

Quick reference:

| Level | Token Range | Typical Use |
|-------|-------------|-------------|
| 1 | < 4k | Small edits, docs, formatting |
| 2 | 4k-8k | Localized code changes, simple tests |
| 3 | 8k-16k | Standard implementation or focused debugging |
| 4 | 16k-32k | Multi-file features and moderate design tradeoffs |
| 5 | 32k-64k | Complex refactors, integrations, security-sensitive work |
| 6 | 64k-120k | Architecture, deep debugging, broad cross-module changes |
| 7 | > 120k | Mission-critical architecture, high ambiguity, high-risk decisions |

Vendor mapping lives in [`.adlc/manifest.json#model_levels`](.adlc/manifest.json). Print the current table:

```powershell
.\.adlc\tools\show-models.ps1
```

```bash
bash .adlc/tools/show-models.sh
```

Minimum levels and the full risk/approval matrix are defined in [`.adlc/modules/01_CORE_RULES.md`](.adlc/modules/01_CORE_RULES.md) §11 and `manifest.json#risk_floors`.

---

## _CONTEXT.md vs PROGRESS.md

| | `_CONTEXT.md` | `PROGRESS.md` |
|---|---|---|
| **Purpose** | Current state | Session journal |
| **Contains** | Phase, stack, constraints, active task, blockers | Completed work, decisions, lessons learned |
| **Updated** | Every session (overwrite state) | Every session (append entries) |
| **Lifetime** | Lives as long as the project | Grows over project lifetime |

---

## New Repository Setup

1. Follow `.adlc/INSTALL.md`
2. Copy startup files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `OPENCLAW.md`), `.github/`, and `.adlc/` to the new repo
3. Create `_CONTEXT.md` from the template
4. Optionally create `.adlc/project/instructions.md` for project-specific rules
5. Copy relevant SKILLs to `.adlc/project/skills/`
6. Keep `.copilot/` only for compatibility with existing GitHub Copilot setups

## Scaffold

Create missing project state and project override files:

```powershell
.\.adlc\tools\init.ps1
```

```bash
bash .adlc/tools/init.sh
```

Use `--context minimal` for small projects or spikes. Add `-Company` in PowerShell or `--company` in Bash to scaffold `.adlc/company/`. Use `-Force` in PowerShell or `--force` in Bash only when you intentionally want to overwrite generated files.

For monorepos, scaffold a specific subproject while reading templates from the repository root:

```powershell
.\.adlc\tools\init.ps1 -ProjectRoot .\apps\app-a -FrameworkRoot .
```

```bash
bash .adlc/tools/init.sh --project-root apps/app-a --framework-root .
```

Preprocess company docs for a specific subproject:

```powershell
.\.adlc\tools\preprocess-company-docs.ps1 -ProjectRoot .\apps\app-a
```

```bash
bash .adlc/tools/preprocess-company-docs.sh --project-root apps/app-a
```

Update `.adlc/projects.json` after adding or moving subprojects:

```powershell
.\.adlc\tools\update-projects.ps1
```

```bash
bash .adlc/tools/update-projects.sh
```

## Validation

Run the lightweight validator after setup or migration:

```powershell
.\.adlc\tools\validate.ps1
```

```bash
bash .adlc/tools/validate.sh
```

The validators always check JSON syntax and use `.adlc/schemas/` for schema validation when a local JSON Schema runtime is available.

## Tests

Run script smoke tests:

```powershell
.\.adlc\tests\test.ps1
```

```bash
bash .adlc/tests/test.sh
```

## Versioning

Version changes follow `.adlc/VERSIONING.md` and are recorded in `CHANGELOG.md`.
