# SECURITY CONSTRAINTS LIBRARY (SEC-XX)

> Reusable security constraints. Reference from `_CONTEXT.md`, enforce in every phase.

---

## SEC-01 Input Validation
- Allow-list inputs, validate types and ranges
- Reject unexpected fields, trim whitespace
- Sanitize user-controlled strings
- Server-side validation is mandatory

Checklist:
- [ ] DTOs have explicit schemas
- [ ] Validators cover required/optional fields
- [ ] Edge cases tested (empty, max length, unicode)

## SEC-02 Authentication
- Use a proven identity provider or library
- Tokens: short-lived access + refresh flow
- Never log secrets or tokens

Checklist:
- [ ] All protected endpoints require auth
- [ ] Token validation (issuer, audience, expiry)
- [ ] HTTPS enforced

## SEC-03 Authorization
- Enforce least privilege (role/permission checks)
- Validate resource ownership/tenancy
- Reject parameter tampering

Checklist:
- [ ] Role/permission matrix documented
- [ ] Sensitive actions gated by explicit checks
- [ ] Multi-tenant boundaries enforced

## SEC-04 Secrets & Config
- No hardcoded secrets; use env vars / secret store
- Rotate keys regularly
- Do not commit secrets to VCS

Checklist:
- [ ] Secret scanning in CI
- [ ] Config separation per environment
- [ ] Secret usage audited

## SEC-05 Data Protection
- PII: minimize, mask in logs, apply retention policies
- Encryption at rest where supported
- Encryption in transit (TLS)

Checklist:
- [ ] PII inventory in `_CONTEXT.md`
- [ ] Logging redaction in place
- [ ] Backups encrypted + tested

## SEC-06 Dependency Hygiene
- Pin versions, track SBOM
- Vulnerability scanning (SAST/DAST)
- Avoid abandoned libraries

Checklist:
- [ ] Vulnerability scan clean
- [ ] Dependencies up to date
- [ ] No unmaintained packages

## SEC-07 Threat Modeling (Phase 0-2)
- Identify assets, actors, trust boundaries
- List threats (STRIDE), mitigations, residual risk

Checklist:
- [ ] Threat model published
- [ ] Mitigations mapped to code
- [ ] Residual risks documented

## SEC-08 Logging & Monitoring (OWASP A09)
- Log security-relevant events: login, failed auth, privilege changes, data access
- Structured log format (JSON) with correlation IDs
- NEVER log secrets, tokens, passwords, or full PII
- Tamper-resistant log storage (append-only, separate from app)
- Alerting on anomalies: brute-force, privilege escalation, unusual data export
- Retention policy aligned with compliance requirements

Checklist:
- [ ] Auth events logged (success + failure)
- [ ] Log redaction for sensitive fields
- [ ] Alerts on repeated auth failures
- [ ] Log retention policy documented
- [ ] Correlation IDs propagated across services

## SEC-09 Server-Side Request Forgery (OWASP A10)
- Validate and allow-list outbound URLs/hosts
- Block requests to internal/private IP ranges (127.0.0.0/8, 10.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.168.0.0/16)
- Do not follow redirects blindly from user-supplied URLs
- Enforce protocol allow-list (https only where possible)
- Use dedicated HTTP client with timeouts for external calls

Checklist:
- [ ] Outbound URL allow-list enforced
- [ ] Private IP ranges blocked
- [ ] Redirect following restricted
- [ ] Timeout configured on all external HTTP calls
- [ ] User-supplied URLs validated before fetch

---

## Validation & Evidence
- Include enforcement evidence in PRs: validators, auth checks, config diffs
- For high-risk changes: test names, log excerpts, traces

## References
- OWASP ASVS / Top 10 (2021)
- NIST SP 800-53 (as applicable)
- OWASP Logging Cheat Sheet
- OWASP SSRF Prevention Cheat Sheet
