# Contesto del Progetto

> Ultimo aggiornamento: 2026-04-01

## Fase Corrente

Fase 8 completata — edizione inglese tradotta e compilata con successo. Pronto per revisione/copy editing EN o cover Amazon KDP (Fase 7b)

## Stato dei Capitoli

| # | File | Stato | Fase | Ultima modifica | Note |
|---|------|-------|------|-----------------|------|
| 0 | 00-introduzione.md | ✅ completato | Fase 7 | 2026-04-01 | SDLC vs ADLC, paradigma |
| 1 | 01-la-rivoluzione-0code.md | ✅ completato | Fase 7 | 2026-04-01 | Riscritto post-review |
| 2 | 02-ambiente-di-sviluppo.md | ✅ completato | Fase 7 | 2026-04-01 | VS Code, Copilot, Claude Code |
| 3 | 03-metodo-adlc.md | ✅ completato | Fase 7 | 2026-04-01 | Framework ADLC completo |
| 4 | 04-hello-world.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 1: Hello World |
| 5 | 05-applicazione-cli.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 2: TaskMaster CLI |
| 6 | 06-rest-api.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 3: Notes REST API |
| 7 | 07-database-postgresql.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 4: PostgreSQL + Prisma |
| 8 | 08-autenticazione-oauth2.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 5: OAuth 2.0 |
| 9 | 09-frontend-react.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 6: Frontend React |
| 10 | 10-integrazione-fullstack.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 7: Full-Stack |
| 11 | 11-setup-flutter.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 8: Setup Flutter |
| 12 | 12-flutter-backend.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto 9: Flutter + Backend |
| 13 | 13-release.md | ✅ completato | Fase 7 | 2026-04-01 | Pubblicazione store |
| 14 | 14-testing-sicurezza.md | ✅ completato | Fase 7 | 2026-04-01 | Testing e sicurezza |
| 15 | 15-deploy-produzione.md | ✅ completato | Fase 7 | 2026-04-01 | Deploy produzione |
| 16 | 16-pattern-avanzati.md | ✅ completato | Fase 7 | 2026-04-01 | Pattern avanzati |
| A | 90-appendice-a-glossario.md | ✅ completato | Fase 7 | 2026-04-01 | Glossario |
| B | 91-appendice-b-template.md | ✅ completato | Fase 7 | 2026-04-01 | Template pronti all'uso |
| C | 92-appendice-c-comandi.md | ✅ completato | Fase 7 | 2026-04-01 | Comandi e scorciatoie |
| D | 93-appendice-d-bibliografia.md | ✅ completato | Fase 7 | 2026-04-01 | Bibliografia e risorse |
| E | 94-appendice-e-framework-adlc.md | ✅ completato | Fase 7 | 2026-04-01 | Framework ADLC reale |
| F | 95-appendice-f-progetto-autonomo.md | ✅ completato | Fase 7 | 2026-04-01 | Progetto BookShelf |

## Attività Completate

