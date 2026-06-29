# SKILL — Visual Studio 2026 Solution & Documentation

> **Load** when working on solution structure, `.sln`/`.csproj`, NuGet, or the
> documentation layout of a Visual Studio repository.
> **Do NOT load** for normal coding inside a single project.

---

## Identity
You navigate Visual Studio **solutions** and own the shared **AI-DLC.Documentation**
project. You keep documentation separate from source code (RULE DOC-01) and keep
all paths anchored to the repo root.

## Principles
- **Repo root is the anchor** — never use the `.sln` file location as a path reference
- **Docs ≠ code** — documentation never lives in application source folders
- **`.ai-dlc/` is read-only** — framework only; never put docs there
- **One canonical docs project** — `AI-DLC.Documentation.csproj` at the repo root

---

## Canonical layout (Layout B)
```
<repo root>/
├── AI-DLC.Documentation.csproj      ← docs-only project (no executable C#)
├── .ai-dlc/                         ← framework (read-only)
├── docs/_solution/                  ← solution-wide: MAP, RISKS, DECISION_RECORDS
└── projects/
    ├── <ProjectName>/               ← per-project
    │   ├── _CONTEXT.md   (mandatory)
    │   ├── PROGRESS.md   (mandatory)
    │   ├── instructions.md (mandatory)
    │   └── docs/         ← PHASES, EPICS, API, DECISION_RECORDS
    └── shared/                      ← cross-project shared docs
```

## Adding a new project
1. Create `projects\<ProjectName>\` with the three mandatory files
   (`_CONTEXT.md`, `PROGRESS.md`, `instructions.md`).
2. Add an `<ItemGroup Label="Project — <Name>">` to `AI-DLC.Documentation.csproj`:
   `<None Include="projects\<Name>\**\*.*" />`
3. Anchor every `Include` to the repo root (the `.csproj` lives there).

## .csproj rules
- Docs-only: `EnableDefaultCompileItems=false`, no runnable C#.
- All `<None Include>` paths are **repo-root relative** (the project file is at root).
- Framework files referenced read-only from `.ai-dlc\…`.

## C# / naming
- PascalCase for project and folder names.
- Relative paths only when suggesting file locations.

---

## Risk — HALT (HIGH, explicit confirmation)
- Editing `*.sln`, `.csproj` references, NuGet feeds, or CI/CD pipelines → HIGH, level 5 min.

## Constraints — BLOCKING
- ❌ NEVER place documentation inside application source folders (e.g. `src\MyApp\`)
- ❌ NEVER place documentation inside `.ai-dlc\`
- ❌ NEVER use the `.sln` location as a path reference
- ❌ NEVER generate runnable C# inside the documentation project
- ✅ ALWAYS create `_CONTEXT.md` + `PROGRESS.md` + `instructions.md` for a new project
- ✅ ALWAYS anchor paths to the repo root
