param(
  [string]$Root = (Resolve-Path ".").Path,
  [switch]$Strict
)

$ErrorActionPreference = "Stop"

$agentsPath = Join-Path $Root "AGENTS.md"
$copilotPath = Join-Path $Root ".github/copilot-instructions.md"

if (-not (Test-Path -LiteralPath $agentsPath)) {
  Write-Error "AGENTS.md not found at $agentsPath"
  exit 1
}
if (-not (Test-Path -LiteralPath $copilotPath)) {
  Write-Error "copilot-instructions.md not found at $copilotPath"
  exit 1
}

$copilot = Get-Content -LiteralPath $copilotPath -Raw

# Canonical concepts that MUST appear in copilot-instructions.md to stay in sync with AGENTS.md.
$expected = @(
  @{ Name = "halt-triggers reference";   Pattern = "\.adlc/halt-triggers\.yaml" }
  @{ Name = "manifest model levels";     Pattern = "manifest\.json#model_levels" }
  @{ Name = "risk classification table"; Pattern = "(?ms)Risk[^\n]*Minimum Model Level" }
  @{ Name = "task sizing requirement";   Pattern = "(?i)token estimate" }
  @{ Name = "confidence tag scope";      Pattern = "(?i)high-stakes output" }
  @{ Name = "session bootstrap";         Pattern = "_CONTEXT\.md" }
  @{ Name = "priority layers";           Pattern = "\.adlc/modules/" }
)

$missing = New-Object System.Collections.Generic.List[string]
foreach ($e in $expected) {
  if ($copilot -notmatch $e.Pattern) {
    $missing.Add($e.Name)
  }
}

if ($missing.Count -gt 0) {
  Write-Host "copilot-instructions.md is missing canonical concepts:" -ForegroundColor Yellow
  foreach ($m in $missing) {
    Write-Host "- $m" -ForegroundColor Yellow
  }
  Write-Host "Edit .github/copilot-instructions.md to align with AGENTS.md."
  if ($Strict) {
    exit 1
  }
  exit 0
}

Write-Host "copilot-instructions.md is coherent with AGENTS.md canonical concepts." -ForegroundColor Green
