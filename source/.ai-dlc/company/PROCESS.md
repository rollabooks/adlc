# Company Process — EBIT SUITESTENSA SDLC

> Maps the EBIT Software Development Lifecycle to AI-DLC phases.
> Source: LC-SUITESTENSA-EN rev.V (29/09/2025) + Annex A rev.U
> Azure DevOps operational details: see `DEVOPS.md`

---

## Process Gates

| Gate | EBIT Reference | Applies When | Required Evidence | Approver |
|------|----------------|--------------|-------------------|----------|
| **G0 — Inception** | 5.2.1 | New product/module or major CR set | PNPM, RQ Document, USD, Product Backlog v1.0 | PP + R&D + SPV + INT + DRC |
| **G1 — Requirements Ready** | 5.2.3 | Before Sprint development starts | Product Backlog "Ready" status, SI Documents, ADD approved | RdP + R&D |
| **G2 — Architecture Approved** | 5.2.3.6–5.2.3.10 | System architecture defined | ADD (Architectural Design Document), Safety Classification, RMS-SUITESTENSA initiated | RdP / R&D Manager |
| **G3 — Sprint Done** | 5.2.4 | Work items reach Definition of Done | Unit tests passed, Test Cases specified and executed, code reviewed | Scrum Team + RdP |
| **G4 — Test Plan Approved** | 5.2.5 | Before system-level verification starts | Software System Test Plan, Risk mitigation TCs, Regression plan | R&D / RdP + STM |
| **G5 — Verification Complete** | 5.2.6–5.2.8 | After all V&V activities | Software System Test Report, RAV Checklist, VR-SUITESTENSA | RdP + R&D |
| **G6 — Final Planning Review** | 5.2.9 | Before commercial release | Release Note, RMR-SUITESTENSA, GSPR Checklist, IEC compliance checklist, Final PR minutes | R&D Manager + PP Manager |
| **G7 — Post-Launch Change** | 5.2.10 | Any change after initial release | Full SDLC re-execution, Regression testing, Compatibility verification | Same as G0–G6 |

---

## Phase 0 — Discovery (EBIT: Concept Development)

### EBIT Requirements (5.2.1)

- [ ] **PNPM** (Proposal of New Product/Module) submitted to EBIT management
- [ ] First-level **Product Requirements (RQ)** defined including:
  - Intended Use, Intended User, Intended Use Environment
  - Basic Technical Specifications
  - Product Classification & regulatory approvals needed
  - Project Budget & Timeline
- [ ] **Usability Specification Document (USD)** initiated:
  - Intended medical indication, patient population, body part
  - Operator profile, conditions of use, operating principle
  - Primary Operating Functions (frequent + safety-related)
- [ ] Compatibility & relationship with other products assessed
- [ ] Validation & market test activities planned

### AI-DLC Compliance

- AI-DLC Discovery checklist remains mandatory
- RQ Document maps to AI-DLC "scope definition"
- USD maps to AI-DLC "stakeholder identification + domain analysis"

---

## Phase 1 — Analysis (EBIT: Software Requirements Development)

### EBIT Requirements (5.2.3)

- [ ] Product Requirements reviewed and accepted by RdP + team
- [ ] **User Need requirements** identified from RQ analysis
- [ ] Product Backlog v1.0 approved at **Inception** (initial Planning Review)
- [ ] System architecture identified → **ADD** document
- [ ] Software system divided into items, safety-classified per IEC 62304
- [ ] **SI Documents** (Software Input Specifications) drafted where needed
- [ ] Usability Specification extended with use scenarios and risk-related requirements
- [ ] **Risk Management activities initiated** (RMS-SUITESTENSA):
  - Safety risks (ISO/TR 24971 Annex A)
  - Security risks (IEC/TR 80001-2-2, IEC/TR 80002-1 Annex B)
  - Usability hazards (from USD + Primary Operating Functions)
