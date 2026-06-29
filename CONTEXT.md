# Contesto del Progetto

> Ultimo aggiornamento: 2026-06-29

## Fase Corrente

Fase 6 (Correzione bozze) — completata su TUTTO il libro (21 capitoli); corretti ch04, ch09, ch13; PDF compila senza errori. Allineamento v4.0.0 + Layout B + company/ conclusi

## Parametri del Libro

| Campo | Valore |
|---|---|
| Titolo | AI-DLC — Orchestrare Agenti AI nello Sviluppo Software |
| Nome metodologia | AI-DLC (AI-Driven Development Life Cycle), nomenclatura da AWS, specializzata nel libro |
| Autore | Riccardo Rolla |
| Lingua | Italiano |
| Struttura | 16 capitoli + Introduzione + 4 Appendici |
| Esempio ricorrente | Progetto "TaskFlow API" (REST API Node.js/Fastify) |
| Profondità | Workflow utente (non dettaglio moduli interni) |
| Sorgente framework | `source/.ai-dlc/` in repo ADLC.20260403 |
| Versione framework | 4.0.0 |

## Stato dei Capitoli

| # | File | Stato | Fase | Ultima modifica | Note |
|---|------|-------|------|-----------------|------|
| 0 | 00-introduzione.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 1 | 01-cose-ai-dlc.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 2 | 02-setup-primo-progetto.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 3 | 03-sessione-reale.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 4 | 04-context-md.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 5 | 05-progress-md.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 6 | 06-fasi-e-modes.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 7 | 07-classificazione-rischio.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 8 | 08-model-levels.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 9 | 09-confidence-tags.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 10 | 10-halt-triggers.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 11 | 11-vincoli-sec-perf.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 12 | 12-moduli-e-skill.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 13 | 13-comandi-conversazionali.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 14 | 14-multi-agente.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 15 | 15-monorepo-legacy.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| 16 | 16-produzione.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| A | 90-appendice-a-glossario.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| B | 91-appendice-b-comandi.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| C | 92-appendice-c-template.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |
| D | 93-appendice-d-risorse.md | ✅ completato | Fase 3 | 2026-06-27 | Prima bozza |

## Attività Completate

