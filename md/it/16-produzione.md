# Capitolo 16 — Troubleshooting, CI/CD e Manutenzione del Framework

Arrivati in produzione, AI-DLC entra nella sua fase di vita più lunga: non più setup iniziale o sviluppo attivo, ma manutenzione. Il framework deve rimanere utile mentre il team cresce, gli agenti AI evolvono e il progetto accumula storia.

Questo capitolo copre tre argomenti: i problemi comuni e come risolverli, l'integrazione con CI/CD per rendere le verifiche automatiche, e come tenere il framework aggiornato nel tempo senza rompere ciò che funziona.

---

## 16.1 Troubleshooting — problemi comuni

### "L'agente ignora i vincoli SEC"

**Sintomi:** l'agente produce codice che viola un vincolo SEC dichiarato in `_CONTEXT.md`. Per esempio, loga un token JWT nonostante SEC-03 dica di non farlo.

**Cause probabili:**
1. L'agente non ha letto `_CONTEXT.md` all'inizio della sessione — il bootstrap non è avvenuto.
2. `_CONTEXT.md` ha i vincoli nella sezione sbagliata o con un formato non riconosciuto.
3. La sessione è molto lunga e il context è stato parzialmente perso.

**Soluzione:**
```text
@show-constraints
```
Se la lista è vuota o incompleta, l'agente non ha letto correttamente il context. Chiedi esplicitamente:
```text
"Rileggi _CONTEXT.md e confermami i vincoli SEC e PERF attivi."
```
Per sessioni lunghe, usa `@checkpoint` ogni 3-5 azioni per ri-ancorare il contesto.

---

### "L'agente chiede conferma anche per task LOW"

**Sintomi:** in Mode STANDARD, l'agente chiede conferma per una rinomina di variabile o per l'aggiunta di un commento.

**Causa:** stai usando Mode STANDARD su un progetto maturo dove questi task sono routine.

**Soluzione:** abbassa il Mode a LITE in `_CONTEXT.md`:
```markdown
| Mode | LITE |
```
LITE salta la conferma per LOW e riduce la cerimonia per MEDIUM. Torna a STANDARD solo per lavoro in zone nuove o rischiose.

---

### "L'agente ha modificato file che non doveva"

**Sintomi:** l'agente ha toccato un file in `.github/workflows/` o in `prisma/schema.prisma` senza che tu lo avessi chiesto esplicitamente.

**Causa:** il path non è coperto dagli HALT trigger, oppure l'override di progetto ha disattivato il trigger sbagliato.

**Soluzione:** apri `.adlc/halt-triggers.yaml` e verifica quali pattern esistono. Se il path non è coperto, aggiungilo nell'override di progetto:
```yaml
# .adlc/project/halt-triggers.yaml
triggers:
  - id: custom-config
    patterns:
      - "config/production/**"
    reason: Configurazione di produzione
    risk: HIGH+
```

---

### "Il validator fallisce su un task"

**Sintomi:** `validate.ps1` produce un errore come:
```text
✗ T-009.1.md: missing required field 'Model Level'
```

**Causa:** il file di task contiene ancora il placeholder `[1-7]` invece di un valore reale.

**Soluzione:** apri il file del task e sostituisci i placeholder:
```markdown
| Model Level | 3 |
| Risk Floor Applied | MEDIUM → min 3 |
```

---

### "Il validator fallisce su un epic"

**Sintomi:**
```
✗ EPIC-002.md: missing section 'Risk and Model Floor'
```

**Causa:** l'epic è stato creato senza seguire il template.

**Soluzione:** apri `.adlc/modules/templates/EPIC_TEMPLATE.md` e aggiungi le sezioni mancanti all'epic.

---

### "Warning: _CONTEXT.md non popolato"

**Sintomi:**
```
⚠ _CONTEXT.md: Active Task Token Est. is placeholder (0/0/0)
⚠ _CONTEXT.md: Active Task Model Level is placeholder
```

**Causa:** hai creato `_CONTEXT.md` ma non hai ancora stimato il task attivo.

**Soluzione:** stima i token del task corrente e aggiorna i campi. Se sei in CI e vuoi che il warning diventi un failure:
```bash
bash .adlc/tools/validate.sh --strict
```

---

### "L'agente carica troppo contesto"

**Sintomi:** le risposte dell'agente sono lente o verbose; sembra stia processando molte cose non pertinenti.

**Causa:** sei in Mode STANDARD o AUDIT su un task LOW/MEDIUM in un progetto stabile.

