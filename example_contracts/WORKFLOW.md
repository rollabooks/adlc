# ADLC — Human–AI Agent Interaction Workflow
> Operational guide for using the `.github/copilot_modules/` framework
> with per-project instructions in `.copilot/` and SKILL files.

> ⚠️ **NOTE**: This file is a **generic operational guide** for any project.
> The **authoritative source** for rules is `.github/copilot_modules/` (technology-agnostic framework).
> In case of conflict, `.github/` prevails — unless explicitly overridden in `.copilot/instructions.md`.
>
> **.github modules involved in this workflow**:
> | Workflow Phase | .github Module | Section |
> |-----------------|----------------|----------|
> | Phase 0 (Prep) | `02_DISCOVERY_ANALYSIS_EN.md` | §Discovery |
> | Phase 1 (Scope) | `02_DISCOVERY_ANALYSIS_EN.md` | §Analysis |
> | Phase 2 (Design) | `03_DESIGN_EN.md` | §Architecture, §EPIC/Task |
> | Phase 3 (Simulate) | `04_IMPLEMENTATION_EN.md` | §Pseudocode rule |
> | Phase 4 (Build) | `04_IMPLEMENTATION_EN.md` | §Task workflow |
> | Phase 5 (Release) | `05_VERIFICATION_RELEASE_EN.md` | §Testing, §Release |
> | Phase 6 (Learn) | `01_CORE_RULES_EN.md`, `06_OPS_EN.md` | §Context update, §Session summary, §Incident response |
> | Session Start | `01_CORE_RULES_EN.md` | §R1, §1.1 Context Discovery |
> | Control | `01_CORE_RULES_EN.md` | §10 Commands, §12 Mandatory STOP |

---

## Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    REPOSITORY                                │
│                                                              │
│  .github/                          notes-app/                │
│  ├── copilot-instructions.md       ├── .copilot/             │
│  └── copilot_modules/              │   ├── instructions.md   │
│      ├── 01_CORE_RULES_EN.md       │   └── skills/           │
│      ├── 02_DISCOVERY_...          │       ├── analysis.md   │
│      ├── ...                       │       ├── design.md     │
│      ├── SECURITY_CONSTR...        │       ├── react.md      │
│      └── PERFORMANCE_CON...        │       ├── api-design.md │
│                                    │       ├── database.md   │
│                                    │       ├── security.md   │
│                                    │       ├── flutter.md    │
│                                    │       └── ops.md        │
│                                    ├── _CONTEXT.md            │
│                                    ├── PROGRESS.md            │
│                                    └── src/                   │
│                                                               │
│                                    taskmaster-cli/             │
│  FRAMEWORK (agnostic,              ├── .copilot/              │
│   read-only for the agent)         │   └── instructions.md    │
│                                    ├── _CONTEXT.md            │
│                                    ├── PROGRESS.md            │
│                                    └── src/                   │
└─────────────────────────────────────────────────────────────┘

