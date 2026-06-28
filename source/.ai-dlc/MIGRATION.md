# AI-DLC Migration Guide

Use this guide when moving from the old Copilot-centered layout to the neutral AI-DLC layout.

## Path Changes

| Old Path | New Path |
|----------|----------|
| `copilot_modules/` | `.ai-dlc/modules/` |
| `.github/copilot_modules/` | `.ai-dlc/modules/` |
| `copilot-instructions.md` | `.github/copilot-instructions.md` |
| `.copilot/instructions.md` | `.ai-dlc/project/instructions.md` preferred |
| `.copilot/skills/` | `.ai-dlc/project/skills/` preferred |

## Recommended Steps

1. Move framework modules into `.ai-dlc/modules/`.
2. Move GitHub Copilot startup rules into `.github/copilot-instructions.md`.
3. Add root startup files for each supported agent.
4. Move reusable project rules to `.ai-dlc/project/instructions.md`.
5. Keep `.copilot/` only for compatibility with existing GitHub Copilot setups.
6. Run `.ai-dlc/tools/validate.ps1` or `.ai-dlc/tools/validate.sh` after migration.

## Compatibility

The framework still supports `.copilot/instructions.md` and `.copilot/skills/`.
When both `.ai-dlc/project/` and `.copilot/` exist, `.ai-dlc/project/` has higher priority.
