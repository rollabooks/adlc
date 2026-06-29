# Copy Editing — File modificati dopo il 2026-06-27

**Data:** 2026-06-29
**Lingua:** it
**Fase:** 5 — Copy Editing
**Scope:** i 7 capitoli `.md` modificati dopo il copyedit completo del 2026-06-27
(02, 05, 08, 12, 14, 16, 90), più verifica incrociata col sorgente `VISUALSTUDIO.md`.

> Il copyedit completo del libro è in `copyedit-full-it-2026-06-27.md`. Questo rapporto
> copre solo le modifiche introdotte con l'allineamento v4.0.0 (Visual Studio 2026,
> moduli always-on 12-14).

---

## Stato complessivo

⚠️ Correzioni necessarie. Nessun errore grave; inconsistenze terminologiche e di
percorso introdotte dall'aggiornamento v4.0.0. Capitoli 12, 16, 90 puliti.

---

## Correzioni oggettive (proposte per applicazione diretta)

### F2 — Genere di "task" (Cap 8 §8.3)
Il manoscritto tratta "task" come maschile ovunque (`un task`, `il task`, `task semplici`).
- Riga ~102: «garantisce che **le task** MEDIUM vengano **gestite**»
- Proposta: «garantisce che **i task** MEDIUM vengano **gestiti**»

