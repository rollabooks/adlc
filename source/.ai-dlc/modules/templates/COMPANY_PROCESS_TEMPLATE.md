# Company Process Extension

> Preferred path: `.ai-dlc/company/README.md`
> Purpose: organization-level SDLC, governance, compliance, and engineering process rules.

## Scope

This extension applies to:
- [project/team/product scope]

## Load Order

Agents should load:
1. `.ai-dlc/company/README.md`
2. `.ai-dlc/company/processed/INDEX.md` if present
3. `.ai-dlc/company/PROCESS.md`
4. `.ai-dlc/company/GOVERNANCE.md`
5. `.ai-dlc/company/STANDARDS.md`
6. relevant files under `.ai-dlc/company/processed/`
7. relevant files under `.ai-dlc/company/docs/`

## Source Documents

Put original company documents here:

```text
.ai-dlc/company/source/
├── process.docx
├── governance.pdf
└── standards.docx
```

Run preprocessing before asking agents to apply company rules:

```powershell
.\.ai-dlc\tools\preprocess-company-docs.ps1
```

```bash
bash .ai-dlc/tools/preprocess-company-docs.sh
```

Agents should prefer `.ai-dlc/company/processed/` over raw PDF/DOCX files.

## Process Gates

| Gate | Applies When | Required Evidence | Approver |
|------|--------------|-------------------|----------|
| [Gate name] | [condition] | [artifact/check] | [role/team] |

## Required Artifacts

- [ADR / threat model / test report / release note / runbook]

## Compliance Requirements

- [GDPR / ISO / SOC2 / internal policy / N/A]

## Engineering Standards

- [standard or link to docs]

## Precedence

If this extension conflicts with project rules, [define precedence or require explicit human decision].
