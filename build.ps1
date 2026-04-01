# ============================================================
# Progetto Editoriale — Script di build (PowerShell)
# Compila PlantUML → PNG e libro LaTeX con LuaLaTeX
# ============================================================
# Uso:
#   .\build.ps1                 # Compila tutto (lingua da config.tex)
#   .\build.ps1 -Lang it        # Compila solo italiano
#   .\build.ps1 -Lang all       # Compila tutte le lingue configurate
#   .\build.ps1 -DiagramsOnly  # Solo diagrammi PlantUML (figures/)
#   .\build.ps1 -BookOnly      # Solo libro PDF
#   .\build.ps1 -EbookOnly     # Solo EPUB
#   .\build.ps1 -Clean         # Pulizia file temporanei
# ============================================================

param(
    [switch]$DiagramsOnly,
    [switch]$BookOnly,
    [switch]$EbookOnly,
    [switch]$Clean,
    [string]$Lang = ""
)

$ErrorActionPreference = "Stop"
$Root         = $PSScriptRoot
$BookDir      = Join-Path $Root "tex"
$DiagramsDir  = Join-Path $Root "figures"
$PlantUMLJar  = Join-Path $Root "tools\plantuml.jar"
$PlantUMLUrl  = "https://github.com/plantuml/plantuml/releases/download/v1.2025.2/plantuml-1.2025.2.jar"

# --- Lingua default ---
$DefaultLang = "it"

# --- Determina lingue da compilare ---
function Get-AvailableLangs {
    # Trova tutte le lingue dai file tex/book-<lang>.tex
    $bookFiles = Get-ChildItem -Path $BookDir -Filter "book-*.tex"
    $langs = $bookFiles | ForEach-Object {
        if ($_.BaseName -match '^book-(\w+)$') { $Matches[1] }
    }
    return $langs
}

if ($Lang -eq "all") {
    $LangsToProcess = @(Get-AvailableLangs)
    if ($LangsToProcess.Count -eq 0) {
        Write-Host "ERRORE: nessuna cartella lingua trovata in chapters/" -ForegroundColor Red
        exit 1
    }
    Write-Host "Lingue da compilare: $($LangsToProcess -join ', ')" -ForegroundColor Magenta
} elseif ($Lang) {
    $LangsToProcess = @($Lang)
} else {
    $LangsToProcess = @($DefaultLang)
}

function Build-Diagrams {
    param([string]$DiagramLang = "")

    # Se specificata una lingua, compila solo quella; altrimenti tutte le sottocartelle
    if ($DiagramLang) {
        $langDirs = @(Join-Path $DiagramsDir $DiagramLang)
    } else {
        $langDirs = @(Get-ChildItem -Path $DiagramsDir -Directory | ForEach-Object { $_.FullName })
    }

    if ($langDirs.Count -eq 0) {
        Write-Host "Nessuna cartella diagrammi trovata in figures/" -ForegroundColor Yellow
        return
    }

    Write-Host "`n=== Compilazione PlantUML → PNG ===" -ForegroundColor Cyan

    # Scarica plantuml.jar se non presente
    if (-not (Test-Path $PlantUMLJar)) {
        $toolsDir = Split-Path $PlantUMLJar
        if (-not (Test-Path $toolsDir)) { New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null }
        Write-Host "Scaricamento plantuml.jar..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $PlantUMLUrl -OutFile $PlantUMLJar
    }

    # Verifica Java
    try { java -version 2>&1 | Out-Null } catch {
        Write-Host "ERRORE: Java non trovato. Installa JDK/JRE." -ForegroundColor Red
        exit 1
    }

    $env:PLANTUML_LIMIT_SIZE = "16384"
    $totalCount = 0

    foreach ($langDir in $langDirs) {
        $lang = Split-Path $langDir -Leaf
        $pumlFiles = Get-ChildItem "$langDir\*.puml" -ErrorAction SilentlyContinue
        if ($pumlFiles.Count -eq 0) {
            Write-Host "  [$lang] Nessun file .puml trovato" -ForegroundColor Yellow
            continue
        }
        Write-Host "  [$lang] Compilazione $($pumlFiles.Count) diagrammi..." -ForegroundColor White
        java -jar $PlantUMLJar -tpng -Sdpi=300 "$langDir\*.puml"
        $count = (Get-ChildItem "$langDir\*.png" -ErrorAction SilentlyContinue).Count
        $totalCount += $count
    }

    Write-Host "`n$totalCount diagrammi PNG generati" -ForegroundColor Green
}

