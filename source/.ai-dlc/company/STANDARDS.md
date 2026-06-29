# Company Standards — EBIT SUITESTENSA

> Engineering standards, security requirements, and development practices.
> Source: LC-SUITESTENSA-EN rev.V + Annex A rev.U + POL000022 + IPR000021

---

## Development Environment

| Requirement | EBIT Rule | AI-DLC Enforcement |
|-------------|-----------|------------------|
| Network isolation | Dev environment on **logically segregated network**, not Internet-exposed | Agent must not suggest public-facing dev environments |
| Test isolation | Test environment on **logically segregated network**, not Internet-exposed | Agent must not suggest public test endpoints |
| Source control | Azure DevOps (TFS) | All code version-controlled; referenced in PROGRESS.md |
| ALM tool | Microsoft Azure DevOps | Work items, sprints, test cases managed here |
| CI/CD | Managed via Azure DevOps pipelines | Changes to pipelines = HIGH risk, halt trigger |

---

## Security Standards (IEC 81001-5-1 + EBIT ISMS)

### Mandatory Security Activities

| Activity | When | Responsible | AI-DLC SEC Mapping |
|----------|------|-------------|------------------|
| Secure coding practices | During implementation | R&D / Scrum Team | SEC-01 through SEC-07 |
| Static Code Analysis (SAST) | During development (regular) | R&D | SEC-02 |
| Vulnerability Assessment (VA) | Periodic + pre-release | Per IPR000021 | SEC-03 |
| Penetration Testing (PT) | Periodic + pre-release | Per IPR000021 | SEC-03 |
| Source Code Review | Regular during development | R&D | SEC-02, SEC-04 |
| Security risk identification | Requirements phase (5.2.3.7) | R&D | SEC-01 |
| Risk control measures | Design + Implementation | R&D | SEC-05 |
| OTS/SOUP security evaluation | Before integration | R&D (or per contract) | SEC-06 |
| Subcontractor code security | Before acceptance | R&D (VA/PT/Code Review) | SEC-06 |

### Security Risk Assessment Method

Per EBIT lifecycle (5.2.3.7):
- **Safety risks**: evaluated per UNI ISO/TR 24971:2020 Annex A
- **Security risks**: evaluated per IEC/TR 80001-2-2:2012 and IEC/TR 80002-1 Annex B
- **Usability hazards**: from USD + Primary Operating Functions

### Secure Development Requirements (IPR000021)

- Periodic VA/PT on released product versions (detect emerging threats)
- Code Review with OTS tools (static analysis) during development
- Findings feed back into Risk Analysis documentation (RMS updates)
- Subcontracted/OTS code: contract clauses for VA/PT/Code Review before production

---

## Risk Management Standards

### Classification (IEC 62304)

| Safety Class | Description | Verification Level |
|--------------|-------------|-------------------|
| Class A | No injury or damage to health possible | Basic |
| Class B | Non-serious injury possible | Moderate |
| Class C | Death or serious injury possible | Comprehensive |

### Safety Class → AI-DLC Workflow Impact

The safety class of a software item **directly changes** what AI-DLC requires from the agent:

| Activity | Class A | Class B | Class C |
|----------|---------|---------|--------|
| **Pseudocode before code** | Optional (>50 lines rule) | Mandatory for complex logic | **Mandatory for ALL logic** |
| **Code review** | Self-review acceptable | Peer review required | **Independent reviewer** (not the author) |
| **Unit test coverage** | Basic happy-path | Branch coverage ≥70% | **Branch coverage ≥90%** + boundary conditions |
| **Integration test** | Functional verification | Functional + fault handling | **Full verification** (all items in §5.2.4.6) |
| **Risk control verification** | If applicable | Mandatory for identified risks | **Mandatory + RAV for every control measure** |
| **Traceability** | RQ → Task | RQ → Task → Test Case | **RQ → SI → Task → Changeset → TC → Test Run** (full chain) |
| **Documentation** | Minimal SI (may be inline in DevOps) | SI Document recommended | **SI Document mandatory** + ADD reference |
| **Regression testing** | Where impacted | Module-level regression | **System-level regression** |
| **AI-DLC risk level for changes** | MEDIUM | HIGH | **HIGH+** (always halt) |
| **Minimum model level** | 3 | 5 | **6** |

### Agent Rules per Safety Class

1. **Determine safety class FIRST**: before implementing any code, the agent must check the software item's safety classification in the ADD/Technical Description.
2. **If class unknown**: treat as **Class C** (most restrictive) until classification is confirmed.
3. **Class C halt**: any modification to Class C items triggers automatic **HALT** — no code generation without explicit confirmation.
4. **Class B+ verification**: for Class B and C, the agent must produce a verification checklist covering: proper event sequence, data flow, fault handling, initialization, memory management, boundary conditions, risk control measures.
5. **Downgrade not allowed**: the agent cannot suggest reclassifying an item to a lower safety class.

### Items Covered by Verification per §5.2.4.6

