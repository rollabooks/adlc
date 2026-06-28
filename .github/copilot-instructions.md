# Progetto Editoriale — Istruzioni per l'Agente

Questo è un progetto editoriale per la creazione di manuali tecnici multilingua.
L'agente deve seguire il workflow descritto qui come processo di lavoro.

## Struttura del Progetto

```
CONTEXT.md           ← Memoria di progetto: stato, attività, decisioni
docs/ideas/          ← Idee, proposte, brainstorming
docs/research/       ← Fonti, materiale di ricerca, riferimenti
docs/reviews/        ← Rapporti di revisione, valutazioni, correzioni
md/<lang>/           ← Capitoli Markdown per EPUB (ordinati per prefisso numerico)
chapters/<lang>/     ← Capitoli LaTeX per PDF
tex/                 ← Configurazione LaTeX, stili, lingue
tex/book-<lang>.tex  ← Documento principale LaTeX per ogni lingua
ebook/               ← Metadati e stili EPUB
figures/             ← Diagrammi PlantUML (.puml)
figures/<lang>/      ← Diagrammi PlantUML per lingua
covers/              ← Cover Amazon KDP (eBook e cartaceo, per lingua)
covers/<lang>/       ← Cover specifiche per lingua
covers/assets/       ← Elementi grafici riutilizzabili (logo, pattern, sfondi)
covers/templates/    ← Template sorgente (PSD, AI, SVG, GIMP)
```

## Stato del Progetto

Prima di qualsiasi operazione, l'agente deve determinare lo stato attuale:

1. **Leggere `CONTEXT.md`** nella root del progetto per riprendere il contesto: fase corrente, attività completate, in corso e pianificate
2. **Leggere `tex/config.tex`** per titolo, autore, stile scelto
3. **Elencare le cartelle `md/` e `chapters/`** per le lingue attive
4. **Leggere `tex/config-<lang>.tex`** per i metadati per lingua
5. **Contare e leggere i capitoli** in `md/<lang>/` per capire a che punto è la scrittura
6. **Controllare `docs/reviews/`** per rapporti di revisione pendenti
7. **Controllare `docs/ideas/`** per materiale da elaborare

Se il progetto non è ancora inizializzato (manca `tex/config.tex` o è ancora con i valori di esempio), guidare l'utente attraverso l'inizializzazione con `init-project.ps1`.

## Workflow Editoriale Completo

Il progetto segue 9 fasi. L'agente identifica la fase corrente e propone il passo successivo.

---

### FASE 0 — Inizializzazione

**Quando**: il progetto è appena clonato o `tex/config.tex` ha ancora i valori di esempio.

**Azioni**:
1. Chiedere all'utente: titolo, autore, lingua principale, stile grafico
2. Eseguire `.\init-project.ps1 -Title "..." -Author "..." -Language <lang>`
3. Verificare che le cartelle `chapters/<lang>/`, `md/<lang>/` siano state create
4. Confermare la configurazione leggendo `tex/config.tex` e `tex/config-<lang>.tex`

**Risultato**: progetto pronto con struttura per la lingua scelta.

---

### FASE 1 — Ideazione e Valutazione

**Quando**: l'utente ha un'idea o una proposta da valutare prima di iniziare a scrivere.

**Skill**: `reader` (Scout editoriale)

**Azioni**:
1. L'utente deposita le proprie idee in `docs/ideas/` (anche appunti informali, elenchi, documenti sparsi)
2. L'agente usa la skill `reader` per valutare:
   - originalità e posizionamento nel mercato
   - pubblico target (livello, dimensione)
   - completezza della proposta (argomenti coperti)
   - tempestività e rilevanza
3. Produce una scheda di valutazione in `docs/reviews/evaluation-<titolo>-<data>.md`
4. Raccomanda: pubblicare / revisionare la proposta / respingere

**Risultato**: decisione informata su procedere con la scrittura.

---

### FASE 2 — Pianificazione

**Quando**: l'idea è approvata, serve un indice strutturato.

**Azioni**:
1. Leggere tutto il materiale in `docs/ideas/` e `docs/research/`
2. Proporre un indice completo con:
   - Titoli dei capitoli e breve descrizione
   - Ordine logico e progressione didattica
   - Parti (raggruppamenti tematici)
   - Appendici necessarie
