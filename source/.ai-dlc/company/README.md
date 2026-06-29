# Company Process Extension — EBIT SUITESTENSA

> Canonical path: `.ai-dlc/company/README.md`
> Source: `LC-SUITESTENSA-EN rev.V (29/09/2025)` + `Annex A rev.U (29/11/2024)`

---

## Scope

This extension applies to all projects within the **SUITESTENSA** platform developed by **EBIT s.r.l.**,
ensuring AI-DLC-driven development remains compliant with:

- **IEC 62304:2015** — Medical Device Software – Software life-cycle process
- **IEC 81001-5-1:2021** — Health software security in the product life cycle
- **IEC 82304-1:2016** — Health software – General requirements for product safety
- **IEC 62366-1:2015+AMD1:2020** — Usability engineering for medical devices
- **ISO 14971:2019+A11:2021** — Risk Management for Medical Devices
- **MDR (EU) 2017/745** — Medical Devices Regulation
- **EBIT QMS** — QPR000149 (Design & Development), QPR000147 (Product Concept & Planning)
- **EBIT ISMS** — POL000022, IPR000021 (Secure Software Development)

---

## Required AI-DLC Mode

EBIT SUITESTENSA is a regulated medical device project. The following AI-DLC modes are **prohibited**:

| Mode | Allowed? | Reason |
|------|----------|--------|
| STANDARD | **Yes** | Default for all EBIT work |
| AUDIT | **Yes** | For compliance reviews |
| LITE | **No** | Skips mandatory verification steps |
| RAPID | **No** | Skips risk assessment |
| FAST | **No** | Skips documentation requirements |

---

## Load Order

### Full Load (default)

Agents should load:

1. `.ai-dlc/company/README.md` (this file)
2. `.ai-dlc/company/PROCESS.md` (SDLC phases, gates, significant change)
3. `.ai-dlc/company/GOVERNANCE.md` (roles, approvals, compliance, incident mgmt, CAPA)
4. `.ai-dlc/company/STANDARDS.md` (engineering, security, testing, source control, GDPR, templates)
5. `.ai-dlc/company/DEVOPS.md` (Azure DevOps work items, states, fields, traceability, releases, test plan)
6. `.ai-dlc/company/halt-triggers.yaml` (EBIT-specific halt triggers for agents)

### Selective Load (by task type)

For **model levels 1-3** or focused tasks, load only what's needed:

| Task Type | Load |
|-----------|------|
| Code implementation (Sprint task) | README + STANDARDS + halt-triggers |
| Bug fix / Issue resolution | README + DEVOPS (Problem Resolution, State Machines) + halt-triggers |
| Release preparation | README + PROCESS + DEVOPS (Release Types, Traceability, Pre-release) |
| Architecture / Design | README + PROCESS (Phase 2) + STANDARDS (Risk, Security) + GOVERNANCE |
| Test planning | README + DEVOPS (Test Plan Org, Regression) + STANDARDS (Testing) |
| Incident / CAPA | README + GOVERNANCE (Incident Mgmt) + DEVOPS (Issue States) |
| Regulatory review | Full load |

> When in doubt, load everything. Selective loading is an optimization, not an obligation.

---

## Documentation Unit: Module (not .csproj)

In solutions with many projects, AI-DLC documentation is organized by **logical module**,
not by individual `.csproj`. A module groups related `.csproj` files by functional domain.

| Term | Meaning |
|------|--------|
| `<Project>` in paths | Logical module name (e.g., `Cardiology`, `Integration`, `Platform`) |
| Module | 1-N `.csproj` that belong to the same functional domain |
| MODULES.md | Inventory mapping all `.csproj` to their module, in `docs\_solution\` |

### Grouping Criteria

- Common namespace root (first segment after company prefix)
- Mutual `ProjectReference` dependencies
- Shared physical folder or bounded context
- Same safety class and release cycle

### Activation Strategy

| Level | When | Creates |
|-------|------|--------|
| L0 — Inventory | Once, immediately | `docs\_solution\MODULES.md` only |
| L1 — Scaffold | Module enters Sprint | `_CONTEXT.md` + `PROGRESS.md` + `instructions.md` |
| L2 — Discovery | First substantial change | `PHASES\00_DISCOVERY.md` |
| L3 — Full lifecycle | New dev or significant CR | All PHASES + EPICS + DECISION_RECORDS |

> See `projects\shared\FIRST_PROMPT_GUIDE.md` for detailed prompts.

---

## Project-Level Overrides

Projects may customize behavior via `.ai-dlc/project/instructions.md`:

### Overridable (per project)

- Sprint cadence (default: 2 weeks)
- Test Suite naming conventions (must remain CTS-SE-* compliant)
- Additional halt triggers (more restrictive only)
- Documentation template customization (adding sections)
- AI-DLC phase file structure within `projects\<Project>\`

### NOT overridable (company-mandated)

- Process gates G0–G7 (cannot be skipped or reordered)
- Safety classification requirements
- Traceability chain (RQ→Task→Changeset→TC→Deploy)
- Approval matrix (who approves what)
- Risk management process
- GDPR/privacy requirements
- Build & signing process (build server mandatory)
- Significant Change Assessment requirement
- AI-DLC mode restriction (STANDARD/AUDIT only)

---

## Source Documents

```text
.ai-dlc/company/source/
├── LC-SUITESTENSA-EN-Software LifeCycle rev.V.pdf
├── Annex A - LC-SUITESTENSA-EN revU.pdf
├── lifecycle_extracted.txt       (preprocessed text from main doc)
└── annex_a_extracted.txt         (preprocessed text from Annex A)
```

Preprocessed text files are agent-readable. Agents should prefer these over raw PDFs.

---

## AI-DLC ↔ EBIT Phase Mapping (Summary)

| AI-DLC Phase | EBIT SDLC Phase | Key EBIT Artifact |
|------------|-----------------|-------------------|
| 0 Discovery | 5.2.1 Concept Development & Product Requirement Definition | PNPM, RQ Document, USD |
| 1 Analysis | 5.2.3 Software Requirements Development | Product Backlog v1.0, SI Documents, ADD |
| 2 Design | 5.2.2 Project Initiation + 5.2.3 Architecture | PdP, ADD, Risk Management Plan |
| 3 Implementation | 5.2.4 Software Unit Implementation & Verification | Unit Tests, Sprint Backlog, Definition of Done |
| 4 Verification | 5.2.5–5.2.8 Test Plan, Integration, V&V | TP, TR, RAV, VR-SUITESTENSA |
| 5 Release | 5.2.9 Software Release | Release Note, Final PR, RMR, GSPR Checklist |
| 6 Operations | 5.2.10 Post-Launch + 5.2.11 OTS Management | Change Management, Regression Testing |

---

## Precedence

If this extension conflicts with AI-DLC framework defaults:
- **Company rules take precedence** for regulatory/compliance matters (risk, security, validation).
- **AI-DLC framework takes precedence** for tooling, file layout, and agent behavior.
- **Conflicts must be flagged** — agent halts and asks for human decision.