- [ ] OTS / SOUP / Third-party software identified and classified

### AI-DLC Compliance

- AI-DLC Analysis checklist remains mandatory
- "Functional Requirements" = EBIT Product Requirements + SI Documents
- "Non-Functional Requirements" = Performance, Security, Usability from USD + RMS
- Risk analysis is **mandatory** at this phase (not deferred to implementation)

---

## Phase 2 — Design (EBIT: Project Initiation & Architecture)

### EBIT Requirements (5.2.2, 5.2.3.8–5.2.3.10)

- [ ] **Project Development Plan (PdP)** approved by R&D containing:
  1. Project objectives & sustainability/risk elements
  2. Technological innovation elements & system architecture
  3. Standards & regulatory requirements identification
  4. Development tools & services
  5. Risk Management Plan reference
  6. Test Plan reference
  7. Maintenance plan
  8. Work organization & responsibilities
  9. Progress verification methods
  10. Timeline & milestones
- [ ] Software system architecture finalized → **ADD approved** by RdP/R&D
- [ ] Software items classified by safety level (IEC 62304)
- [ ] **Risk Management Plan** aligned with architecture
- [ ] Sprint cadence and Scrum Team defined at Inception
- [ ] Development tools documented; dev environment on segregated network

### AI-DLC Compliance

- AI-DLC Design checklist + ADR (Architecture Decision Record) required
- ADR maps to EBIT ADD
- AI-DLC "EPICs & Tasks" maps to EBIT Product Backlog + Sprint Backlog planning
- Stack evaluation maps to PdP item #4 (development tools)

---

## Phase 3 — Implementation (EBIT: Unit Implementation & Verification)

### EBIT Requirements (5.2.4)

- [ ] Development assigned per Sprint Backlog according to architecture specs
- [ ] Software developed and verified at **unit level** by developer
- [ ] Programming languages & tools documented
- [ ] **Development environment on segregated network** (not Internet-exposed)
- [ ] Unit tests performed against Specifications when items reach "Definition of Done"
- [ ] Test Cases specified by developer for each completed work item (RQ/CR)
- [ ] **Software Items Verification** covers:
  - Proper event sequence
  - Data flow
  - Fault handling
  - Initialization of variables
  - Memory management
  - Boundary conditions
  - Risk control measures implementation
- [ ] Simulators/emulators used where applicable for unit testing
- [ ] **Sprint Planning (SP)** bi-weekly: select Sprint Backlog
- [ ] **Sprint Review (SR)** bi-weekly: progress review
- [ ] **Daily Scrum**: team status-check

### Agile Cadence

| Ceremony | Frequency | Participants | AI-DLC Mapping |
|----------|-----------|--------------|--------------|
| Sprint Planning (SP) | Bi-weekly | PP + R&D | Sprint task selection |
| Sprint Review (SR) | Bi-weekly | PP + R&D + Scrum Team | Progress checkpoint |
| Daily Scrum | Daily | Scrum Team | Status sync |
| Requirement Analysis | As needed | PP + SPV + INT + R&D | Backlog refinement |
| Delivery Updates | Regular | PP + SPV + INT | External feedback review |

### AI-DLC Compliance

- AI-DLC Implementation checklist remains mandatory
- "Feature branch + PR" workflow maps to EBIT unit implementation + verification
- Pseudocode rule (>50 lines) still applies — aligns with EBIT architecture-first approach
- Security constraints (SEC-XX) must include IEC 81001-5-1 requirements
- PERF constraints must include device performance requirements from SI

---

## Phase 4 — Verification (EBIT: Test Plan, Integration, V&V)

### EBIT Requirements (5.2.5–5.2.8)

- [ ] **Software System Test Plan** created by STM including:
  - Item-level, integration-level, and system-level test cases
  - Regression testing section (for existing devices)
  - Risk mitigation control measures verification (from RMS)
  - Security measures (VA/PT, Source Code Review per IPR000021)
