param(
  [string]$ProjectRoot = (Resolve-Path ".").Path,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$sourceDir = Join-Path $ProjectRoot ".ai-dlc/company/source"
$processedDir = Join-Path $ProjectRoot ".ai-dlc/company/processed"
$indexPath = Join-Path $processedDir "INDEX.md"
$report = New-Object System.Collections.Generic.List[string]
$documents = New-Object System.Collections.Generic.List[object]

function Get-Tool {
  param([string]$Name)
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }
  return $null
}

function Get-SafeName {
  param([string]$Name)
  $base = [System.IO.Path]::GetFileNameWithoutExtension($Name)
  return ($base -replace '[^A-Za-z0-9._-]', '_')
}

if (-not (Test-Path -LiteralPath $sourceDir)) {
  New-Item -ItemType Directory -Force -Path $sourceDir | Out-Null
  Write-Host "Created: .ai-dlc/company/source"
}

if (-not (Test-Path -LiteralPath $processedDir)) {
  New-Item -ItemType Directory -Force -Path $processedDir | Out-Null
  Write-Host "Created: .ai-dlc/company/processed"
}

$pandoc = Get-Tool "pandoc"
$pdftotext = Get-Tool "pdftotext"
$sources = Get-ChildItem -LiteralPath $sourceDir -File -ErrorAction SilentlyContinue

$index = New-Object System.Collections.Generic.List[string]
$index.Add("# Company Process Processed Index")
$index.Add("")
$index.Add("> Generated from `.ai-dlc/company/source/`.")
$index.Add("")

foreach ($file in $sources) {
  $ext = $file.Extension.ToLowerInvariant()
  $safe = Get-SafeName $file.Name
  $target = Join-Path $processedDir "$safe.md"
  $status = "unsupported"
  $tool = $null
  $message = ""

  if ((Test-Path -LiteralPath $target) -and -not $Force) {
    $status = "skipped"
    $message = "Skipped existing"
    $report.Add("${message}: $($file.Name)")
    $index.Add("- [$safe.md]($safe.md) - from '$($file.Name)' (existing)")
    $documents.Add([ordered]@{
      source = ".ai-dlc/company/source/$($file.Name)"
      output = ".ai-dlc/company/processed/$safe.md"
      status = $status
      tool = $tool
      message = $message
    })
    continue
  }

  if ($ext -eq ".docx") {
    if (-not $pandoc) {
      $message = "Cannot process DOCX without pandoc"
      $report.Add("${message}: $($file.Name)")
      $documents.Add([ordered]@{
        source = ".ai-dlc/company/source/$($file.Name)"
        output = $null
        status = "failed"
        tool = $null
        message = $message
      })
      continue
    }
    & $pandoc $file.FullName -t gfm -o $target
    $tool = "pandoc"
    $message = "Processed DOCX"
    $report.Add("${message}: $($file.Name) -> $safe.md")
    $index.Add("- [$safe.md]($safe.md) - from '$($file.Name)'")
    $documents.Add([ordered]@{
      source = ".ai-dlc/company/source/$($file.Name)"
      output = ".ai-dlc/company/processed/$safe.md"
      status = "processed"
      tool = $tool
      message = $message
    })
    continue
  }

  if ($ext -eq ".pdf") {
    if ($pandoc) {
      & $pandoc $file.FullName -t gfm -o $target
      if ((Test-Path -LiteralPath $target) -and ((Get-Item -LiteralPath $target).Length -gt 0)) {
        $tool = "pandoc"
        $message = "Processed PDF"
        $report.Add("$message with pandoc: $($file.Name) -> $safe.md")
        $index.Add("- [$safe.md]($safe.md) - from '$($file.Name)'")
        $documents.Add([ordered]@{
          source = ".ai-dlc/company/source/$($file.Name)"
          output = ".ai-dlc/company/processed/$safe.md"
          status = "processed"
          tool = $tool
          message = $message
        })
        continue
      }
    }

    if ($pdftotext) {
      $tmp = Join-Path $processedDir "$safe.txt"
      & $pdftotext $file.FullName $tmp
      $text = if (Test-Path -LiteralPath $tmp) { Get-Content -LiteralPath $tmp -Raw } else { "" }
      @("# $safe", "", "> Extracted from '$($file.Name)' using pdftotext.", "", '```text', $text, '```') | Set-Content -LiteralPath $target -Encoding utf8
      Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
      $tool = "pdftotext"
      $message = "Processed PDF"
      $report.Add("$message with pdftotext: $($file.Name) -> $safe.md")
      $index.Add("- [$safe.md]($safe.md) - from '$($file.Name)'")
      $documents.Add([ordered]@{
        source = ".ai-dlc/company/source/$($file.Name)"
        output = ".ai-dlc/company/processed/$safe.md"
        status = "processed"
        tool = $tool
        message = $message
      })
      continue
    }

    $message = "Cannot process PDF without pandoc or pdftotext"
    $report.Add("${message}: $($file.Name)")
    $documents.Add([ordered]@{
      source = ".ai-dlc/company/source/$($file.Name)"
      output = $null
      status = "failed"
      tool = $null
      message = $message
    })
    continue
  }

  if ($ext -in @(".md", ".txt")) {
    Copy-Item -LiteralPath $file.FullName -Destination $target -Force:$Force
    $tool = "copy"
    $message = "Copied text document"
    $report.Add("${message}: $($file.Name) -> $safe.md")
    $index.Add("- [$safe.md]($safe.md) - from '$($file.Name)'")
    $documents.Add([ordered]@{
      source = ".ai-dlc/company/source/$($file.Name)"
      output = ".ai-dlc/company/processed/$safe.md"
      status = "processed"
      tool = $tool
      message = $message
    })
    continue
  }

  $message = "Unsupported source format"
  $report.Add("${message}: $($file.Name)")
  $documents.Add([ordered]@{
    source = ".ai-dlc/company/source/$($file.Name)"
    output = $null
    status = "unsupported"
    tool = $null
    message = $message
  })
}

$index.Add("")
$index.Add("## Processing Report")
$index.Add("")
foreach ($line in $report) {
  $index.Add("- $line")
}

$index | Set-Content -LiteralPath $indexPath -Encoding utf8

$manifest = [ordered]@{
  version = "1.0"
  generated_at = (Get-Date).ToString("o")
  project_root = $ProjectRoot
  documents = $documents
}
$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $processedDir "manifest.json") -Encoding utf8

Write-Host "Company document preprocessing complete."
foreach ($line in $report) {
  Write-Host "- $line"
}