For Class B/C items, software verification MUST cover:
- [ ] Proper event sequence
- [ ] Data flow correctness
- [ ] Fault handling (graceful degradation)
- [ ] Initialization of variables
- [ ] Memory management (no leaks, no overflows)
- [ ] Boundary conditions
- [ ] Implementation of risk control measures

### Required Risk Documents

| Document | Abbreviation | Purpose |
|----------|-------------|---------|
| Risk Management Plan | RMP-SUITESTENSA | Defines process, schedule, responsibilities |
| Risk Management Summary | RMS-SUITESTENSA | Records risk identification & assessment |
| Risk Analysis Design Review | RADR | Design phase risk review |
| Risk Analysis Verification | RAV | Verification of risk control implementation |
| Risk Management Report | RMR-SUITESTENSA | Final risk assessment for release |

### Risk Management Rules for Agents

- **Risk analysis starts at Phase 1** (requirements), not deferred to implementation
- Risk documents are **iterative** — updated as new elements emerge
- All bugs found during RAV verification → **Critical severity**
- Agent must flag any code touching risk control measures as **HIGH+ risk**
- Risk mitigation measures must be traceable to Test Cases

---

## Usability Engineering (IEC 62366-1)

### Required Artifacts

| Artifact | Owner | Phase |
|----------|-------|-------|
| Usability Specification Document (USD) | PP | Discovery/Analysis |
| Usability Engineering File (UEF) | PP | Ongoing |
| Usability Evaluation Plan | PP | Verification |

### USD Content Requirements

- Intended medical indication
- Intended patient population
- Intended body part / tissue type
- Intended operator profile
- Intended conditions of use
- Operating principle
- Primary Operating Functions (frequent + safety-related)
- Use scenarios (frequent + reasonably foreseeable worst-case)
- Operator-equipment interface requirements

### Agent Rules for Usability

- Any UI/UX changes → reference USD requirements
- New Primary Operating Functions → USD update required (halt trigger)
- Usability validation is performed **independently** by PP (not R&D)

---

## Testing Standards

### Test Levels

| Level | EBIT Reference | Performed By | AI-DLC Mapping |
|-------|----------------|--------------|--------------|
| Unit Test | 5.2.4 | Developer | Implementation phase |
| Integration Test | 5.2.6 | Dedicated test group | Verification phase |
| System Test | 5.2.6.5 | SW System Test Group | Verification phase |
| Validation | 5.2.8 | PP (independent) | Verification phase |

### Test Case Requirements

- Traceability to software requirements
- Clear expected outcomes
- Repeatable procedures
- Specific functional/non-functional targeting
- Execution recorded in Azure DevOps

### Regression Testing

- Mandatory for post-launch releases (5.2.10)
- Covers modules not directly changed
- Verifies no unintended side effects
- Part of Test Plan for existing device changes

### Test Acceptance Criteria

- Test methodology correct
- Procedures trace to System Requirements
- All applicable requirements verified
- Pass/fail criteria met
- No Critical bugs unresolved at release

---

## OTS / SOUP / Subcontractor Standards

### OTS Software Integration

| Step | Activity | Responsible |
|------|----------|-------------|
| 1 | Evaluate performance & limitations | R&D (General), PP (Medical Device) |
| 2 | Verify suitability for device integration | R&D |
| 3 | Security compliance check (VA/PT/Code Review) | Per IPR000021 |
| 4 | Integration testing as part of system | R&D |
| 5 | New version impact analysis | R&D (General), PP (Medical Device) |
| 6 | Track in source control | R&D |

### Subcontractor Requirements

- Must follow EBIT procedures **or** provide equivalent procedures
- Must deliver same documentation set as internal development
- Contract clauses for VA/PT/Code Review (per IPR000021)
- Qualified per QPR000150 (Procurement)
- Changes managed as internal software

---

## Naming & Documentation Conventions

