# ============================================================
# init-project.ps1 — Inizializza un nuovo progetto editoriale
# ============================================================
# Configura il progetto e crea le cartelle per ogni lingua.
# La lingua italiana (it) è già inclusa come esempio.
# Per aggiungere altre lingue, usa -AddLang.
#
# Uso:
#   .\init-project.ps1                                    # interattivo
#   .\init-project.ps1 -Title "My Book" -Author "Author"  # parametri
#   .\init-project.ps1 -AddLang es                         # aggiunge una lingua
# ============================================================

param(
    [string]$Title = "",
    [string]$Author = "",
    [ValidateSet("en","it","es","de","fr","pt","ja","zh")]
    [string]$Language = "",
    [ValidateSet("en","it","es","de","fr","pt","ja","zh")]
    [string]$AddLang = ""
)

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Inizializzazione Progetto Editoriale" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# --- Se stiamo solo aggiungendo una lingua ---
if ($AddLang) {
    Write-Host "`nAggiunta lingua: $AddLang" -ForegroundColor Magenta
    $Language = $AddLang
} else {
    # --- Chiedi titolo e autore se non forniti ---
    if (-not $Title) {
        $Title = Read-Host "Titolo del libro"
    }
    if (-not $Author) {
        $Author = Read-Host "Autore"
    }
}

if (-not $Language) {
    Write-Host "Lingue disponibili: en (English), it (Italiano), es (Español),"
    Write-Host "  de (Deutsch), fr (Français), pt (Português), ja (日本語), zh (中文)"
    $Language = Read-Host "Lingua principale [it]"
    if (-not $Language) { $Language = "it" }
}

# ============================================================
# Crea cartella capitoli LaTeX per la lingua: chapters/<lang>/
# ============================================================
$langChaptersDir = Join-Path $Root "chapters" $Language
$sourceDir       = Join-Path $Root "chapters" "it"  # italiano = lingua di riferimento

# ============================================================
# Crea cartella diagrammi per la lingua: figures/<lang>/
# ============================================================
$langFiguresDir = Join-Path $Root "figures" $Language
$sourceFigures  = Join-Path $Root "figures" "it"  # italiano = lingua di riferimento

if (-not (Test-Path $langFiguresDir)) {
    New-Item -ItemType Directory -Path $langFiguresDir -Force | Out-Null
    Write-Host "  Creata cartella: figures/$Language/" -ForegroundColor Green

    # Copia i file .puml dalla lingua di riferimento
    if (Test-Path $sourceFigures) {
        Get-ChildItem -Path $sourceFigures -Filter "*.puml" | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $langFiguresDir $_.Name)
            Write-Host "    Copiato: $($_.Name)" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  Esiste già: figures/$Language/" -ForegroundColor Yellow
}

if (-not (Test-Path $langChaptersDir)) {
    New-Item -ItemType Directory -Path $langChaptersDir -Force | Out-Null
    Write-Host "  Creata cartella: chapters/$Language/" -ForegroundColor Green

    # Copia i capitoli dalla lingua di riferimento (it)
    Get-ChildItem -Path $sourceDir -Filter "*.tex" | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $langChaptersDir $_.Name)
        Write-Host "    Copiato: $($_.Name)" -ForegroundColor Green
    }

    # Crea cartella figures per la lingua
    $figuresDir = Join-Path $langChaptersDir "figures"
    New-Item -ItemType Directory -Path $figuresDir -Force | Out-Null
    Write-Host "    Creata: chapters/$Language/figures/" -ForegroundColor Green
} else {
    Write-Host "  Esiste già: chapters/$Language/" -ForegroundColor Yellow
}

# ============================================================
# Crea config-<lang>.tex per la lingua
# ============================================================
$langConfigFile = Join-Path $Root "tex" "config-$Language.tex"
$sourceConfig   = Join-Path $Root "tex" "config-it.tex"

if (-not (Test-Path $langConfigFile)) {
    if (Test-Path $sourceConfig) {
        Copy-Item $sourceConfig $langConfigFile
        Write-Host "  Creato: tex/config-$Language.tex" -ForegroundColor Green
    }
}

# ============================================================
# Crea file book-<lang>.tex se non esiste
# ============================================================
$bookTexFile = Join-Path $Root "tex" "book-$Language.tex"
$sourceBookTex = Join-Path $Root "tex" "book-it.tex"  # italiano = riferimento

if (-not (Test-Path $bookTexFile)) {
    if (Test-Path $sourceBookTex) {
        # Copia dal file italiano e adatta i percorsi
        $content = Get-Content $sourceBookTex -Raw
        $content = $content -replace 'chapters/it/', "chapters/$Language/"
        $content = $content -replace 'figures/it/', "figures/$Language/"
        $content = $content -replace 'book-it\.tex', "book-$Language.tex"
        $content = $content -replace 'lang/it', "lang/$Language"
        Set-Content $bookTexFile $content -NoNewline
        Write-Host "  Creato: tex/book-$Language.tex" -ForegroundColor Green
        Write-Host "  NOTA: Modifica tex/book-$Language.tex per adattare nomi capitoli e parti." -ForegroundColor Yellow
    } else {
        Write-Host "  ATTENZIONE: tex/book-it.tex non trovato. Crea manualmente tex/book-$Language.tex" -ForegroundColor Red
    }
} else {
    Write-Host "  Esiste già: tex/book-$Language.tex" -ForegroundColor Yellow
}

# ============================================================
# Crea cartella Markdown per la lingua: md/<lang>/
# I file .md hanno prefisso numerico per l'ordine di concatenazione:
#   00-introduzione.md, 01-capitolo-01.md, ..., 90-appendice-a.md
# ============================================================
$langLibroDir = Join-Path $Root "md" $Language
$sourceLibro  = Join-Path $Root "md" "it"  # italiano = lingua di riferimento

