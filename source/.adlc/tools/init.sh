#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(pwd)"
FRAMEWORK_ROOT="$(pwd)"
CONTEXT="full"
COMPANY=0
FORCE=0

usage() {
  cat <<'EOF'
Usage: bash .adlc/tools/init.sh [--project-root PATH] [--framework-root PATH] [--context full|minimal] [--company] [--force]

Creates missing AI-DLC project files:
- _CONTEXT.md
- PROGRESS.md
- .adlc/project/instructions.md
- .adlc/project/skills/
- optional .adlc/company/ process extension with --company

By default, existing files are not overwritten.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      PROJECT_ROOT="$2"
      shift 2
      ;;
    --project-root)
      PROJECT_ROOT="$2"
      shift 2
      ;;
    --framework-root)
      FRAMEWORK_ROOT="$2"
      shift 2
      ;;
    --context)
      CONTEXT="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --company)
      COMPANY=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$CONTEXT" != "full" && "$CONTEXT" != "minimal" ]]; then
  printf 'Invalid --context value: %s\n' "$CONTEXT" >&2
  exit 1
fi

copy_template() {
  local source="$1"
  local destination="$2"
  local template="$FRAMEWORK_ROOT/$source"
  local target="$PROJECT_ROOT/$destination"
  local parent
  parent="$(dirname "$target")"

  if [[ ! -f "$template" ]]; then
    printf 'Template not found: %s\n' "$source" >&2
    exit 1
  fi

  mkdir -p "$parent"

  if [[ -e "$target" && "$FORCE" -ne 1 ]]; then
    printf 'Skipped existing file: %s\n' "$destination"
    return
  fi

  cp -f "$template" "$target"
  printf 'Created: %s\n' "$destination"
}

if [[ "$CONTEXT" == "minimal" ]]; then
  context_template=".adlc/modules/templates/CONTEXT_MIN.md"
else
  context_template=".adlc/modules/templates/CONTEXT_TEMPLATE.md"
fi

copy_template "$context_template" "_CONTEXT.md"
copy_template ".adlc/modules/templates/PROGRESS_TEMPLATE.md" "PROGRESS.md"
copy_template ".adlc/modules/templates/PROJECT_INSTRUCTIONS_TEMPLATE.md" ".adlc/project/instructions.md"

if [[ "$COMPANY" -eq 1 ]]; then
  copy_template ".adlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md" ".adlc/company/README.md"
  mkdir -p "$PROJECT_ROOT/.adlc/company/docs"
  printf 'Created: .adlc/company/docs\n'
  mkdir -p "$PROJECT_ROOT/.adlc/company/source" "$PROJECT_ROOT/.adlc/company/processed"
  printf 'Created: .adlc/company/source\n'
  printf 'Created: .adlc/company/processed\n'
fi

mkdir -p "$PROJECT_ROOT/.adlc/project/skills"
printf 'Created: .adlc/project/skills\n'
printf 'AI-DLC project scaffold complete.\n'
