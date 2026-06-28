# AI-DLC Versioning Policy

AI-DLC uses semantic versioning: `MAJOR.MINOR.PATCH`.

## Increment Rules

| Change Type | Increment | Examples |
|-------------|-----------|----------|
| Breaking behavior or path change | MAJOR | Startup contract changes, required file paths changed |
| Backward-compatible feature | MINOR | New template, new validator, new agent startup file |
| Fix or documentation clarification | PATCH | Typo, validator bug fix, clearer wording |

## Required Updates

When changing the version:
1. Update `.ai-dlc/VERSION`
2. Update `.ai-dlc/manifest.json`
3. Add an entry to `CHANGELOG.md`
4. Run both validators:
   - `.\.ai-dlc\tools\validate.ps1`
   - `bash .ai-dlc/tools/validate.sh`
5. Run both smoke test suites:
   - `.\.ai-dlc\tests\test.ps1`
   - `bash .ai-dlc/tests/test.sh`

## Compatibility Notes

Keep `.copilot/` compatibility unless a MAJOR release explicitly removes it.
Document any migration steps in `.ai-dlc/MIGRATION.md`.