| Convention | Standard |
|------------|----------|
| Project naming | PascalCase (C# convention) |
| Work item IDs | Azure DevOps format |
| Document versioning | Sequential revision letters (A, B, C…) |
| Sprint naming | Sprint [N] — [Start Date] |
| Release versioning | As per Product Release Note |
| Test Suite naming | `CTS-SE-{ProjectCode}-{ModuleCode}-[{SubModule}]-{Description}` |
| Test Plan naming | `TP SUITESTENSA {Version}` |
| Deploy title | `{Type} SE {MajorVersion} B{Build}.{SP}` |
| Build label | `SE_{YYYYMMDD}.{DailyProgressive}` |

---

## Source Control Standards (Annex A)

### Changeset Rules

- Every Changeset **must** be linked to a Task or Bug
- Changeset comment must identify the impact of changes
- No orphan changesets (unlinked to work items)

### Branching Strategy

| Release Type | Branch Strategy |
|--------------|-----------------|
| Main Release | Branch from development |
| Service Pack | Branch from Main Release |
| Patch | Label/changeset tracking |
| Hotfix | Branch from released version (not recommended but allowed) |
| Pre-Hotfix/Fix | Shelveset/changeset tracking |

### Build & Signing

- All builds produced on **build server** (not local machines)
- Setup packages protected with **digital certificate** (code signing)
- Build artifacts verified after Sharepoint upload:
  1. Download on test machine
  2. Verify certificate integrity
  3. Execute installation
  4. Confirm no OS-level warnings
  5. Record verification in Test Plan

### Distribution

- Official packages published to Sharepoint SPV: `https://esaotegroup.sharepoint.com/sites/EbitIT/SPV/Release`
- No physical media (CD/DVD) distribution
- Installation exclusively by EBIT-authorized personnel
- Delivery via reserved Sharepoint access

---

## GDPR & Privacy Requirements (EU 679/2016)

> Referenced in §5.2.4.3, §5.2.5.1, §5.2.11.2, §5.2.11.8

### Applicable Since

GDPR requirements integrated in EBIT SDLC since 25/05/2018 (rev. H).

### Privacy-by-Design Principles for SUITESTENSA

| Principle | Implementation Requirement |
|-----------|---------------------------|
| **Data minimization** | Collect only data necessary for the medical function |
| **Purpose limitation** | Patient data used only for stated clinical purpose |
| **Storage limitation** | Retention policies defined per data category |
| **Integrity & confidentiality** | Encryption at rest and in transit for patient data |
| **Access control** | Role-based access; audit trail for data access |
| **Data portability** | Export capabilities for patient data (where applicable) |
| **Right to erasure** | Anonymization/deletion procedures defined |

### Development Requirements

- [ ] Development environment **must not contain real patient data**
- [ ] Test environment **must not be Internet-exposed** (also for data protection)
- [ ] Pseudonymized/synthetic data for testing
- [ ] Audit logging for all patient data access operations
- [ ] Encryption libraries from evaluated OTS (no custom crypto)
- [ ] Data flow documentation identifying personal data paths

### Agent Rules for GDPR

1. Any code handling patient/personal data → **HIGH risk** (halt trigger)
2. Agent must not suggest storing personal data in logs or debug outputs
3. Database schema changes involving patient data → **HIGH+** (privacy impact assessment needed)
4. New integrations transmitting patient data → flag for Data Protection Officer review
5. Test data generation: agent must use synthetic/pseudonymized data only
6. Never suggest disabling encryption or access control, even temporarily

---

## Document Templates Reference

> EBIT documents follow formats defined in QMS. The following table maps EBIT artifacts
> to suggested AI-DLC template structures for agent-generated documentation drafts.
>
> **`<Project>`** = logical module name (not a single `.csproj`). See company `README.md` §Documentation Unit.

| EBIT Document | Abbreviation | AI-DLC Template Location | Key Sections |
|---------------|-------------|------------------------|--------------|
| Architectural Design Document | ADD | `projects\<Project>\PHASES\02_DESIGN.md` | System overview, component diagram, safety classification, interfaces, data flows |
| Software Input Specification | SI | `projects\<Project>\API\SI-{Module}.md` | Functional spec, non-functional req, error handling, integration points |
| Project Development Plan | PdP | `projects\<Project>\PHASES\02_DESIGN.md` | Objectives, standards, tools, risk plan ref, test plan ref, timeline, team |
| Test Plan | TP | `projects\<Project>\PHASES\04_VERIFICATION.md` | Scope, test levels, regression plan, risk TCs, acceptance criteria, schedule |
| Test Report | TR | `projects\<Project>\PHASES\04_VERIFICATION.md` | Results summary, pass/fail, bug list, regression results, conclusions |
| Product Release Note | PRN | `projects\<Project>\PHASES\05_RELEASE.md` | Released functionalities, known issues, compatibility, version info |
| Usability Specification | USD | `projects\<Project>\PHASES\00_DISCOVERY.md` | Intended use, operator profile, POF, use scenarios, interface requirements |
| Risk Management Summary | RMS | `projects\<Project>\DECISION_RECORDS\RMS.md` | Risks identified, probability, severity, acceptability, countermeasures |
| Validation Report | VR | `projects\<Project>\PHASES\04_VERIFICATION.md` | Validation results, usability eval, performance eval, conclusions |

### Agent Rules for Templates

1. Agent-generated drafts are **not** official EBIT documents — they are working drafts for human review
2. Official documents reside in Azure DevOps and QMS systems
3. AI-DLC documentation complements (not replaces) the official EBIT QMS documentation
4. When drafting, include all required sections from the table above
5. Mark all agent-generated content with `[DRAFT — requires human review]`

---

## AI-DLC Halt Triggers (EBIT-specific)

The following actions are **always HIGH or higher risk** in EBIT context:

| Trigger | Risk | Reason |
|---------|------|--------|
| Modify risk control measures code | HIGH+ | RAV required |
| Change safety-classified software items | HIGH+ | IEC 62304 impact |
| Add/update OTS dependency | HIGH | OTS evaluation required |
| Modify architecture (ADD) | HIGH | RdP/R&D approval required |
| Change Test Plan | HIGH | STM + R&D approval required |
| Modify security-sensitive code | HIGH+ | IPR000021 compliance |
| Change usability (Primary Operating Functions) | HIGH | USD update + PP validation |
| Modify Azure DevOps pipeline | HIGH | CI/CD approval required |
| Release artifacts (build, deploy) | HIGH | Final PR required |
