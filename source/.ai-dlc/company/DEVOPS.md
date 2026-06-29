# Azure DevOps Operations — EBIT SUITESTENSA

> Work items, state machines, release types, traceability, and test management.
> Source: Annex A rev.U (29/11/2024)
> Cross-references: `GOVERNANCE.md` (approvals, CAPA, escalation), `PROCESS.md` (phases, gates)

---

## Work Item Types → AI-DLC Concepts

| Azure DevOps Item | Created By | Assigned To | AI-DLC Equivalent |
|-------------------|------------|-------------|-----------------|
| **Epic** | PP / RdP | PP / RdP | Module / major feature grouping |
| **Feature** | PP / RdP | PP / RdP | Feature within a module |
| **User Story** | PM | PP | Input from field / customer feedback → may become RQ |
| **Requirement** | PP | RdP | Functional Requirement (FR) — new product requirement |
| **Change Request** | PP | RdP | Modification to existing functionality |
| **Issue** | PP / RdP | RdP | Bug/problem reported from field (via SHAPE → auto-created) |
| **Task** | RdP / Dev | Dev | Development/analysis activity (may have sub-tasks) |
| **Bug** | RdP / Dev | Dev | Code defect requiring fix |
| **Test Plan** | RdT | — | Container for all test activities for a release |
| **Test Suite** | RdT | — | Logical grouping of Test Cases (hierarchical) |
| **Test Case** | Dev / PP | — | Single verification/validation scenario with steps |
| **Test Run** | Dev / PP | — | Execution of a Test Case |
| **Test Session** | Tester | — | Session details (state, version, build quality, dates, iteration) |
| **Changeset** | Dev | — | Source code commit — must link to Task or Bug |
| **Deploy** | RdT | Tester | Release package identification (version, type, contents) |
| **Planning Review** | PP | PP / RdP | Container for Planning Review meeting artifacts |
| **Externally-Sourced Software** | PP / RdP | PP / RdP | OTS/SOUP software tracking |
| **Externally-Sourced Software Revision** | PP / RdP | PP / RdP | Specific version of OTS/SOUP |

---

## Work Item Relationships (Hierarchy)

```
Epic
└── Feature
    ├── Requirement ──────── Task ──── Changeset
    │                        └── Task ──── Changeset
    ├── Change Request ───── Task ──── Changeset
    │                        └── Bug ──── Changeset
    └── Issue ────────────── Bug ──── Changeset
                             └── Task ──── Changeset

Test Plan
└── Test Suite
    └── Test Case ──── Test Run
                       └── Bug (on failure)

Deploy ─── references ──→ Requirement / Change Request / Issue
       ─── references ──→ Test Plan

Externally-Sourced Software
└── Externally-Sourced Software Revision ──── Test Case / Test Result
```

---

## State Machines

### Requirement States

```
Proposed → Blocked → Active → Resolved → Closed
              ↕
         (unblocked)

• Proposed: assigned to release, awaiting analysis
• Blocked: needs clarification (reason documented)
• Active: content complete and approved
• Resolved: ALL linked Tasks are Closed
• Closed: verified and released
```

### Task States

```
Proposed → Active → Resolved → Closed
    ↕
 Blocked → (notifies PP automatically)

• Active: development in progress
• Blocked: escalation needed (auto-notifies PP via Requirement)
• Resolved: development + unit test complete
• Closed: verified
```

### Bug States

```
Proposed → Active → Resolved → Closed
              ↓
           Closed (rejected: Duplicate/Postponed/Not an issue)

• Proposed: created by tester after failed test
• Active: confirmed as software issue, fix in progress
• Resolved: fix committed + developer-tested
• Closed: verified in confirmatory test OR rejected
```

### Issue States

```
Proposed → Active → Resolved → Closed
    ↓
 REJECTED (NOT ISSUE):
   • Duplicate
   • Postponed
   • Rejected (not an issue)
   • Required R&D action
   • Missing Documentation
   • Missing Functionality
   • Site customization
   • CustomPage Configuration
   • Overtaken by events
```

---

## Definition of Ready (DoR)

A Requirement/CR reaches **Ready** status when:
- [ ] Description complete (in Azure DevOps or linked document)
- [ ] Impact Assessment filled (including Impact on UX by PP)
- [ ] Risk Management assessment by RdP recorded in Impact Assessment field
- [ ] Target Resolved Date set
- [ ] Priority assigned (1 = highest)
- [ ] Associated to a release (Target Integration Build)
- [ ] State = **Active** (content complete and approved)
- [ ] Approved at Sprint Planning meeting

