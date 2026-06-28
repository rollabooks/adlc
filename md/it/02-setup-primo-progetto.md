# Capitolo 2 — Setup del primo progetto in 15 minuti

Lorenzo ha clonato il repository di TaskFlow API, aperto il terminale e ha davanti a sé una directory con il codice del progetto e nient'altro. Nessun `_CONTEXT.md`, nessun framework AI. Questo è il punto di partenza.

In questo capitolo seguiamo Lorenzo — e tu con lui — mentre aggiunge AI-DLC al progetto, compila il contesto per la prima volta e fa il primo turno con un agente AI. Quindici minuti, non di più.

---

## 2.1 Passo 1 — Copiare il framework nel repository

AI-DLC non ha un installer. Si copia. La struttura che ti serve è questa:

```
progetto/
├── AGENTS.md                        ← OpenAI Codex CLI
├── CLAUDE.md                        ← Claude Code
├── GEMINI.md                        ← Google Gemini
├── OPENCLAW.md                      ← OpenClaw
├── .github/
│   └── copilot-instructions.md      ← GitHub Copilot
└── .ai-dlc/
    ├── @@AI-DLCFILE@@
    ├── COMMANDS.md
    ├── halt-triggers.yaml
    ├── manifest.json
    ├── modules/                     ← regole del framework
    ├── schemas/                     ← schemi JSON
    ├── templates/                   ← template per i tuoi file
    └── tools/                       ← script di utilità
```

Il modo più rapido è clonare la repo ufficiale del framework e copiare i file nella radice del tuo progetto:

> **Nota:** l'URL del repository è indicativo — verifica quello aggiornato nella documentazione ufficiale del framework o nel file `README.md` della distribuzione che hai ricevuto.

```bash
# Clona il framework (una volta sola, in una directory temporanea)
git clone https://github.com/rollaradio/adlc-framework /tmp/adlc

# Copia nella radice del tuo progetto
cp /tmp/adlc/AGENTS.md .
cp /tmp/adlc/CLAUDE.md .
cp /tmp/adlc/GEMINI.md .
cp /tmp/adlc/OPENCLAW.md .
cp -r /tmp/adlc/.github .
cp -r /tmp/adlc/.ai-dlc .
```

In PowerShell:

```powershell
# Clona il framework
git clone https://github.com/rollaradio/adlc-framework $env:TEMP\adlc

# Copia nella radice del tuo progetto
Copy-Item "$env:TEMP\adlc\AGENTS.md" .
Copy-Item "$env:TEMP\adlc\CLAUDE.md" .
Copy-Item "$env:TEMP\adlc\GEMINI.md" .
Copy-Item "$env:TEMP\adlc\OPENCLAW.md" .
Copy-Item "$env:TEMP\adlc\.github" . -Recurse
Copy-Item "$env:TEMP\adlc\.ai-dlc" . -Recurse
```

> **Nota:** i file `AGENTS.md`, `CLAUDE.md`, ecc. sono read-only per l'uso normale — non modificarli. Le tue personalizzazioni vanno in `.ai-dlc/project/` (lo vediamo tra poco).

---

## 2.2 Passo 2 — Scaffold dello stato di progetto

Una volta copiati i file del framework, esegui lo script di inizializzazione. Questo crea i file di stato che l'agente leggerà a ogni sessione.

**Bash (Linux/macOS/WSL):**

```bash
bash .ai-dlc/tools/init.sh
```

**PowerShell (Windows):**

```powershell
.\.ai-dlc\tools\init.ps1
```

Lo script crea quattro cose:

| File/Cartella | A cosa serve |
|---|---|
| `_CONTEXT.md` | Stato corrente del progetto (fase, task, vincoli) |
| `PROGRESS.md` | Diario di bordo delle sessioni |
| `.ai-dlc/project/instructions.md` | Regole specifiche per il tuo progetto |
| `.ai-dlc/project/skills/` | Cartella per skill personalizzate |

Per progetti piccoli o spike, puoi usare il context minimo:

```bash
bash .ai-dlc/tools/init.sh --context minimal
```

Questo crea un `_CONTEXT.md` più snello, senza tutti i campi del template completo.

---

## 2.3 Passo 3 — Compilare `_CONTEXT.md`

Apri `_CONTEXT.md`. Troverai un template con placeholder da riempire. Ecco cosa significa ogni campo, con i valori di Lorenzo per TaskFlow API.

```markdown
| Param                    | Value                                     |
|--------------------------|-------------------------------------------|
| Project                  | TaskFlow API                              |
| Phase                    | 0-Discovery                               |
| Mode                     | STANDARD                                  |
| Active Task              | T-001 Setup progetto e analisi requisiti  |
| Active Task Token Est.   | 8000/2000/10000                           |
| Active Task Model Level  | 3 Sonnet Low                              |

## Stack
| Layer    | Technology            |
|----------|-----------------------|
| Runtime  | Node.js 22            |
| Framework| Fastify 5             |
| Database | PostgreSQL 16 + Prisma|
| Auth     | OIDC + JWT            |
| Deploy   | Docker + Railway      |

## Security Constraints
| ID     | Name           | Spec                              |
|--------|----------------|-----------------------------------|
| SEC-01 | Input Validation | Zod schema su ogni endpoint      |
| SEC-02 | Authentication | OIDC, JWT con refresh rotation    |
| SEC-03 | Logging        | Nessun token o dato PII nei log   |

## Performance Constraints
| ID      | Name           | Target                   |
|---------|----------------|--------------------------|
| PERF-01 | Latency        | P95 < 200ms per endpoint |
| PERF-02 | Payload size   | Max 1MB per risposta     |
```

