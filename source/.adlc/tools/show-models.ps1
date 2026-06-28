param(
  [string]$Root = (Resolve-Path ".").Path,
  [ValidateSet("table", "json")]
  [string]$Format = "table",
  [ValidateSet("anthropic", "openai", "gemini", "all")]
  [string]$Vendor = "all"
)

$ErrorActionPreference = "Stop"

$manifestPath = Join-Path $Root ".adlc/manifest.json"
if (-not (Test-Path -LiteralPath $manifestPath)) {
  Write-Error "manifest.json not found at $manifestPath"
  exit 1
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$levels = $manifest.model_levels

if ($Format -eq "json") {
  $levels | ConvertTo-Json -Depth 5
  return
}

$rows = foreach ($key in 1..7) {
  $lv = $levels.$key
  [pscustomobject]@{
    Level     = $key
    Anthropic = $lv.anthropic
    OpenAI    = $lv.openai
    Gemini    = $lv.gemini
    Tokens    = $lv.token_range
    Purpose   = $lv.purpose
  }
}

switch ($Vendor) {
  "anthropic" { $rows | Select-Object Level, Anthropic, Tokens, Purpose | Format-Table -AutoSize }
  "openai"    { $rows | Select-Object Level, OpenAI,    Tokens, Purpose | Format-Table -AutoSize }
  "gemini"    { $rows | Select-Object Level, Gemini,    Tokens, Purpose | Format-Table -AutoSize }
  default     { $rows | Format-Table -AutoSize }
}
