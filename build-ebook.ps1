# ============================================================
# Progetto Editoriale — Generazione EPUB con Pandoc
# Uso: .\build-ebook.ps1              # lingua da config.tex
#      .\build-ebook.ps1 -Lang en     # specifica una lingua
# ============================================================
# I file .md in md/<lang>/ vengono scoperti e ordinati automaticamente per nome.
# Usa prefissi numerici per controllare l'ordine:
#   00-introduzione.md, 01-capitolo-01.md, ..., 90-appendice-a.md
# ============================================================

param(
    [string]$Lang = ""
)

$ErrorActionPreference = "Stop"
$Root       = $PSScriptRoot
$EbookDir   = Join-Path $Root "ebook"

# --- Leggi stile da config.tex ---
$configFile = Join-Path $Root "tex" "config.tex"
$BookStyle  = "manning"  # default
if (Test-Path $configFile) {
    $match = Select-String -Path $configFile -Pattern '\\newcommand\{\\BookStyle\}\{(\w+)\}'
    if ($match) { $BookStyle = $match.Matches[0].Groups[1].Value }
}

# Lingua da parametro (obbligatoria o default it)
$BookLang = if ($Lang) { $Lang } else { "it" }

# Directory libro per questa lingua
$LibroDir   = Join-Path $Root "md" $BookLang
$OutputEpub = Join-Path $EbookDir "book-$BookLang.epub"
$Metadata   = Join-Path $EbookDir "metadata-$BookLang.yaml"

Write-Host "Lingua: $BookLang" -ForegroundColor Magenta

# Verifica che la cartella lingua esista
if (-not (Test-Path $LibroDir)) {
    Write-Host "ERRORE: cartella md/$BookLang non trovata. Esegui init-project.ps1 -Language $BookLang" -ForegroundColor Red
    exit 1
}

# Cerca CSS: prima styles/<stile>-style.css, poi style.css generico
$StyleCSS = Join-Path $EbookDir "styles" "${BookStyle}-style.css"
if (-not (Test-Path $StyleCSS)) {
    $StyleCSS = Join-Path $EbookDir "style.css"
}
Write-Host "Stile EPUB: $BookStyle ($StyleCSS)" -ForegroundColor Magenta

# --- Verifica pandoc ---
try { pandoc --version 2>&1 | Out-Null } catch {
    Write-Host "ERRORE: pandoc non trovato. Installa da https://pandoc.org" -ForegroundColor Red
    exit 1
}

# --- Crea directory ebook se non esiste ---
if (-not (Test-Path $EbookDir)) {
    New-Item -ItemType Directory -Path $EbookDir | Out-Null
}

# --- Scopri capitoli automaticamente ---
# I file .md in md/<lang>/ vengono ordinati alfabeticamente per nome.
# Usa prefissi numerici per controllare l'ordine:
#   00-introduzione.md, 01-capitolo-01.md, ..., 90-appendice-a.md
$mdFiles = Get-ChildItem -Path $LibroDir -Filter "*.md" | Sort-Object Name
if ($mdFiles.Count -eq 0) {
    Write-Host "ERRORE: nessun file .md trovato in md/$BookLang/" -ForegroundColor Red
    exit 1
}
$inputFiles = $mdFiles | ForEach-Object { $_.FullName }
Write-Host "Capitoli trovati: $($mdFiles.Count)" -ForegroundColor White
$mdFiles | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Gray }

# --- Genera EPUB ---
Write-Host "`n=== Generazione EPUB ===" -ForegroundColor Cyan
Write-Host "Capitoli: $($mdFiles.Count)"

# --- Comprimi copertina per KDP (< 5 MB consigliato) ---
$CoverSrc = Join-Path $Root "covers" $BookLang "ebook-cover.png"
# Fallback: vecchia posizione cover\cover.png
if (-not (Test-Path $CoverSrc)) {
    $CoverSrc = Join-Path $Root "cover\cover.png"
}
$CoverJpg = Join-Path $EbookDir "cover.jpg"

# Converti PNG → JPG se magick è disponibile, altrimenti usa il PNG
$useCover = $CoverSrc
if (Test-Path $CoverSrc) {
    try {
        & magick $CoverSrc -resize "1600x2560>" -quality 85 $CoverJpg 2>$null
        if (Test-Path $CoverJpg) { $useCover = $CoverJpg; Write-Host "Copertina compressa: cover.jpg" }
    } catch {
        Write-Host "ImageMagick non trovato, uso copertina originale PNG" -ForegroundColor Yellow
    }
} else {
    Write-Host "Copertina non trovata in cover\sviluppo-0code.png — EPUB senza copertina" -ForegroundColor Yellow
    $useCover = $null
}

$pandocArgs = @(
    "--toc"
    "--toc-depth=3"
    "--top-level-division=chapter"
    "--wrap=none"
    "--strip-comments"
    "--lua-filter=$EbookDir\split-code.lua"
    "--resource-path=$LibroDir;$Root\figures\$BookLang"
    "-f", "markdown+smart+pipe_tables+backtick_code_blocks+fenced_code_attributes"
    "-t", "epub3"
    "-o", $OutputEpub
)

# Aggiungi metadata se esiste
if (Test-Path $Metadata) {
    $pandocArgs += "--metadata-file=$Metadata"
}

# Aggiungi CSS se esiste
if (Test-Path $StyleCSS) {
    $pandocArgs += "--css=$StyleCSS"
}

# Aggiungi copertina se disponibile
if ($useCover -and (Test-Path $useCover)) {
    $pandocArgs += "--epub-cover-image=$useCover"
}

$pandocArgs += $inputFiles

& pandoc @pandocArgs

if (Test-Path $OutputEpub) {
    $size = [math]::Round((Get-Item $OutputEpub).Length / 1KB)
    Write-Host "`n✅ EPUB generato: ebook/book-$BookLang.epub ($size KB)" -ForegroundColor Green
} else {
    Write-Host "`nERRORE: EPUB non generato." -ForegroundColor Red
    exit 1
}