Alcuni campi che ti potrebbero sembrare oscuri:

**Phase** segue la numerazione AI-DLC: 0 è Discovery (analisi requisiti), 1 è Analysis, 2 è Design, 3 è Implementation, 4 è Verification, 5 è Release, 6 è Ops. Lorenzo è all'inizio, quindi `0-Discovery`.

**Mode** controlla quanta cerimonia applica l'agente. `STANDARD` è il default consigliato per iniziare. Lo puoi abbassare a `LITE` quando il progetto è rodato e i workflow sono stabili.

**Active Task Token Est.** è una stima `input/output/totale` in token. Serve per scegliere il modello AI giusto. Se non sai da dove iniziare, metti `0/0/0` — lo calibrerai dopo la prima sessione.

**Active Task Model Level** va da 1 a 7. Il Capitolo 8 spiega i livelli in dettaglio. Per iniziare: livello 3 per task standard, livello 5 per task di design o sicurezza.

> **Regola pratica:** compila almeno `Project`, `Phase`, `Mode` e `Stack`. I vincoli SEC e PERF sono fondamentali — anche solo due o tre, quelli più rilevanti per il tuo dominio. Il resto puoi aggiungerlo progressivamente.

---

## 2.4 Passo 4 — Verificare con il validator

Prima di aprire l'agente, verifica che il framework sia correttamente installato:

```bash
bash .ai-dlc/tools/validate.sh
```

```powershell
.\.ai-dlc\tools\validate.ps1
```

L'output atteso è simile a questo:

```
AI-DLC validation — v3.3.0

✅ Framework files present
✅ AGENTS.md, CLAUDE.md, GEMINI.md, OPENCLAW.md found
✅ .github/copilot-instructions.md found
✅ halt-triggers.yaml valid
✅ manifest.json valid
⚠  _CONTEXT.md: Active Task Token Est. is placeholder (0/0/0)
⚠  _CONTEXT.md: Active Task Model Level is placeholder

AI-DLC validation passed (2 warnings)
```

I warning sui placeholder sono normali per la prima sessione — scompaiono appena stimi il task corrente. Gli errori `✗` invece indicano problemi da correggere prima di procedere.

Se vuoi rendere i warning dei failure (utile in CI), usa `--strict`:

```bash
bash .ai-dlc/tools/validate.sh --strict
```

---

## 2.5 Passo 5 — Il primo turno con l'agente

Apri il tuo agente AI preferito (Claude Code, GitHub Copilot, Codex…). Non chiedere nulla ancora. Prima, fai confermare il contesto:

> "Carica `_CONTEXT.md` e confermami il contesto: fase, task attivo, stack, vincoli SEC e PERF attivi."

L'agente risponderà con qualcosa del tipo:

> `Context: TaskFlow API | Phase: 0-Discovery | Task: T-001 Setup progetto | Stack: Node.js/Fastify/PostgreSQL | Constraints: SEC-01 (Input Validation), SEC-02 (Auth OIDC), SEC-03 (No PII in logs), PERF-01 (P95 < 200ms). Proceed?`

Questa conferma è il "bootstrap". Quando la vedi, sai che l'agente ha letto il contesto e lavorerà rispettandolo per tutta la sessione. Da questo momento puoi iniziare il dialogo reale.

Lorenzo chiede:

> "Analizza la struttura del repository e dimmi cosa manca per avere un setup Fastify funzionante con le dipendenze che ho indicato in `_CONTEXT.md`."

L'agente esamina il progetto, elenca le dipendenze mancanti, e — cosa importante — cita SEC-02 quando propone la configurazione dell'autenticazione. Il vincolo è attivo. Non dovrà essere ripetuto.

---

## 2.6 Struttura raccomandata per `.ai-dlc/project/`

Dopo lo scaffold, hai una cartella `.ai-dlc/project/` vuota (eccetto per `instructions.md`). Questa è la tua area personale — tutto ciò che scrivi qui sovrascrive le regole del framework per il tuo progetto specifico.

Una struttura utile nel tempo:

```
.ai-dlc/project/
├── instructions.md      ← regole specifiche del tuo progetto
├── domain.md            ← business logic e regole di dominio
├── conventions.md       ← convenzioni di codice specifiche
└── skills/              ← skill personalizzate per il tuo dominio
```

Per ora, aggiungi a `instructions.md` solo quello che non è già in `_CONTEXT.md`:

```markdown
# TaskFlow API — Project Instructions

## Conventions
- All API errors must use the RFC 7807 Problem Details format
- Database queries use Prisma only — no raw SQL except in migrations
- All endpoints must have a corresponding integration test

## Git workflow
- Branch naming: feat/T-NNN-description, fix/T-NNN-description
- PR review required before merge to main
- Squash merge only
```

---

## Riepilogo

Hai fatto cinque passi:

1. Copiato i file del framework nella radice del progetto
2. Eseguito `init.ps1` / `init.sh` per lo scaffold iniziale
3. Compilato `_CONTEXT.md` con fase, stack e vincoli
4. Verificato con `validate.ps1` / `validate.sh`
5. Fatto il primo bootstrap con l'agente e ricevuto conferma del contesto

TaskFlow API è pronta. L'agente sa dove sei, cosa stai costruendo e cosa non può ignorare. Nel prossimo capitolo vediamo come si svolge una sessione completa, dall'inizio al commit finale.