function Build-Book {
    param([string]$BuildLang)

    Write-Host "`n=== Compilazione libro [$BuildLang] con LuaLaTeX ===" -ForegroundColor Cyan

    # Verifica lualatex
    try { lualatex --version 2>&1 | Out-Null } catch {
        Write-Host "ERRORE: lualatex non trovato. Installa TeX Live o MiKTeX." -ForegroundColor Red
        exit 1
    }

    # Verifica che esista il file book-<lang>.tex
    $texFile = "book-$BuildLang"
    $texPath = Join-Path $BookDir "$texFile.tex"
    if (-not (Test-Path $texPath)) {
        Write-Host "ERRORE: $texFile.tex non trovato in tex/. Esegui init-project.ps1 -AddLang $BuildLang" -ForegroundColor Red
        return
    }

    Push-Location $BookDir
    try {
        # Prima passata
        Write-Host "Pass 1/4..."
        lualatex --interaction=nonstopmode --shell-escape "$texFile.tex" 2>&1 | Out-Null

        # Genera bibliografia (biber) e indice analitico
        Write-Host "Generazione bibliografia (biber)..."
        biber "$texFile" 2>&1 | Out-Null

        Write-Host "Generazione indice analitico..."
        makeindex "$texFile.idx" 2>&1 | Out-Null

        # Seconda passata (bibliografia + indice)
        Write-Host "Pass 2/4..."
        lualatex --interaction=nonstopmode --shell-escape "$texFile.tex" 2>&1 | Out-Null

        # Terza passata (cross-reference finali)
        Write-Host "Pass 3/4..."
        lualatex --interaction=nonstopmode --shell-escape "$texFile.tex" 2>&1 | Out-Null

        # Quarta passata (riferimenti definitivi)
        Write-Host "Pass 4/4..."
        lualatex --interaction=nonstopmode --shell-escape "$texFile.tex" 2>&1 | Out-Null

        $pdf = Join-Path $BookDir "$texFile.pdf"
        if (Test-Path $pdf) {
            $size = [math]::Round((Get-Item $pdf).Length / 1KB)
            Write-Host "`nLibro generato: $texFile.pdf ($size KB)" -ForegroundColor Green
        } else {
            Write-Host "ERRORE: PDF non generato. Controlla $texFile.log" -ForegroundColor Red
        }
    } finally {
        Pop-Location
    }
}

function Clean-Build {
    Write-Host "`n=== Pulizia file temporanei ===" -ForegroundColor Yellow

    # PNG dei diagrammi generati (in ogni sottocartella lingua)
    Get-ChildItem -Path $DiagramsDir -Directory | ForEach-Object {
        Get-ChildItem "$($_.FullName)\*.png" -ErrorAction SilentlyContinue | Remove-Item -Force
    }
    Write-Host "  Rimossi PNG diagrammi"

    # File ausiliari LaTeX
    $extensions = @("*.aux", "*.log", "*.toc", "*.out", "*.idx", "*.ilg", "*.ind",
                    "*.fls", "*.fdb_latexmk", "*.synctex.gz", "*.bbl", "*.blg")
    foreach ($ext in $extensions) {
        Get-ChildItem (Join-Path $BookDir $ext) -ErrorAction SilentlyContinue | Remove-Item -Force
    }
    # Ausiliari anche nelle sottocartelle (chapters/)
    foreach ($ext in $extensions) {
        Get-ChildItem (Join-Path $BookDir "chapters\$ext") -ErrorAction SilentlyContinue | Remove-Item -Force
    }
    Write-Host "  Rimossi file ausiliari LaTeX"
    Write-Host "Pulizia completata." -ForegroundColor Green
}

# === MAIN ===
Write-Host "============================================" -ForegroundColor White
Write-Host "  Progetto Editoriale — Build System" -ForegroundColor White
Write-Host "============================================" -ForegroundColor White

if ($Clean) {
    Clean-Build
} elseif ($DiagramsOnly) {
    foreach ($l in $LangsToProcess) {
        Build-Diagrams -DiagramLang $l
    }
} elseif ($BookOnly) {
    foreach ($l in $LangsToProcess) {
        Build-Book -BuildLang $l
    }
} elseif ($EbookOnly) {
    foreach ($l in $LangsToProcess) {
        & (Join-Path $Root "build-ebook.ps1") -Lang $l
    }
} else {
  		
    foreach ($l in $LangsToProcess) {
        Build-Diagrams -DiagramLang $l
        Build-Book -BuildLang $l
        & (Join-Path $Root "build-ebook.ps1") -Lang $l
    }
}

Write-Host "`nBuild completato!" -ForegroundColor Green