- [ ] Test environment on **segregated network** (not Internet-exposed)
- [ ] Test Plan **issued and approved before tests start** by R&D/RdP
- [ ] **Software Integration Testing** (5.2.6):
  - Integration tests by dedicated group
  - Integrated items verified against SI Documents
  - Flow tests (data & control flows between modules)
  - Module verification sessions
  - Integrated verification sessions (qualification of candidate builds)
- [ ] **RAV Checklist** (Risk Analysis Verification) completed
- [ ] **Software System Test Report** approved by RdP:
  - Test methodology correct
  - Traceability to requirements
  - All requirements verified
  - Pass/fail criteria met
- [ ] **Validation** by PP (independent from design team):
  - Usability validation
  - Performance validation
  - Functionality validation
  - Validation Test Cases on Azure DevOps with steps, acceptance criteria, expected results
- [ ] **Usability Evaluation Plan** maintained by PP

### Problem Resolution (5.2.7)

- [ ] Problems tracked in Azure DevOps (Issue type)
- [ ] Anomalies investigated for reproducibility and root cause
- [ ] Safety/effectiveness relevance evaluated and classified
- [ ] Bugs from Risk Analysis Verification → **Critical severity**
- [ ] HotFix implementation verified by reporter or independent person
- [ ] Impact analysis mandatory for non-installation-specific fixes
- [ ] Regression test performed when needed

### AI-DLC Compliance

- AI-DLC Verification checklist remains mandatory
- "Security testing" includes VA/PT and Code Review per EBIT ISMS
- Bug severity classification: align AI-DLC with EBIT Critical/High/Medium/Low
- RAV Checklist must be referenced in AI-DLC test documentation

### Validation Exclusion Criteria (§5.2.8.4)

A Requirement/CR **may be excluded from PP Validation** if it meets ALL of the following:

| Criterion | Description |
|-----------|-------------|
| Back-end only | Requirement relates to a technical/architectural back-end functionality |
| No UI impact | Requirement has no direct impact on the User Interface |
| No UX impact | CR to existing functionality has no relevant impact on User Experience |
| Integration only | Requirement is related to integration processes (back-end requirements) |

**In general**, validation is not required when the Verification Phase (§5.2.6) already covers:
- Usability of the requirement
- Performance of the requirement
- Functionality of the requirement

**Agent rules for validation exclusion:**

1. The agent **cannot decide** to exclude validation — this is a PP decision.
2. When documenting a requirement, the agent should flag whether the exclusion criteria may apply.
3. If PP has confirmed exclusion (recorded in Azure DevOps `VT` tag), the agent skips validation references.
4. **When in doubt**: assume validation IS required.
5. Exclusion decision must be registered in the Planning Review minutes.
6. Items excluded from validation still require full **Verification** (R&D test cycle).

---

## Phase 5 — Release (EBIT: Software Release)

### EBIT Requirements (5.2.9)

- [ ] **Final Planning Review** meeting confirms:
  - Residual anomalies evaluated → no unacceptable risk
  - All risk reduction measures successfully tested
  - No Critical bugs unresolved
  - Validation Test Cases accepted on Azure DevOps
- [ ] **IEC compliance checklist** (62304 + 81001-5-1 + 82304) verified by R&D
- [ ] **Product Release Note** containing:
  - List of all released functionalities
  - Third-party integration test status (if applicable)
  - Integration Project Release Note (when applicable)
- [ ] **Final Planning Review minutes** approved by R&D Manager + PP Manager
- [ ] Documentation filed:
  - VR-SUITESTENSA (Validation Report)
  - RMR-SUITESTENSA (Risk Management Report)
  - GSPR-SUITESTENSA (General Safety & Performance Requirements checklist)
  - MDCG 2020-3 / NBOG BPG 2014-3 significant change assessment
- [ ] Source code, executable, and archive documentation version-controlled
- [ ] Internal training activities planned

