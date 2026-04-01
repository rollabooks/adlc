# ============================================================
# ADLC Book - Code extractor for official repository
# Usage:
#   .\extract-code.ps1
#   .\extract-code.ps1 -OutputDir .\official-book-code -IncludeTextBlocks
#   .\extract-code.ps1 -SourceDir .\libro -CopyDiagrams
# ============================================================

param(
    [string]$SourceDir = (Join-Path $PSScriptRoot "libro"),
    [string]$OutputDir = (Join-Path $PSScriptRoot "official-book-code"),
    [switch]$IncludeTextBlocks,
    [switch]$IncludeAllMarkdown,
    [switch]$GroupByStack,
    [switch]$CopyDiagrams,
    [switch]$NoClean
)

$ErrorActionPreference = "Stop"

function Normalize-Lang([string]$raw) {
    if ([string]::IsNullOrWhiteSpace($raw)) { return "" }

    $value = $raw.Trim().ToLower()

    if ($value.StartsWith("{")) {
        # Supports forms like: {.bash .numberLines}
        $m = [regex]::Match($value, "\.([a-z0-9_+\-]+)")
        if ($m.Success) { return $m.Groups[1].Value }
    }

    # Pick first token for headers like: "bash title=..."
    $token = ($value -split "\s+")[0]
    return $token.Trim()
}

function Sanitize-Name([string]$value) {
    if ([string]::IsNullOrWhiteSpace($value)) { return "snippet" }
    $s = $value.ToLower() -replace "[^a-z0-9._-]", "-"
    $s = $s -replace "-+", "-"
    $s = $s.Trim('-')
    if ([string]::IsNullOrWhiteSpace($s)) { return "snippet" }
    return $s
}

function Get-StackFromSource([string]$sourceFile) {
    if ([string]::IsNullOrWhiteSpace($sourceFile)) { return "other" }

    $s = ($sourceFile -replace "\\", "/").ToLower()

    if ($s -eq "introduzione.md") { return "foundations" }
    if ($s.StartsWith("parte-i-il-paradigma/")) { return "foundations" }

    if ($s.StartsWith("parte-ii-primi-progetti/")) {
        if ($s.Contains("capitolo-04-") -or $s.Contains("capitolo-05-") -or $s.Contains("capitolo-06-")) {
            return "backend"
        }
        return "backend"
    }

    if ($s.StartsWith("parte-iii-web-fullstack/")) {
        if ($s.Contains("capitolo-09-")) { return "frontend" }
        if ($s.Contains("capitolo-10-")) { return "fullstack" }
        return "backend"
    }

    if ($s.StartsWith("parte-iv-flutter-mobile/")) { return "mobile" }

    if ($s.StartsWith("parte-v-qualita-e-produzione/")) {
        if ($s.Contains("capitolo-15-")) { return "devops" }
        return "quality"
    }

    if ($s.StartsWith("parte-vi-avanzato/")) { return "advanced" }
    if ($s.StartsWith("appendici/")) { return "appendix" }

    return "other"
}

$extMap = @{
    "bash"       = "sh"
    "sh"         = "sh"
    "shell"      = "sh"
    "pwsh"       = "ps1"
    "powershell" = "ps1"
    "yaml"       = "yaml"
    "yml"        = "yaml"
    "json"       = "json"
    "jsonc"      = "json"
    "javascript" = "js"
    "js"         = "js"
    "typescript" = "ts"
    "ts"         = "ts"
    "python"     = "py"
    "py"         = "py"
    "dart"       = "dart"
    "go"         = "go"
    "java"       = "java"
    "kotlin"     = "kt"
    "swift"      = "swift"
    "ruby"       = "rb"
    "rust"       = "rs"
    "php"        = "php"
    "markdown"   = "md"
    "md"         = "md"
    "ini"        = "ini"
    "toml"       = "toml"
    "xml"        = "xml"
    "html"       = "html"
    "css"        = "css"
    "scss"       = "scss"
    "sql"        = "sql"
    "dockerfile" = "dockerfile"
    "docker"     = "dockerfile"
    "plantuml"   = "puml"
    "puml"       = "puml"
    "text"       = "txt"
    "txt"        = "txt"
    ""           = "txt"
}

