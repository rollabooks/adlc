# SECURITY CONSTRAINTS LIBRARY (SEC-XX)

> Purpose: Common, reusable security constraints and checklists for AI-assisted development. Reference from `_CONTEXT.md` and enforce in every phase.

---

## SEC-01 Input Validation
- Allow-list inputs, validate types and ranges
- Reject unexpected fields, trim whitespace
- Sanitize user-controlled strings (no HTML/script injection)
- Server-side validation is mandatory (client-side is insufficient)

Checklist:
- [ ] DTOs have explicit schemas
- [ ] Validators cover required/optional fields
- [ ] Edge cases tested (empty, max length, unicode)

## SEC-02 Authentication
- Use a proven identity provider or library
- Tokens: short-lived access tokens + refresh flow
- Never log secrets or tokens

Checklist:
- [ ] All protected endpoints require auth
- [ ] Token validation (issuer, audience, expiry)
- [ ] HTTPS enforced in all environments

## SEC-03 Authorization
- Enforce least privilege (role/permission checks)
- Validate resource ownership/tenancy
- Reject over-broad queries and parameter tampering

Checklist:
- [ ] Role/permission matrix documented
- [ ] Sensitive actions gated by explicit checks
- [ ] Multi-tenant boundaries enforced

## SEC-04 Secrets & Config
- No hardcoded secrets; use env vars/secret store
- Rotate keys regularly; restrict access by environment
- Do not commit `.env` or secrets to VCS

Checklist:
- [ ] Secret scanning configured (CI)
- [ ] Config separation per environment
- [ ] Secret usage audited in code

## SEC-05 Data Protection
- PII: minimize, mask in logs, apply retention policies
- At-rest encryption where supported (DB, files)
- In-transit encryption (TLS)

Checklist:
- [ ] PII inventory in `_CONTEXT.md`
- [ ] Logging redaction in place
- [ ] Backups encrypted + tested

## SEC-06 Dependency Hygiene
- Pin versions, track SBOM
- Use vulnerability scanning (SAST/DAST/Dependabot)
- Avoid abandoned libraries

Checklist:
- [ ] Vulnerability scan clean (or mitigated)
- [ ] Up-to-date dependencies
- [ ] No unmaintained/unknown packages

## SEC-07 Threat Modeling (Phase 0-2)
- Identify assets, actors, trust boundaries
- List threats (STRIDE), mitigations, residual risk

Checklist:
- [ ] Threat model published in docs
- [ ] Mitigations mapped to code changes
- [ ] Residual risks documented

---

## Validation & Evidence
- Include evidence of enforcement in PRs: links to validators, auth checks, config diffs
- For high-risk changes, attach test names, log excerpts, or traces

## References
- OWASP ASVS / Top 10
- NIST SP 800-53 (as applicable)