---

## Definition of Done (DoD)

A work item (RQ/CR) reaches **Done** when:
- [ ] All linked Tasks in state **Closed**
- [ ] All linked documentation Tasks closed (user manuals updated)
- [ ] Changesets linked to respective Tasks
- [ ] Unit tests specified and executed by developer
- [ ] Test Cases specified by developer for the work item
- [ ] Risk Management impact assessment completed
- [ ] Requirement auto-transitions to **Resolved**

---

## Mandatory Fields Reference

### Requirement / Change Request

| Field | Mandatory | Set By | Description |
|-------|-----------|--------|-------------|
| Description | Yes | PP | Detailed requirement description (or link to doc) |
| Impact Assessment | Yes | PP + RdP | Risk impact (including Impact on UX by PP) |
| Target Resolved Date | Yes | PP | Expected implementation date |
| Priority | Yes | PP | 1 = highest priority |
| Target Integration Build | Yes | PP | Associated release version |
| Reason for Blocked | If Blocked | RdP/Dev | Why the item is blocked |
| State | Yes | System | Proposed → Blocked → Active → Resolved → Closed |
| VT (Validation Tag) | If applicable | PP | Whether validation by PP is required |

### Change Request (additional)

| Field | Mandatory | Set By | Description |
|-------|-----------|--------|-------------|
| Justification | Yes | PP | Reason for the change |
| Impact on Architecture | Yes | PP/RdP | Structural impact |
| Impact on User Experience | Yes | PP | UX/UI impact |
| Impact on Technical Publications | Yes | PP | Documentation impact |

### Task

| Field | Mandatory | Set By | Description |
|-------|-----------|--------|-------------|
| Description | Yes | RdP/Dev | Technical specification (or link to SI document) |
| Estimate | Yes | Dev | Effort in person-hours |
| Macro Estimate | Yes | Dev | Accuracy level of estimate |
| Completed Work | Ongoing | Dev | Actual hours spent |
| State | Yes | System | Proposed → Active → Blocked → Resolved → Closed |

### Bug

| Field | Mandatory | Set By | Description |
|-------|-----------|--------|-------------|
| Symptom | Yes | Tester/Reporter | What was observed |
| Steps to Reproduce | Yes | Tester/Reporter | How to reproduce |
| Assigned To | Yes | RdP | Module owner or developer |
| Severity | Yes | RdP | Critical / High / Medium / Low |
| Reason (if Closed) | If rejected | Dev | Duplicate / Postponed / Rejected (not an issue) / etc. |
| Integrated In | On fix | Dev | Version containing the fix |

### Issue

| Field | Mandatory | Set By | Description |
|-------|-----------|--------|-------------|
| Description | Yes | HD/RdP | Problem description |
| Symptoms | Yes | HD/RdP | Observable symptoms |
| Steps to Reproduce | Yes | HD/RdP | Reproduction conditions |
| Target Resolve Date | Yes | RdP | Expected analysis completion |
| Build | Yes | RdP | Affected product version(s) |
| Escalate | If safety-related | RdP | Escalation to RS + RA |
| CAPA Plan Description | If cat. a/b | RdP | CAPA justification (mandatory for a/b) |

### Deploy

| Field | Mandatory | Set By | Description |
|-------|-----------|--------|-------------|
| Title | Yes | RdT | Release name (e.g., "Service Pack SE 1.9 B31.0") |
| Type | Yes | RdT | Release / Service Pack / Patch / Hotfix |
| Build Quality | Yes | RdT | Build quality level |
| Label (SUITESTENSA) | Yes | RdT | Compilation version label |
| Deploy Folder | Yes | RdT | Sharepoint publication path |
| Setup / Cumulative | Yes | RdT | Distribution mode |
| Release Date | Yes | RdT | Actual release date |
| Regression Analysis | If Hotfix | RdT | How regression was verified |
| Changeset | Yes | RdT | Changeset number for reproducibility |

### Agent Field Validation Rules

- When creating documentation referencing work items, verify mandatory fields are noted
- Flag any missing mandatory field as a **blocker** before the item can progress
- Impact Assessment is a **halt trigger** if empty on Active requirements
- CAPA Plan Description on category a/b Issues is **CRITICAL** if missing

---

## User Story Lifecycle (§3.1, §4.4)

### Flow: Field Signal → Product Requirement

