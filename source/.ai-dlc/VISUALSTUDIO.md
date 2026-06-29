# Visual Studio 2026 — AI-DLC Framework

> Read by: **Visual Studio 2026 Copilot** (GitHub Copilot integration inside the IDE).
> GitHub Copilot (VS Code) reads `.github/copilot-instructions.md`.
> Shared agent rules live in `AGENTS.md` — loaded first.
 
---

@AGENTS.md

<!-- The line above imports the shared AI-DLC contract at session start.
     Common rules (bootstrap, priority, phase activation, risk, sizing) live there.
     Add Visual Studio 2026-specific overrides below. -->

---

## Visual Studio 2026 Specifics

### Solution & Project Navigation

- This repository may contain one or more Visual Studio **solutions** (`.sln`). The `.sln` location is **irrelevant** to AI-DLC paths — all paths are anchored to the **repo root**.
- Every solution **MUST** include the shared **`AI-DLC.Documentation` project** (`AI-DLC.Documentation.csproj`, at the **repo root**).
  This is the **single, canonical documentation project** for ALL projects in the solution.
- Each project has its own subfolder under `projects\<ProjectName>\` (repo root) which **must** contain:
  - `_CONTEXT.md` — session state and constraints for that project
  - `PROGRESS.md` — progress log for that project
  - `instructions.md` — project-specific Copilot rules
  - subdirectories — all documentation artifacts for that project (PHASES, EPICS, DECISION_RECORDS, API, …)
- Shared documentation across projects lives in `projects\shared\`.
- Solution-wide documentation lives in `docs\_solution\`.
- The `.ai-dlc\` folder contains **only read-only framework files** (modules, schemas, tools, tests).
- When a user references "the docs project" or asks where to put docs,
  the answer is `projects\<ProjectName>\`. Load `SKILL_VISUALSTUDIO.md` for full conventions.

### Documentation Ownership Rule

> **RULE DOC-01 (mandatory):** Every project **must** have its own `_CONTEXT.md` and `PROGRESS.md`
> inside `projects\<ProjectName>\` (at the repo root).
> All context, rules and documentation for a project live exclusively in that subfolder.
> Shared cross-project documentation goes in `projects\shared\`; solution-wide docs in `docs\_solution\`.
> No documentation files are placed inside application source folders (e.g. `src\MyApp\`) or loose at the repo root.
> The `.ai-dlc\` folder is reserved exclusively for read-only framework files.
> The `.sln` file location is irrelevant — never use it as a path reference.

### File Priority Inside a Solution Root

```
1. projects\<Project>\_CONTEXT.md        ← session state (phase, task, constraints)
2. projects\<Project>\PROGRESS.md        ← progress log for the project
3. projects\<Project>\instructions.md    ← project-specific rules
4. .ai-dlc\company\                      ← enterprise process gates
5. .ai-dlc\modules\                      ← framework (read-only)
6. projects\<Project>\                   ← canonical docs for each project
   projects\shared\                      ← shared docs across projects
   docs\_solution\                       ← solution-wide docs
```

### Copilot Behaviour

- Load `SKILL_VISUALSTUDIO.md` when working on solution structure, `.csproj`, `.sln`, or docs.
- **When asked to write or update documentation for a project**: always target `projects\<ProjectName>\`.
- **When asked for shared / cross-project documentation**: target `projects\shared\`.
- **When a new project is added**: create `projects\<ProjectName>\` with `_CONTEXT.md`, `PROGRESS.md`, and `instructions.md` — these three files are **mandatory** for every project.
- **Never create documentation files inside application source folders** (e.g. `src\MyApp\`).
- **Never create documentation files inside `.ai-dlc\`** — that folder is framework-only and read-only.
- **Never use the `.sln` file location as a path reference** — always anchor paths to the repo root.
- Halt before touching `*.sln`, `.csproj` references, NuGet feeds, or CI/CD pipelines
  (HIGH risk — explicit confirmation required).
- Prefer **relative paths** when suggesting file locations inside the solution.
- Use **C# naming conventions** for project and folder names (PascalCase).
- Do NOT generate runnable C# code inside the Documentation project.

### Task Sizing Reminder

- Every created task: token estimate + model level 1-7
  (mapping in `.ai-dlc/manifest.json#model_levels`).
- HIGH risk (`.sln`, `.csproj` structure changes): level 5 minimum.
