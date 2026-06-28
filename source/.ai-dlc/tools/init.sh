#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(pwd)"
FRAMEWORK_ROOT="$(pwd)"
CONTEXT="full"
COMPANY=0
FORCE=0

usage() {
  cat <<'EOF'
Usage: bash .ai-dlc/tools/init.sh [--project-root PATH] [--framework-root PATH] [--context full|minimal] [--company] [--force]

Creates missing AI-DLC project files:
- _CONTEXT.md
- PROGRESS.md
- .ai-dlc/project/instructions.md
- .ai-dlc/project/skills/
- optional .ai-dlc/company/ process extension with --company

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
  context_template=".ai-dlc/modules/templates/CONTEXT_MIN.md"
else
  context_template=".ai-dlc/modules/templates/CONTEXT_TEMPLATE.md"
fi

copy_template "$context_template" "_CONTEXT.md"
copy_template ".ai-dlc/modules/templates/PROGRESS_TEMPLATE.md" "PROGRESS.md"
copy_template ".ai-dlc/modules/templates/PROJECT_INSTRUCTIONS_TEMPLATE.md" ".ai-dlc/project/instructions.md"

if [[ "$COMPANY" -eq 1 ]]; then
  copy_template ".ai-dlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md" ".ai-dlc/company/README.md"
  mkdir -p "$PROJECT_ROOT/.ai-dlc/company/docs"
  printf 'Created: .ai-dlc/company/docs\n'
  mkdir -p "$PROJECT_ROOT/.ai-dlc/company/source" "$PROJECT_ROOT/.ai-dlc/company/processed"
  printf 'Created: .ai-dlc/company/source\n'
  printf 'Created: .ai-dlc/company/processed\n'
fi

mkdir -p "$PROJECT_ROOT/.ai-dlc/project/skills"
printf 'Created: .ai-dlc/project/skills\n'
printf 'AI-DLC project scaffold complete.\n'