```
┌─────────────────────────────────────────────────────────────────┐
│  SOURCES: Field use, Tenders, Evaluations, Internal feedback    │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                    ┌───────▼───────┐
                    │  PM creates    │
                    │  User Story    │
                    └───────┬───────┘
                            │
                    ┌───────▼───────┐
                    │  RPM evaluates │ (completeness, priority, dates)
                    │  & assigns     │
                    └───────┬───────┘
                            │
                    ┌───────▼───────┐
                    │  PP approves   │ (Risk Assessment: Impact on UX)
                    └───────┬───────┘
                            │
                ┌─────────┼─────────┐
                │                     │
        ┌───────▼───────┐  ┌───────▼───────┐
        │  Requirement   │  │ Change Request │
        │  (new feature) │  │ (modification) │
        └───────┬───────┘  └───────┬───────┘
                │                     │
                └─────────┬─────────┘
                          │
                  ┌───────▼───────┐
                  │ Assigned to    │
                  │ RdP            │ → enters standard SDLC
                  └───────────────┘
```

### PP Actions on RQ/CR Creation

1. **Description**: detailed in Azure DevOps or linked document (Impact Assessment field)
2. **Risk Assessment**: Impact on UX recorded in Impact Assessment field
3. **Assignment**: to RdP for analysis and development
4. **Target date**: Target Resolved Date
5. **Priority**: 1 = highest
6. **Sprint Planning**: PP convenes SP to approve and schedule

### Change Request Additional Fields

- **Justification**: reason for the change
- **Impact on Architecture**: structural impact assessment
- **Impact on User Experience**: UX/UI impact
- **Impact on Technical Publications**: documentation impact

---

## Traceability Requirements

### Mandatory Traceability Chain

Every released requirement must have a **complete traceability chain** from definition to verification:

```
User Story (optional)
  └→ Requirement / Change Request
       ├→ SI Document (Software Input Specification) [if needed]
       ├→ Task(s)
       │    └→ Changeset(s) [linked to each Task]
       ├→ Test Case(s) [R&D verification]
       │    └→ Test Run(s) [execution evidence]
       ├→ Test Case(s) [PP validation, if applicable]
       │    └→ Test Run(s) [validation evidence]
       └→ Deploy [release package containing this RQ/CR]
```

### Traceability Rules for Agents

| Rule | Enforcement |
|------|-------------|
| Every RQ/CR must have ≥1 Task | Agent should create Task when implementing a requirement |
| Every Task must have ≥1 Changeset | Agent must remind developer to link commits |
| Every RQ/CR must have ≥1 Test Case (R&D) | Agent must flag untested requirements |
| Every RQ/CR with `VT` tag must have ≥1 Validation TC (PP) | Agent must include in checklist |
| Every Changeset must reference Task or Bug | No orphan commits allowed |
| Deploy must link all contained RQ/CR/Issue | Agent must verify completeness at release |
| RAV must trace to risk control Test Cases | Agent must cross-reference risk measures |

### Traceability Verification at Release

Before release (§5.2.9), the following traceability must be verified:
- [ ] All RQ/CR in Product Backlog have linked Tasks (all Closed)
- [ ] All Tasks have linked Changesets
- [ ] All RQ/CR have linked Test Cases with Passed results
- [ ] All validated RQ/CR (VT tag) have PP Validation Test Cases
- [ ] All risk control measures have RAV Test Cases
- [ ] Deploy item links all released RQ/CR/Issue items
- [ ] No orphan Changesets in the release branch

---

## Release Types (§3.5)

| Type | Contents | Test Plan Scope | Delivery | AI-DLC Mapping |
|------|----------|----------------|----------|--------------|
| **Release** (Main) | RQ + CR + Issue fixes + Translations | Full: RQ/CR/Issue + regression + flow + validation + automated | Complete setup (build server, signed) | Phase 5 — full release cycle |
| **Service Pack** | RQ + CR + Issue fixes + Translations | RQ/CR/Issue + regression + flow + validation + automated | Complete setup (build server) | Phase 5 — full release cycle |
| **Patch** | RQ + CR + Issue fixes | RQ/CR/Issue + regression + flow + validation + automated | Package (may be without setup) | Phase 5 — reduced scope |
| **Hotfix** | Specific Issue fixes | Targeted test plan + RdT+RdP joint verification | File subset (build server) | `07_SPECIAL_LANES.md` — Hotfix lane |
| **Pre-Hotfix** | Ad-hoc fix for specific installation | Targeted verification on reporting site | Site-specific files | `07_SPECIAL_LANES.md` — Hotfix lane |
| **Fix** | Correction for specific version(s) | Test on validated system for that version | Files to FIX folder under version | `07_SPECIAL_LANES.md` — Hotfix lane |

