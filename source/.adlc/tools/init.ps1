param(
  [string]$ProjectRoot = (Resolve-Path ".").Path,
  [string]$FrameworkRoot = (Resolve-Path ".").Path,
  [ValidateSet("full", "minimal")]
  [string]$Context = "full",
  [switch]$Company,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

function Copy-Template {
  param(
    [string]$Source,
    [string]$Destination
  )

  $target = Join-Path $ProjectRoot $Destination
  $template = Join-Path $FrameworkRoot $Source
  $parent = Split-Path -Parent $target

  if (-not (Test-Path -LiteralPath $template)) {
    throw "Template not found: $Source"
  }

  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
  }

  if ((Test-Path -LiteralPath $target) -and -not $Force) {
    Write-Host "Skipped existing file: $Destination"
    return
  }

  Copy-Item -LiteralPath $template -Destination $target -Force:$Force
  Write-Host "Created: $Destination"
}

$contextTemplate = if ($Context -eq "minimal") {
  ".adlc/modules/templates/CONTEXT_MIN.md"
} else {
  ".adlc/modules/templates/CONTEXT_TEMPLATE.md"
}

Copy-Template -Source $contextTemplate -Destination "_CONTEXT.md"
Copy-Template -Source ".adlc/modules/templates/PROGRESS_TEMPLATE.md" -Destination "PROGRESS.md"
Copy-Template -Source ".adlc/modules/templates/PROJECT_INSTRUCTIONS_TEMPLATE.md" -Destination ".adlc/project/instructions.md"

if ($Company) {
  Copy-Template -Source ".adlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md" -Destination ".adlc/company/README.md"
  $companyDocsPath = Join-Path $ProjectRoot ".adlc/company/docs"
  if (-not (Test-Path -LiteralPath $companyDocsPath)) {
    New-Item -ItemType Directory -Force -Path $companyDocsPath | Out-Null
    Write-Host "Created: .adlc/company/docs"
  }
  foreach ($path in @(".adlc/company/source", ".adlc/company/processed")) {
    $companyPath = Join-Path $ProjectRoot $path
    if (-not (Test-Path -LiteralPath $companyPath)) {
      New-Item -ItemType Directory -Force -Path $companyPath | Out-Null
      Write-Host "Created: $path"
    }
  }
}

$skillsPath = Join-Path $ProjectRoot ".adlc/project/skills"
if (-not (Test-Path -LiteralPath $skillsPath)) {
  New-Item -ItemType Directory -Force -Path $skillsPath | Out-Null
  Write-Host "Created: .adlc/project/skills"
}

Write-Host "AI-DLC project scaffold complete."
