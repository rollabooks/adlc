# Company Process Extension

> Preferred path: `.adlc/company/README.md`
> Purpose: organization-level SDLC, governance, compliance, and engineering process rules.

## Scope

This extension applies to:
- [project/team/product scope]

## Load Order

Agents should load:
1. `.adlc/company/README.md`
2. `.adlc/company/processed/INDEX.md` if present
3. `.adlc/company/PROCESS.md`
4. `.adlc/company/GOVERNANCE.md`
5. `.adlc/company/STANDARDS.md`
6. relevant files under `.adlc/company/processed/`
7. relevant files under `.adlc/company/docs/`

## Source Documents

Put original company documents here:

```text
.adlc/company/source/
├── process.docx
├── governance.pdf
└── standards.docx
```

Run preprocessing before asking agents to apply company rules:

```powershell
.\.adlc\tools\preprocess-company-docs.ps1
```

```bash
bash .adlc/tools/preprocess-company-docs.sh
```

Agents should prefer `.adlc/company/processed/` over raw PDF/DOCX files.

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
