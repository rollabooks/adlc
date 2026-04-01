# OPERATING GUIDE - AI-Driven SDLC Framework

> Reading time: 5 minutes
> Goal: Start using the framework effectively

---

## What is this framework?

A system of contracts that standardizes interaction between you and the AI during software development. It solves:

| Problem | Solution |
|---------|----------|
| AI forgets context between sessions | `_CONTEXT.md` as persistent memory |
| AI ignores security/performance requirements | SEC-XX/PERF-XX constraints always visible |
| Unreliable AI output | FACT/INFERRED/ASSUMPTION classification |
| Too much overhead to start | One mandatory file + Context Card |

---

## Quick start (5 minutes)

### Step 1: Initial setup (one-time)

```bash
# Copy the template to the project root
 cp .github/copilot_modules/00_CONTEXT_TEMPLATE_EN.md ./_CONTEXT.md
```

### Step 2: Fill the Context Card

Open `_CONTEXT.md` and fill the base sections:

```markdown
# PROJECT CONTEXT CARD
> Last Updated: 2025-12-13
> Status: ACTIVE

## 1. CURRENT STATE
| Param | Value |
|-------|-------|
| Phase | 0-Discovery |
| Sprint | 1 - Initial setup |
| Active Task | TASK-001 Project setup |
| Current Branch | main |
| Blockers | None |

## 2. TECH STACK
| Layer | Technology |
|-------|------------|
| Backend | [stack from project] |
| Frontend | [framework from project] |
| Database | [DB + ORM] |
...

## 3. CRITICAL CONSTRAINTS
### Security (Must Have)
| ID | Constraint | Details |
|----|------------|---------|
| SEC-01 | Authentication | JWT Bearer |
| SEC-02 | Authorization | RBAC |
...
```

### Step 3: Start an AI session

```
1. Open a new chat with the AI
2. Load: 01_CORE_RULES_EN.md
3. Paste: contents of _CONTEXT.md
4. The AI replies: "Context acquired. Phase: X | Task: Y..."
5. Work
```

---

## Daily workflow

### Start of day
```
[You]    -> Load 01_CORE_RULES_EN.md + paste _CONTEXT.md
[AI]     -> "Context acquired. Phase: Implementation | Task: TASK-042 | SKILL: api-design.md..."
[You]    -> "Continue with the task"
```

### During work
```
[You]    -> Normal requests
[AI]     -> Responds + confidence tag
[You]    -> Every 3-5 actions: "@checkpoint"
[AI]     -> Summary + possible _CONTEXT.md update
```

### End of session
```
[You]    -> "@checkpoint" or "end session"
[AI]     -> Generates updated block for _CONTEXT.md
[You]    -> Copy block into local _CONTEXT.md
```

---

## Essential commands

| Command | When to use |
|---------|-------------|
| `@checkpoint` | Every 3-5 actions or end of session |
| `@context-update` | When you want to update _CONTEXT.md |
| `@show-constraints` | To see active SEC/PERF constraints |
| `@security-check` | Before a PR or critical code |
| `@stop` | Stop the AI immediately |
| `@explain` | Understand the reasoning |

---

## What to load by phase

| You are doing... | Load Module | Load SKILL |
|-----------------|------|------------|
| Anything | `01_CORE_RULES_EN.md` + `_CONTEXT.md` | (none) |
| New project/feature | + `02_DISCOVERY_ANALYSIS_EN.md` | `analysis.md` |
| Architecture decisions | + `03_DESIGN_EN.md` | `design.md` |
| Coding (backend) | + `04_IMPLEMENTATION_EN.md` | `api-design.md` / `database.md` / `security.md` |
| Coding (frontend) | + `04_IMPLEMENTATION_EN.md` | `react.md` |
| Coding (mobile) | + `04_IMPLEMENTATION_EN.md` | `flutter.md` |
| Testing/Deploy | + `05_VERIFICATION_RELEASE_EN.md` | (reuse implementation SKILL) |
| Production issues | + `06_OPS_EN.md` | `ops.md` |
| Docs from code | + `10_DOCUMENTATION_EN.md` (+ `09_CODEBASE_ANALYSIS_EN.md` if you have MAP/HOTSPOTS) | (none) |
| Quick POC | Only `01_CORE_RULES_EN.md` + `_CONTEXT.md` (use RAPID MODE) | (none) |

## How to generate documentation from code (DOC-GEN-001)

1) Prepare input: updated `_CONTEXT.md`, clear scope (module/app), optional MAP/HOTSPOTS from `09_CODEBASE_ANALYSIS_EN.md`.
2) Load in chat: `01_CORE_RULES_EN.md` + `_CONTEXT.md` + `10_DOCUMENTATION_EN.md` (+ `09_CODEBASE_ANALYSIS_EN.md` if available).
3) Ask the AI, e.g.:
```
Generate complete documentation for module <name> according to DOC-GEN-001.
Output in docs/ (md + tex), PlantUML diagrams -> PNG, include validation report.
```
4) Verify the AI returns: list of generated files (md/tex/pdf), PlantUML/LaTeX results, TODO/ASSUMPTION markers.
5) Copy blocks into local files and keep the validation report.

