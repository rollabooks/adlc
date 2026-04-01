# ============================================================
# Progetto Editoriale — Makefile
# Compila PlantUML → PNG, libro LaTeX e EPUB
# ============================================================
# Uso:
#   make                    # Compila tutto (lingua default)
#   make LANG=en            # Compila lingua specifica
#   make book LANG=en       # Solo PDF lingua specifica
#   make ebook LANG=it      # Solo EPUB lingua specifica
#   make all-langs          # Compila TUTTE le lingue
#   make diagrams           # Solo diagrammi PlantUML (figures/)
#   make clean              # Pulizia file generati
#   make help               # Mostra comandi disponibili
# ============================================================

PLANTUML_JAR  := tools/plantuml.jar
PLANTUML_URL  := https://github.com/plantuml/plantuml/releases/download/v1.2025.2/plantuml-1.2025.2.jar
DIAGRAMS_SRC  := figures
BOOK_DIR      := tex

# --- Lingua (da parametro LANG= oppure default it) ---
LANG ?= it

# Trova tutte le lingue disponibili (da tex/book-*.tex)
AVAILABLE_LANGS := $(patsubst $(BOOK_DIR)/book-%.tex,%,$(wildcard $(BOOK_DIR)/book-*.tex))

PUML_FILES    := $(wildcard $(DIAGRAMS_SRC)/*.puml)
EBOOK_DIR     := ebook
LIBRO_DIR     := md/$(LANG)

# I file .md vengono scoperti automaticamente e ordinati per nome.
# Usa prefissi numerici per controllare l'ordine:
#   00-introduzione.md, 01-capitolo-01.md, ..., 90-appendice-a.md
MD_FILES := $(sort $(wildcard $(LIBRO_DIR)/*.md))

.PHONY: all diagrams book ebook clean help all-langs

all: diagrams book ebook  ## Compila tutto (lingua da LANG= o config.tex)

help:  ## Mostra questo help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# --- PlantUML ---
$(PLANTUML_JAR):
	@mkdir -p tools
	@echo "⬇ Scaricamento plantuml.jar..."
	curl -fsSL -o $@ $(PLANTUML_URL)

diagrams: $(PLANTUML_JAR) $(PUML_FILES)  ## Compila .puml → .png
	@echo "🔨 Compilazione diagrammi PlantUML..."
	java -jar $(PLANTUML_JAR) -tpng -Sdpi=300 $(DIAGRAMS_SRC)/*.puml
	@echo "✅ Diagrammi generati"

# --- LuaLaTeX ---
book: diagrams  ## Compila il libro PDF (usa LANG= per la lingua)
	@echo "📖 Compilazione libro [$(LANG)] con LuaLaTeX..."
	@# Verifica che esista book-<lang>.tex
	@test -f $(BOOK_DIR)/book-$(LANG).tex || { echo "❌ ERRORE: $(BOOK_DIR)/book-$(LANG).tex non trovato"; exit 1; }
	cd $(BOOK_DIR) && lualatex --interaction=nonstopmode --shell-escape book-$(LANG).tex
	@echo "📖 Generazione bibliografia (biber)..."
	cd $(BOOK_DIR) && biber book-$(LANG) || true
	@echo "📖 Generazione indice analitico..."
	cd $(BOOK_DIR) && makeindex book-$(LANG).idx || true
	@echo "📖 Pass 2/4..."
	cd $(BOOK_DIR) && lualatex --interaction=nonstopmode --shell-escape book-$(LANG).tex
	@echo "📖 Pass 3/4..."
	cd $(BOOK_DIR) && lualatex --interaction=nonstopmode --shell-escape book-$(LANG).tex
	@echo "📖 Pass 4/4..."
	cd $(BOOK_DIR) && lualatex --interaction=nonstopmode --shell-escape book-$(LANG).tex
	@echo "✅ Libro generato: $(BOOK_DIR)/book-$(LANG).pdf"

# --- EPUB ---
ebook: $(MD_FILES)  ## Genera EPUB (usa LANG= per la lingua)
	@echo "📱 Generazione EPUB [$(LANG)]..."
	@test -d $(LIBRO_DIR) || { echo "❌ ERRORE: $(LIBRO_DIR) non trovata"; exit 1; }
	@mkdir -p $(EBOOK_DIR)
	pandoc \
		--metadata-file=$(EBOOK_DIR)/metadata-$(LANG).yaml \
		--css=$(EBOOK_DIR)/style.css \
		--lua-filter=$(EBOOK_DIR)/split-code.lua \
		--toc --toc-depth=3 --top-level-division=chapter \
		--wrap=none \
		--resource-path=$(LIBRO_DIR):$(DIAGRAMS_SRC) \
		-f markdown+smart+pipe_tables+backtick_code_blocks+fenced_code_attributes \
		-t epub3 \
		-o $(EBOOK_DIR)/book-$(LANG).epub \
		$(MD_FILES)
	@echo "✅ EPUB generato: $(EBOOK_DIR)/book-$(LANG).epub"

# --- Compila tutte le lingue ---
all-langs: diagrams  ## Compila PDF e EPUB per TUTTE le lingue disponibili
	@echo "🌍 Lingue disponibili: $(AVAILABLE_LANGS)"
	@for lang in $(AVAILABLE_LANGS); do \
		echo ""; \
		echo "========== Lingua: $$lang =========="; \
		$(MAKE) book ebook LANG=$$lang; \
	done

# --- Pulizia ---
clean:  ## Rimuovi file generati
	rm -f $(DIAGRAMS_SRC)/*.png
	rm -f $(EBOOK_DIR)/book-*.epub
	cd $(BOOK_DIR) && rm -f *.aux *.log *.toc *.out *.idx *.ilg *.ind \
		*.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg *.bcf *.run.xml *.pdf
	@echo "🧹 Pulizia completata"
