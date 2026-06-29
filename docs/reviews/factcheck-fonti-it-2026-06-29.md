# Fact-check fonti — cap. 1 e Appendice D

**Data:** 2026-06-29
**Metodo:** verifica web puntuale (titolo, autori, ID arXiv, dati citati).

---

## Esito sintetico

✅ **Tutte le citazioni ad alto rischio verificate e accurate.** I paper arXiv 2026
con ID specifici — che erano i candidati più probabili a un'allucinazione — esistono
realmente e i numeri citati sono corretti. **Una sola correzione consigliata** (titolo
libro Osmani, cambiato dopo la stesura).

---

## Verificate ✅

| Citazione (libro) | Esito |
|---|---|
| *Assistance to Autonomy* — arXiv **2605.15245** (2026) | ✅ Esiste. "oltre 1600 candidati" (cap.1) **e** "92 studi primari" (App D) entrambi corretti; output verifiability come abilitante principale; Planner–Executor–Reviewer. |
| *Agentic AI in the SDLC: Architecture, Empirical Evidence…* — arXiv **2604.26275** (2026) | ✅ Esiste (29 apr 2026). Architettura a 6 livelli, A-SDLC. |
| *Context Rot in AI-Assisted Software Development* — arXiv **2606.09090**, Treude & Baltes | ✅ Esiste. Titolo completo conferma "context rot", **356 repository**, **23,0%** con riferimenti obsoleti. Dato corretto. |
| *Evaluating AGENTS.md* — arXiv **2602.11988**, Gloaguen et al. (ETH Zürich) | ✅ Esiste (feb 2026). 138 task; i context file **non** migliorano il success rate e aumentano il costo **oltre il 20%**. Corretto. |
| *Vibe Coding* — Kim & Yegge (IT Revolution), prefazione **Dario Amodei** | ✅ Confermato. Titolo "…Building Production-Grade Software With GenAI, Chat, Agents, and Beyond"; ISBN 9781966280026; FAAFO. |
| Anthropic — *Effective context engineering for AI agents* | ✅ Esiste (anthropic.com/engineering). "attention budget" e "lost in the middle" presenti. |
| *The Prompt Report* — Schulhoff et al. | ✅ Esiste, arXiv **2406.06608** (giu 2024). |
| CoT — Wei et al. (arXiv 2201.11903); ReAct — Yao et al. (arXiv 2210.03629) | ✅ Reali (citazioni classiche). |
| AWS **AI-DLC** — Raja SP, fasi Inception/Construction/Operations | ✅ Confermato (AWS 2025; AWS DevOps Blog + re:Invent 2025). |
| Fred Brooks *No Silver Bullet* (1986); Karpathy origine "vibe coding" (2025) | ✅ Reali. |

> Non ri-verificate singolarmente (basso rischio, fonti consolidate): OWASP Top 10/ASVS/
> cheat sheet, NIST AI RMF (600-1) e SSDF, Google SRE Book, ADR (Nygard), Fowler.

---

## ✅ Correzione applicata (2026-06-29)

**Addy Osmani — titolo del libro cambiato.**
Il libro cita *«Vibe Coding: The Future of Programming» (O'Reilly, 2025)* in **§1.2** e in
**Appendice D**. Il titolo ufficiale è stato **rinominato** in
***«Beyond Vibe Coding: Leveraging Your Experience in the Age of AI-Assisted Coding»*** (Addy
Osmani, O'Reilly, 2025; ISBN 9798341634756). Il contenuto (il "problema del 70%") è reale e
attribuito correttamente a Osmani.

**Applicato:** §1.2 (ch01) usa la forma breve *«Beyond Vibe Coding»*; Appendice D (ch93) il
titolo completo *«Beyond Vibe Coding: Leveraging Your Experience in the Age of AI-Assisted
Coding»* con nota "già annunciato come *Vibe Coding: The Future of Programming*". Aggiornati
md + tex. PDF ricompila.

---

## Nota di coerenza interna (non un errore)

Cap.1 §1.2 parla di review «costruita su oltre 1.600 fonti»; App D la descrive «costruita su
92 studi primari». **Entrambi corretti**: 1.600 = pubblicazioni candidate screenate, 92 =
studi primari inclusi. Se si vuole massima chiarezza, si può armonizzare il fraseggio
(es. cap.1: "su oltre 1.600 fonti screenate, 92 studi primari").