Flow: .github (universal rules) + .copilot/ (project rules + skills) + _CONTEXT.md (session state)
```

---

## Phase 0: Initial Setup (one-time)

### What the human does
1. Verify that `.github/copilot-instructions.md` and `.github/copilot_modules/` are present in the repo
2. For each project in the repo, create:
   ```
   <ProjectRoot>/.copilot/instructions.md   ← project-specific rules
   <ProjectRoot>/.copilot/skills/            ← SKILL files (optional)
   <ProjectRoot>/_CONTEXT.md                ← current project state
   <ProjectRoot>/PROGRESS.md                ← session history (multi-session projects)
   ```
3. Populate `_CONTEXT.md` with: phase, stack, SEC/PERF constraints, build/test/run commands
4. Create SKILL files for specialized domains (React, Flutter, API Design, etc.)

### What the agent does
- Nothing. The agent does not modify `.github/`. It can help create `.copilot/`, `_CONTEXT.md`, and SKILL files if requested.

### SKILL files (Progressive Disclosure)
SKILL files grant domain-specific competencies to the AI. They are loaded **only when needed** to avoid context saturation.

```
.copilot/skills/
├── analysis.md        ← Discovery & Analysis (Phase 0-1): requirements, user stories, threat model
├── design.md          ← Architecture & Design (Phase 2): stack evaluation, ADRs, EPIC/tasks
├── react.md           ← React/frontend conventions, component patterns
├── flutter.md         ← Flutter/mobile conventions, Riverpod, navigation
├── api-design.md      ← REST conventions, response formats, error codes
├── database.md        ← Schema conventions, query patterns, migrations
├── security.md        ← Auth patterns, OWASP checklist, token handling
└── ops.md             ← Operations (Phase 6): incidents, monitoring, runbooks
```

**When to load a SKILL**: The agent loads the relevant SKILL when the task involves that domain.
For example, `react.md` is loaded only during frontend implementation tasks.

**Priority hierarchy** (highest to lowest):
1. `_CONTEXT.md` — Current session state (MAXIMUM priority)
2. `.copilot/instructions.md` — Project-specific rules
3. `.copilot/skills/*.md` — Domain competencies (loaded on demand)
4. `.github/copilot_modules/` — Framework rules (read-only, MINIMUM priority)

---

## Phase 1: Session Start (every chat)

> 📘 **.github Module**: `01_CORE_RULES_EN.md` §R1 Session start + §1.1 Context Discovery Protocol

```
┌──────────┐                              ┌──────────┐
│  HUMAN   │  Opens a new chat            │  AGENT   │
│          │ ─────────────────────────────▶│          │
│          │                              │          │
│          │                              │ 1. Reads copilot-instructions.md
│          │                              │ 2. Executes Bootstrap Protocol
│          │                              │ 3. Searches _CONTEXT.md (discovery §1.1)
│          │                              │ 4. Loads .copilot/instructions.md
│          │                              │ 5. Identifies relevant SKILLs
│          │                              │ 6. Reads PROGRESS.md (if exists)
│          │                              │
│          │  "Context acquired.          │          │
│          │   Project: X | Phase: Y      │          │
│          │   Stack: Z | Mode: M         │          │
│          │◀──Proceed?"──────────────────│          │
│          │                              │          │
│  "Yes"   │                              │          │
│  or fix  │ ────────────────────────────▶│          │
└──────────┘                              └──────────┘
```

### Useful commands at start
| Command | What happens |
|---------|-------------|
| `@context-update` | The agent updates `_CONTEXT.md` and `PROGRESS.md` from current state |
| `@checkpoint` | The agent saves progress and proposes the next step |
| (none) | The agent starts with the Bootstrap Protocol automatically |

---

## Phase 2: Task Assignment

> 📘 **.github Module**: `01_CORE_RULES_EN.md` §11 Risk Classification

### The human communicates the task
Examples of effective prompts:

| Type | Prompt Example |
|------|------------------|
| **New feature** | "Implement JWT authentication for the Core Host (E-003 task 3.1)" |
| **Bug fix** | "The PATCH handler returns 500 when Upload-Offset doesn't match" |
| **Refactoring** | "Move the validation logic from Core.Host to Uploads.Core" |
| **Documentation** | "Generate API documentation for the endpoints" |
| **Analysis** | "Analyze the code in Edge/ and identify tech debt" |

### The agent classifies and responds

```
Automatic classification:
├─ LOW RISK + SMALL    → Executes directly, notifies at end
├─ MEDIUM RISK/SCOPE   → "I propose to [X]. Proceed?"
└─ HIGH RISK/LARGE     → Detailed plan + explicit confirmation
```

**Golden rule**: If the agent says "Proceed?", the human MUST respond before the agent acts.

---

## Phase 2b: Epic → Task Navigation

> 📘 **.github Module**: `01_CORE_RULES_EN.md` §Task Navigation Protocol + `04_IMPLEMENTATION_EN.md` §Task File Navigation

### Task structure on disk
```
docs/epics/
├── INDEX.md                          ← epic index (overview + status)
├── E-NNN_Epic_Name.md                ← epic summary (goal, scope, constraints)
└── tasks/
    └── E-NNN/
        ├── T-NNN.1_Task_Name.md      ← atomic task (AC, files, SEC/PERF)
        ├── T-NNN.2_Task_Name.md
        └── ...
```

### How to assign a task

| Method | Prompt | What the agent does |
|------|--------|------------------|
| **By task file** | "Implement T-001.3" | Loads `tasks/E-001/T-001.3_*.md`, extracts AC, implements |
| **By epic** | "Work on E-001" | Reads `E-001_*.md`, proposes the next TODO task |
| **Free-form** | "Add the UserSession model" | Classifies risk, proposes plan, executes |

### Task lifecycle
```
🔲 TODO → 🔄 IN_PROGRESS → ✅ DONE
```

**Rules**:
1. The agent updates the status in the task file after completion
2. If all tasks in an epic are ✅, the agent reports it
3. `_CONTEXT.md` § Active Task is updated on every change
4. One task = one unit of work per session (ideal)

### Task file template
```markdown
# T-NNN.N — Title
Epic: E-NNN | SP: N | Status: 🔲 TODO | Risk: LOW/MED/HIGH
Dependencies: T-NNN.N (if any)

## Objective
[1-2 sentences]

## Acceptance Criteria
- [ ] AC1
- [ ] AC2

## Files involved
- `path/to/file.js`

## Applicable SEC/PERF
- SEC-XX: [if applicable]
- PERF-XX: [if applicable]

## Implementation notes
[pseudocode if >50 lines, otherwise empty]
```

---

## Phase 3: Work Cycle

> 📘 **.github Module**: `04_IMPLEMENTATION_EN.md` §Implementation checklist + §Pseudocode rule

```
                    ┌────────────────────┐
                    │   TASK ASSIGNED     │
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │ Agent verifies:     │
                    │ • Applicable SEC-XX │
                    │ • Applicable PERF-XX│
                    │ • .copilot/ rules   │
                    └────────┬───────────┘
                             │
                ┌────────────▼────────────┐
                │  Logic > 50 lines?      │
                │                         │
           Yes  │                         │  No
        ┌───────┘                         └───────┐
        │                                         │
  ┌─────▼─────┐                             ┌─────▼─────┐
  │ Pseudocode│                             │  Direct   │
  │ + Review  │                             │  code     │
  └─────┬─────┘                             └─────┬─────┘
        │ Human approval                          │
        └────────────┬────────────────────────────┘
                     │
               ┌─────▼─────┐
               │ IMPLEMENT  │
               │ + test     │
               └─────┬─────┘
                     │
               ┌─────▼──────┐     ❌ Failed
               │ BUILD+TEST │────────────▶ Fix & retry
               └─────┬──────┘
                     │ ✅
               ┌─────▼──────┐
               │ CHECKPOINT  │
               │ (every 3-5  │
               │  actions)   │
               └─────┬──────┘
                     │
              ┌──────▼──────┐
              │ More tasks?  │
              │              │
         Yes  │              │  No
      ┌───────┘              └───────┐
      │                              │
      ▼                              ▼
   (loop back)                 End session
```

### Checkpoint Format
Every 3-5 significant actions, the agent produces:
```markdown
## CHECKPOINT [N]
Phase: [from _CONTEXT.md] | Task: [active]
✅ Completed: [action list]
📋 Next: [next action]
📊 Confidence: On track / Minor issues / Blocked
```

---

## Phase 4: Control Commands (during work)

> 📘 **.github Module**: `01_CORE_RULES_EN.md` §10 Control Commands + §12 Mandatory STOP

The human can intervene at any time:

| Command | Effect |
|---------|---------|
| `@stop` | The agent stops immediately |
| `@explain` | The agent explains the reasoning behind the last action |
| `@undo` | The agent undoes the last change (if possible) |
| `@alternatives` | The agent proposes alternative solutions |
| `@simplify` | The agent simplifies the approach |
| `@confidence` | The agent declares FACT / INFERRED / ASSUMPTION |
| `@context-update` | The agent updates `_CONTEXT.md` and `PROGRESS.md` with current state |
| `@checkpoint` | The agent saves checkpoint and proposes the next step |

### Mandatory STOP Situations

The agent stops **automatically** and asks for confirmation when:
- 🔴 Database schema or API contract change
- 🔴 Deletion of data or code
- 🔴 Change to authentication/authorization logic
- 🔴 Architectural change
- 🔴 Violation of a SEC-XX or PERF-XX constraint
- 🔴 Secret/credential management

---

## Phase 5: Session End

> 📘 **.github Module**: `01_CORE_RULES_EN.md` §13 Session Summary + §R4 End of session

### The agent proposes
```markdown
## SESSION SUMMARY
✅ Completed: [N tasks]
📋 To do: [next tasks]
🔄 _CONTEXT.md: updated? Yes/No
� PROGRESS.md: updated? Yes/No
📊 Build: ✅ 0 errors, 0 warnings | Tests: ✅ N passed
```

### The human verifies
1. Reviews the summary
2. Approves the `_CONTEXT.md` and `PROGRESS.md` updates (or corrects them)
3. Decides whether to start another session or close

---

## Complete Session Examples

### Example A: Analysis & Design Session (Phase 0-2)

```
HUMAN:   [opens chat — new project, no _CONTEXT.md yet]
AGENT:   "No _CONTEXT.md found. Starting Discovery (Phase 0).
          SKILL loaded: analysis.md
          I'll help define the domain. What is the project about?"

HUMAN:   "I want to build a note-taking app with tags and sharing"

AGENT:   [analyzes domain, identifies entities: Note, User, Tag]
         "Domain analysis complete. I propose:
          — Entities: Note (title, content), User (email, OAuth), Tag (name)
          — Relationships: User 1:N Note, Note N:M Tag
          Next: define functional requirements (FR) and user stories?"

HUMAN:   "Yes, also include security and performance NFRs"

AGENT:   [generates FR list, user stories with GIVEN/WHEN/THEN, SEC/PERF NFRs]
         "CHECKPOINT 1 — Analysis deliverables:
          — 8 functional requirements (FR-01..FR-08)
          — 6 user stories with acceptance criteria
          — Security: SEC-01..SEC-05 defined
          — Performance: PERF-01..PERF-03 defined
          — Preliminary threat model drafted
          Ready to move to Design (Phase 2)? Loading design.md SKILL."

HUMAN:   "Yes, proceed to stack selection"

AGENT:   [loads SKILL design.md]
         "SKILL design.md loaded. Evaluating stack options.
          Based on requirements, I propose 3 options..."
         [generates stack evaluation matrix + ADR-001]
         "Stack selected: Node.js/Express + React + PostgreSQL.
          ADR-001 written. Next: EPIC/task breakdown?"

HUMAN:   "Yes, @context-update then wrap up"

AGENT:   [creates _CONTEXT.md + EPIC/task breakdown]
         "SESSION SUMMARY: Analysis + Design complete.
          _CONTEXT.md created (Phase 2 —> 3).
          SKILLs used: analysis.md, design.md
          3 EPICs defined, 12 tasks ready for sprint planning."
```

### Example B: Implementation Session (Phase 3-4)

```
HUMAN:   [opens chat]
AGENT:   "Context acquired. Project: Notes App | Phase: 4-Impl
          Stack: Node.js/Express + React + PostgreSQL | Mode: STANDARD
          SKILL loaded: api-design.md
          Task: E-003 CRUD Notes ready. Proceed?"

HUMAN:   "Implement the Note model with Prisma and the CRUD endpoints"

AGENT:   "MEDIUM RISK. SKILL api-design.md loaded. I propose:
          1. Define Note model in schema.prisma (title, content, userId)
          2. Generate Prisma migration
          3. Implement service — controller — route (per SKILL)
          4. Add unit tests for the service layer
          Proceed?"

HUMAN:   "Yes"

AGENT:   [implements] [migration applied] [tests passed]
         "CHECKPOINT 1 — Note model + 4 CRUD endpoints created.
          Tests: 6 passed. SEC-01 (input validation) applied.
          Next: NoteCard React component?"

HUMAN:   "Yes, switch to frontend"

AGENT:   [loads SKILL react.md]
         "SKILL react.md loaded. Implementing NoteCard + NoteForm."
         [implements components] [build green] [tests passed]
         "CHECKPOINT 2 — Frontend components created.
          Build: ✅ | Tests: ✅ 9 passed.
          Update _CONTEXT.md and PROGRESS.md?"

HUMAN:   "Yes, @context-update then let's wrap up"

AGENT:   [updates _CONTEXT.md and PROGRESS.md]
         "SESSION SUMMARY: 2 tasks completed (backend + frontend),
          _CONTEXT.md updated, PROGRESS.md updated.
          SKILLs used: api-design.md, react.md
          Suggested next: E-004 Authentication"
```


## Golden Rules for the Human

1. **Give context, not micro-instructions** — The agent has all context in `_CONTEXT.md` + `.copilot/`
2. **Trust the checkpoints** — If the agent says "build green, tests passed", the work is verified
3. **Act on STOPs** — When the agent asks for confirmation, the risk is real
4. **Use the commands** — `@explain`, `@alternatives`, `@checkpoint` are more effective than long explanations
5. **Update `_CONTEXT.md` and `PROGRESS.md`** at session end — They are the persistent memory between sessions
6. **Don't modify `.github/`** — To change the framework, use a dedicated PR
7. **Create SKILLs for repeated domains** — If you're doing React work across multiple sessions, a SKILL saves you from re-explaining conventions every time

## Golden Rules for the Agent

1. **Never fabricate** — If information is missing, ask
2. **Never skip SEC/PERF constraints** — They are BLOCKING
3. **Always verify the build** — No checkpoint without build + test
4. **Respect the hierarchy** — `.github/` (framework) → `.copilot/` (project + skills) → `_CONTEXT.md` (session)
5. **Mandatory confidence tag** — Every technical output >5 lines ends with FACT/INFERRED/ASSUMPTION
6. **Update `_CONTEXT.md`** — Every significant decision must be recorded in the Recent Decisions section
7. **Update `PROGRESS.md`** — Record completed work, problems solved, and next steps at session end
8. **Load SKILLs on demand** — When switching phases or domains (analysis → design → implementation → ops, or backend → frontend → mobile), load the relevant SKILL file. Do not load all SKILLs at once
