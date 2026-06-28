# AI-DLC Commands

These commands are conversational controls for agents. They are not shell commands unless a project maps them to scripts.

| Command | Purpose | Expected Output | Files Usually Updated |
|---------|---------|-----------------|-----------------------|
| `@checkpoint` | Capture current state after 3-5 significant actions | Completed, next, blockers, context update needed | `PROGRESS.md`, optionally `_CONTEXT.md` |
| `@context-update` | Propose an updated context card | Replacement block or full `_CONTEXT.md` draft | `_CONTEXT.md` |
| `@show-constraints` | Show active SEC/PERF constraints | Constraint table with source | none |
| `@security-check` | Verify current plan/code against SEC-XX | Findings, risks, required fixes | none or task docs |
| `@perf-check` | Verify current plan/code against PERF-XX | Findings, risks, required fixes | none or task docs |
| `@load-phase [N]` | Load phase module for phase N | Module name and loaded rules summary | none |
| `@set-phase [N]` | Propose phase transition | Required changes and confirmation request | `_CONTEXT.md` after approval |
| `@prompt-list` | List reusable prompts | Prompt IDs and short descriptions | none |
| `@prompt [ID]` | Apply reusable prompt template | Filled prompt or next questions | none |
| `@alternatives` | Generate 2-3 options | Options with tradeoffs and recommendation | ADR for critical decisions |
| `@simplify` | Reduce scope or complexity | Smaller plan and removed scope | task docs if accepted |
| `@rollback` | Propose rollback plan | Revert path, risk, validation | task docs or release notes |
| `@stop` | Stop work immediately | Current state and safe next step | none |

## Command Rules

- Commands do not override risk classification.
- `@security-check` and `@perf-check` must cite active `_CONTEXT.md` constraints.
- `@context-update` proposes changes; the user or repository policy decides whether to write them.
- `@rollback` must not execute destructive actions without explicit confirmation.
