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
.ai-dlc/
```

## Create Project State

You can scaffold the standard project files automatically:

```powershell
.\.ai-dlc\tools\init.ps1
```

With company process extension:

```powershell
.\.ai-dlc\tools\init.ps1 -Company
```

Or on Bash-compatible environments:

```bash
bash .ai-dlc/tools/init.sh
```

With company process extension:

```bash
bash .ai-dlc/tools/init.sh --company
```

Manual setup is also supported.

Create `_CONTEXT.md` from the full template:

```bash
cp .ai-dlc/modules/templates/CONTEXT_TEMPLATE.md ./_CONTEXT.md
```

For a spike or small project, use:

```bash
cp .ai-dlc/modules/templates/CONTEXT_MIN.md ./_CONTEXT.md
```

## Add Project Rules

Prefer the neutral AI-DLC path:

```bash
mkdir -p .ai-dlc/project/skills
cp .ai-dlc/modules/templates/PROJECT_INSTRUCTIONS_TEMPLATE.md .ai-dlc/project/instructions.md
```

Use `.copilot/` only when an existing GitHub Copilot setup requires compatibility.

## Add Company Process Extension

If the repository must follow enterprise SDLC, governance, compliance, or engineering standards, create `.ai-dlc/company/`:

```bash
mkdir -p .ai-dlc/company/docs
cp .ai-dlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md .ai-dlc/company/README.md
```

Agents load `.ai-dlc/company/` automatically when it exists.

### Preprocess PDF/DOCX company docs

Put original documents in `.ai-dlc/company/source/`, then run:

```powershell
.\.ai-dlc\tools\preprocess-company-docs.ps1
```

Or:

```bash
bash .ai-dlc/tools/preprocess-company-docs.sh
```

The output goes to `.ai-dlc/company/processed/`. Agents should use processed Markdown/text files, not raw PDF/DOCX files.
The preprocessing step also creates `.ai-dlc/company/processed/manifest.json`.

## Initialize Progress Tracking

```bash
cp .ai-dlc/modules/templates/PROGRESS_TEMPLATE.md ./PROGRESS.md
```

## Create Planning Artifacts

Use:
- `.ai-dlc/modules/templates/EPIC_TEMPLATE.md` for epics
- `.ai-dlc/modules/templates/TASK_TEMPLATE.md` for tasks
- `.ai-dlc/modules/templates/DECISION_RECORD_TEMPLATE.md` for ADRs and critical decisions

Reference examples:
- `.ai-dlc/examples/CONTEXT.example.md`
- `.ai-dlc/examples/EPIC.example.md`
- `.ai-dlc/examples/TASK.example.md`
- `.ai-dlc/examples/PROGRESS.example.md`

## Validate Installation

Run:

```powershell
.\.ai-dlc\tools\validate.ps1
```

Or on Bash-compatible environments:

```bash
bash .ai-dlc/tools/validate.sh
```

## CI

Use `.ai-dlc/examples/github-actions-validate.yml` as a GitHub Actions example for pull request validation.

## First Agent Session

Ask the agent to:
1. load `_CONTEXT.md`
2. load `.ai-dlc/project/instructions.md` if present
3. load the relevant phase module from `.ai-dlc/modules/`
4. confirm project, phase, task, stack, and active constraints

## Monorepo Setup

For multiple projects in one repository, keep the shared framework at repository root and scaffold each project separately:

```powershell
.\.ai-dlc\tools\init.ps1 -ProjectRoot .\apps\app-a -FrameworkRoot .
.\.ai-dlc\tools\init.ps1 -ProjectRoot .\services\service-b -FrameworkRoot .
```

```bash
bash .ai-dlc/tools/init.sh --project-root apps/app-a --framework-root .
bash .ai-dlc/tools/init.sh --project-root services/service-b --framework-root .
```

Each project gets its own `_CONTEXT.md`, `PROGRESS.md`, `.ai-dlc/project/`, and optional `.ai-dlc/company/`.

Agents must use the `_CONTEXT.md` closest to the active file.

Update the repository project index after adding or moving projects:

```powershell
.\.ai-dlc\tools\update-projects.ps1
```

```bash
bash .ai-dlc/tools/update-projects.sh
```

Run smoke tests after installation or framework changes:

```powershell
.\.ai-dlc\tests\test.ps1
```

```bash
bash .ai-dlc/tests/test.sh
```

JSON schemas live in `.ai-dlc/schemas/` for:
- `.ai-dlc/manifest.json`
- `.ai-dlc/projects.json`
- `.ai-dlc/company/processed/manifest.json`