if (-not (Test-Path $SourceDir)) {
    throw "SourceDir non trovato: $SourceDir"
}

if ((Test-Path $OutputDir) -and (-not $NoClean)) {
    Remove-Item $OutputDir -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$snippetsDir = Join-Path $OutputDir "snippets"
New-Item -ItemType Directory -Path $snippetsDir -Force | Out-Null

$manifest = New-Object System.Collections.Generic.List[Object]
$totalBlocks = 0
$totalFiles = 0

Write-Host "`n=== Extracting code blocks from Markdown chapters ===" -ForegroundColor Cyan
Write-Host "Source: $SourceDir"
Write-Host "Output: $OutputDir"

$mdFiles = Get-ChildItem -Path $SourceDir -Recurse -Filter "*.md"

if (-not $IncludeAllMarkdown) {
    $mdFiles = $mdFiles | Where-Object {
        $_.Name -eq "INTRODUZIONE.md" -or
        $_.Name -like "capitolo-*.md" -or
        $_.Name -like "appendice-*.md"
    }
}

$mdFiles = $mdFiles | Sort-Object FullName

foreach ($md in $mdFiles) {
    $lines = Get-Content -LiteralPath $md.FullName
    if ($lines.Count -eq 0) { continue }

    $rel = [System.IO.Path]::GetRelativePath($SourceDir, $md.FullName)
    $relUnix = ($rel -replace "\\", "/")
    $chapterKey = [System.IO.Path]::ChangeExtension($relUnix, $null)
    $chapterDir = Join-Path $snippetsDir ($chapterKey.Replace('/', '\\'))

    $inFence = $false
    $fenceChar = ""
    $fenceLen = 0
    $lang = ""
    $buffer = New-Object System.Collections.Generic.List[string]
    $startLine = 0
    $blockIndex = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        if (-not $inFence) {
            $open = [regex]::Match($line, '^(?<fence>`{3,}|~{3,})\s*(?<lang>.*)$')
            if ($open.Success) {
                $inFence = $true
                $fenceChar = $open.Groups['fence'].Value.Substring(0, 1)
                $fenceLen = $open.Groups['fence'].Value.Length
                $lang = Normalize-Lang $open.Groups['lang'].Value
                $buffer.Clear()
                $startLine = $i + 1
            }
            continue
        }

        $closePattern = "^(" + [regex]::Escape($fenceChar) + "{" + $fenceLen + ",})\s*$"
        if ($line -match $closePattern) {
            $inFence = $false
            $blockIndex++

            $effectiveLang = $lang
            if ([string]::IsNullOrWhiteSpace($effectiveLang)) { $effectiveLang = "snippet" }

            if (($effectiveLang -eq "snippet") -and (-not $IncludeTextBlocks)) {
                continue
            }

            $extKey = if ($extMap.ContainsKey($lang)) { $lang } else { "" }
            $ext = if ($extMap.ContainsKey($extKey)) { $extMap[$extKey] } else { "txt" }
            $label = Sanitize-Name $effectiveLang
            $fileName = "{0:D3}-{1}.{2}" -f $blockIndex, $label, $ext

            New-Item -ItemType Directory -Path $chapterDir -Force | Out-Null
            $outPath = Join-Path $chapterDir $fileName
            $content = ($buffer -join "`n")
            [System.IO.File]::WriteAllText($outPath, $content, [System.Text.UTF8Encoding]::new($false))

            $outRel = ([System.IO.Path]::GetRelativePath($OutputDir, $outPath) -replace "\\", "/")

            $manifest.Add([pscustomobject]@{
                source_file  = $relUnix
                start_line   = $startLine
                end_line     = $i + 1
                language     = $effectiveLang
                output_file  = $outRel
            }) | Out-Null

            $totalBlocks++
            continue
        }

        $buffer.Add($line)
    }

    if ($blockIndex -gt 0) {
        $totalFiles++
        Write-Host ("  {0} -> {1} block(s)" -f $relUnix, $blockIndex) -ForegroundColor Green
    }
}

$csvPath = Join-Path $OutputDir "manifest.csv"
$manifest | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

