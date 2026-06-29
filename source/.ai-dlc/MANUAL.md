# AI-DLC — User Manual (English)

> Framework version: 4.0.0
> Audience: developers who want to use AI-DLC to orchestrate one or more AI agents in a software project, even without prior experience with similar systems.

---

## Table of Contents

1. [What is AI-DLC and why does it exist](#1-what-is-adlc-and-why-does-it-exist)
2. [When to use it (and when not to)](#2-when-to-use-it-and-when-not-to)
3. [Knowledge prerequisites](#3-knowledge-prerequisites)
4. [Fundamental concepts](#4-fundamental-concepts)
5. [Setting up your first project](#5-setting-up-your-first-project)
6. [Typical session workflow](#6-typical-session-workflow)
7. [Framework tools](#7-framework-tools)
8. [Generating documentation from legacy code](#8-generating-documentation-from-legacy-code)
9. [Working with multiple agents](#9-working-with-multiple-agents)
10. [Monorepo](#10-monorepo)
11. [Enterprise extension (company)](#11-enterprise-extension-company)
12. [Common errors and troubleshooting](#12-common-errors-and-troubleshooting)
13. [Quick glossary](#13-quick-glossary)

---

## 1. What is AI-DLC and why does it exist

**AI-DLC** stands for *AI-Driven Development Life Cycle*. It's a lightweight framework made of Markdown and JSON files that brings order between you and the AI agents you work with (Claude Code, Copilot, Codex, Gemini, OpenClaw, etc.).

It solves four everyday problems:

| Problem | AI-DLC Solution |
|---------|---------------|
| AI forgets context between sessions | `_CONTEXT.md`, a persistent state file that the agent re-reads every session |
| AI ignores or forgets security and performance requirements | Constraints `SEC-XX` and `PERF-XX` always visible in the context |
| AI invents or guesses | Confidence tags (`FACT` / `INFERRED` / `ASSUMPTION`) on critical output |
| AI loads too many rules at once | Modules loaded only when needed (per project phase) |

**What AI-DLC is NOT:**
- It's not an AI: it doesn't generate code on its own. It's an operational contract that agents follow.
- It's not a tool to install: there's no executable. It's just text files in a folder.
- It's not language or stack specific: it works with any technology.

---

## 2. When to use it (and when not to)

**Use it when:**
- You're working on a real project (not a 30-minute spike) with an AI agent.
- You need continuity across sessions or team members.
- The project has security, performance, or compliance constraints.
- You want to use multiple AI agents without repeating the same rules.
- You work in a team and want the agent to follow shared conventions.

**You don't need it when:**
- You're running a 1-hour experiment.
- You're asking an agent a straightforward question.
- The project is already governed by a stricter agent framework.

**Adoption cost:** ~15 minutes for initial scaffold, then 1-2 minutes per session to update `_CONTEXT.md`.

---

## 3. Knowledge prerequisites

### Essential
- **Command line**: ability to open a terminal (PowerShell or Bash) and run commands.
- **Basic Markdown**: ability to read and edit `.md` files (headings, tables, lists).
- **Basic Git**: `clone`, `commit`, `push`, branching. (Optional for local projects, but recommended.)

### Useful but optional
- **JSON and YAML**: the framework uses both (`manifest.json`, `halt-triggers.yaml`). Knowing how to read them helps.
- **PowerShell or Bash scripting**: for modifying tools. Not needed to use them.
- **Glob patterns**: like `**/migrations/**`. Useful for customizing HALT triggers.
- **JSON Schema**: only if you want to modify validation schemas.

### Conceptual
- **SDLC** (Software Development Life Cycle): typical project phases (Discovery → Design → Implementation → Verification → Release → Ops). AI-DLC numbers them 0-6 and asks you to know which phase you're in.
- **Conventional Commits**: convention using `feat:`/`fix:`/`refactor:` for commit messages. AI-DLC recommends it but doesn't enforce it.
- **Basic risk management**: distinguishing "rename a variable" (LOW) from "modify database schema" (HIGH).

**If you're junior:** start with mode `LITE` (see modes section), a single skill (`SKILL_API_DESIGN.md` or similar), and skip the company extension until you need it. The framework adapts to your level.

---

## 4. Fundamental concepts

### 4.1 `_CONTEXT.md` — your project's memory

It's the heart of AI-DLC. A single Markdown file at your project root that tells the agent:
- **where you are** (project phase, active task, branch)
- **what you must respect** (tech stack, SEC and PERF constraints)
- **how to behave** (mode: LITE/STANDARD/AUDIT/RAPID/FAST)

The agent reads it every session. If you change phase or constraints, update it.

**Minimal example:**

```markdown
| Param | Value |
|-------|-------|
| Phase | 3-Impl |
| Mode | LITE |
| Active Task | T-001.2 Implement profile read endpoint |
| Active Task Model Level | 5 |

### Security
| SEC-02 | Authentication | OIDC access tokens |
| SEC-03 | Authorization | RBAC per resource owner |
```

Use `.ai-dlc/modules/templates/CONTEXT_TEMPLATE.md` for the complete version, `CONTEXT_MIN.md` for spikes/POCs.

### 4.2 `PROGRESS.md` — your session diary

Companion to `_CONTEXT.md`. While context snapshots current state, `PROGRESS.md` records what happened in past sessions: completed work, decisions made, lessons learned. It grows over time, never overwritten.

### 4.3 Phases — the 7 project phases

| Phase | Name | When you're here |
|-------|------|------------------|
| 0 | Discovery | Understand the problem, gather requirements |
| 1 | Analysis | Analyze requirements, choose macro approach |
| 2 | Design | Architecture, API contract, database schema |
| 3 | Implementation | Code, testing |
| 4 | Verification | QA, integration testing |
| 5 | Release | Deploy, final documentation |
| 6 | Ops | Monitoring, incident response, maintenance |

The agent loads different modules and skills depending on the phase (see 4.5).

### 4.4 Modes — how much ceremony do you want

| Mode | When to use |
|------|-------------|
| `LITE` | Daily work on LOW/MEDIUM tasks in stable projects (recommended by default) |
| `STANDARD` | Historic default, applies all CORE RULES |
| `AUDIT` | For changes with full traceability (compliance, security) |
| `RAPID` | Spike, POC, emergencies (timeboxed) |
| `FAST` | When you need speed on simple tasks |

Change the `Mode:` in `_CONTEXT.md` to scale overhead.

### 4.5 Modules and Skills — phase-based loading

**Modules** (`.ai-dlc/modules/00_MODE.md`, `01_CORE_RULES.md`, etc.) are the framework. Read-only. Loaded only when needed for the current phase.

**Skills** (`SKILL_API_DESIGN.md`, `SKILL_SECURITY.md`, etc.) are thematic guides. Load them one at a time based on task type.

**Example:** if you're in Phase 3 designing REST endpoints, the agent loads `04_IMPLEMENTATION.md` + `SKILL_API_DESIGN.md`. It doesn't load the Ops module or Testing skill.

### 4.6 SEC and PERF constraints — the guardrails

`SEC_CONSTRAINTS.md` defines 9 reusable security constraints (SEC-01 Input Validation, SEC-02 Authentication, ...). `PERF_CONSTRAINTS.md` defines 7 performance constraints.

In `_CONTEXT.md` you list only the ones active in your project. The agent re-reads them before generating code.

**Example:**
```markdown
| SEC-02 | Authentication | OIDC, JWT with refresh |
| PERF-01 | Latency Targets | P95 < 250ms |
```

### 4.7 HALT trigger — when the agent must stop

`.ai-dlc/halt-triggers.yaml` defines file patterns that require **explicit confirmation** before modification: database schema, authentication code, secrets, infrastructure, CI/CD, framework files.

When the agent touches one of these paths, it stops and asks before proceeding. You can override the default by creating `.ai-dlc/project/halt-triggers.yaml` in your project.

### 4.8 Risk classification — not all tasks are equal

| Risk | Examples | Agent action |
|------|----------|--------------|
| LOW | Rename, typo, format | Execute and notify |
| MEDIUM | New feature, refactor | Propose a plan and wait for approval |
| HIGH | Schema, auth, architecture | Detailed plan + explicit confirmation |
| HIGH+ | Secrets, compliance, production | HALT before planning |
| CRITICAL | Ambiguous mission-critical decisions | HALT + alternatives + decision record |

The risk level also determines the **minimum model level** required (see 4.10).

### 4.9 Confidence tags — when the AI admits uncertainty

For high-impact output (HIGH-risk, SEC/PERF claims, code in HALT zones) the agent closes with:

```markdown
---
AI CONFIDENCE: FACT | INFERRED | ASSUMPTION
Basis: [why it asserts this — file, test, source]
```

| Tag | Meaning | Action |
|-----|---------|--------|
| FACT | Verifiable from input | Can be used |
| INFERRED | Logical deduction | Needs review |
| ASSUMPTION | Unverified hypothesis | STOP and ask |

In `LITE` mode tags are only for critical output (so they don't become noise).

### 4.10 Model levels — which AI for which task

Every task created in AI-DLC includes an **AI Sizing**: token estimate, model level 1-7, recommended model.

| Level | Token range | Use for |
|-------|-------------|---------|
| 1 | < 4k | Small edits, docs, formatting |
| 2 | 4k-8k | Localized changes, simple tests |
| 3 | 8k-16k | Standard implementation, focused debugging |
| 4 | 16k-32k | Multi-file features, moderate design |
| 5 | 32k-64k | Complex refactors, integrations, security |
| 6 | 64k-120k | Architecture, deep debugging |
| 7 | > 120k | Mission-critical, high ambiguity |

The vendor mapping (Anthropic/OpenAI/Gemini) for each level lives in `.ai-dlc/manifest.json#model_levels`. To print it:

```powershell
.\.ai-dlc\tools\show-models.ps1
```

```bash
bash .ai-dlc/tools/show-models.sh
```

**Risk floor:** some risks force a minimum level. Auth/secrets/production → minimum level 6. Even if token estimates suggest level 3.

### 4.11 Conversational commands

These are "commands" you type in the chat with the agent. They're not shell commands. Examples:

| Command | What it does |
|---------|--------------|
| `@checkpoint` | Agent saves current state and proposes updates |
| `@show-constraints` | Print active SEC/PERF constraints |
| `@security-check` | Verify code/plan against SEC |
| `@stop` | Stop immediately |
| `@alternatives` | Propose 2-3 alternative options |
| `@simplify` | Reduce scope/complexity |

Full list: `.ai-dlc/COMMANDS.md`.

---

## 5. Setting up your first project

### 5.1 Scenario: adding AI-DLC to an existing repo

**Step 1 — copy the framework**

If you don't have AI-DLC files in your repo, copy them from an existing source (this repo or a template):

```text
AGENTS.md
CLAUDE.md
GEMINI.md
OPENCLAW.md
.github/copilot-instructions.md
.ai-dlc/
```

**Step 2 — scaffold project state**

```powershell
.\.ai-dlc\tools\init.ps1
```

```bash
bash .ai-dlc/tools/init.sh
```

For small projects or spikes use `--context minimal`. Creates: `_CONTEXT.md`, `PROGRESS.md`, `.ai-dlc/project/instructions.md`, `.ai-dlc/project/skills/` folder.

**Step 3 — populate `_CONTEXT.md`**

Open the file. For each row with `[placeholder]` put the real value:
- `Phase` → what phase you're in (e.g., `3-Impl`)
- `Mode` → `LITE` if it's a stable project, otherwise `STANDARD`
- `Active Task` → task ID and title
- `Active Task Token Estimate` → e.g., `12000/2500/14500`
- `Active Task Model Level` → e.g., `5 Sonnet High`
- `Stack`, `SEC`, `PERF` → what applies to your project

**Step 4 — verify**

```powershell
.\.ai-dlc\tools\validate.ps1
```

```bash
bash .ai-dlc/tools/validate.sh
```

If you see `AI-DLC validation passed`, you're ready. If there are warnings about unpopulated `_CONTEXT.md`, fill in the missing fields.

**Step 5 — first turn with the agent**

Open your agent (Claude Code, Copilot, Codex…). Ask:

> "Load `_CONTEXT.md` and confirm the context: phase, task, stack, active constraints."

The agent will read everything and give you a confirmation line like:
> `Context: <Project> | Phase: 3 | Task: T-001.2 | Stack: Node.js/Fastify | Constraints: SEC-02,SEC-03,PERF-01. Proceed?`

From here the conversation begins.

### 5.2 Scenario: brand new project

Create folder, enter directory, run `init`, then follow from Step 3.

---

## 6. Typical session workflow

### Session start
1. Open your agent.
2. Agent reads `_CONTEXT.md` and `PROGRESS.md` (if host supports it automatically) or you request it.
3. Agent confirms state → phase, task, constraints.
4. You say what you want to do today.

### During the session
- For **LOW** tasks (rename, typo): agent executes and notifies.
- For **MEDIUM** tasks (new feature): agent proposes a plan, you approve.
- For **HIGH** tasks (schema, auth): agent **HALT**, presents detailed plan, waits for explicit confirmation.
- Every 3-5 significant actions → `@checkpoint` to mark a stopping point.

### Session end
- Agent proposes an updated `_CONTEXT.md` block (if phase/task/stack changed).
- Agent proposes an entry for `PROGRESS.md` with summary.
- You confirm or adjust, then commit.

### Changing phases
When you move from Design to Implementation, update `Phase` in `_CONTEXT.md` and the agent loads different modules/skills in the next session.

---

## 7. Framework tools

All in `.ai-dlc/tools/`. Work in both PowerShell (`.ps1`) and Bash (`.sh`).

| Tool | What it does |
|------|--------------|
| `init.ps1/sh` | Create state files for a new project |
| `validate.ps1/sh` | Verify repo has complete framework + checks on tasks/epics/context |
| `validate.ps1/sh --strict` | Same but makes warnings fail |
| `show-models.ps1/sh` | Print model level → vendor mapping (Anthropic/OpenAI/Gemini) |
| `sync-copilot.ps1/sh` | Verify `copilot-instructions.md` is aligned with `AGENTS.md` concepts |
| `preprocess-company-docs.ps1/sh` | Convert company PDF/DOCX to readable Markdown for agents |
| `update-projects.ps1/sh` | In monorepo, update the projects index |

### Example: add a new SEC to your project
1. Open `_CONTEXT.md` → add a row `| SEC-04 | Secrets & Config | ... |`
2. Run `validate` for sanity check
3. In the next session the agent will respect it

---

## 8. Generating documentation from legacy code

One of the most common AI-DLC use cases is taking an existing codebase with no (or poor) documentation and producing a useful, verifiable foundation. The framework covers this flow with two modules that must be used in sequence: **analyze first, then document**.

### 8.1 When you need it

- You inherit a legacy project with no meaningful README.
- You need to onboard new developers (human or AI agents) onto a complex codebase.
- You're about to do a major refactor and need a stable map first.
- You want a documented security/performance audit.
- Compliance requires architecture overview, data model, runbook.

### 8.2 The two AI-DLC modules involved

| Module | Phase | Purpose |
|--------|-------|---------|
| `.ai-dlc/modules/09_CODEBASE_ANALYSIS.md` | Intake | Understand structure, dependencies, hotspots, risks |
| `.ai-dlc/modules/10_DOCUMENTATION.md` | Output | Produce navigable Markdown from templates |

Analysis is a prerequisite: without a solid `MAP.md`, documentation ends up inventing things. AI-DLC is explicit about this: if the agent can't verify something, it must label it `ASSUMPTION` + `TODO`.

### 8.3 Recommended workflow (4 steps + 1)

**Step 0 — Prepare context**

Create (or update) `_CONTEXT.md`. Set:
- `Phase`: `0-Discovery` (for analysis) then `5-Release` (for documentation)
- `Mode`: `STANDARD` (decisions here have long-term impact, no `LITE`)
- `Active Task`: e.g., `T-DOC-001 Document legacy auth module`
- `Active Task Model Level`: minimum `5` (Sonnet High) — `6` if the codebase exceeds 50k LOC

**Step 1 — Codebase analysis (module 09)**

Open the agent and ask (adapt path and goals):

```
Load .ai-dlc/modules/09_CODEBASE_ANALYSIS.md and analyze this repository.
Goal: understand architecture, prepare full documentation.
Constraints: read _CONTEXT.md for SEC/PERF.

Produce in docs/_analysis/:
1) MAP.md — modules + dependencies + entry points
2) RISKS.md — technical risks (security/performance) + technical debt
3) HOTSPOTS.md — 10 most critical files with rationale
4) RUN.md — build/test/run commands
Don't invent: if you lack information, list questions and assumptions.
```

The agent runs 4 passes:
1. **Entry points & runtime path** — where the app starts, how it's configured
2. **Architecture snapshot** — pattern, domains, data stores, integrations
3. **Dependency & risk scan** — auth, logging, error handling, performance
4. **Change map** — primary code path, secondary impact, tests to touch

Expected output: 4 files in `docs/_analysis/`. Review them manually. The agent's questions/assumptions are the most important signal: answer them before moving to step 2.

**Step 2 — Documentation generation (module 10)**

Once `MAP.md` is approved, ask:

```
Load .ai-dlc/modules/10_DOCUMENTATION.md and generate documentation
for [module or full project] using docs/_analysis/ as source.

Produce in docs/:
- 00_OVERVIEW.md
- 01_ARCHITECTURE.md (with Mermaid diagrams)
- 02_API.md
- 03_DATA_MODEL.md
- 04_SECURITY_PERF.md
- 05_RUNBOOK.md
- 99_GLOSSARY.md

Apply anti-noise rules:
- 1 page per concept (max 2)
- Each section: purpose + code location + how to verify
- If not verifiable: ASSUMPTION + TODO
- No duplication across files
Conclude with a validation report.
```

**Step 3 — Verify**

For each generated file check:
- API endpoints actually exist (open the cited code)
- Data model entities match real tables/schema
- Mermaid diagrams render (open on GitHub or use a viewer)
- `TODO` and `ASSUMPTION` are justified or must be resolved

**Step 4 — Commit and update `PROGRESS.md`**

A typical entry:

```markdown
## 2026-05-13 — Legacy documentation pass
- Analyzed auth module (12 files, ~3200 LOC)
- Produced docs/00..05_*.md
- 7 ASSUMPTIONs to resolve (see docs/_analysis/RISKS.md)
- Estimated coverage: ~80% of code mapped
```

**Step 5 (optional) — Maintenance**

Documentation ages. Two options:

- **Manual**: on every PR touching a documented area, the agent in mode `STANDARD` proposes lines to update in `docs/`.
- **Automated**: add a CI job that fails when a PR changes `src/api/` files without updating `docs/02_API.md` (simple regex check).

### 8.4 What NOT to do

- **Don't skip step 1**: documenting without analysis produces fabricated content that makes things worse.
- **Don't use mode `LITE` or `RAPID`**: documentation is high-impact output, full ceremony required (confidence tags included).
- **Don't leave `ASSUMPTION` without a verify-by date**: mark with `<!-- TODO: verify by YYYY-MM-DD -->`.
- **Don't auto-generate diagrams from tools that don't understand the domain**: Mermaid diagrams the agent writes by reading the code are worth more than automatic generators.
- **Don't document what `git log` or `README` already explain**: AI-DLC prioritizes the **how to use** over chronology.

### 8.5 Task template

To track the work, create a standard AI-DLC task. Example:

```markdown
# T-DOC-001 — Documentation pass for legacy auth module

## AI Sizing
| Field | Value |
|-------|-------|
| Token Estimate | 40k input / 12k output / 52k total |
| Model Level | 5 |
| Risk Floor Applied | none (documentation, no production code) |
| Recommended Model | see manifest.json#model_levels |
| Rationale | refactor analysis on SEC-sensitive module |

## Goal
Produce complete docs/* for auth module, starting from codebase analysis.

## Deliverable
- docs/_analysis/{MAP,RISKS,HOTSPOTS,RUN}.md
- docs/{00..05,99}_*.md
- Validation report with ASSUMPTION list
```

### 8.6 Quick reference

| You want to… | Agent prompt | Module |
|--------------|--------------|--------|
| Just understand the code | "Run 09 on the whole repo" | 09 |
| Document a specific module | "Run 09 on src/auth/, then 10 limited to auth" | 09 + 10 |
| Update docs after a PR | "Diff against docs/, propose updates" | 10 |
| Full audit | "09 + 10 + cross-check with SEC_CONSTRAINTS.md" | 09 + 10 + SEC |

---

## 9. Working with multiple agents

AI-DLC is multi-agent by design. Each agent has a startup file at the root:

| Agent | Startup file |
|-------|--------------|
| Claude Code | `CLAUDE.md` (imports `AGENTS.md`) |
| OpenAI Codex CLI | `AGENTS.md` |
| Gemini | `GEMINI.md` (points to `AGENTS.md`) |
| OpenClaw | `OPENCLAW.md` (points to `AGENTS.md`) |
| GitHub Copilot | `.github/copilot-instructions.md` (standalone) |

**Best practice:** edit only `AGENTS.md`. The others import it or stay minimal. For Copilot (which can't import) use `sync-copilot` to verify alignment.

You can use Claude for design and Copilot for coding: they read the same `_CONTEXT.md`, apply the same rules.

---

## 10. Monorepo

In a monorepo (multiple apps/services in one repo) keep the shared framework at root and scaffold each subproject:

```powershell
.\.ai-dlc\tools\init.ps1 -ProjectRoot .\apps\app-a -FrameworkRoot .
```

```bash
bash .ai-dlc/tools/init.sh --project-root apps/app-a --framework-root .
```

Each subproject has its own `_CONTEXT.md`, `PROGRESS.md`, `.ai-dlc/project/`. The agent uses the `_CONTEXT.md` closest to the file it's working on.

Update the subproject index after additions/moves:

```bash
bash .ai-dlc/tools/update-projects.sh
```

---

## 11. Enterprise extension (company)

If your project must follow enterprise SDLC processes, governance, compliance, or internal standards, create `.ai-dlc/company/`. The agent loads it automatically.

Typical structure:

```text
.ai-dlc/company/
├── README.md         (index)
├── PROCESS.md        (internal SDLC)
├── GOVERNANCE.md     (approvals, audit, compliance)
├── STANDARDS.md      (engineering standards)
├── source/           (original PDF/DOCX files)
└── processed/        (generated Markdown version)
```

For PDF/DOCX: put in `source/`, then:

```bash
bash .ai-dlc/tools/preprocess-company-docs.sh
```

The agent reads `processed/`, not the binaries.

---

## 12. Common errors and troubleshooting

### "Agent doesn't respect SEC constraints"
Likely cause: `_CONTEXT.md` doesn't have them filled in, or agent didn't read the file at session start. Verify with `@show-constraints`.

### "Agent keeps asking for confirmation even on LOW tasks"
You're probably in mode `STANDARD` or `AUDIT`. Switch to mode `LITE` if your project is stable.

### "Agent made changes it shouldn't have"
Check `.ai-dlc/halt-triggers.yaml`: is the affected path covered? If not, add it as an override in `.ai-dlc/project/halt-triggers.yaml`.

### "Validator fails on a task"
Open the task `T-NNN.N.md`. Verify that `| Model Level |` and `| Risk Floor Applied |` don't contain placeholders like `[1-7]`. Fill with real values.

### "Validator fails on an epic"
Epic must have `## Risk and Model Floor` and `## Task Breakdown`. Use `.ai-dlc/modules/templates/EPIC_TEMPLATE.md` as reference.

### "Warning on unpopulated `_CONTEXT.md`"
It's just a default warning — it clears when you fill in `Active Task`, `Active Task Token Estimate`, `Active Task Model Level` fields. In CI you can force failure with `--strict`.

### "I want to modify `.ai-dlc/modules/...`"
Don't. Modules are read-only during normal use. For customizations, put rules in `.ai-dlc/project/instructions.md` or skills in `.ai-dlc/project/skills/`.

### "Agent loads too much"
You might be in mode `STANDARD` or `AUDIT` on a LOW task. Change mode to `LITE` or `FAST`.

### "I want to bypass a HALT"
Don't circumvent it. Either change the affected path in `.ai-dlc/project/halt-triggers.yaml` (remove that pattern from the trigger) or accept that the path requires confirmation — it's there for good reasons.

---

## 13. Quick glossary

- **AI-DLC**: AI-Driven Development Life Cycle. This framework.
- **AI Sizing**: token estimate + model level + recommended model for a task.
- **Bootstrap**: sequence the agent runs at session start (read `_CONTEXT.md`, load skills, etc.).
- **Checkpoint**: stopping point after 3-5 significant actions where state is locked.
- **Company extension**: `.ai-dlc/company/` folder with additional enterprise rules.
- **Confidence tag**: `FACT` / `INFERRED` / `ASSUMPTION`, AI's self-assessment of reliability.
- **Conversational command**: `@checkpoint`, `@stop`, etc. Chat commands for the agent.
- **HALT trigger**: file path pattern that forces the agent to ask confirmation before editing.
- **Mode**: ceremony level. `LITE`/`STANDARD`/`AUDIT`/`RAPID`/`FAST`.
- **Model level**: 1-7, the "power level" of AI needed for a task.
- **Module**: file `.ai-dlc/modules/NN_*.md`, framework rule loaded per phase.
- **PERF-XX**: reusable performance constraint (e.g., PERF-01 latency).
- **Phase**: 0-6, where you are in the development cycle.
- **Risk floor**: minimum model level forced by certain risks (e.g., auth → minimum 6).
- **SEC-XX**: reusable security constraint (e.g., SEC-02 authentication).
- **Skill**: file `.ai-dlc/modules/skills/SKILL_*.md`, thematic guide loaded on demand.
- **Strict mode (validator)**: warnings become failures. Used in CI.

---

## Learn more

- `README.md` — quick-start
- `.ai-dlc/INSTALL.md` — setup checklist
- `.ai-dlc/COMMANDS.md` — full conversational commands
- `.ai-dlc/modules/01_CORE_RULES.md` — detailed base rules
- `.ai-dlc/modules/SEC_CONSTRAINTS.md`, `PERF_CONSTRAINTS.md` — constraint libraries
- `.ai-dlc/examples/` — populated examples of context, epic, task, progress
- `.ai-dlc/VERSIONING.md` — versioning policy
- `CHANGELOG.md` — change history

For questions: always start with `_CONTEXT.md`. It's the source of truth for your project.