- [2026-04-01] Fase 8 completata: tradotti in inglese tutti i 23 capitoli e appendici Markdown in `md/en/`
- [2026-04-01] Sostituito il placeholder di `chapters/en/ch00-introduction.tex` con l'introduzione completa in inglese derivata da `md/en/00-introduction.md` e verificata con build PDF `book-en.pdf`
- [2026-04-01] Tradotti e verificati con PlantUML gli 11 diagrammi dell'edizione inglese in `figures/en/` mantenendo struttura e naming della versione italiana
- [2026-04-01] Aggiornati `tex/config-en.tex`, `ebook/metadata-en.yaml` e `tex/book-en.tex` per la struttura completa dell'edizione inglese
- [2026-04-01] Formattati i capitoli LaTeX inglesi in `chapters/en/` e compilati con successo `tex/book-en.pdf` (1247 KB) ed `ebook/book-en.epub` (1206 KB)
- [2025-06-01] Valutazione editoriale: voto 8/10, pubblicabile con revisione minore (docs/reviews/evaluation-sviluppo-0code-2025-06-01.md)
- [2026-03-30] Review editoriale strutturale: ristrutturazione completa da manuale teorico a guida pratica (docs/reviews/review-struttura-it-2026-03-30.md)
- [2026-03-30] Completamento riscrittura tutti i 16 capitoli + introduzione + 6 appendici in Markdown (libro/)
- [2026-03-30] Formattazione LaTeX di tutti i capitoli (book/chapters/)
- [2026-04-01] Riorganizzazione archivio: allineamento alla struttura del workflow editoriale
- [2026-04-01] Capitoli Markdown copiati da libro/ → md/it/ (23 file, naming NN-nome.md)
- [2026-04-01] Capitoli LaTeX copiati da book/chapters/ → chapters/it/ (24 file)
- [2026-04-01] Documenti editoriali riorganizzati in docs/ideas/, docs/research/, docs/reviews/
- [2026-04-01] Aggiornamento config: autore "Riccardo Rolla", titolo "Sviluppo Software 0-Code"
- [2026-04-01] Aggiornamento tex/book-it.tex con struttura 6 parti + 16 capitoli + 6 appendici
- [2026-04-01] Aggiornamento metadati EPUB (ebook/metadata-it.yaml)
- [2026-04-01] Fix path immagini: md/it/ → ../../figures/it/, LaTeX graphicspath → ../figures/it/
- [2026-04-01] Pulizia file ridondanti: eliminati libro/, book/, diagrams/, review/, 4 docs root. Salvato review.md → docs/reviews/review-roadmap-editoriale.md
- [2026-04-01] Fase 5 (Copy Editing) completata: 1 errore fattuale corretto, 1 link rotto fixato, 101 blocchi codice taggati, glossario terminologico creato (docs/reviews/terminology-it.md). Rapporto: docs/reviews/copyedit-full-it-2026-04-01.md
- [2026-04-01] Fase 6 (Correzione Bozze) completata: 8 correzioni applicate (2 refusi, 4 grammatica, 2 formattazione). 17 capitoli su 23 puliti. Rapporto: docs/reviews/proofread-full-it-2026-04-01.md
- [2026-04-01] Fase 7 (Formattazione LaTeX e Compilazione): sincronizzate 5 correzioni fasi 5-6 nei file chapters/it/, compilazione PDF (book-it.pdf, 2407 KB) e EPUB (book-it.epub, 1210 KB) riuscita senza errori
- [2026-04-01] Completata l'edizione LaTeX inglese: creati `ch01-the-0code-revolution.tex`, `ch02-development-environment.tex`, `ch03-adlc-method.tex`, `app-b-templates.tex`, `app-c-commands.tex`, `app-d-bibliography.tex`, `app-e-adlc-framework.tex` e `app-f-autonomous-project.tex`; compilazione PDF `book-en.pdf` riuscita (1247 KB)

## Attività in Corso

- Nessuna attività in corso

## Attività Pianificate

- Fase 7b: Preparazione cover Amazon KDP (`covers/it/` e `covers/en/` — `ebook-cover.png` mancante)
- Rigenerare gli EPUB con copertina dopo la creazione delle cover
- Revisione editoriale / copy editing dell'edizione inglese, se desiderato

## Decisioni e Note

- [2026-04-01] La struttura originale in libro/ (con sottocartelle parte-*/) è stata preservata; i contenuti sono stati copiati (non spostati) in md/it/ e chapters/it/ per conformarsi al workflow
- [2026-04-01] I documenti nella root di docs/ sono stati copiati nelle sottocartelle appropriate (ideas/, research/, reviews/) — i file originali rimangono in docs/ come riferimento
- [2026-04-01] Il libro ha già attraversato le fasi 1-4 (valutazione, review strutturale, riscrittura completa). Fasi 5-7 completate.
- [2026-04-01] EPUB italiano ed EPUB inglese generati senza copertina — manca `covers/it/ebook-cover.png` e la corrispondente cover EN (1600×2560 px richiesti)
- [2026-04-01] Verificata la compilazione dell'edizione inglese: `tex/book-en.pdf` (1247 KB) e `ebook/book-en.epub` (1206 KB)
- [2026-04-01] Verificata anche la sintassi PlantUML dei diagrammi EN con PlantUML 1.2024.3 e Graphviz 2.44.1
- [2026-04-01] Strutture parallele eliminate: ora esiste solo la struttura workflow (md/it/, chapters/it/, tex/)
