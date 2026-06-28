param(
  [string]$Root = (Resolve-Path ".").Path,
  [switch]$Strict
)

$ErrorActionPreference = "Stop"
$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Issue {
  param([string]$Message, [switch]$WarnOnly)
  if ($WarnOnly -and -not $Strict) {
    $warnings.Add($Message)
  } else {
    $failures.Add($Message)
  }
}

function Test-RequiredPath {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath (Join-Path $Root $Path))) {
    $failures.Add("Missing required path: $Path")
  }
}

function Test-NoLegacyReference {
  $files = Get-ChildItem -LiteralPath $Root -Recurse -File -Force |
    Where-Object {
      $_.FullName -notmatch "\\.git\\" -and
      $_.FullName -notmatch "\\CHANGELOG\.md$" -and
      $_.FullName -notmatch "\\.adlc\\MIGRATION\.md$" -and
      $_.FullName -notmatch "\\.adlc\\tools\\validate\.ps1$" -and
      $_.Extension -in @(".md", ".json", ".ps1", ".txt")
    }

  foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    if ($content -match "(\.github/)?copilot_modules") {
      $relative = Resolve-Path -LiteralPath $file.FullName -Relative
      $failures.Add("Legacy copilot_modules reference in $relative")
    }
  }
}

function Test-Manifest {
  $manifestPath = Join-Path $Root ".adlc/manifest.json"
  try {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    if (-not $manifest.version) {
      $failures.Add("Manifest missing version")
    }
  } catch {
    $failures.Add("Invalid .adlc/manifest.json: $($_.Exception.Message)")
  }
}

function Test-JsonSchemaIfAvailable {
  param(
    [string]$JsonPath,
    [string]$SchemaPath,
    [string]$Label
  )

  $jsonFullPath = Join-Path $Root $JsonPath
  $schemaFullPath = Join-Path $Root $SchemaPath
  if (-not (Test-Path -LiteralPath $jsonFullPath) -or -not (Test-Path -LiteralPath $schemaFullPath)) {
    return
  }

  $python = Get-Command python3 -ErrorAction SilentlyContinue
  if (-not $python) {
    $python = Get-Command python -ErrorAction SilentlyContinue
  }
  if (-not $python) {
    return
  }

  & $python.Source --version *> $null
  if ($LASTEXITCODE -ne 0) {
    return
  }

  $script = @'
import json
import sys

schema_path, json_path = sys.argv[1], sys.argv[2]
with open(schema_path, encoding="utf-8") as f:
    schema = json.load(f)
with open(json_path, encoding="utf-8") as f:
    data = json.load(f)

try:
    import jsonschema
except Exception:
    raise SystemExit(0)

jsonschema.validate(instance=data, schema=schema)
'@

  $temp = [System.IO.Path]::GetTempFileName() + ".py"
  try {
    Set-Content -LiteralPath $temp -Value $script -Encoding utf8
    & $python.Source $temp $schemaFullPath $jsonFullPath 2>$null
    if ($LASTEXITCODE -ne 0) {
      $failures.Add("$Label does not match schema")
    }
  } finally {
    Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
  }
}

function Test-TaskTemplates {
  $taskFiles = Get-ChildItem -LiteralPath $Root -Recurse -File -Force -Filter "T-*.md" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\.git\\" }

  foreach ($file in $taskFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $relative = Resolve-Path -LiteralPath $file.FullName -Relative
    if ($content -notmatch "## AI Sizing") {
      Add-Issue "Task file missing AI Sizing section: $relative"
      continue
    }
    if ($content -match '\| Model Level \| \[1-7\] \|') {
      Add-Issue "Task file has unpopulated Model Level: $relative"
    }
    if ($content -match '\| Risk Floor Applied \| \[none ') {
      Add-Issue "Task file has unpopulated Risk Floor Applied: $relative"
    }
    if ($content -match '\| Input Tokens \| \[N\] \|') {
      Add-Issue "Task file has unpopulated Input Tokens: $relative" -WarnOnly
    }
  }
}