3. Per ogni capitolo, definire il prefisso numerico (`01-`, `02-`, ..., `90-` per appendici)
4. Salvare l'indice pianificato in `docs/ideas/indice-<lang>.md`
5. Creare i file vuoti in `md/<lang>/` con i nomi definitivi

**Risultato**: struttura del libro definita, file Markdown per ogni capitolo pronti.

---

### FASE 3 — Scrittura

**Quando**: la struttura è definita, ci sono capitoli da scrivere.

**Skill**: `writer` (Scrittore tecnico)

**Azioni**:
1. L'agente verifica quali capitoli in `md/<lang>/` sono ancora vuoti o incompleti
2. Per ogni capitolo da scrivere:
   a. Leggere il materiale correlato in `docs/ideas/` e `docs/research/`
   b. Leggere i capitoli precedenti per coerenza di stile e tono
   c. Scrivere il capitolo usando la skill `writer`
   d. Rispettare la struttura: introduzione → sezioni → riepilogo
   e. Includere esempi di codice funzionanti e commentati
   f. Usare admonition (`> **Nota:**`, `> **Suggerimento:**`, `> **Attenzione:**`)
3. Salvare in `md/<lang>/` con il prefisso numerico corretto

**Regola**: scrivere un capitolo alla volta, poi proporre all'utente di procedere con il successivo o di revisionare.

**Risultato**: capitoli Markdown scritti e pronti per la revisione.

---

### FASE 4 — Revisione Editoriale

**Quando**: uno o più capitoli sono scritti e pronti per la revisione.

**Skill**: `editor` (Revisore editoriale)

**Azioni**:
1. Leggere i capitoli da revisionare in `md/<lang>/`
2. Analizzare secondo i criteri: struttura, chiarezza, progressione, coerenza, qualità tecnica
3. Generare rapporto in `docs/reviews/review-ch<NN>-<lang>-<data>.md`
4. Il rapporto classifica i problemi:
   - **Critici** (🔴): errori tecnici, informazioni sbagliate
   - **Importanti** (🟡): struttura confusa, sezioni mancanti
   - **Suggerimenti** (🟢): miglioramenti opzionali
5. Proporre le modifiche all'utente

**Ciclo**: dopo la revisione, tornare alla FASE 3 per le correzioni, poi ri-revisionare.

**Risultato**: capitoli revisionati e approvati dall'editor.

---

### FASE 5 — Copy Editing

**Quando**: i capitoli sono stati revisionati e approvati nella sostanza.

**Skill**: `copyeditor` (Redattore editoriale)

**Azioni**:
1. Revisione formale di ogni capitolo:
   - Coerenza terminologica (stesso termine per lo stesso concetto ovunque)
   - Fact-checking (URL funzionanti, versioni software corrette, nomi di librerie)
   - Uniformità stilistica (capitalizzazione, formattazione, convenzioni)
   - Verifica riferimenti incrociati tra capitoli
2. Rapporto con lista terminologica e interventi in `docs/reviews/copyedit-<lang>-<data>.md`
3. Applicare le correzioni direttamente ai file `md/<lang>/` (previa conferma)

**Risultato**: testo coerente, verificato nei fatti e pronto per la correzione bozze.

---

### FASE 6 — Correzione Bozze

**Quando**: il testo è passato per copy editing ed è quasi definitivo.

**Skill**: `proofreader` (Correttore di bozze)

**Azioni**:
1. Ultima lettura di ogni capitolo cercando solo:
   - Refusi e errori di battitura
   - Errori grammaticali e di punteggiatura
   - Formattazione Markdown rotta (link, codice, heading mal chiusi)
   - Spaziatura e indentazione inconsistente
2. Rapporto in `docs/reviews/proofread-<lang>-<data>.md`
3. NON intervenire su contenuto, struttura o terminologia — solo errori residui

**Risultato**: testo pulito, pronto per la formattazione finale.

---

### FASE 6b — Creazione Diagrammi

**Quando**: il testo è definitivo (fasi 3-6 complete) e si vogliono aggiungere diagrammi esplicativi.

**Skill**: `diagrammer` (Grafico di diagrammi tecnici)

**Azioni**:
1. Leggere ogni capitolo in `md/<lang>/` e identificare i concetti che beneficerebbero di una rappresentazione visiva
2. Proporre all'utente la lista dei diagrammi con tipo e descrizione
3. Creare i file `.puml` in `figures/<lang>/` seguendo le regole della skill:
   - Diagrammi leggibili in bianco e nero (stampa cartacea)
   - Testi nella lingua del capitolo
   - Terminologia coerente con il testo
   - Dimensione ottimizzata per la larghezza pagina del libro (~12 cm)
