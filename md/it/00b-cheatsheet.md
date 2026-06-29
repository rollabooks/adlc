# AI-DLC in una schermata

Tutto il framework su una pagina. I dettagli sono nei capitoli indicati.

**I quattro problemi → i quattro meccanismi** *(Cap. 1)*

| Problema | Meccanismo AI-DLC |
|---|---|
| L'AI dimentica | `_CONTEXT.md` + `PROGRESS.md` |
| Ignora i vincoli | `SEC-XX` / `PERF-XX` |
| Inventa | Confidence tag `FACT`/`INFERRED`/`ASSUMPTION` |
| Fa troppo | HALT trigger + classificazione del rischio |

**File del progetto**

| File | Ruolo |
|---|---|
| `_CONTEXT.md` | Stato corrente + vincoli (sempre letto) |
| `PROGRESS.md` | Diario di sessioni e decisioni |
| `.ai-dlc/` | Framework: moduli, template, tool |
| `AGENTS.md`, `CLAUDE.md`… | Entry point degli agenti |

**Fasi** (campo `Phase`, Cap. 6): 0 Discovery · 1 Analysis · 2 Design · 3 Implementation · 4 Verification · 5 Release · 6 Ops

**Modes** (quanta cerimonia, non la sicurezza): LITE · STANDARD · AUDIT · RAPID · FAST

**Rischio → azione** *(Cap. 7)*

| Livello | Azione |
|---|---|
| LOW | Esegui → notifica |
| MEDIUM | Proponi un piano → attendi approvazione |
| HIGH | Piano dettagliato + conferma esplicita |
| HIGH+ | HALT → piano + conferma |
| CRITICAL | HALT → alternative + ADR |

**Confidence tag**: `FACT` (verificato) · `INFERRED` (dedotto) · `ASSUMPTION` (ipotesi → TODO di verifica)

**Comandi chiave** *(Cap. 13)*

| Comando | Cosa fa |
|---|---|
| `@Task [obiettivo]` | Avvia l'unità di implementazione test-driven |
| `@checkpoint` | Fissa lo stato, propone update di context e progress |
| `@security-check` / `@perf-check` | Verifica vs vincoli attivi |
| `@alternatives` | 2-3 opzioni con trade-off |
| `@stop` | Ferma immediatamente |

**Il ciclo del task** (Fase 3, §6.7): `@Task` → approva piano + test → implementa fino al verde → regressione completa → `@checkpoint`

> **Hai 30 minuti?** Vai al Capitolo 2 per lo scaffold, poi al Capitolo 3 per una sessione reale. La checklist di adozione è in fondo al Capitolo 16.