if (-not (Test-Path $langLibroDir)) {
    New-Item -ItemType Directory -Path $langLibroDir -Force | Out-Null
    # Copia solo i file .md (struttura piatta, no sottocartelle)
    Get-ChildItem -Path $sourceLibro -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $langLibroDir $_.Name)
        Write-Host "    Copiato: $($_.Name)" -ForegroundColor Green
    }
    Write-Host "  Creata struttura: md/$Language/" -ForegroundColor Green
} else {
    Write-Host "  Esiste già: md/$Language/" -ForegroundColor Yellow
}

# Se stiamo solo aggiungendo una lingua, creiamo anche i metadati EPUB
if ($AddLang) {
    $langMetaFile = Join-Path $Root "ebook" "metadata-$AddLang.yaml"
    $sourceMetaFile = Join-Path $Root "ebook" "metadata-it.yaml"
    if (-not (Test-Path $langMetaFile)) {
        if (Test-Path $sourceMetaFile) {
            Copy-Item $sourceMetaFile $langMetaFile
            Write-Host "  Creato: ebook/metadata-$AddLang.yaml" -ForegroundColor Green
        }
    }

    Write-Host "`n============================================" -ForegroundColor Cyan
    Write-Host "  Lingua $AddLang aggiunta!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Cartelle e file creati:" -ForegroundColor White
    Write-Host "  figures/$AddLang/              (diagrammi PlantUML)"
    Write-Host "  chapters/$AddLang/            (capitoli LaTeX)"
    Write-Host "  md/$AddLang/                  (capitoli Markdown per EPUB)"
    Write-Host "  tex/book-$AddLang.tex         (file LaTeX principale)"
    Write-Host "  tex/config-$AddLang.tex       (metadati edizione: titolo, sottotitolo)"
    Write-Host "  ebook/metadata-$AddLang.yaml  (metadati EPUB)"
    Write-Host ""
    Write-Host "Per compilare questa lingua:"
    Write-Host "  .\build.ps1 -Lang $AddLang"
    exit 0
}

# ============================================================
# Crea directory di supporto
# ============================================================

# --- Crea directory cover ---
$coverDir = Join-Path $Root "cover"
if (-not (Test-Path $coverDir)) {
    New-Item -ItemType Directory -Path $coverDir -Force | Out-Null
    Write-Host "  Creata directory: cover/" -ForegroundColor Green
}

# --- Aggiorna config.tex (impostazioni condivise: autore) ---
$configFile = Join-Path $Root "tex\config.tex"
if ((Test-Path $configFile) -and $Author) {
    $content = Get-Content $configFile -Raw
    $content = $content -replace 'Nome Autore', $Author
    Set-Content $configFile $content -NoNewline
    Write-Host "  Aggiornato: tex/config.tex (autore)" -ForegroundColor Green
}

# --- Aggiorna config-<lang>.tex (metadati per lingua: titolo) ---
$langConfigFile = Join-Path $Root "tex\config-$Language.tex"
if (Test-Path $langConfigFile) {
    $content = Get-Content $langConfigFile -Raw
    if ($Title) {
        $content = $content -replace 'Titolo del Libro', $Title
    }
    Set-Content $langConfigFile $content -NoNewline
    Write-Host "  Aggiornato: tex/config-$Language.tex (titolo)" -ForegroundColor Green
}

# --- Aggiorna metadata-<lang>.yaml per EPUB ---
$langMetaFile = Join-Path $Root "ebook\metadata-$Language.yaml"
if (-not (Test-Path $langMetaFile)) {
    $sourceMetaFile = Join-Path $Root "ebook\metadata-it.yaml"
    if (Test-Path $sourceMetaFile) {
        Copy-Item $sourceMetaFile $langMetaFile
    }
}
if (Test-Path $langMetaFile) {
    $metaContent = Get-Content $langMetaFile -Raw
    if ($Title) {
        $metaContent = $metaContent -replace 'Titolo del Libro', $Title
    }
    if ($Author) {
        $metaContent = $metaContent -replace 'Nome Autore', $Author
    }
    Set-Content $langMetaFile $metaContent -NoNewline
    Write-Host "  Aggiornato: ebook/metadata-$Language.yaml" -ForegroundColor Green
}

# ============================================================
# Riepilogo
# ============================================================
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  Progetto inizializzato!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Struttura lingua '$Language':" -ForegroundColor White
Write-Host "  figures/$Language/                (diagrammi PlantUML)"
Write-Host "  chapters/$Language/              (capitoli LaTeX per PDF)"
Write-Host "  md/$Language/                    (capitoli Markdown per EPUB)"
Write-Host "  tex/book-$Language.tex           (file LaTeX principale)"
Write-Host "  tex/config-$Language.tex         (metadati edizione: titolo, sottotitolo)"
Write-Host "  ebook/metadata-$Language.yaml    (metadati EPUB)"
Write-Host ""
Write-Host "Prossimi passi:" -ForegroundColor White
Write-Host "  1. Modifica tex/config.tex con autore e stile"
Write-Host "  2. Modifica tex/config-$Language.tex con titolo e sottotitolo"
Write-Host "  3. Modifica tex/book-$Language.tex per aggiungere capitoli"
Write-Host "  4. Scrivi i capitoli in chapters/$Language/"
Write-Host "  5. Compila con: .\build.ps1 -Lang $Language"
Write-Host ""
Write-Host "Per aggiungere un'altra lingua:" -ForegroundColor White
Write-Host "  .\init-project.ps1 -AddLang en"
Write-Host ""
Write-Host "Per compilare tutte le lingue:" -ForegroundColor White
Write-Host "  .\build.ps1 -Lang all"
Write-Host ""