### Deploy Work Item (Release Package)

Every release creates a **Deploy** item in Azure DevOps containing:
- Title (naming convention: e.g., "Service Pack SE 1.9 B31.0")
- Type: Release / Service Pack / Patch / Hotfix
- Build Quality
- Changeset number (enables exact rebuild)
- Deploy Folder (Sharepoint path)
- Distribution mode: Setup / Cumulative / Differential
- Release Date (expected + actual)
- Regression Analysis (mandatory for Hotfix)
- Links to all contained RQ/CR/Issue items
- Reference link to Test Plan

### Version Numbering Scheme

```
SUITESTENSA v{Major}.{Minor}.{ServicePack}.{BuildNumber}

BuildNumber decomposition:
  {Build}{ServicePack}{Hotfix}

Example: SUITESTENSA v1.7.0.29020
  v1.7 = commercial version
  0 = service pack (0=main, 2=SP)
  29020: 29=build, 0=SP, 20=? → internal build ID

Build Label: SE_{YYYYMMDD}.{DailyProgressive}
```

---

## Problem Resolution (Operational Flow)

> Severity classification and CAPA governance: see `GOVERNANCE.md` §Incident Management

### Issue Lifecycle (Field-Reported Problems)

```
┌─────────────┐      ┌───────────────────┐      ┌──────────────┐
│ SHAPE Ticket│─────▶│ Auto-create ISSUE │─────▶│ RdP/Dev      │
│ (Help Desk) │      │ (unassigned)      │      │ Analysis     │
└─────────────┘      └───────────────────┘      └──────┬───────┘
                                                       │
                              ┌─────────────────────────┼──────────────────┐
                              │                         │                  │
                      ┌───────▼────────┐    ┌──────────▼─────┐   ┌───────▼────────┐
                      │ Confirmed NC   │    │ NOT ISSUE      │   │ Safety/Security│
                      │ → Create Bug   │    │ → REJECTED     │   │ → Escalate     │
                      │ → Assign Dev   │    │ (with reason)  │   │   (see GOV)    │
                      └───────┬────────┘    └────────────────┘   └───────┬────────┘
                              │                                          │
                      ┌───────▼────────┐                         ┌───────▼────────┐
                      │ Fix + Test     │                         │ CAPA eval      │
                      │ → Patch/Hotfix │                         │ (see GOV)      │
                      └───────┬────────┘                         └────────────────┘
                              │
                      ┌───────▼────────┐
                      │ Release to     │
                      │ field (SPV)    │
                      └────────────────┘
```

### Hotfix/Patch Process (RdP Responsibility)

1. Impact analysis on collateral effects of proposed fix
2. Open branch from released version (if needed — not recommended)
3. Define module + integration tests + regression tests for Hotfix
4. Identify affected versions (including later releases)
5. Release Note with version applicability + criticality
6. Update Issue state to Closed with version reference (Integrated In field)
7. Create Deploy item with links to all Issues
8. Publish to Sharepoint SPV area
9. Notify SPV + PP with applicability and criticality info

---

## Externally-Sourced Software Process (§5)

### Azure DevOps Tracking

| Item | Purpose | States |
|------|---------|--------|
| Externally-Sourced Software | Master record for a third-party component | — |
| Externally-Sourced Software Revision | Specific version under evaluation | Active → Closed |

### State Meaning

- **Active**: validation in progress — NOT allowed in production
- **Closed**: validation complete, compatible, allowed in production

### Integration Process

1. RS creates Externally-Sourced Software item in Azure DevOps
2. Assigns monitoring responsible for new versions
3. New version → create Externally-Sourced Software Revision
4. Associate Test Cases + Test Results for integration tests
5. If integration requires new development → enters standard SDLC (Chapter 3)
6. Transition to Closed only after successful validation

---

## Planning Review Artifact (§2.3)

### Azure DevOps: Planning Review Work Item

| Field | Content |
|-------|---------|
| Type | Planning Review |
| Created by | PP |
| Assigned to | PP + RdP |
| Attached documents | PR meeting minutes (initial + intermediate + final) |
| COMMENTS section | MDR change assessment outcome (per QPR000030) |
| VT information | Which RQ/CR are subject to validation (recorded in individual items) |

### Planning Review Types