### F3 — "level" → "livello" nella prosa (Cap 8)
Glossario: `Model Level`/`Level` solo come nome di campo o intestazione di tabella;
nella prosa si usa "livello". Le intestazioni delle tabelle (§8.1 "Level", §8.4 "Minimum
Level") restano invariate.
- §8.3 (riga ~100): «il **level** sale a 3» → «il **livello** sale a 3»
- §8.7 Riepilogo (riga ~171): «forza un **minimum level** indipendentemente» → «forza un **livello minimo** indipendentemente»

### F5 — Percorsi `.adlc\` → `.ai-dlc\` (Cap 14 §14.8)
Tutto il libro usa `.ai-dlc/` (rebrand commit c313663). La sezione 14.8 sui Visual Studio
è rimasta con la vecchia forma `.adlc\`.
- Riga ~177: `.adlc\company\` → `.ai-dlc\company\`
- Riga ~178: `.adlc\modules\` → `.ai-dlc\modules\`

> **Nota cross-file:** il sorgente `source/.ai-dlc/VISUALSTUDIO.md` usa ancora `.adlc\`
> in più punti — va riallineato a `.ai-dlc\` separatamente (non è un file del libro).
> Le stesse correzioni vanno riportate su `chapters/it/ch14-multi-agente.tex`.

---

## Correzioni da confermare (richiedono decisione dell'autore)

### F1 — `VISUALSTUDIO.md` assente nel setup (Cap 2)
Incoerenza interna al capitolo: l'output di `validate` (§2.4) elenca
«AGENTS.md, CLAUDE.md, GEMINI.md, OPENCLAW.md, **VISUALSTUDIO.md** found», ma:
- l'albero di installazione §2.1 non lo elenca;
- i comandi `cp` / `Copy-Item` (§2.1) non lo copiano.
Cap 14 e il glossario (Cap 90) trattano `VISUALSTUDIO.md` come entry point di prima classe.
**Proposta:** aggiungere `VISUALSTUDIO.md` all'albero §2.1 e a entrambi i blocchi di copia.

### F4 — "latency" / "latenza" non uniforme (Cap 8)
Il termine oscilla nello stesso capitolo:
- §intro: «Il secondo è **il latency**» (maschile, inglese) e poco dopo «la differenza di **latenza**» (italiano)
- §8.7: «aumenta **la latency**» (femminile, inglese)
- Riepilogo: «bilanciando costo, **latency** e capacità»
**Proposta:** uniformare a **"latenza"** (italiano, femminile), già presente nel testo e
forma standard nel settore. In alternativa, mantenere "latency" invariante con articolo
femminile costante ("la latency"). Da aggiungere al glossario terminologico.

### F6 — Nome del progetto documentazione (Cap 14 §14.8)
La sezione usa `Adlc.Documentation`. Stato della nomenclatura non risolto nel sorgente:
- `VISUALSTUDIO.md` → `Adlc.Documentation\Adlc.Documentation.csproj`
- file reale nel repo → `source/.ai-dlc/AI-DLC.Documentation.csproj`
Sorgente e libro non concordano sul nome canonico (`Adlc.Documentation` vs
`AI-DLC.Documentation`). **Serve una decisione dell'autore** sul nome unico, poi allineare
libro + `VISUALSTUDIO.md` + `.csproj`. Non corretto in questa fase.

---

## Note minori (opzionali)

- **Cap 16 §16.4:** prosa «entra in **Phase 6** (Ops)» — il glossario riserva "Phase" al
  nome del campo e usa "Fase" nella prosa (il titolo della sezione dice già "Fase 6").
  Suggerito: «entra in **Fase 6** (Ops)».

---

## Verifiche completate senza rilievi

- **Cap 12, 16, 90:** terminologia, percorsi `.ai-dlc/`, capitalizzazione tecnologie,
  livelli di intestazione e tag lingua dei blocchi codice tutti coerenti.
- **Riferimenti incrociati:** Cap 2 §2.3 → Cap 8; Cap 8 §8.3 → §8.1; Cap 12 §12.5 → Cap 6;
  Cap 14 §14.5 sync-copilot; Cap 16 → §4.8 e Appendice C — tutti validi.
- **Capitalizzazione tecnologie:** PostgreSQL, Node.js, Fastify, Prisma, Zod, GitHub,
  TypeScript corretti nei file rivisti.
- **Versione framework:** v4.0.0 coerente in tutti i file modificati.
- **Glossario (Cap 90):** voci `AI-DLC` vs `ADLC`, entry point con `VISUALSTUDIO.md`,
  `Company extension` con `.ai-dlc/company/` — tutto allineato.

---

## Statistiche

| Tipo | Conteggio |
|---|---|
| Correzioni oggettive proposte | 3 (F2, F3, F5) |
| Correzioni da confermare | 3 (F1, F4, F6) |
| Note minori | 1 |
| File rivisti | 7 |
| File puliti senza modifiche | 3 (Cap 12, 16, 90) |

---

## Esito — applicato il 2026-06-29 (conferma autore)

Applicate su `md/it/` e relativi `chapters/it/*.tex`:

- ✅ **F2** — Cap 8: `le task → i task` (solo md; il tex non conteneva la frase)
- ✅ **F3** — Cap 8: `il level → il livello`, `minimum level → livello minimo` (md + ch08.tex)
- ✅ **F5** — Cap 14 §14.8: `.adlc\ → .ai-dlc\` (solo md; il tex non conteneva la lista percorsi)
- ✅ **F1** — Cap 2: aggiunto `VISUALSTUDIO.md` all'albero §2.1 e ai comandi di copia (md + ch02.tex tree)
- ✅ **F4** — Cap 8: `latency → latenza` (md + ch08.tex); glossario terminologico aggiornato
- ✅ **F-16.4** — Cap 16 §16.4: prosa `Phase 6 → Fase 6` (solo md; il riepilogo tex resta "Phase 6" come etichetta)

**F6 — nome canonico: RISOLTO il 2026-06-29 (decisione autore = `AI-DLC`):**
- ✅ Rinominato `Adlc.Documentation` → `AI-DLC.Documentation` in: `md/it/14`, `ch14.tex`,
  `source/.ai-dlc/VISUALSTUDIO.md`, `source/README.md`, `source/CHANGELOG.md`
  (allineato al file reale `.csproj` e a `manifest.json#visualstudio_csproj`).
- Invariati per natura: `aidlc.pdf` (PDF AWS), `awslabs/aidlc-workflows` (repo esterno),
  label LaTeX `tab:01-vibe-vs-aidlc` (identificatore interno).

**Allineamento sorgente eseguito il 2026-06-29:**
- ✅ `source/.ai-dlc/VISUALSTUDIO.md`: rebrand `.adlc\` / `.adlc/` → `.ai-dlc`; marchio `ADLC` → `AI-DLC` (titolo, "contract", "paths").
- ✅ `source/.ai-dlc/AI-DLC.Documentation.csproj`: corretto refuso `.ad-dlc\company\` → `.ai-dlc\company\`.

**Layout — RISOLTO il 2026-06-29 (decisione autore = Layout B, csproj in radice):**
Motivazione: le `<None Include>` del `.csproj` sono già relative alla radice, quindi il file
referenzia correttamente solo se sta in radice; inoltre `.ai-dlc/` deve contenere solo framework.
Layout canonico:
```
<repo root>/
├── AI-DLC.Documentation.csproj
├── .ai-dlc/            (framework, read-only)
├── docs/_solution/     (documentazione a livello di solution)
└── projects/
    ├── <Project>/      (_CONTEXT.md, PROGRESS.md, instructions.md, docs/)
    └── shared/         (documentazione cross-progetto)
```
Applicato:
- ✅ Spostato `AI-DLC.Documentation.csproj` da `.ai-dlc/` alla radice `source/`; commenti interni allineati.
- ✅ `manifest.json#visualstudio_csproj`: `.ai-dlc/AI-DLC.Documentation.csproj` → `AI-DLC.Documentation.csproj`.
- ✅ `VISUALSTUDIO.md`: layout riscritto (`projects\<Project>\`, `projects\shared\`, `docs\_solution\`).
- ✅ Libro §14.8 (`md/it/14` + `ch14.tex`): albero e lista priorità riscritti al Layout B.
- ✅ `source/README.md`: riga csproj spostata in radice nell'albero directory.
- ✅ `source/CHANGELOG.md` e `source/.ai-dlc/company/README.md`: percorsi allineati.

**Note residue:**
- ✅ `SKILL_VISUALSTUDIO.md` **creato** in `source/.ai-dlc/modules/skills/` (già referenziato da csproj, VISUALSTUDIO.md, libro). Risolto 2026-06-29.
- ✅ Cartella `source/.ai-dlc/company/` rebrandizzata interamente (ADLC→AI-DLC, .adlc/→.ai-dlc/) e percorsi `_solution\`→`docs\_solution\` allineati al Layout B. Risolto 2026-06-29.