### AI-DLC Compliance

- AI-DLC Release checklist remains mandatory
- Release note maps to AI-DLC "CHANGELOG" + deployment documentation
- Final PR maps to AI-DLC "Go/No-Go decision"
- All EBIT release artifacts must be referenced in `PROGRESS.md`

---

## Phase 6 — Operations (EBIT: Post-Launch & OTS Management)

### EBIT Requirements (5.2.10–5.2.11)

- [ ] **Post-launch changes** follow full SDLC (same as initial release)
- [ ] Regression testing at Software System Test level
- [ ] Compatibility verified with legacy hardware configurations
- [ ] Limitations documented in release notes + Field Service info
- [ ] **OTS Software management**:
  - Performance/limitations evaluated before integration
  - Security compliance verified (VA/PT, Code Review per IPR000021)
  - New OTS versions: impact analysis, integration test, validation
  - OTS tracked in source control
- [ ] **SOUP**: controlled, managed as OTS with thorough analysis
- [ ] **Subcontracted software**:
  - Must follow EBIT procedures or equivalent
  - Security compliance (VA/PT, Code Review)
  - Managed as internal software for changes
  - Supplier qualified per QPR000150

### AI-DLC Compliance

- AI-DLC Operations module applies
- OTS/SOUP management is a **halt trigger** (HIGH risk) when updating dependencies
- Subcontracted software changes require explicit confirmation

---

## Sprint Workflow (Agile Cadence)

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPRINT (2 weeks)                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐   ┌────────────────┐   ┌──────────────────────┐  │
│  │ Sprint   │──▶│ Daily Scrum    │──▶│ Development +        │  │
│  │ Planning │   │ (daily)        │   │ Unit Verification    │  │
│  └──────────┘   └────────────────┘   └──────────┬───────────┘  │
│                                                  │              │
│                                      ┌───────────▼───────────┐  │
│                                      │ Definition of Done    │  │
│                                      │ • Code complete       │  │
│                                      │ • Test Cases written  │  │
│                                      │ • Unit tests passed   │  │
│                                      └───────────┬───────────┘  │
│                                                  │              │
│  ┌──────────┐   ┌────────────────────────────────▼───────────┐  │
│  │ Sprint   │◀──│ Pre-testing by Test Team                   │  │
│  │ Review   │   │ (on "Ready" Test Cases)                    │  │
│  └──────────┘   └────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Required Artifacts per Phase (EBIT Mandatory)

> **`<Project>`** in paths below refers to the **logical module name** (not a single `.csproj`).
> A module groups related projects by functional domain. See `README.md` §Documentation Unit.

| Phase | EBIT Artifact | AI-DLC Location |
|-------|---------------|---------------|
| 0 | PNPM, RQ Document, USD | `projects\<Project>\PHASES\00_DISCOVERY.md` |
| 1 | Product Backlog v1.0, SI Documents, ADD | `projects\<Project>\PHASES\01_ANALYSIS.md` |
| 2 | PdP, Risk Management Plan, Test Plan ref | `projects\<Project>\PHASES\02_DESIGN.md` |
| 3 | Sprint Backlog, Unit Test evidence | `projects\<Project>\PHASES\03_IMPLEMENTATION.md` |
| 4 | TP, TR, RAV, VR-SUITESTENSA | `projects\<Project>\PHASES\04_VERIFICATION.md` |
| 5 | Release Note, RMR, GSPR, Final PR minutes | `projects\<Project>\PHASES\05_RELEASE.md` |
| 6 | Change docs, Regression results, OTS eval | `projects\<Project>\PHASES\06_OPERATIONS.md` |

> All artifacts above are tracked in Azure DevOps. AI-DLC documentation references them by ID/link.
> Work item types, state machines, fields, and traceability: see `DEVOPS.md`.

---

## Significant Change Assessment (MDCG 2020-3 / NBOG BPG 2014-3)

