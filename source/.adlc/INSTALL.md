# AI-DLC Installation Guide

Use this checklist when adding AI-DLC to a new repository.

## Copy Framework Files

Copy these paths to the repository root:

```text
AGENTS.md
CLAUDE.md
GEMINI.md
OPENCLAW.md
.github/copilot-instructions.md
.adlc/
```

## Create Project State

You can scaffold the standard project files automatically:

```powershell
.\.adlc\tools\init.ps1
```

With company process extension:

```powershell
.\.adlc\tools\init.ps1 -Company
```

Or on Bash-compatible environments:

```bash
bash .adlc/tools/init.sh
```

With company process extension:

```bash
bash .adlc/tools/init.sh --company
```

Manual setup is also supported.

Create `_CONTEXT.md` from the full template:

```bash
cp .adlc/modules/templates/CONTEXT_TEMPLATE.md ./_CONTEXT.md
```

For a spike or small project, use:

```bash
cp .adlc/modules/templates/CONTEXT_MIN.md ./_CONTEXT.md
```

## Add Project Rules

Prefer the neutral AI-DLC path:

```bash
mkdir -p .adlc/project/skills
cp .adlc/modules/templates/PROJECT_INSTRUCTIONS_TEMPLATE.md .adlc/project/instructions.md
```

Use `.copilot/` only when an existing GitHub Copilot setup requires compatibility.

## Add Company Process Extension

If the repository must follow enterprise SDLC, governance, compliance, or engineering standards, create `.adlc/company/`:

```bash
mkdir -p .adlc/company/docs
cp .adlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md .adlc/company/README.md
```

Agents load `.adlc/company/` automatically when it exists.

### Preprocess PDF/DOCX company docs

Put original documents in `.adlc/company/source/`, then run:

```powershell
.\.adlc\tools\preprocess-company-docs.ps1
```

Or:

```bash
bash .adlc/tools/preprocess-company-docs.sh
```

The output goes to `.adlc/company/processed/`. Agents should use processed Markdown/text files, not raw PDF/DOCX files.
The preprocessing step also creates `.adlc/company/processed/manifest.json`.

## Initialize Progress Tracking

```bash
cp .adlc/modules/templates/PROGRESS_TEMPLATE.md ./PROGRESS.md
```

## Create Planning Artifacts

Use:
- `.adlc/modules/templates/EPIC_TEMPLATE.md` for epics
- `.adlc/modules/templates/TASK_TEMPLATE.md` for tasks
- `.adlc/modules/templates/DECISION_RECORD_TEMPLATE.md` for ADRs and critical decisions

Reference examples:
- `.adlc/examples/CONTEXT.example.md`
- `.adlc/examples/EPIC.example.md`
- `.adlc/examples/TASK.example.md`
- `.adlc/examples/PROGRESS.example.md`

## Validate Installation

Run:

```powershell
.\.adlc\tools\validate.ps1
```

Or on Bash-compatible environments:

```bash
bash .adlc/tools/validate.sh
```

## CI

Use `.adlc/examples/github-actions-validate.yml` as a GitHub Actions example for pull request validation.

## First Agent Session

Ask the agent to:
1. load `_CONTEXT.md`
2. load `.adlc/project/instructions.md` if present
3. load the relevant phase module from `.adlc/modules/`
4. confirm project, phase, task, stack, and active constraints

## Monorepo Setup

For multiple projects in one repository, keep the shared framework at repository root and scaffold each project separately:

```powershell
.\.adlc\tools\init.ps1 -ProjectRoot .\apps\app-a -FrameworkRoot .
.\.adlc\tools\init.ps1 -ProjectRoot .\services\service-b -FrameworkRoot .
```

```bash
bash .adlc/tools/init.sh --project-root apps/app-a --framework-root .
bash .adlc/tools/init.sh --project-root services/service-b --framework-root .
```

Each project gets its own `_CONTEXT.md`, `PROGRESS.md`, `.adlc/project/`, and optional `.adlc/company/`.

Agents must use the `_CONTEXT.md` closest to the active file.

Update the repository project index after adding or moving projects:

```powershell
.\.adlc\tools\update-projects.ps1
```

```bash
bash .adlc/tools/update-projects.sh
```

Run smoke tests after installation or framework changes:

```powershell
.\.adlc\tests\test.ps1
```

```bash
bash .adlc/tests/test.sh
```

JSON schemas live in `.adlc/schemas/` for:
- `.adlc/manifest.json`
- `.adlc/projects.json`
- `.adlc/company/processed/manifest.json`
