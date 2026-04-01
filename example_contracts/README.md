# Example Contracts — ADLC Framework

This directory contains the complete example of the **ADLC (Agent Development Life Cycle)** framework
described in the book. It demonstrates the 3-level architecture for AI-assisted development.

---

## Directory Structure

```
example_contracts/
│
├── copilot-instructions.md              ← Universal AI contract (always loaded)
├── WORKFLOW.md                          ← Human–AI interaction guide
│
├── copilot_modules/                     ← Framework modules (technology-agnostic)
│   ├── 00_CONTEXT_TEMPLATE_EN.md        ← _CONTEXT.md template
│   ├── 00_MODE_EN.md                    ← Operating modes (FAST/STANDARD/AUDIT/RAPID)
│   ├── 01_CORE_RULES_EN.md              ← Base rules (always loaded)
│   ├── 02_DISCOVERY_ANALYSIS_EN.md      ← Phase 0-1: Discovery & Analysis
│   ├── 03_DESIGN_EN.md                  ← Phase 2: Architecture & Design
│   ├── 04_IMPLEMENTATION_EN.md          ← Phase 3-4: Implementation
│   ├── 05_VERIFICATION_RELEASE_EN.md    ← Phase 5: Testing & Release
│   ├── 06_OPS_EN.md                     ← Phase 6: Operations
│   ├── 07_SPECIAL_LANES_EN.md           ← Parallel workflows
│   ├── 08_PROMPT_LIBRARY_EN.md          ← Reusable prompt templates
│   ├── 09_CODEBASE_ANALYSIS_EN.md       ← Codebase analysis protocol
│   ├── 10_DOCUMENTATION_EN.md           ← Documentation generation
│   ├── 11_BUGFIX_PLAYBOOK_EN.md         ← Structured debugging
│   ├── 12_OPERATING_GUIDE_EN.md         ← Quick start guide
│   ├── 13_ARCH_BACKEND_EXAMPLE_EN.md    ← Backend architecture (Node.js example)
│   ├── SECURITY_CONSTRAINTS_LIBRARY_EN.md   ← SEC-01..SEC-07 patterns
│   ├── PERFORMANCE_CONSTRAINTS_LIBRARY_EN.md ← PERF-01..PERF-07 patterns
│   │
│   └── skills/                          ← SKILL files (domain specializations)
│       ├── SKILL_ANALYSIS_EN.md         ← Discovery & Analysis (Phase 0-1)
│       ├── SKILL_DESIGN_EN.md           ← Architecture & Design (Phase 2)
│       ├── SKILL_REACT_EN.md            ← React/frontend conventions
│       ├── SKILL_FLUTTER_EN.md          ← Flutter/mobile conventions
│       ├── SKILL_API_DESIGN_EN.md       ← REST API design patterns
│       ├── SKILL_DATABASE_EN.md         ← Database & Prisma ORM
│       ├── SKILL_SECURITY_EN.md         ← Security & authentication
│       └── SKILL_OPS_EN.md              ← Operations & Monitoring (Phase 6)
│
└── project_example/                     ← Example project-level files (Notes App)
    ├── _CONTEXT.md                      ← Project state (updated each session)
    ├── PROGRESS.md                      ← Session history (persistent memory)
    └── .copilot/
        └── instructions.md              ← Project-specific agent rules
```

---

## The 3-Level Architecture

```
Level 1: .github/copilot_modules/     → Universal framework (read-only)
Level 2: .copilot/ + skills/           → Project rules + domain expertise
Level 3: _CONTEXT.md + PROGRESS.md     → Session state (highest priority)
```

### Priority (highest to lowest)
1. **`_CONTEXT.md`** — Current session state, active task, recent decisions
2. **`.copilot/instructions.md`** — Project-specific rules and conventions
3. **`.copilot/skills/*.md`** — Domain SKILLs (loaded on demand)
4. **`.github/copilot_modules/`** — Framework rules (generic, technology-agnostic)

---

## How to Use

### New Repository
1. Copy `copilot-instructions.md` → `.github/copilot-instructions.md`
2. Copy `copilot_modules/` → `.github/copilot_modules/`
3. For each project, create `_CONTEXT.md` using the template in `00_CONTEXT_TEMPLATE_EN.md`
4. Create `.copilot/instructions.md` with project-specific rules
5. Copy relevant SKILL files to `.copilot/skills/`

### Existing Repository
1. Verify `.github/copilot-instructions.md` exists
2. Create `.copilot/instructions.md` in your project root
3. Start a chat — the agent follows the Bootstrap Protocol automatically

---

## SKILL Files (Progressive Disclosure)

SKILLs grant domain-specific expertise to the AI. They are loaded **only when needed**,
covering all ADLC phases:

| SKILL | ADLC Phase | When to Load | Domain |
|-------|-----------|-------------|--------|
| `SKILL_ANALYSIS_EN.md` | Phase 0-1 | New project / requirements elicitation | Discovery, requirements, user stories, threat model |
| `SKILL_DESIGN_EN.md` | Phase 2 | Stack selection / architecture | ADRs, stack evaluation, EPIC/task breakdown |
| `SKILL_REACT_EN.md` | Phase 3-4 | Frontend React tasks | Components, hooks, state, testing |
| `SKILL_FLUTTER_EN.md` | Phase 3-4 | Mobile Flutter tasks | Riverpod, navigation, deep links |
| `SKILL_API_DESIGN_EN.md` | Phase 3-4 | API design/implementation | REST conventions, response format |
| `SKILL_DATABASE_EN.md` | Phase 3-4 | Schema & data access | Prisma, migrations, query patterns |
| `SKILL_SECURITY_EN.md` | Phase 3-4 | Auth & security features | OAuth2, JWT, CORS, OWASP |
| `SKILL_OPS_EN.md` | Phase 6 | Production operations | Incident response, SLA, runbooks, monitoring |

Create your own SKILLs for project-specific domains (e.g., `SKILL_PAYMENT.md`, `SKILL_ANALYTICS.md`).

---

## Book Reference

This framework is described in detail in:
- **Chapter 3**: _CONTEXT.md basics and the 7 ADLC phases
- **Chapter 9**: SKILL files introduction (React SKILL)
- **Chapter 11**: Flutter SKILL
- **Appendix B**: Templates for all contract files
- **Appendix E**: Full 17-file professional framework analysis
