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
$LibroDir   = Join-Path $Root "chapters" $BookLang
$TexMain    = Join-Path $Root "tex" "book-$BookLang.tex"
$OutputEpub = Join-Path $EbookDir "book-$BookLang.epub"
$Metadata   = Join-Path $EbookDir "metadata-$BookLang.yaml"

Write-Host "Lingua: $BookLang" -ForegroundColor Magenta

# Verifica che il file LaTeX principale esista
if (-not (Test-Path $TexMain)) {
    Write-Host "ERRORE: file LaTeX principale $TexMain non trovato." -ForegroundColor Red
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

# --- Pre-processing: sostituisci simboli LaTeX non gestiti da Pandoc ---
# \checkmark, \cmark, \xmark vengono ignorati da Pandoc fuori da math mode.
# Li sostituiamo con caratteri Unicode nei file .tex prima della conversione.
$texFiles = Get-ChildItem -Path (Join-Path $Root "chapters" $BookLang) -Filter "*.tex"
$backupDir = Join-Path $Root "chapters" $BookLang ".epub-backup"
if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }

foreach ($f in $texFiles) {
    # Backup originale
    Copy-Item $f.FullName (Join-Path $backupDir $f.Name) -Force
    # Sostituisci simboli
    $content = Get-Content $f.FullName -Raw -Encoding UTF8
    $content = $content -replace '\\checkmark(?:\{\})?', '✓'
    $content = $content -replace '\\cmark(?:\{\})?', '✓'
    $content = $content -replace '\\xmark(?:\{\})?', '✗'
    Set-Content $f.FullName -Value $content -Encoding UTF8 -NoNewline
}

# --- Genera EPUB ---
Write-Host "`n=== Generazione EPUB (da LaTeX) ===" -ForegroundColor Cyan
Write-Host "File sorgente: tex/book-$BookLang.tex"

# --- Comprimi copertina per KDP (< 5 MB consigliato) ---
$CoverSrc = Join-Path $Root "covers" $BookLang "ebook-cover-$BookLang.jpg"
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
    Write-Host "Copertina non trovata — EPUB senza copertina" -ForegroundColor Yellow
    $useCover = $null
}