function Test-EpicTemplates {
  $epicFiles = Get-ChildItem -LiteralPath $Root -Recurse -File -Force -Filter "E-*.md" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\.git\\" }

  foreach ($file in $epicFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $relative = Resolve-Path -LiteralPath $file.FullName -Relative
    if ($content -notmatch "## Risk and Model Floor") {
      Add-Issue "Epic file missing Risk and Model Floor section: $relative"
    }
    if ($content -notmatch "## Task Breakdown") {
      Add-Issue "Epic file missing Task Breakdown section: $relative"
    }
    if ($content -match '\| \[LOW/MEDIUM/HIGH\] \|') {
      Add-Issue "Epic file has unpopulated Risk row: $relative"
    }
  }
}

function Test-ContextSizing {
  $contextPath = Join-Path $Root "_CONTEXT.md"
  if (-not (Test-Path -LiteralPath $contextPath)) {
    return
  }
  $content = Get-Content -LiteralPath $contextPath -Raw
  if ($content -match '\| Active Task Token Estimate \| \[input/output/total\] \|') {
    Add-Issue "_CONTEXT.md has unpopulated Active Task Token Estimate" -WarnOnly
  }
  if ($content -match '\| Active Task Model Level \| \[1-7\]') {
    Add-Issue "_CONTEXT.md has unpopulated Active Task Model Level" -WarnOnly
  }
  if ($content -match '\| Active Task \| \[TASK-ID\]') {
    Add-Issue "_CONTEXT.md has unpopulated Active Task identifier" -WarnOnly
  }
}

function Test-HaltTriggersIfPresent {
  $haltPath = Join-Path $Root ".adlc/halt-triggers.yaml"
  if (-not (Test-Path -LiteralPath $haltPath)) {
    return
  }
  $content = Get-Content -LiteralPath $haltPath -Raw
  if ($content -notmatch "(?m)^version:\s*\d+") {
    Add-Issue ".adlc/halt-triggers.yaml missing version field"
  }
  if ($content -notmatch "(?m)^triggers:") {
    Add-Issue ".adlc/halt-triggers.yaml missing triggers list"
  }
}

$required = @(
  "AGENTS.md",
  "CLAUDE.md",
  "GEMINI.md",
  "OPENCLAW.md",
  ".github/copilot-instructions.md",
  ".adlc/ADLC.md",
  ".adlc/INSTALL.md",
  ".adlc/VERSIONING.md",
  ".adlc/VERSION",
  ".adlc/manifest.json",
  ".adlc/tools/init.ps1",
  ".adlc/tools/init.sh",
  ".adlc/tools/preprocess-company-docs.ps1",
  ".adlc/tools/preprocess-company-docs.sh",
  ".adlc/tools/update-projects.ps1",
  ".adlc/tools/update-projects.sh",
  ".adlc/tests/test.ps1",
  ".adlc/tests/test.sh",
  ".adlc/schemas/manifest.schema.json",
  ".adlc/schemas/projects.schema.json",
  ".adlc/schemas/processed-company.schema.json",
  ".adlc/modules/01_CORE_RULES.md",
  ".adlc/modules/templates/EPIC_TEMPLATE.md",
  ".adlc/modules/templates/TASK_TEMPLATE.md",
  ".adlc/modules/templates/DECISION_RECORD_TEMPLATE.md",
  ".adlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md",
  ".adlc/modules/templates/PROJECTS_TEMPLATE.json",
  "CHANGELOG.md"
)

foreach ($path in $required) {
  Test-RequiredPath -Path $path
}

Test-Manifest
Test-JsonSchemaIfAvailable -JsonPath ".adlc/manifest.json" -SchemaPath ".adlc/schemas/manifest.schema.json" -Label "manifest.json"
Test-JsonSchemaIfAvailable -JsonPath ".adlc/projects.json" -SchemaPath ".adlc/schemas/projects.schema.json" -Label "projects.json"
Test-NoLegacyReference
Test-TaskTemplates
Test-EpicTemplates
Test-ContextSizing
Test-HaltTriggersIfPresent

if ($warnings.Count -gt 0) {
  Write-Host "AI-DLC validation warnings:" -ForegroundColor Yellow
  foreach ($warning in $warnings) {
    Write-Host "- $warning" -ForegroundColor Yellow
  }
  Write-Host "(Run with -Strict to fail on warnings.)" -ForegroundColor Yellow
}

if ($failures.Count -gt 0) {
  Write-Host "AI-DLC validation failed:" -ForegroundColor Red
  foreach ($failure in $failures) {
    Write-Host "- $failure" -ForegroundColor Red
  }
  exit 1
}

Write-Host "AI-DLC validation passed." -ForegroundColor Green