**Soluzione:** abbassa il Mode (LITE per lavoro quotidiano, FAST per task genuinamente semplici). Se il problema persiste, verifica che il task attivo in `_CONTEXT.md` rispecchi davvero ciò su cui stai lavorando — un task con scope eccessivo porta l'agente a caricare più contesto del necessario.

---

### "Voglio bypassare un HALT trigger"

**Sintomi:** l'agente blocca ogni modifica a un path che in questo momento devi toccare frequentemente.

**Soluzione corretta:** non cercare di "scavalcare" il trigger. Disattivalo consapevolmente nel file di override per la durata del lavoro intensivo, poi riattivalo:

```yaml
# .adlc/project/halt-triggers.yaml
disable:
  - schema   # disattivato temporaneamente durante la Fase 2 (Design DB)
```

Documenta in `PROGRESS.md` perché hai disattivato il trigger e quando pianifichi di riattivarlo. Non lasciarlo disattivato a tempo indeterminato.

---

### "Il debugging con l'agente non converge"

**Sintomi:** dopo tre tentativi di fix, il bug è ancora lì. L'agente propone soluzioni sempre più elaborate.

**Soluzione:** carica il playbook dedicato:
```
Carica .adlc/modules/11_BUGFIX_PLAYBOOK.md.

Bug: [sintomo] + [repro steps] + [logs]
Ambiente: [dev / staging / prod]
```

Il playbook impone un approccio strutturato: triage (10 minuti), root cause analysis, fix minimale, verifica. Interrompe il ciclo "prova e riprova" sostituendolo con un metodo.

---

## 16.2 Integrazione CI/CD

Il validator AI-DLC può girare in CI come qualsiasi altro script di verifica. L'esempio ufficiale usa GitHub Actions:

```yaml
# .github/workflows/AI-DLC-validate.yml
name: AI-DLC Validate

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  AI-DLC-validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Validate AI-DLC
        run: bash .adlc/tools/validate.sh

      - name: Smoke tests
        run: bash .adlc/tests/test.sh
```

**Cosa controlla il validator in CI:**
- Presenza di tutti i file del framework (AGENTS.md, CLAUDE.md, halt-triggers.yaml, ecc.)
- Validità JSON di `manifest.json` e `projects.json`
- Validità YAML di `halt-triggers.yaml` contro il suo schema
- Presenza di `_CONTEXT.md` e `PROGRESS.md`
- Warning su placeholder non compilati nei task/epic (failure solo con `--strict`)

**Modalità strict per team esigenti:**

```yaml
- name: Validate AI-DLC (strict)
  run: bash .adlc/tools/validate.sh --strict
```

In strict mode, anche i warning diventano failure. Utile per team che vogliono garantire che `_CONTEXT.md` sia sempre aggiornato prima del merge.

**Aggiungere sync-copilot al CI:**

Se il team usa Copilot, aggiungi la verifica dell'allineamento:

```yaml
- name: Sync Copilot check
  run: bash .adlc/tools/sync-copilot.sh
```

---

## 16.3 Manutenzione del framework nel tempo

### Quando aggiornare il framework

AI-DLC segue semantic versioning (`MAJOR.MINOR.PATCH`):

| Tipo di release | Quando aggiornare |
|---|---|
| PATCH (3.3.x → 3.3.1) | Subito: sono fix e chiarimenti, nessun cambio comportamentale |
| MINOR (3.3.x → 3.4.0) | Pianificato: nuovi template, nuovi tool, backward-compatible |
| MAJOR (3.x.x → 4.0.0) | Con attenzione: cambiano i path, i contratti di startup o le regole fondamentali — leggere `MIGRATION.md` prima di procedere |

Per verificare la versione installata:
```bash
cat .adlc/VERSION
```

### Come aggiornare

Un aggiornamento AI-DLC è una copia di file, non un `npm update`. Il flusso raccomandato:

```bash
# 1. Scarica la nuova versione in una directory temporanea
git clone https://github.com/rollaradio/adlc-framework /tmp/adlc-new

# 2. Leggi CHANGELOG.md e MIGRATION.md della nuova versione
cat /tmp/adlc-new/CHANGELOG.md

# 3. Copia i file del framework (NON _CONTEXT.md, PROGRESS.md, .adlc/project/)
cp -r /tmp/adlc-new/.adlc/modules .adlc/
cp -r /tmp/adlc-new/.adlc/schemas .adlc/
cp /tmp/adlc-new/.adlc/halt-triggers.yaml .adlc/
cp /tmp/adlc-new/.adlc/manifest.json .adlc/
cp /tmp/adlc-new/.adlc/VERSION .adlc/

# 4. Aggiorna gli entry point degli agenti
cp /tmp/adlc-new/AGENTS.md .
cp /tmp/adlc-new/CLAUDE.md .
# ... altri entry point

# 5. Valida
bash .adlc/tools/validate.sh
```

