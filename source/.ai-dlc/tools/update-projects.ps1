param(
  [string]$RepoRoot = (Resolve-Path ".").Path
)

$ErrorActionPreference = "Stop"
$projects = @()

$contexts = Get-ChildItem -LiteralPath $RepoRoot -Recurse -File -Force -Filter "_CONTEXT.md" |
  Where-Object { $_.FullName -notmatch "\\.git\\" }

foreach ($context in $contexts) {
  $projectRoot = Split-Path -Parent $context.FullName
  $relativeRoot = [System.IO.Path]::GetRelativePath($RepoRoot, $projectRoot)
  $relativeRoot = $relativeRoot -replace "\\", "/"
  $id = if ($relativeRoot -eq ".") { "root" } else { ($relativeRoot -replace "[\\/]", "-") }

  $projects += [ordered]@{
    id = $id
    name = $id
    root = $relativeRoot
    context = (Join-Path $relativeRoot "_CONTEXT.md") -replace "\\", "/"
    progress = (Join-Path $relativeRoot "PROGRESS.md") -replace "\\", "/"
    project_rules = (Join-Path $relativeRoot ".ai-dlc/project") -replace "\\", "/"
    company_extension = (Join-Path $relativeRoot ".ai-dlc/company") -replace "\\", "/"
  }
}

$manifest = [ordered]@{
  version = "1.0"
  generated_at = (Get-Date).ToString("o")
  projects = $projects
}

$adlcDir = Join-Path $RepoRoot ".ai-dlc"
if (-not (Test-Path -LiteralPath $adlcDir)) {
  New-Item -ItemType Directory -Force -Path $adlcDir | Out-Null
}
$output = Join-Path $RepoRoot ".ai-dlc/projects.json"
$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $output -Encoding utf8
Write-Host "Updated: .ai-dlc/projects.json ($($projects.Count) projects)"