4. Compilare: `.\build.ps1 -DiagramsOnly` o `.\build.ps1 -Lang <lang>`
5. Proporre dove inserire i riferimenti `![Descrizione](figures/<lang>/chNN-nome.png)` nei capitoli Markdown
6. Aggiornare i capitoli con i riferimenti alle figure (previa conferma)

**Regola**: procedere un capitolo alla volta. Proporre i diagrammi e attendere conferma prima di crearli.

**Risultato**: diagrammi PlantUML creati, compilati in PNG e referenziati nei capitoli.

---

### FASE 7 — Formattazione LaTeX e Compilazione

**Quando**: i capitoli Markdown sono definitivi (fasi 3-6 complete).

**Skill**: `formatter` (Formattatore LaTeX)

**Azioni**:
1. Per ogni capitolo in `md/<lang>/`, convertire in LaTeX in `chapters/<lang>/`:
   - Mappare `#` → `\chapter`, `##` → `\section`, ecc.
   - Convertire blockquote con `> **Tipo:**` nei box corretti (`\begin{tipbox}`, ecc.)
   - Convertire blocchi di codice in `\begin{lstlisting}`
   - Convertire figure in `\begin{figure}`
   - Convertire tabelle in `tabular`
2. Registrare ogni nuovo capitolo in `tex/book-<lang>.tex`
3. Compilare:
   - PDF: `.\build.ps1 -Lang <lang> -BookOnly`
   - EPUB: `.\build.ps1 -Lang <lang> -EbookOnly`
4. Verificare errori di compilazione e correggerli

**Risultato**: PDF e EPUB generati correttamente.

---

### FASE 7b — Preparazione Cover Amazon KDP

**Quando**: il libro è compilato (FASE 7) e si prepara la pubblicazione su Amazon KDP.

**Azioni**:
1. Verificare che esistano i file cover in `covers/<lang>/`:
   - `ebook-cover.png` (1600×2560 px, rapporto 1:1.6, RGB, sRGB)
   - `print-cover.pdf` (fronte + dorso + retro, con abbondanza 3.2mm per lato)
2. Se le cover non esistono, guidare l'utente nella creazione:
   - Consultare `covers/specs.md` per le specifiche tecniche
   - Usare i template in `covers/templates/` come base
   - Usare gli asset condivisi in `covers/assets/`
3. Validare le cover:
   - eBook: dimensione minima 1000×1600 px, massima 10000×10000 px, < 50 MB
   - Cartaceo: dimensioni calcolate in base a formato trim e numero di pagine (vedi `covers/specs.md`)
4. Il build genera automaticamente `ebook/cover.jpg` dalla cover eBook durante la compilazione EPUB

**Risultato**: cover pronte per il caricamento su Amazon KDP.

---

### FASE 8 — Traduzione (opzionale)

**Quando**: l'edizione nella lingua principale è completa e si vuole pubblicare in altre lingue.

**Skill**: `translator` (Traduttore tecnico)

**Azioni**:
1. Verificare che la lingua target esista: se no, `.\init-project.ps1 -AddLang <lang>`
2. Tradurre capitolo per capitolo:
   - Markdown: `md/<lang-source>/*.md` → `md/<lang-target>/*.md`
   - LaTeX: `chapters/<lang-source>/*.tex` → `chapters/<lang-target>/*.tex`
3. Regole di traduzione:
   - NON tradurre: nomi di funzioni, variabili, classi, comandi, URL, percorsi file
   - Tradurre: commenti nel codice, testo descrittivo, admonition
   - Adattare: convezioni locali (date, valuta, unità di misura)
   - Usare la terminologia standard della lingua target (glossario tecnico consolidato)
4. Aggiornare `tex/config-<lang>.tex` e `ebook/metadata-<lang>.yaml` con titolo e metadati tradotti
5. Compilare e verificare: `.\build.ps1 -Lang <lang-target>`

**Risultato**: edizione completa in un'altra lingua.

---

## Regole Generali per l'Agente

### Comportamento