**Non toccare mai durante l'aggiornamento:**
- `_CONTEXT.md` — è il tuo stato di progetto
- `PROGRESS.md` — è la tua storia
- `.adlc/project/` — sono le tue personalizzazioni
- `.adlc/company/` — sono i tuoi processi aziendali

Questi file sono tuoi. Il framework è in `.adlc/modules/`, `.adlc/schemas/`, gli entry point degli agenti. Quella è la parte che si aggiorna.

### Personalizzare senza rompere l'aggiornabilità

La regola che garantisce aggiornabilità nel tempo è sempre la stessa: **personalizza in `.adlc/project/`, non in `.adlc/modules/`**.

Se vuoi aggiungere una regola al comportamento dell'agente in Fase 3, non modificare `04_IMPLEMENTATION.md`. Aggiungi la regola in `.adlc/project/instructions.md`. La prossima volta che aggiorni il framework, il tuo file di istruzioni rimane intatto.

Se vuoi aggiungere una skill personalizzata, mettila in `.adlc/project/skills/`, non in `.adlc/modules/skills/`. Stessa logica.

---

## 16.4 L'agente in Fase 6 — Ops

Quando il software è in produzione, l'agente entra in Phase 6 (Ops). Il comportamento cambia in modo significativo:

- **Ogni modifica ha un piano di rollback obbligatorio.** Non si propone un fix senza aver anche proposto come tornare indietro se il fix peggiora le cose.
- **Le dipendenze si aggiornano solo con test di non-regressione.** Nessun `npm update` senza aver verificato che la test suite passi dopo.
- **Il runbook è il primo posto dove guardare.** Prima di inventare soluzioni a un problema, l'agente controlla se esiste già una procedura in `docs/05_RUNBOOK.md`.
- **L'incident response segue il workflow del modulo `06_OPS.md`**: acknowledge → investigate → fix → verify → post-mortem → aggiorna runbook.

Per attivare il comportamento Ops:

```markdown
| Phase | 6-Ops |
```

In `_CONTEXT.md`. Da quel momento, l'agente carica `06_OPS.md` e applica il protocollo di produzione.

---

## 16.5 Quando il framework non serve più

AI-DLC è uno strumento, non un dogma. Ci sono situazioni in cui ha senso ridurlo o rimuoverlo:

- Il progetto è in maintenance mode con cambiamenti rarissimi e nessun agente AI attivo.
- Il team ha adottato un framework agente più stringente che include già gestione del contesto, classificazione del rischio e confidence tag.
- Il progetto si è concluso e il repository è archivio storico.

In questi casi, la "disinstallazione" è semplice: rimuovi i file del framework dal repository. Non c'è un processo di cleanup complesso — sono file Markdown e JSON. `_CONTEXT.md` e `PROGRESS.md` vale la pena tenerli come documentazione storica, ma il resto può andare.

---

## Riepilogo

- I **problemi comuni** hanno cause precise: vincoli ignorati (bootstrap mancato), troppe conferme (Mode sbagliato), file toccati indebitamente (trigger non configurati), validator in failure (placeholder non compilati).
- **CI/CD**: `validate.sh` in GitHub Actions verifica la presenza e validità del framework ad ogni PR. `--strict` fa fallire anche i warning, utile per team esigenti.
- **Aggiornamenti**: copia selettiva di `.adlc/modules/`, `.adlc/schemas/` e file di startup degli agenti — mai `_CONTEXT.md`, `PROGRESS.md`, `.adlc/project/`. Leggi sempre `MIGRATION.md` prima di aggiornamenti MAJOR.
- **Personalizzazione** senza rompere l'aggiornabilità: tutto in `.adlc/project/`, niente in `.adlc/modules/`.
- **Phase 6 (Ops)**: rollback obbligatorio su ogni modifica, aggiornamenti con test di non-regressione, incident response strutturata.

> **Nota:** il bullet "Contribuire al framework" menzionato in alcune versioni precedenti di questo riepilogo è stato rimosso — il processo di contribuzione al framework è documentato nel `README.md` del repository ufficiale e non è parte di questo manuale d'uso.

---

*Fine dei capitoli. Nelle appendici trovi glossario, comandi completi, template pronti all'uso e risorse.*
