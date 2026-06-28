# Appendice B — Comandi Conversazionali Completi

Riferimento completo di tutti i comandi conversazionali AI-DLC. I comandi usano il prefisso `@` e vengono scritti direttamente nella chat con l'agente. Non sono comandi shell.

---

## Tabella di riferimento rapido

| Comando | Scopo | Risk bypass? | Modifica file? |
|---|---|---|---|
| `@checkpoint` | Fissa stato avanzamento | No | Propone (no auto) |
| `@context-update` | Aggiorna il context | No | Propone (no auto) |
| `@show-constraints` | Mostra vincoli SEC/PERF attivi | No | No |
| `@security-check` | Verifica piano/codice vs SEC | No | No |
| `@perf-check` | Verifica piano/codice vs PERF | No | No |
| `@load-phase [N]` | Carica modulo fase N | No | No |
| `@set-phase [N]` | Propone cambio fase | No | Propone (no auto) |
| `@prompt-list` | Lista prompt riusabili | No | No |
| `@prompt [ID]` | Applica template prompt | No | No |
| `@alternatives` | Genera 2-3 opzioni | No | Opzionale (ADR) |
| `@simplify` | Riduce scope/complessità | No | Propone (no auto) |
| `@rollback` | Piano di rollback | No | Propone (no auto) |
| `@stop` | Ferma immediatamente | No | No |

---

## Dettaglio comandi

### `@checkpoint`

**Uso:** dopo 3-5 azioni significative, o prima di una pausa.

**Input opzionale:** nessuno, o contesto aggiuntivo:
```text
@checkpoint — ho appena finito il refactor del middleware
```

**Output:**
- Riepilogo lavoro completato nella sessione
- Prossimi passi identificati
- Eventuali blocchi
- Proposta di aggiornamento `_CONTEXT.md` (Active Task, Token Est., Model Level)
- Proposta di voce per `PROGRESS.md`

**Nota:** `_CONTEXT.md` e `PROGRESS.md` non vengono mai modificati automaticamente. L'agente propone il testo da incollare; sei tu ad applicarlo.

---

### `@context-update`

**Uso:** quando un singolo campo del context è cambiato e non vuoi fare un checkpoint completo.

```text
@context-update — ho finito T-007, passo a T-008 GET /tasks/:id
```

**Output:** blocco Markdown pronto da incollare in `_CONTEXT.md` con i campi aggiornati.

---

### `@show-constraints`

**Uso:** in qualsiasi momento per verificare quali vincoli sono attivi.

**Output:** tabella con ID, nome e spec di tutti i vincoli SEC e PERF dichiarati nel `_CONTEXT.md` corrente.

**Quando usarlo:** quando sospetti che il context non sia stato letto correttamente, o prima di iniziare lavoro in zone SEC/PERF-sensibili.

---

### `@security-check`

**Uso:** dopo aver implementato qualcosa, prima del PR, o su richiesta durante la progettazione.

```text
@security-check — controlla l'endpoint POST /tasks
@security-check — rivedi il piano per il sistema di webhook
```

**Output:** analisi per ogni vincolo SEC attivo, con:
- Status: ✅ (rispettato), ⚠ (da verificare), ✗ (violato)
- Confidence tag per ogni claim
- Azioni richieste per i finding

**Nota:** cita solo i vincoli dichiarati in `_CONTEXT.md`. Se un vincolo non è nel context, non viene verificato.

---

### `@perf-check`

**Uso:** analogo a `@security-check` per i vincoli PERF.

```
@perf-check — controlla la query GET /tasks con filtri
```

**Output:** analisi per ogni vincolo PERF attivo con lo stesso formato di `@security-check`.

---

### `@load-phase [N]`

**Uso:** carica il modulo della fase N senza cambiare `_CONTEXT.md`.

```text
@load-phase 4    ← carica 05_VERIFICATION_RELEASE.md
@load-phase 2    ← carica 03_DESIGN.md
```

**Output:** nome del modulo caricato e riepilogo delle regole attive per quella fase.

**Quando usarlo:** quando fai un task di una fase diversa da quella corrente (es. sei in Fase 3 ma fai una review Fase 4) senza voler cambiare il context.