### When Required

At every **Final Planning Review** (§5.2.9), the team must assess whether the changes constitute a
**significant modification** to the device's design or intended use, per MDR (EU) 2017/745.

### Assessment Criteria

A change is considered **significant** if ANY of the following apply:

| Criterion | Examples |
|-----------|----------|
| New intended purpose or indication | Extended patient population, new clinical application |
| New operating principle | Different algorithm approach, new measurement method |
| New or modified safety feature | New risk control measure, changed safety boundary |
| Change in materials/components contacting patient | N/A for pure software (unless embedded in HW) |
| New user interface paradigm | Fundamental UI redesign affecting safe operation |
| Change affecting clinical performance | Accuracy, sensitivity, specificity modified |
| New connection to other devices/systems | New integration endpoint with clinical impact |
| Change to sterilization/biocompatibility | N/A for SUITESTENSA |
| Introduction of new technology | AI/ML algorithms, new imaging modality processing |

### Assessment Process

1. PP identifies changes in scope (Product Backlog items for the release)
2. Assessment documented in Planning Review `COMMENTS` section
3. Assessment referenced in QPR000030-Change Assessment
4. If **significant**: may require new conformity assessment / notified body review
5. If **not significant**: document justification in Planning Review minutes

### Agent Rules

- Agent **cannot** determine significance — always flag for human review
- When generating release documentation, include placeholder for change assessment
- If any RQ/CR introduces a new clinical feature, new integration, or modifies safety logic → flag as "potentially significant" in PROGRESS.md
- Risk level: **HIGH** (minimum model level 5)

---

## Consolidated Pre-Release Checklist

> Use this checklist before Final Planning Review (G6). Detailed traceability rules in `DEVOPS.md`.

### Product Backlog Completeness

- [ ] All RQ/CR in scope are in state **Resolved** or **Closed**
- [ ] No RQ/CR in state **Blocked** or **Active** (must be deferred or resolved)
- [ ] All linked Tasks in state **Closed**
- [ ] All linked documentation Tasks closed (user manuals updated)

### Traceability (see DEVOPS.md for detail)

- [ ] Every RQ/CR has ≥1 Task with linked Changeset(s)
- [ ] Every RQ/CR has ≥1 Test Case with Passed result
- [ ] VT-tagged items have PP Validation Test Cases
- [ ] Deploy item links all released RQ/CR/Issue items
- [ ] No orphan Changesets in the release branch

### Risk Management

- [ ] RMS-SUITESTENSA updated with any new risks identified
- [ ] RAV Checklist completed — all risk control measures verified
- [ ] All bugs from RAV marked Critical and resolved
- [ ] RMR-SUITESTENSA finalized (residual risk acceptable)
- [ ] No unresolved Critical bugs

### Testing

- [ ] Software System Test Plan approved (G4)
- [ ] Software System Test Report approved by RdP
- [ ] Regression tests executed and passed
- [ ] Integration tests passed (flow + data)
- [ ] Validation Test Cases accepted on Azure DevOps (PP)

### Regulatory & Compliance

- [ ] IEC compliance checklist (62304 + 81001-5-1 + 82304) verified
- [ ] GSPR-SUITESTENSA checklist completed
- [ ] MDCG 2020-3 significant change assessment documented
- [ ] Security activities completed (VA/PT if scheduled)

### Release Artifacts

- [ ] Product Release Note drafted
- [ ] VR-SUITESTENSA (Validation Report) finalized
- [ ] Final Planning Review meeting scheduled
- [ ] Build produced on build server (signed with digital certificate)
- [ ] Internal training activities planned (if applicable)

### Agent Rules for Pre-Release

1. Agent generates this checklist automatically when Phase 5 begins
2. Each unchecked item is a **blocker** — agent must flag before release documentation
3. Agent cannot mark items as complete — human verification required
4. Risk level for entire section: **HIGH** (minimum model level 5)