---

## Understanding AI confidence tags

Every technical AI response ends with:

```markdown
---
AI CONFIDENCE: FACT
Basis: Function signature verified in src/module/file.js#L42
```

| Tag | Meaning | Action |
|-----|---------|--------|
| FACT | Verified from provided input | Use directly |
| INFERRED | Logical deduction | Review before use |
| ASSUMPTION | Unverified hypothesis | AI stops and asks |

Rule: If the AI does not include the tag on long technical answers, ask: "What is the confidence level?"

 Note: Use the standardized tag format from `.github/copilot_modules/01_CORE_RULES_EN.md` to keep responses consistent across sessions.

---

## Rapid Prototyping Mode

For quick POC/spikes (max 2h), use the simplified format:

```markdown
## RAPID MODE

Goal: Test integration with external API X
Time-box: 2 hours
Security constraint #1: No hardcoded credentials
Stack: Node.js + Axios

Expected output: Working POC
Rule: Separate branch `poc/test-api-x`
```

---

## File structure

```
project/
  _CONTEXT.md                      # Your context card (filled)
  PROGRESS.md                      # Session history (multi-session memory)
  .copilot/
    instructions.md                # Project-specific agent rules
    skills/                        # Domain SKILLs (loaded on demand)
      analysis.md                  # Phase 0-1: requirements, user stories
      design.md                    # Phase 2: stack, ADRs, EPIC/tasks
      react.md                     # Phase 3-4: React/frontend
      flutter.md                   # Phase 3-4: Flutter/mobile
      api-design.md                # Phase 3-4: REST API patterns
      database.md                  # Phase 3-4: schema, migrations
      security.md                  # Phase 3-4: auth, OWASP
      ops.md                       # Phase 6: incidents, monitoring
  docs/
    AI/
      00_CONTEXT_TEMPLATE_EN.md    # Template (full + minimal)
      00_MODE_EN.md                # Operating modes
      01_CORE_RULES_EN.md          # Always required
      02_DISCOVERY_ANALYSIS_EN.md  # New project
      03_DESIGN_EN.md              # Architecture
      04_IMPLEMENTATION_EN.md      # Code
      05_VERIFICATION_RELEASE_EN.md # Test & Deploy
      06_OPS_EN.md                 # Production
      07_SPECIAL_LANES_EN.md       # Parallel workflows
      08_PROMPT_LIBRARY_EN.md      # Prompt templates
      09_CODEBASE_ANALYSIS_EN.md   # Codebase analysis
      10_DOCUMENTATION_EN.md       # Doc generation & automation
      11_BUGFIX_PLAYBOOK_EN.md     # Structured debugging
      12_OPERATING_GUIDE_EN.md     # This guide
      13_ARCH_BACKEND_EXAMPLE_EN.md # Backend architecture (example)
      SECURITY_CONSTRAINTS_LIBRARY_EN.md
      PERFORMANCE_CONSTRAINTS_LIBRARY_EN.md
```

---

## FAQ

### "Do I need to load everything every time?"
No. Only `01_CORE_RULES_EN.md` + your `_CONTEXT.md`. Other modules are on-demand.

### "What if I change phase during the session?"
Use `@load-phase [N]` to load the new phase module, or ask the AI to adapt. The agent will also switch the active SKILL automatically.

### "What are SKILLs and do I need them?"
SKILLs are domain-specific expertise files in `.copilot/skills/`. They cover all ADLC phases: `analysis.md` (Phase 0-1), `design.md` (Phase 2), implementation SKILLs like `react.md`/`flutter.md`/`api-design.md`/`database.md`/`security.md` (Phase 3-4), and `ops.md` (Phase 6). The agent loads only the relevant SKILL for the current task. You can also create custom SKILLs for your project domains.

### "How do I update _CONTEXT.md?"
Use `@context-update` -> the AI generates the markdown block -> copy it locally.

### "The AI does not use confidence tags"
Remind it: "Remember to add AI CONFIDENCE tags to technical responses."

### "Too rigid for a quick POC"
Use RAPID MODE in `01_CORE_RULES_EN.md`.

---

## Typical session checklist

```
- Open new AI chat
- Load 01_CORE_RULES_EN.md
- Paste _CONTEXT.md
- Verify AI confirms context ("Context acquired...")
- Work (normal requests)
- @checkpoint every 3-5 actions
- End: @checkpoint
- Update local _CONTEXT.md with AI output
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| AI ignores constraints | Run `@show-constraints`, then restate them explicitly |
| AI suggests wrong stack | Check TECH STACK in `_CONTEXT.md` |
| Responses too long | Remind: "Max 3-5 paragraphs, then ask" |
| AI doesn't stop on critical decisions | Remind about High-Risk Zones in `01_CORE_RULES_EN.md` |
| Context lost between sessions | Keep `_CONTEXT.md` updated |

---

Version: 2.1
Last updated: 2025-12

Tip: Keep `_CONTEXT.md` updated. It is the memory that makes the AI useful from the first message of each session.