---

### `@set-phase [N]`

**Uso:** quando vuoi fare un cambio di fase ufficiale.

```text
@set-phase 4
```

**Output:** lista delle modifiche necessarie a `_CONTEXT.md` e richiesta di conferma. Non esegue il cambio — propone.

---

### `@prompt-list`

**Uso:** mostra i template di prompt riusabili disponibili nel modulo `08_PROMPT_LIBRARY.md`.

**Output:** lista di ID e descrizioni brevi dei prompt disponibili.

---

### `@prompt [ID]`

**Uso:** applica un template di prompt riusabile.

```text
@prompt SPEC-001
@prompt REVIEW-002
```

**Output:** il template compilato con le informazioni del contesto corrente, oppure domande di chiarimento se mancano informazioni necessarie.

---

### `@alternatives`

**Uso:** quando vuoi opzioni strutturate invece di una decisione unilaterale dell'agente.

```text
@alternatives — per la strategia di caching
@alternatives — per il formato della risposta di errore
```

**Output:** 2-3 opzioni con:
- Pro e contro per ciascuna
- Adatta a quale contesto
- Raccomandazione motivata

**Nota:** per decisioni CRITICAL, l'agente produce anche una bozza di ADR (Architecture Decision Record).

---

### `@simplify`

**Uso:** quando il task sta diventando troppo grande per una sessione.

```text
@simplify — il T-010 sta diventando troppo ampio
@simplify — il piano per l'autenticazione è troppo complesso
```

**Output:**
- Scope ridotto proposto (cosa rimane nel task corrente)
- Scope rimandato (task successivi)
- Motivazione dello split

---

### `@rollback`

**Uso:** prima di un'operazione rischiosa, per avere un piano di revert pronto.

```text
@rollback — cosa faccio se la migration fallisce in staging?
@rollback — piano di revert per il deploy di oggi
```

**Output:**
- Path di rollback step-by-step
- Rischio dell'operazione di rollback stessa
- Come verificare che il rollback sia riuscito

**Importante:** `@rollback` non esegue mai azioni distruttive senza conferma esplicita.

---

### `@stop`

**Uso:** per fermare immediatamente qualsiasi lavoro in corso.

**Output:**
- Stato di ciò che era in corso
- Nessuna modifica irreversibile eseguita (o elenco di quelle già eseguite)
- Prossimo passo sicuro

**Nota:** non annulla le modifiche già apportate ai file. Per il revert usa git.

---

## Comandi personalizzati di progetto

Puoi definire shortcut personalizzati in `.ai-dlc/project/instructions.md`. Quando li scrivi nella chat, l'agente li interpreta come descritto.

Formato:

```markdown
## Project Commands

@nome-comando
  [descrizione di cosa deve fare l'agente quando riceve questo comando]
```

Esempio:

```markdown
@deploy-check
  Esegui in sequenza:
  1. @security-check sull'endpoint modificato nell'ultimo commit
  2. Verifica che tutti i test passino (npm test)
  3. Controlla che la migration sia backward-compatible
  4. Proponi la voce di CHANGELOG.md

@domain-check
  Carica SKILL_TASKFLOW_DOMAIN.md e verifica che le modifiche
  rispettino le business invariant del dominio (transizioni di
  stato, ownership, soft delete).
```

---

## Regole che tutti i comandi rispettano

1. **Nessun comando bypassa gli HALT trigger.** Neanche `@stop` li disattiva — li rende semplicemente irrilevanti perché il lavoro si ferma.

2. **Nessun comando modifica file automaticamente.** `@context-update`, `@checkpoint`, `@alternatives` propongono testo da applicare. Sei sempre tu ad applicarlo.

3. **`@security-check` e `@perf-check` citano solo i vincoli in `_CONTEXT.md`.** Non inventano vincoli aggiuntivi.

4. **`@rollback` non esegue azioni distruttive senza conferma esplicita.** Propone il piano, attende la tua conferma, poi esegue.

5. **I comandi non cambiano la classificazione del rischio.** Se un task è HIGH, rimane HIGH anche se stai usando `@simplify`.