| Type | When | Content |
|------|------|---------|
| **Inception** (Initial PR) | Start of new release cycle | Product vision, scope, Product Backlog v1.0, team structure, timeline |
| **Intermediate PR** (Sprint Review) | Bi-weekly during development | Progress, backlog revision, requirement updates, regulatory review |
| **Final PR** | Before release | V&V results, risk conclusions, GSPR, release authorization |

### Meeting Minutes Must Record

- Attendees (PP, R&D, SPV, INT, DRC as applicable)
- Product Backlog status and any changes
- MDR change assessment result
- Requirements subject to validation (VT tag decisions)
- Regulatory compliance status
- Go/No-Go decision (Final PR only)
- Action items and responsibilities

---

## Test Plan Organization (§3.3)

### Hierarchy in Azure DevOps

```
Test Plan: "TP SUITESTENSA {Version}"
├── Test Suite: by competence group (RAD, CAR, COM, INT, Regression)
│   ├── Test Suite: by module
│   │   ├── Test Suite: by RQ/CR/Issue or new functionality
│   │   │   └── Test Case: individual test with Test Steps
│   │   └── ...
│   └── ...
├── Test Suite: "CV-PP" (Validation by PP)
│   └── Test Case: validation scenarios (usability, performance, functionality)
└── ...
```

### Test Suite Naming Convention

```
CTS-SE-{ProjectCode}-{ModuleCode}-[{SubModuleCode}]-{ExtendedDescription}

Where:
  CTS = Component Test Specification
  SE = SUITESTENSA
  ProjectCode = CAR | RAD | COM | INT
  ModuleCode = module identifier
  SubModuleCode = optional sub-module
  ExtendedDescription = human-readable module description
```

### Test Execution Flow

1. Module owners set work items to **Resolved** → signals ready for testing
2. RdT launches Test Plan in "Run Tests" mode
3. Tester executes step-by-step; marks each step Passed/Failed
4. Test Case = Passed only if ALL steps passed
5. Failed test → Tester creates Bug (Proposed, assigned to module owner)
6. Module owner: Active (confirmed) or Closed (rejected with reason)
7. Developer fixes → Bug to Resolved
8. Confirmatory test → Bug to Closed
9. Module owner identifies regression test candidates
10. RdT reports results to RdP

### Test Plan Completion

At Test Plan closure, the Test Suite records:
- Test plan status, start date, completion date
- Description, list of Test Sessions
- Summary of bugs (total, open, closed, postponed)
- Summary of Test Cases (passed, failed, blocked)
- Attachments: overall TC status, complete bug list, open bugs at release, postponed bugs

### Rules for Agents

- Unit tests are NOT mandatory to register in Azure DevOps (developer responsibility)
- Test Plan must be available at first RC (Release Candidate)
- RdP may approve module test even with failed tests IF:
  - Failed test does not impact functional/performance requirements
  - Failed test is not related to risk mitigation verification
  - Problem tracked as known bug for later resolution

---

## Regression Testing Scoping Rules (§3.3)

### When Regression is Mandatory

| Context | Regression Required | Scope |
|---------|--------------------|---------|
| Main Release | Yes | Modules not changed + flow tests + automated tests |
| Service Pack | Yes | Impacted modules + flow tests + automated tests |
| Patch | Yes | Impacted modules + flow tests + automated tests |
| Hotfix | Yes (targeted) | RdT + RdP joint verification; regression scope in Deploy item |
| Pre-Hotfix/Fix | Targeted only | Verification on reporting/affected site |
| Post-launch release (§5.2.10) | Yes | Software System Test level |

### Regression Scope Definition

1. **Module owner responsibility**: identify test cases and modules for regression
2. **Based on**: impacted areas from code change (Changeset analysis)
3. **Includes**: modules not directly changed but potentially affected by side effects
4. **For Hotfix**: RdP must document regression analysis in Deploy item (`Regression Analysis` field)

### Regression Test Plan Content

- [ ] Modules subject to regression testing identified
- [ ] Automated tests included (where available)
- [ ] Flow tests (data and control flow between modules)
- [ ] Test Cases from previous releases that cover unchanged modules
- [ ] Rationale for scope decisions documented

### Agent Rules for Regression

1. When implementing a change, the agent should identify potentially impacted modules
2. Flag modules with shared dependencies or integration points
3. If change touches a module used by multiple features → recommend broad regression
4. For Hotfix: agent must include regression analysis placeholder in documentation
5. Test Cases passed in previous sessions are NOT re-executed unless:
   - Linked to unresolved issues
   - Linked to bug-related work items
   - Identified as regression risk candidates by module owner
