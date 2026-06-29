<#
.SYNOPSIS
    Compila i diagrammi PlantUML (.puml) del libro in PNG a 300 DPI.

.DESCRIPTION
    Cerca i file .puml sotto figures/ (per tutte le lingue o una specifica) e li
    renderizza in PNG nella stessa cartella. Per default rigenera solo i PNG
    mancanti o piu' vecchi del .puml; usa -Force per rigenerare tutto.

    PlantUML viene cercato in quest'ordine:
      1. comando 'plantuml' nel PATH (es. installato con scoop/choco)
      2. variabile d'ambiente PLANTUML_JAR (richiede 'java' nel PATH)
      3. un file plantuml*.jar dentro il repository (es. tools/)

.PARAMETER Lang
    Lingua da compilare (sottocartella di figures/). Default: 'all'.

.PARAMETER Force
    Rigenera tutti i PNG anche se gia' aggiornati.

.EXAMPLE
    .\build-diagrams.ps1
.EXAMPLE
    .\build-diagrams.ps1 -Lang it -Force
#>
[CmdletBinding()]
param(
    [string]$Lang = 'all',
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repoRoot   = $PSScriptRoot
$figuresDir = Join-Path $repoRoot 'figures'

function Fail($message) {
    Write-Host $message -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $figuresDir)) {
    Fail "Cartella figures/ non trovata in $repoRoot"
}

# --- Individua il runner PlantUML --------------------------------------------
function Resolve-PlantUml {
    $cli = Get-Command plantuml -ErrorAction SilentlyContinue
    if ($cli) {
        return @{ Kind = 'cli'; Exe = $cli.Source; Jar = $null }
    }

    $jar = $env:PLANTUML_JAR
    if (-not $jar) {
        $found = Get-ChildItem -Path $repoRoot -Recurse -Filter 'plantuml*.jar' -ErrorAction SilentlyContinue |
                 Select-Object -First 1
        if ($found) { $jar = $found.FullName }
    }
    if ($jar) {
        if (-not (Test-Path $jar)) {
            Fail "PLANTUML_JAR punta a un file inesistente: $jar"
        }
        if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
            Fail "Trovato il jar PlantUML ($jar) ma 'java' non e' nel PATH. Installa un JDK (es. scoop install temurin-jdk)."
        }
        return @{ Kind = 'jar'; Exe = 'java'; Jar = $jar }
    }

    Fail @"
PlantUML non trovato. Opzioni:
  - scoop install plantuml        (fornisce il comando 'plantuml', richiede Java)
  - oppure scarica plantuml.jar e imposta `$env:PLANTUML_JAR = 'C:\percorso\plantuml.jar'
    (richiede 'java' nel PATH: scoop install temurin-jdk)
"@
}

# --- Raccogli i .puml da compilare -------------------------------------------
if ($Lang -eq 'all') {
    $pumlFiles = Get-ChildItem -Path $figuresDir -Recurse -Filter '*.puml' -ErrorAction SilentlyContinue
} else {
    $langDir = Join-Path $figuresDir $Lang
    if (-not (Test-Path $langDir)) {
        Fail "Cartella figures/$Lang non trovata."
    }
    $pumlFiles = Get-ChildItem -Path $langDir -Recurse -Filter '*.puml' -ErrorAction SilentlyContinue
}

if (-not $pumlFiles) {
    Write-Host "Nessun file .puml trovato (Lang=$Lang)."
    exit 0
}

$plantuml = Resolve-PlantUml
Write-Host ("PlantUML: {0}" -f $(if ($plantuml.Kind -eq 'jar') { "java -jar $($plantuml.Jar)" } else { $plantuml.Exe }))
Write-Host ("Diagrammi trovati: {0}" -f $pumlFiles.Count)
Write-Host ''

$rendered = 0; $skipped = 0; $failed = 0

foreach ($puml in $pumlFiles) {
    $png = [System.IO.Path]::ChangeExtension($puml.FullName, '.png')

    if (-not $Force -and (Test-Path $png)) {
        $pngItem = Get-Item $png
        if ($pngItem.LastWriteTime -ge $puml.LastWriteTime) {
            Write-Host ("  [skip]  {0} (PNG aggiornato)" -f $puml.Name)
            $skipped++
            continue
        }
    }

    $plantArgs = @('-tpng', '-Sdpi=300', '-charset', 'UTF-8', $puml.FullName)
    if ($plantuml.Kind -eq 'jar') {
        $plantArgs = @('-jar', $plantuml.Jar) + $plantArgs
    }

    # stderr di PlantUML viene catturato; non usiamo 2>&1 (vedi note ambiente)
    & $plantuml.Exe @plantArgs
    if ($LASTEXITCODE -eq 0 -and (Test-Path $png)) {
        Write-Host ("  [ok]    {0} -> {1}" -f $puml.Name, (Split-Path $png -Leaf))
        $rendered++
    } else {
        Write-Warning ("  [FAIL]  {0} (exit {1})" -f $puml.Name, $LASTEXITCODE)
        $failed++
    }
}

Write-Host ''
Write-Host ("Fatto. Renderizzati: {0}  Saltati: {1}  Falliti: {2}" -f $rendered, $skipped, $failed)
if ($failed -gt 0) { exit 1 }