- [2026-06-29] Box "Senza/Con AI-DLC" estesi a ch1 (convenzioni/team) e ch3 (bootstrap), md+tex; i 5 PNG dei diagrammi generati e ora inclusi come figure reali nel PDF (verificato nel log). PDF compila ok
- [2026-06-29] Creato build-diagrams.ps1 (root): compila figures/**/*.puml in PNG 300 DPI via PlantUML (CLI / $env:PLANTUML_JAR / jar nel repo); rigenera solo i PNG obsoleti o tutti con -Force. PlantUML/Java non installati in locale: i 5 PNG vanno ancora generati
- [2026-06-29] Review autore (8.3/10): applicati #1 pitch in Introduzione, #2 box "AI-DLC vs ADLC", #3 nuovo box beforeafterbox "Senza/Con AI-DLC" (env LaTeX + label + tabella md; pilota nell'Introduzione), #5 creati 5 diagrammi in figures/it/ (ch03-ciclo-sessione, ch07-rischio-azione, ch14-stella-multiagente, ch06-fasi-moduli, ch10-halt-flusso) e inseriti i riferimenti su md (![...]) e tex (\diagramfig) in ch03/06/07/10/14; aggiunto helper \diagramfig + \graphicspath in manning-style.tex (mostra segnaposto finche i PNG non sono generati, build resta verde). PNG da generare con PlantUML+Java (assenti in locale); #4 fact-check fonti → tutte verificate, rapporto in docs/reviews/factcheck-fonti-it-2026-06-29.md; applicata l'unica correzione (titolo libro Osmani → "Beyond Vibe Coding" in §1.2 e App. D, md+tex). PDF ricompila ok
- [2026-06-29] Fase 6 — Correzione bozze estesa a tutto il libro (21 capitoli): corretti ch04 (architetturale), ch09 (doppio ---), ch13 (spazio finale); segnalato ch06 "sessioni"→"capitoli" (borderline); controlli automatici ok, PDF compila senza errori; rapporto in docs/reviews/proofread-changed-it-2026-06-29.md
- [2026-06-29] Rebrand completo cartella source/.ai-dlc/company/ (estensione EBIT SUITESTENSA): ADLC→AI-DLC e .adlc/→.ai-dlc/ in README, PROCESS, GOVERNANCE, STANDARDS, DEVOPS, halt-triggers.yaml; percorsi _solution\→docs\_solution\ allineati al Layout B
- [2026-06-29] Creato source/.ai-dlc/modules/skills/SKILL_VISUALSTUDIO.md (navigazione solution, regole .csproj, Layout B, DOC-01); già referenziato dal .csproj
- [2026-06-29] Layout doc VS risolto (autore: Layout B, csproj in radice): spostato AI-DLC.Documentation.csproj in source/ (da .ai-dlc/); manifest, VISUALSTUDIO.md, libro §14.8 (md+tex), README, CHANGELOG, company/README allineati a projects\<Project>\ / projects\shared\ / docs\_solution\
- [2026-06-29] F6 risolto (autore: marchio AI-DLC): rinominato Adlc.Documentation → AI-DLC.Documentation in md/it/14, ch14.tex, source/VISUALSTUDIO.md, source/README.md, source/CHANGELOG.md
- [2026-06-29] Allineamento sorgente: VISUALSTUDIO.md rebrandizzato (.adlc→.ai-dlc, ADLC→AI-DLC); corretto refuso .ad-dlc in AI-DLC.Documentation.csproj
- [2026-06-29] Fase 5 — Copy editing dei 7 capitoli modificati (02, 05, 08, 12, 14, 16, 90): applicate F1-F5 + nota 16.4 su md e tex; rapporto in docs/reviews/copyedit-changed-it-2026-06-29.md; glossario terminologico aggiornato (latenza, genere "task", livello/Level)
- [2026-06-29] Creato nuovo README.md per source/ in stile GitHub landing page (simile ad awslabs/aidlc-workflows)
- [2026-06-29] Aggiornamento LaTeX: ch12 (sezione always-on moduli), ch14 (sezione Visual Studio 2026 + DOC-01)
- [2026-06-29] Cap. 12: aggiunta sezione 12.3 con descrizione dettagliata dei moduli always-on (overconfidence, content validation, structured questions); rinumerate sezioni successive
- [2026-06-29] Cap. 14: aggiunta sezione 14.8 su Visual Studio 2026 e regola DOC-01; aggiornato riepilogo
- [2026-06-29] Allineamento source v4.0.0: corretto versione in README, MANUAL.it, MANUAL.md; aggiunto CHANGELOG 4.0.0; aggiornata struttura directory e tabella agenti con VISUALSTUDIO.md; aggiornati moduli 12-14 in AGENTS.md
- [2026-06-29] Aggiornamento libro: versione v3.3.0→v4.0.0 in cap. 2, 5, 8, 14; aggiunta tabella moduli 12-14 in cap. 12; aggiunto Visual Studio nella tabella agenti cap. 14
- [2026-06-27] Fase 2 completata: indice approvato (docs/ideas/indice-ai-dlc-manuale-it.md)
- [2026-06-27] Repository creato e struttura inizializzata

## Attività in Corso

- Nessuna — F6 (nome), layout doc VS e SKILL_VISUALSTUDIO.md tutti risolti

## Attività Pianificate

- Decidere ch06 "sessioni"→"capitoli" (segnalazione borderline)
- Valutare se aggiungere VISUALSTUDIO.md al trigger framework in halt-triggers.yaml (sorgente + esempio ch10)
- Fase 7b: Preparazione cover Amazon KDP

## Decisioni e Note

- [2026-06-27] Repo separato da "Sviluppo Software 0-Code" (ADLC.20260403)
- [2026-06-27] Solo edizione italiana — nessuna traduzione EN pianificata
- [2026-06-27] Profondità: workflow utente, non dettaglio moduli interni
- [2026-06-27] Esempio ricorrente: "TaskFlow API" — REST API Node.js/Fastify usata in tutti i capitoli