$jsonPath = Join-Path $OutputDir "manifest.json"
$manifest | ConvertTo-Json -Depth 3 | Set-Content -Path $jsonPath -Encoding UTF8

$stackManifest = New-Object System.Collections.Generic.List[Object]
if ($GroupByStack) {
    $byStackDir = Join-Path $OutputDir "by-stack"
    New-Item -ItemType Directory -Path $byStackDir -Force | Out-Null

    foreach ($entry in $manifest) {
        $stack = Get-StackFromSource $entry.source_file
        $stackDir = Join-Path $byStackDir $stack
        New-Item -ItemType Directory -Path $stackDir -Force | Out-Null

        $srcSnippet = Join-Path $OutputDir ($entry.output_file -replace "/", "\\")
        if (-not (Test-Path $srcSnippet)) { continue }

        $chapterSlug = Sanitize-Name ([System.IO.Path]::GetFileNameWithoutExtension($entry.source_file))
        $snippetName = [System.IO.Path]::GetFileName($srcSnippet)
        $stackFileName = "$chapterSlug-$snippetName"
        $dstSnippet = Join-Path $stackDir $stackFileName

        Copy-Item -Path $srcSnippet -Destination $dstSnippet -Force

        $stackRel = ([System.IO.Path]::GetRelativePath($OutputDir, $dstSnippet) -replace "\\", "/")
        $stackManifest.Add([pscustomobject]@{
            stack       = $stack
            source_file = $entry.source_file
            language    = $entry.language
            output_file = $entry.output_file
            stack_file  = $stackRel
        }) | Out-Null
    }

    $stackCsvPath = Join-Path $OutputDir "manifest-by-stack.csv"
    $stackManifest | Export-Csv -Path $stackCsvPath -NoTypeInformation -Encoding UTF8

    $stackJsonPath = Join-Path $OutputDir "manifest-by-stack.json"
    $stackManifest | ConvertTo-Json -Depth 3 | Set-Content -Path $stackJsonPath -Encoding UTF8
}

if ($CopyDiagrams) {
    $srcDiagrams = Join-Path $PSScriptRoot "diagrams"
    if (Test-Path $srcDiagrams) {
        $dstDiagrams = Join-Path $OutputDir "diagrams"
        New-Item -ItemType Directory -Path $dstDiagrams -Force | Out-Null
        Get-ChildItem -Path $srcDiagrams -Filter "*.png" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination (Join-Path $dstDiagrams $_.Name) -Force
        }
    }
}

$readme = @(
    "# ADLC Book - Official Code Export",
    "",
    "Generated by extract-code.ps1.",
    "",
    "## Structure",
    "",
    "- snippets/: extracted code blocks grouped by chapter path",
    "- manifest.csv: source-to-output mapping with line numbers",
    "- manifest.json: same mapping in JSON format",
    "- by-stack/: optional stack-based view (generated with -GroupByStack)",
    "- manifest-by-stack.csv/json: optional stack index",
    "",
    "## Usage",
    "",
    "pwsh ./extract-code.ps1",
    "pwsh ./extract-code.ps1 -IncludeTextBlocks -CopyDiagrams",
    "pwsh ./extract-code.ps1 -GroupByStack",
    "",
    "Generated at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

$readmePath = Join-Path $OutputDir "README.md"
[System.IO.File]::WriteAllText($readmePath, ($readme -join "`n"), [System.Text.UTF8Encoding]::new($false))

Write-Host "`nDone." -ForegroundColor Cyan
Write-Host "Markdown files processed: $totalFiles"
Write-Host "Code blocks extracted:   $totalBlocks"
Write-Host "Output folder:           $OutputDir" -ForegroundColor Green
Write-Host "Manifest CSV:            $csvPath"
Write-Host "Manifest JSON:           $jsonPath"
if ($GroupByStack) {
    Write-Host "Manifest Stack CSV:      $(Join-Path $OutputDir 'manifest-by-stack.csv')"
    Write-Host "Manifest Stack JSON:     $(Join-Path $OutputDir 'manifest-by-stack.json')"
    Write-Host "By-stack folder:         $(Join-Path $OutputDir 'by-stack')"
}
