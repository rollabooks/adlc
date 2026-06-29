# Traceability Matrix — [Project Name]

> Last updated: YYYY-MM-DD
> Purpose: Map requirements → design → code → tests for completeness and gap analysis

---

## Requirements → Design Traceability

| Req ID | Description | Priority | Design Component | ADR Ref | Status |
|--------|-------------|----------|-----------------|---------|--------|
| FR-01 | [description] | Must | [component/service] | ADR-NNN | ✅ Traced |
| FR-02 | [description] | Should | [component/service] | — | ⬜ Gap |
| NFR-01 | [description] | Must | [arch decision] | ADR-NNN | ✅ Traced |

---

## Design → Implementation Traceability

| Component | Responsibility | Source Files | API Endpoints | DB Entities |
|-----------|---------------|--------------|---------------|-------------|
| [Service A] | [what it does] | `src/...` | `POST /api/...` | `table_x` |
| [Service B] | [what it does] | `src/...` | `GET /api/...` | `table_y` |

---

## Implementation → Test Traceability

| Source File / Component | Unit Tests | Integration Tests | E2E Tests | Coverage |
|------------------------|------------|-------------------|-----------|----------|
| `src/auth/service.ts` | `test/auth/*.spec` | `test/int/auth.*` | `e2e/login.*` | 85% |
| `src/api/orders.ts` | `test/orders/*.spec` | — | `e2e/order-flow.*` | 72% |

---

## Full Trace (end-to-end)

| Req ID | User Story | Design | Code | Tests | Verified |
|--------|-----------|--------|------|-------|----------|
| FR-01 | US-01 | AuthService | `src/auth/` | `test/auth/` | ✅ |
| FR-02 | US-03 | OrderAPI | `src/orders/` | `test/orders/` | ✅ |
| FR-03 | US-05 | — | — | — | ❌ Gap |

---

## Gap Analysis

### Orphaned Requirements (no design/code)
- [ ] [FR-XX]: [description] — **Action**: [assign to sprint / defer / remove]

### Orphaned Code (no requirement)
- [ ] `src/legacy/...` — **Action**: [document / refactor / remove]

### Missing Tests
- [ ] [Component]: [no integration test] — **Action**: [add in sprint N]

---

## Metrics

| Metric | Value | Target |
|--------|-------|--------|
| Requirements with full trace | [N/M] | 100% |
| Components with tests | [N/M] | ≥ 90% |
| Orphaned requirements | [N] | 0 |
| Orphaned code | [N] | Minimize |

---

<!--
Usage:
- Create one per project at Design phase (Phase 2)
- Update at each sprint/phase transition
- Use @prompt R03 to auto-generate from codebase
- Reference in PROGRESS.md artifacts list
- Required at COMPREHENSIVE depth; recommended at STANDARD
-->
