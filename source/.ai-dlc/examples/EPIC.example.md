# EPIC: E-001 Customer Account Management

Status: Active
Owner: Platform Team
Target Sprint/Release: Sprint 3

## Summary

Deliver account profile read/update flows for authenticated customers and support users.

## Scope

In scope:
- Customer profile read endpoint
- Customer profile update endpoint
- Audit event for profile changes

Out of scope:
- Billing profile changes
- Identity provider profile synchronization

## User Stories

- US-001: As a customer, I want to view my profile, so that I can verify my account data.
- US-002: As a customer, I want to update allowed profile fields, so that my contact data stays current.

## Acceptance Criteria

- [ ] Authenticated customers can read only their own profile
- [ ] Updates validate allowed fields server-side
- [ ] Profile changes emit an audit event

## Risk and Model Floor

| Risk | Examples in this epic | Required Action | Minimum Model Level | Approval |
|------|-----------------------|-----------------|---------------------|----------|
| HIGH+ | Authorization and production PII | HALT -> detailed plan + explicit confirmation | 6 | Explicit confirmation |

## Security and Performance

Security:
- SEC-03: Enforce resource ownership on every profile request
- SEC-05: Do not log PII values

Performance:
- PERF-01: P95 < 250ms for profile reads

## Dependencies

- Identity provider tenant configuration

## Task Breakdown

| ID | Task | Type | Estimate | Token Est. | Model Level | Risk Floor | Dependencies |
|----|------|------|----------|------------|-------------|------------|--------------|
| T-001.1 | Define profile API contract | design | 3 SP | 9000/2000/11000 | 6 | HIGH+=6 | none |
| T-001.2 | Implement profile read endpoint | dev | 5 SP | 18000/4500/22500 | 6 | HIGH+=6 | T-001.1 |

## Definition of Done

- [ ] All linked tasks done
- [ ] Tests pass
- [ ] SEC/PERF checks verified
- [ ] Documentation updated
