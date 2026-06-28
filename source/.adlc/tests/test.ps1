param(
  [string]$Root = (Resolve-Path ".").Path
)

$ErrorActionPreference = "Stop"

function Assert-Path {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Expected path missing: $Path"
  }
}

$tmp = Join-Path $env:TEMP ("adlc-test-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force $tmp | Out-Null

try {
  $project = Join-Path $tmp "apps/app-a"
  New-Item -ItemType Directory -Force $project | Out-Null

  & (Join-Path $Root ".adlc/tools/init.ps1") -ProjectRoot $project -FrameworkRoot $Root -Context minimal -Company
  Assert-Path (Join-Path $project "_CONTEXT.md")
  Assert-Path (Join-Path $project "PROGRESS.md")
  Assert-Path (Join-Path $project ".adlc/project/instructions.md")
  Assert-Path (Join-Path $project ".adlc/company/README.md")

  Set-Content -LiteralPath (Join-Path $project ".adlc/company/source/PROCESS.txt") -Value "Gate: security review" -Encoding utf8
  & (Join-Path $Root ".adlc/tools/preprocess-company-docs.ps1") -ProjectRoot $project
  Assert-Path (Join-Path $project ".adlc/company/processed/INDEX.md")
  Assert-Path (Join-Path $project ".adlc/company/processed/manifest.json")

  & (Join-Path $Root ".adlc/tools/update-projects.ps1") -RepoRoot $tmp
  Assert-Path (Join-Path $tmp ".adlc/projects.json")

  & (Join-Path $Root ".adlc/tools/validate.ps1") -Root $Root

  # Negative cases for new validator checks
  $negativeRoot = Join-Path $tmp "negative"
  New-Item -ItemType Directory -Force $negativeRoot | Out-Null

  # Mirror minimal required structure so validator only complains about task/epic content
  $required = @(
    "AGENTS.md", "CLAUDE.md", "GEMINI.md", "OPENCLAW.md",
    ".github/copilot-instructions.md",
    ".adlc/ADLC.md", ".adlc/INSTALL.md", ".adlc/VERSIONING.md", ".adlc/VERSION",
    ".adlc/manifest.json",
    ".adlc/tools/init.ps1", ".adlc/tools/init.sh",
    ".adlc/tools/preprocess-company-docs.ps1", ".adlc/tools/preprocess-company-docs.sh",
    ".adlc/tools/update-projects.ps1", ".adlc/tools/update-projects.sh",
    ".adlc/tests/test.ps1", ".adlc/tests/test.sh",
    ".adlc/schemas/manifest.schema.json", ".adlc/schemas/projects.schema.json",
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
    $source = Join-Path $Root $path
    $target = Join-Path $negativeRoot $path
    $parent = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $parent)) {
      New-Item -ItemType Directory -Force $parent | Out-Null
    }
    if (Test-Path -LiteralPath $source) {
      Copy-Item -LiteralPath $source -Destination $target -Force
    }
  }

  # 1. Unpopulated task -> failure
  $badTask = Join-Path $negativeRoot "T-999.1_Bad.md"
  Set-Content -LiteralPath $badTask -Encoding utf8 -Value @"
# T-999.1 - Bad
## AI Sizing
| Model Level | [1-7] |
| Risk Floor Applied | [none / MEDIUM>=3 / HIGH>=5] |
"@
  $exit = 0
  try {
    & (Join-Path $Root ".adlc/tools/validate.ps1") -Root $negativeRoot 2>$null
  } catch { $exit = 1 }
  if ($LASTEXITCODE -eq 0) {
    throw "Negative test failed: unpopulated task should make validator exit non-zero"
  }
  Remove-Item -LiteralPath $badTask -Force

  # 2. Unpopulated epic -> failure
  $badEpic = Join-Path $negativeRoot "E-999_Bad.md"
  Set-Content -LiteralPath $badEpic -Encoding utf8 -Value "# E-999 - Bad`n"
  & (Join-Path $Root ".adlc/tools/validate.ps1") -Root $negativeRoot 2>$null
  if ($LASTEXITCODE -eq 0) {
    throw "Negative test failed: epic without Risk and Model Floor should make validator exit non-zero"
  }
  Remove-Item -LiteralPath $badEpic -Force

  # 3. Unpopulated _CONTEXT.md -> warning (pass without -Strict, fail with -Strict)
  $badContext = Join-Path $negativeRoot "_CONTEXT.md"
  Set-Content -LiteralPath $badContext -Encoding utf8 -Value @"
| Active Task | [TASK-ID] X |
| Active Task Token Estimate | [input/output/total] |
| Active Task Model Level | [1-7] X |
"@
  & (Join-Path $Root ".adlc/tools/validate.ps1") -Root $negativeRoot 2>$null
  if ($LASTEXITCODE -ne 0) {
    throw "Negative test failed: unpopulated _CONTEXT.md should warn (not fail) without -Strict"
  }
  & (Join-Path $Root ".adlc/tools/validate.ps1") -Root $negativeRoot -Strict 2>$null
  if ($LASTEXITCODE -eq 0) {
    throw "Negative test failed: unpopulated _CONTEXT.md should fail with -Strict"
  }
  Remove-Item -LiteralPath $badContext -Force

  Write-Host "AI-DLC PowerShell tests passed." -ForegroundColor Green
} finally {
  if (Test-Path -LiteralPath $tmp) {
    Remove-Item -LiteralPath $tmp -Recurse -Force
  }
}