$pandocArgs = @(
    "--toc"
    "--toc-depth=3"
    "--top-level-division=chapter"
    "--wrap=none"
    "--strip-comments"
    "--lua-filter=$EbookDir\handle-boxes.lua"
    "--lua-filter=$EbookDir\split-code.lua"
    "--lua-filter=$EbookDir\math-to-text.lua"
    "--lua-filter=$EbookDir\strip-epub-colophon.lua"
    "--resource-path=$Root\tex;$Root\chapters\$BookLang;$Root\figures;$Root\figures\$BookLang;$Root"
    "-f", "latex+smart"
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

$pandocArgs += $TexMain

# Cambia directory di lavoro in 'tex' per permettere a Pandoc di risolvere i percorsi relativi (\input)
Push-Location (Join-Path $Root "tex")
& pandoc @pandocArgs
Pop-Location

# --- Ripristina i file .tex originali dopo la conversione EPUB ---
foreach ($f in $texFiles) {
    $backup = Join-Path $backupDir $f.Name
    if (Test-Path $backup) {
        Copy-Item $backup $f.FullName -Force
    }
}
Remove-Item $backupDir -Recurse -Force -ErrorAction SilentlyContinue

if (-not (Test-Path $OutputEpub)) {
    Write-Host "`nERRORE: EPUB non generato." -ForegroundColor Red
    exit 1
}

# --- Fix EPUB3 Landmarks for Amazon KDP ---
# Amazon KDP needs a "bodymatter" landmark to identify the "Start Reading Location".
# Pandoc doesn't generate this from LaTeX \frontmatter/\mainmatter commands.
# This step adds the missing landmark to nav.xhtml and a <reference type="text">
# to the OPF <guide> section, so KDP opens at the first real chapter.
Write-Host "`n--- Fixing EPUB landmarks for Amazon KDP ---" -ForegroundColor Cyan

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

try {
    $zip = [System.IO.Compression.ZipFile]::Open(
        $OutputEpub, [System.IO.Compression.ZipArchiveMode]::Update)

    # --- Read nav.xhtml ---
    $navEntry = $zip.GetEntry("EPUB/nav.xhtml")
    $navContent = $null
    $bodyFile = $null
    $bodyTitle = $null

    if ($navEntry) {
        $stream = $navEntry.Open()
        $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::UTF8)
        $navContent = $reader.ReadToEnd()
        $reader.Dispose(); $stream.Dispose()
    }

    if ($navContent -and $navContent -notmatch 'epub:type="bodymatter"') {
        # Find unique chapter files referenced in the TOC
        $chapterRefs = [regex]::Matches(
            $navContent, 'href="(text/ch\d+\.xhtml)(?:#[^"]*)?">([^<]+)')

        $seen = [ordered]@{}
        foreach ($m in $chapterRefs) {
            $file = $m.Groups[1].Value
            $title = $m.Groups[2].Value
            if (-not $seen.Contains($file)) { $seen[$file] = $title }
        }
        $uniqueChapters = @($seen.Keys)

        # Second unique chapter = bodymatter start (first is frontmatter/intro)
        if ($uniqueChapters.Count -ge 2) {
            $bodyFile  = $uniqueChapters[1]
            $bodyTitle = $seen[$bodyFile]

            $landmarkLi = "    <li>`n      <a href=`"$bodyFile`" epub:type=`"bodymatter`">$bodyTitle</a>`n    </li>"
            $navContent = $navContent -replace '(\s*</ol>\s*</nav>\s*</body>)', "`n$landmarkLi`$1"

            # Write modified nav.xhtml back
            $navEntry.Delete()
            $newNav = $zip.CreateEntry("EPUB/nav.xhtml",
                [System.IO.Compression.CompressionLevel]::Optimal)
            $ws = $newNav.Open()
            $writer = [System.IO.StreamWriter]::new($ws, $utf8NoBom)
            $writer.Write($navContent)
            $writer.Dispose(); $ws.Dispose()

            Write-Host "  Landmark bodymatter → $bodyFile ($bodyTitle)" -ForegroundColor Green
        } else {
            Write-Host "  ATTENZIONE: capitoli insufficienti per determinare il bodymatter" -ForegroundColor Yellow
        }
    } elseif ($navContent) {
        Write-Host "  Landmark bodymatter già presente" -ForegroundColor Green
    }

    # --- Fix content.opf <guide> ---
    if ($bodyFile) {
        $opfEntry = $zip.GetEntry("EPUB/content.opf")
        if ($opfEntry) {
            $stream = $opfEntry.Open()
            $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::UTF8)
            $opfContent = $reader.ReadToEnd()
            $reader.Dispose(); $stream.Dispose()

            if ($opfContent -notmatch 'type="text"') {
                $guideRef = "<reference type=`"text`" title=`"$bodyTitle`" href=`"$bodyFile`" />"
                if ($opfContent -match '</guide>') {
                    $opfContent = $opfContent -replace '(</guide>)', "$guideRef`n`$1"
                } else {
                    $opfContent = $opfContent -replace '(</package>)', "<guide>`n$guideRef`n</guide>`n`$1"
                }

                $opfEntry.Delete()
                $newOpf = $zip.CreateEntry("EPUB/content.opf",
                    [System.IO.Compression.CompressionLevel]::Optimal)
                $ws = $newOpf.Open()
                $writer = [System.IO.StreamWriter]::new($ws, $utf8NoBom)
                $writer.Write($opfContent)
                $writer.Dispose(); $ws.Dispose()

                Write-Host "  Guide reference type=text → $bodyFile" -ForegroundColor Green
            } else {
                Write-Host "  Guide reference type=text già presente" -ForegroundColor Green
            }
        }
    }

    $zip.Dispose()
    Write-Host "  KDP landmarks OK ✅" -ForegroundColor Green

} catch {
    Write-Host "  ATTENZIONE: impossibile correggere i landmark EPUB: $_" -ForegroundColor Yellow
    if ($zip) { try { $zip.Dispose() } catch {} }
}

$size = [math]::Round((Get-Item $OutputEpub).Length / 1KB)
Write-Host "`n✅ EPUB generato: ebook/book-$BookLang.epub ($size KB)" -ForegroundColor Green
