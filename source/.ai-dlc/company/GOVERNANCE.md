# Company Governance — EBIT SUITESTENSA

> Roles, responsibilities, approvals, and decision authority.
> Source: LC-SUITESTENSA-EN rev.V — Section 4 + Annex A rev.U

---

## Roles & Responsibilities

| Role | Abbr. | Responsibilities |
|------|-------|------------------|
| **Planning & Product Manager** | PP | Create product concepts; define first-level RQ & CR; perform Validation; lead Inception meeting; approve final PR minutes with R&D |
| **R&D Manager** | R&D | Review & approve Product Requirements; appoint RdP + team; approve PdP; approve SP/SR minutes with PP; approve System Test Plan |
| **SW Development Project Manager** | RdP | Approve SI Documents; manage SP/SR minutes; lead development team |
| **Software Test Manager** | STM | Deliver & manage Software System Test Plan |
| **Scrum Team** | — | Cross-functional group; execute Sprint Backlog; daily scrum |
| **Integration Department** | INT | Participate in Inception; integration testing |
| **Post-Sales / Technical Assistance** | SPV | Participate in Inception; delivery updates; field feedback |
| **Head of Sales** | DRC | Participate in Inception; market requirements |

---

## Approval Matrix

| Artifact / Decision | Primary Approver | Co-Approver | AI-DLC Risk Level |
|---------------------|------------------|-------------|-----------------|
| PNPM (New Product Proposal) | EBIT Management | PP | HIGH |
| Product Requirements (RQ) | R&D Manager | — | HIGH |
| Product Backlog v1.0 | PP + R&D + SPV + INT + DRC (at Inception) | — | HIGH |
| Project Development Plan (PdP) | R&D Manager | — | HIGH |
| ADD (Architecture Document) | RdP / R&D Manager | — | HIGH |
| SI Documents (Input Specifications) | RdP | — | MEDIUM |
| Software System Test Plan | R&D / RdP | STM | HIGH |
| Software System Test Report | RdP | — | HIGH |
| Integration Test Reports | SW Team Manager → RdP | — | MEDIUM |
| Sprint Planning / Review minutes | R&D + PP | — | LOW |
| Validation Report (VR-SUITESTENSA) | PP | — | HIGH |
| Risk Management Summary (RMS) | R&D | PP (usability risks) | HIGH+ |
| Risk Management Report (RMR) | R&D | PP | HIGH+ |
| RAV Checklist | R&D | — | HIGH |
| GSPR Checklist | R&D | — | HIGH |
| Final Planning Review minutes | R&D Manager + PP Manager | — | HIGH |
| Product Release Note | RdP | R&D | HIGH |
| Release Authorization | R&D Manager + PP Manager | — | HIGH |

---

## Decision Authority & Escalation

| Decision Type | Authority | Escalation |
|---------------|-----------|------------|
| Sprint Backlog content | RdP + PP (at SP) | R&D Manager |
| Product Backlog changes | PP + R&D (at SR) | EBIT Management |
| Architecture changes | RdP / R&D Manager | R&D Manager |
| Risk classification & mitigation | R&D (safety/security), PP (usability) | CQO |
| OTS integration decision | PP (Medical Device OTS), R&D (General) | R&D Manager |
| Subcontractor selection | R&D | Per QPR000150 |
| Regulatory compliance questions | R&D + CQO | Regulatory Director |
| Release Go/No-Go | R&D Manager + PP Manager | EBIT Management |

---

## AI-DLC Agent Rules (Governance)

When an AI-DLC agent operates on EBIT projects:

1. **HALT** before any action that requires an approval from the matrix above.
2. Agents **cannot** approve — they produce artifacts for human review.
3. Risk Management artifacts (RMS, RMR, RAV, RADR) are **always HIGH+ risk** — explicit confirmation required.
4. Final release decisions are **never** automated — always require Final Planning Review.
5. Architecture changes (ADD modifications) are **HIGH risk** — agent must halt.
6. OTS/SOUP/Subcontractor decisions require **explicit human confirmation**.
7. Backlog changes during Sprint (scope change) require SP/SR formalization.

---

## Compliance Requirements

| Standard | Applicability | Key Obligation |
|----------|---------------|----------------|
| IEC 62304:2015 | All software | Safety classification, V&V per class |
| IEC 81001-5-1:2021 | All software | Security lifecycle activities |
| IEC 82304-1:2016 | Health software products | Product safety requirements |
| IEC 62366-1:2015+AMD1:2020 | UI/UX | Usability engineering process |
| ISO 14971:2019+A11:2021 | All medical devices | Risk management |
| MDR (EU) 2017/745 | EU market | GSPR, significant change assessment |
| ISO/IEC 27001:2022 | EBIT ISMS | Secure development (POL000022, IPR000021) |
| QPR000147 | EBIT QMS | Product concept & planning |
| QPR000149 | EBIT QMS | Design & development |
| QPR000150 | EBIT QMS | Procurement (subcontractors) |
| QOI000136 | EBIT QMS | Risk Management Process |

---

## Audit Trail Requirements

- All evidence recorded in **Azure DevOps** (work items, sprints, test cases)
- Product Backlog versions are traceable (v1.0, v1.1, …)
- Sprint containers in Azure DevOps capture workflows and interdependencies
- Test Case execution results stored in Azure DevOps test management
- Risk Analysis documents (RMS, RAV, RADR, RMR) version-controlled
- AI-DLC `PROGRESS.md` must reference Azure DevOps work item IDs where applicable
- Every Changeset linked to Task/Bug for full code traceability
- Deploy items link to all contained RQ/CR/Issue for release traceability

---

## Incident Management & CAPA (Annex A §4)

### Signal Reception Channels

| Channel | Personnel |
|---------|-----------|
| SHAPE ticketing system | Help Desk + Technical Assistance |
| Direct R&D notification | Internal teams, commercial, distributors |
| PM/PP feedback | Planning & Product Management |

### Issue Creation Flow

> Issue state machine and mandatory fields: see `DEVOPS.md` §State Machines / §Mandatory Fields.

1. Help Desk receives signal → registers in SHAPE
2. SHAPE auto-creates **Issue** (unassigned) in Azure DevOps via integration
3. RdP/Dev examine unassigned Issues
4. Confirm as NC (create Bug) OR reject (with documented reason)

### CAPA Evaluation Rules

| Issue Category | CAPA Requirement |
|----------------|------------------|
| a) Potential/Actual Incident | **Mandatory** evaluation; must document if NOT activated |
| b) Blocking Problem | **Mandatory** evaluation; must document if NOT activated |
| c) Non-blocking | Optional (reviewed by RA in Complaint Management meetings) |
| d) Enhancement request | Not applicable |

- CAPA justification recorded in `CAPA Plan Description` field
- RA is responsible for CAPA activation review
- All CAPA decisions are AI-DLC **HIGH+** risk level

### Escalation for Safety

- Safety/security issues (category a): immediate escalation to RS + RA
- Risk impact analysis mandatory before fix
- AI-DLC agents must **HALT** and flag as **CRITICAL** when encountering safety-related Issues
