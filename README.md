# Progetto Editoriale

Struttura completa per gestire un progetto editoriale tecnico multilingua con:

- **PDF** via LuaLaTeX (5 stili: Manning, O'Reilly, Pragmatic, Apress, No Starch)
- **EPUB** via Pandoc (CSS corrispondente per ogni stile)
- **Diagrammi** via PlantUML
- **Multilingua** — ogni lingua ha la propria cartella (8 lingue supportate)

## Struttura del Progetto

```
├── book.tex                    # Documento principale LaTeX
├── build.ps1                   # Build script PowerShell (Windows)
├── build-ebook.ps1             # Generazione EPUB
├── init-project.ps1            # Inizializzazione e aggiunta lingue
├── Makefile                    # Build script Make (Linux/macOS)
├── tex/
│   ├── config.tex              # ⭐ CONFIGURAZIONE: titolo, autore, stile, lingua
│   ├── references.bib          # Bibliografia BibLaTeX
│   ├── styles/                 # 5 stili tipografici (LaTeX + box)
│   │   ├── manning-style.tex / manning-boxes.tex
│   │   ├── oreilly-style.tex / oreilly-boxes.tex
│   │   ├── pragmatic-style.tex / pragmatic-boxes.tex
│   │   ├── apress-style.tex / apress-boxes.tex
│   │   └── nostarch-style.tex / nostarch-boxes.tex
│   └── lang/                   # 8 lingue (en, it, es, de, fr, pt, ja, zh)
├── chapters/
│   └── it/                     # Capitoli LaTeX per lingua (italiano incluso)
│       ├── frontmatter.tex
│       ├── ch00-introduzione.tex
│       ├── ch01-capitolo.tex
│       ├── ch02-capitolo.tex
│       └── app-a-glossario.tex
├── md/
│   └── it/                     # Capitoli Markdown per EPUB per lingua
│       ├── INTRODUZIONE.md
│       ├── parte-i/
│       └── appendici/
├── figures/                    # Diagrammi PlantUML (.puml → .png)
├── ebook/
│   ├── metadata.yaml           # Metadati EPUB
│   ├── style.css               # Stile EPUB generico
│   ├── split-code.lua          # Filtro Pandoc per codice lungo
│   └── styles/                 # 5 CSS EPUB (manning, oreilly, ecc.)
└── cover/                      # Copertina (cover.png)
```

## Quick Start

### 1. Configurazione

Modifica **`tex/config.tex`** con i dati del tuo libro:

```latex
\newcommand{\BookTitle}{Il Mio Libro}
\newcommand{\BookSubtitle}{Un sottotitolo accattivante}
\newcommand{\BookAuthor}{Mario Rossi}
\newcommand{\BookYear}{2026}
\newcommand{\BookStyle}{manning}   % manning | oreilly | pragmatic | apress | nostarch
```

### 2. Aggiungere capitoli

1. Crea un file `chapters/it/ch03-nome-capitolo.tex` copiando un capitolo esistente
2. Registralo in `tex/book-it.tex`:
   ```latex
   \input{../chapters/it/ch03-nome-capitolo}
   ```

### 3. Aggiungere una lingua

```powershell
.\init-project.ps1 -AddLang en     # crea chapters/en/, md/en/ e tex/book-en.tex
```

### 4. Compilazione

**Windows (PowerShell):**
```powershell
.\build.ps1                  # Compila tutto (lingua da config.tex)
.\build.ps1 -Lang it         # Compila solo italiano
.\build.ps1 -Lang all        # Compila tutte le lingue
.\build.ps1 -BookOnly        # Solo PDF
.\build.ps1 -EbookOnly       # Solo EPUB
.\build.ps1 -DiagramsOnly    # Solo diagrammi PlantUML
.\build.ps1 -Clean           # Pulizia file temporanei
```

**Linux/macOS (Make):**
```bash
make                  # Compila tutto
make book LANG=it     # Solo PDF italiano
make ebook LANG=en    # Solo EPUB inglese
make all-langs        # Tutte le lingue
make clean            # Pulizia
make help             # Mostra comandi disponibili
```

## Prerequisiti

| Strumento | Uso | Installazione |
|:--|:--|:--|
| **LuaLaTeX** | Compilazione PDF | [TeX Live](https://tug.org/texlive/) o [MiKTeX](https://miktex.org/) |
| **Biber** | Bibliografia | Incluso in TeX Live/MiKTeX |
| **Pandoc** | Generazione EPUB | [pandoc.org](https://pandoc.org/) |
| **Java** | PlantUML | JDK/JRE 8+ |
| **PlantUML** | Diagrammi | Scaricato automaticamente dal build script |

## Stili Disponibili

Cambia stile in `tex/config.tex` con `\BookStyle`:

| Stile | Caratteristiche |
|:--|:--|
| **manning** | Sans-serif, numero capitolo grande, rosso/grigio |
| **oreilly** | Serif elegante, layout 7×9.19", toni teal |
| **pragmatic** | Font Bookman, badge arancio, marginnotes |
| **apress** | Accademico, linee nere, numeri riga |
| **nostarch** | Schoolbook, sfondo scuro per codice, colori vivaci |

Ogni stile ha il corrispondente CSS per EPUB in `ebook/styles/`.

## Box Admonition

8 tipi di box admonition con etichette localizzate automaticamente:

| Box | Uso |
|:--|:--|
| `tipbox` | Suggerimenti e best practice |
| `warnbox` | Attenzione / errori comuni |
| `notebox` | Note informative |
| `dangerbox` | Pericoli e rischi critici |
| `versionbox` | Note di versione / compatibilità |
| `costbox` | Costi dei servizi |
| `checkpointbox` | Verifiche di avanzamento |
| `praticabox` | Esercizi pratici |

```latex
\begin{tipbox}
Un suggerimento utile per il lettore.
\end{tipbox}
```

## Lingue Supportate

| Codice | Lingua |
|:--|:--|
| `it` | Italiano (incluso come esempio) |
| `en` | English |
| `es` | Español |
| `de` | Deutsch |
| `fr` | Français |
| `pt` | Português |
| `ja` | 日本語 |
| `zh` | 中文 |

## Diagrammi PlantUML

Metti i file `.puml` in `figures/`. Vengono compilati automaticamente in PNG.

```latex
\begin{figure}[H]
  \centering
  \includegraphics[width=0.8\textwidth]{nome-diagramma}
  \caption{Didascalia.}
\end{figure}
```