- **Mai procedere senza conferma** per operazioni distruttive (cancellare capitoli, sovrascrivere revisioni)
- **Un passo alla volta**: completare un capitolo/una fase prima di passare alla successiva
- **Proporre, non imporre**: suggerire il passo successivo e attendere conferma dall'utente
- **Tracciare il progresso**: usare todo list per operazioni multi-step
- **Aggiornare `CONTEXT.md`** al termine di ogni operazione significativa (vedi sezione dedicata)

### Dove scrivere cosa

| Contenuto | Destinazione |
|-----------|-------------|
| Memoria di progetto | `CONTEXT.md` |
| Idee, appunti, proposte | `docs/ideas/` |
| Fonti, ricerche, materiale | `docs/research/` |
| Rapporti di revisione | `docs/reviews/` |
| Capitoli Markdown | `md/<lang>/` |
| Capitoli LaTeX | `chapters/<lang>/` |
| Diagrammi PlantUML | `figures/<lang>/` |
| Configurazione condivisa | `tex/config.tex` |
| Configurazione per lingua | `tex/config-<lang>.tex` |
| Metadati EPUB per lingua | `ebook/metadata-<lang>.yaml` |
| Cover Amazon KDP | `covers/<lang>/` |
| Asset grafici cover | `covers/assets/` |
| Template cover | `covers/templates/` |

### Naming dei file

- Markdown: `<NN>-<nome-descrittivo>.md` (prefisso numerico per ordinamento)
- LaTeX capitoli: `ch<NN>-<nome>.tex`
- LaTeX appendici: `app-<lettera>-<nome>.tex`
- Revisioni: `<tipo>-ch<NN>-<lang>-<YYYY-MM-DD>.md`
- Valutazioni: `evaluation-<titolo-breve>-<YYYY-MM-DD>.md`

### Compilazione

```powershell
# PDF singola lingua
.\build.ps1 -Lang it -BookOnly

# EPUB singola lingua
.\build.ps1 -Lang it -EbookOnly

# Tutto (diagrammi + PDF + EPUB)
.\build.ps1 -Lang it

# Tutte le lingue
.\build.ps1 -Lang all

# Pulizia
.\build.ps1 -Clean
```

### Memoria di Progetto (`CONTEXT.md`)

Il file `CONTEXT.md` nella root del progetto è la **memoria persistente** del workflow editoriale. Permette all'agente di riprendere il lavoro tra sessioni diverse sapendo esattamente cosa è stato fatto, cosa è in corso e cosa è pianificato.

#### Quando leggere

- **Sempre all'inizio di ogni conversazione**, prima di qualsiasi altra operazione
- Quando l'utente chiede lo stato del progetto
- Quando si deve decidere il passo successivo

#### Quando aggiornare

Aggiornare `CONTEXT.md` al termine di ogni operazione significativa:
- Completamento di una fase o sotto-fase
- Scrittura o revisione di un capitolo
- Decisioni importanti (cambio struttura, aggiunta lingua, ecc.)
- Passaggio da una fase all'altra

#### Formato

Il file usa questa struttura fissa:

```markdown
# Contesto del Progetto

> Ultimo aggiornamento: YYYY-MM-DD

## Fase Corrente

Fase N — Nome Fase (breve descrizione dello stato)

## Stato dei Capitoli

| # | File | Stato | Fase | Ultima modifica | Note |
|---|------|-------|------|-----------------|------|
| 0 | 00-introduzione.md | ✅ completato | Fase 6 | 2026-03-15 | Bozze corrette |
| 1 | 01-capitolo-01.md | 📝 in corso | Fase 3 | 2026-03-20 | Prima bozza |
| 2 | 02-capitolo-02.md | ⬜ da fare | — | — | — |

## Attività Completate

- [YYYY-MM-DD] Descrizione attività completata
- [YYYY-MM-DD] Descrizione attività completata

## Attività in Corso

- Descrizione attività in corso (fase, capitolo, dettagli)

## Attività Pianificate

- Prossima attività da fare
- Attività successive

## Decisioni e Note

- [YYYY-MM-DD] Decisione o nota rilevante per il progetto
```

#### Regole

- Usare le icone standard: ✅ completato, 📝 in corso, ⬜ da fare, ❌ bloccato
- Ogni voce nelle attività completate DEVE avere la data tra parentesi quadre
- Mantenere il file conciso: non duplicare il contenuto dei rapporti di revisione, fare solo riferimento
- Se il file non esiste, crearlo alla prima operazione significativa
- Non cancellare mai le attività completate (servono come storico)
