# AI-DLC Migration Guide

Use this guide when moving from the old Copilot-centered layout to the neutral AI-DLC layout.

## Path Changes

| Old Path | New Path |
|----------|----------|
| `copilot_modules/` | `.adlc/modules/` |
| `.github/copilot_modules/` | `.adlc/modules/` |
| `copilot-instructions.md` | `.github/copilot-instructions.md` |
| `.copilot/instructions.md` | `.adlc/project/instructions.md` preferred |
| `.copilot/skills/` | `.adlc/project/skills/` preferred |

## Recommended Steps

1. Move framework modules into `.adlc/modules/`.
2. Move GitHub Copilot startup rules into `.github/copilot-instructions.md`.
3. Add root startup files for each supported agent.
4. Move reusable project rules to `.adlc/project/instructions.md`.
5. Keep `.copilot/` only for compatibility with existing GitHub Copilot setups.
6. Run `.adlc/tools/validate.ps1` or `.adlc/tools/validate.sh` after migration.

## Compatibility

The framework still supports `.copilot/instructions.md` and `.copilot/skills/`.
When both `.adlc/project/` and `.copilot/` exist, `.adlc/project/` has higher priority.
