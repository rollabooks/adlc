@AGENTS.md

<!-- Claude Code: the line above imports AGENTS.md at session start.
     Common rules for all agents live there.
     Add Claude Code-specific overrides below. -->

## Claude Code specifics

- Use **plan mode** (`Shift+Tab` or `/plan`) before touching any path in `.adlc/halt-triggers.yaml`
  or anything marked HIGH in `_CONTEXT.md`.
- Prefer neutral project rules in `.adlc/project/`; keep `.copilot/` compatibility when present.
- Load `.adlc/company/` if present for enterprise process gates and standards.
- Load framework modules from `.adlc/modules/` only as needed for the active phase.
- Include token estimate and Anthropic model level 1-7 for every created task.
- Path-scoped rules go in `.claude/rules/` — one topic per file, YAML `paths:` frontmatter optional.
- Personal/local overrides → `CLAUDE.local.md` (gitignored).
- Keep this file and `AGENTS.md` under 200 lines each; move detail into `.claude/rules/`.
