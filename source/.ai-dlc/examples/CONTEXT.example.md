# PROJECT CONTEXT CARD
> Last Updated: 2026-05-13
> Status: ACTIVE

## 1. CURRENT STATE
| Param | Value |
|-------|-------|
| Phase | 2-Design |
| Mode | LITE |
| Sprint | 0 - Framework adoption |
| Active Task | T-001 Define API contract |
| Active Task Token Estimate | 12000/2500/14500 |
| Active Task Model Level | 3 Sonnet Low |
| Active SKILL | API_DESIGN |
| Current Branch | main |
| Blockers | None |

## 2. TECH STACK
| Layer | Technology |
|-------|------------|
| Backend | Node.js / Fastify |
| Frontend | React |
| Database | PostgreSQL |
| Cache | Redis |
| Infra | Docker |
| CI/CD | GitHub Actions |
| Testing | Vitest / Playwright |

## 3. CRITICAL CONSTRAINTS
### Security
| ID | Constraint | Details |
|----|------------|---------|
| SEC-01 | Input Validation | Validate all API payloads server-side |
| SEC-02 | Authentication | OIDC access tokens |
| SEC-03 | Authorization | RBAC per resource owner |

### Performance
| ID | Constraint | Target |
|----|------------|--------|
| PERF-01 | Latency Targets | P95 < 250ms for read endpoints |
| PERF-03 | Database Efficiency | No N+1 queries |

## 4. BUILD & RUN COMMANDS
| Action | Command |
|--------|---------|
| Build | npm run build |
| Test | npm test |
| Run | npm run dev |

## 5. SCRATCHPAD
Open Questions:
- [ ] Confirm pagination format for list endpoints
