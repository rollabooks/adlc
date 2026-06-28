# PERFORMANCE CONSTRAINTS LIBRARY (PERF-XX)

> Reusable performance constraints. Use during design, implementation, and verification.

---

## PERF-01 Latency Targets
- Define SLOs per API (P50/P95/P99)
- Budget time per layer (network, app, DB)

Checklist:
- [ ] SLOs documented in `_CONTEXT.md`
- [ ] Baseline measurements available
- [ ] Alerts for sustained P95 breaches

## PERF-02 Throughput & Concurrency
- Define expected RPS and peak load
- Use async I/O; avoid blocking hot paths

Checklist:
- [ ] Load test plans exist
- [ ] Connection pooling configured
- [ ] Back-pressure or rate limiting in place

## PERF-03 Database Efficiency
- Index critical queries; avoid N+1
- Measure query plans; bound result sizes

Checklist:
- [ ] Slow query log reviewed
- [ ] ORM uses optimized projections
- [ ] Caching strategy documented

## PERF-04 Resource Utilization
- Monitor CPU, memory, I/O; set limits
- Avoid excessive allocations in loops

Checklist:
- [ ] Profiling traces captured
- [ ] GC pressure analyzed (if applicable)
- [ ] Container/resource limits set

## PERF-05 Caching & CDN
- Select appropriate cache layer
- Apply TTLs; invalidate correctly

Checklist:
- [ ] Hot paths cached
- [ ] ETags/Cache-Control headers set
- [ ] CDN for static content

## PERF-06 Startup & Warm-up
- Lazy-load non-critical components
- Pre-warm caches/connections

Checklist:
- [ ] Startup time measured
- [ ] Health checks gate readiness
- [ ] Warm-up scripts if needed

## PERF-07 Build & Bundle Size (Frontend)
- Code-splitting, tree-shaking, image optimization
- Avoid large polyfills

Checklist:
- [ ] Bundle size budget enforced
- [ ] Performance audits run
- [ ] Critical path optimized

---

## Measurement & Evidence
- Include benchmark numbers in PRs (before/after)
- Attach profiling data
- Document test settings (hardware, dataset, load profile)

## References
- Google SRE (SLOs, SLIs)
- Performance tuning guides per stack
