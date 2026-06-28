# T-001.1 — Define Profile API Contract

Epic: E-001 | SP: 3 | Status: TODO | Risk: HIGH+
Dependencies: none

## AI Sizing

| Metric | Estimate |
|--------|----------|
| Input Tokens | 9000 |
| Output Tokens | 2000 |
| Total Tokens | 11000 |
| Model Level | 6 |
| Recommended Model | Opus High |
| Risk Floor Applied | HIGH+=6 |
| Rationale | Contract touches authorization and PII, so risk floor overrides the raw token estimate. |

## Objective

Define the customer profile API contract, including request/response schemas, auth requirements, and error cases.

## Acceptance Criteria

- [ ] Contract lists all endpoints, methods, and status codes
- [ ] Request and response schemas identify PII fields
- [ ] Authorization rules are explicit per endpoint
- [ ] Error responses do not expose internal details

## Files Involved

- `api-specs/profile.yaml`
- `docs/design/API_CONTRACT.md`

## SEC/PERF Applicable

- SEC-03: Authorization
- SEC-05: Data Protection
- PERF-01: Latency Targets
