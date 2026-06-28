#!/usr/bin/env bash
set -u

ROOT="${1:-$(pwd)}"
STRICT=0
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
  esac
done

agents="$ROOT/AGENTS.md"
copilot="$ROOT/.github/copilot-instructions.md"

if [[ ! -f "$agents" ]]; then
  printf 'AGENTS.md not found at %s\n' "$agents" >&2
  exit 1
fi
if [[ ! -f "$copilot" ]]; then
  printf 'copilot-instructions.md not found at %s\n' "$copilot" >&2
  exit 1
fi

declare -a names=(
  "halt-triggers reference"
  "manifest model levels"
  "risk classification table"
  "task sizing requirement"
  "confidence tag scope"
  "session bootstrap"
  "priority layers"
)
declare -a patterns=(
  '\.adlc/halt-triggers\.yaml'
  'manifest\.json#model_levels'
  'Risk.*Minimum Model Level'
  'token estimate'
  'high-stakes output'
  '_CONTEXT\.md'
  '\.adlc/modules/'
)

missing=()
for i in "${!patterns[@]}"; do
  if ! grep -Eiq "${patterns[$i]}" "$copilot"; then
    missing+=("${names[$i]}")
  fi
done

if (( ${#missing[@]} > 0 )); then
  printf 'copilot-instructions.md is missing canonical concepts:\n' >&2
  for m in "${missing[@]}"; do
    printf -- '- %s\n' "$m" >&2
  done
  printf 'Edit .github/copilot-instructions.md to align with AGENTS.md.\n' >&2
  if [[ "$STRICT" -eq 1 ]]; then
    exit 1
  fi
  exit 0
fi

printf 'copilot-instructions.md is coherent with AGENTS.md canonical concepts.\n'
