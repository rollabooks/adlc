#!/usr/bin/env bash
set -u

ROOT=""
STRICT=0
for arg in "$@"; do
  case "$arg" in
    --strict)
      STRICT=1
      ;;
    *)
      if [[ -z "$ROOT" ]]; then
        ROOT="$arg"
      fi
      ;;
  esac
done
ROOT="${ROOT:-$(pwd)}"

failures=()
warnings=()

add_failure() {
  failures+=("$1")
}

add_warning() {
  if [[ "$STRICT" -eq 1 ]]; then
    failures+=("$1")
  else
    warnings+=("$1")
  fi
}

required_paths=(
  "AGENTS.md"
  "CLAUDE.md"
  "GEMINI.md"
  "OPENCLAW.md"
  ".github/copilot-instructions.md"
  ".adlc/ADLC.md"
  ".adlc/INSTALL.md"
  ".adlc/VERSIONING.md"
  ".adlc/VERSION"
  ".adlc/manifest.json"
  ".adlc/tools/init.ps1"
  ".adlc/tools/init.sh"
  ".adlc/tools/preprocess-company-docs.ps1"
  ".adlc/tools/preprocess-company-docs.sh"
  ".adlc/tools/update-projects.ps1"
  ".adlc/tools/update-projects.sh"
  ".adlc/tests/test.ps1"
  ".adlc/tests/test.sh"
  ".adlc/schemas/manifest.schema.json"
  ".adlc/schemas/projects.schema.json"
  ".adlc/schemas/processed-company.schema.json"
  ".adlc/modules/01_CORE_RULES.md"
  ".adlc/modules/templates/EPIC_TEMPLATE.md"
  ".adlc/modules/templates/TASK_TEMPLATE.md"
  ".adlc/modules/templates/DECISION_RECORD_TEMPLATE.md"
  ".adlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md"
  ".adlc/modules/templates/PROJECTS_TEMPLATE.json"
  "CHANGELOG.md"
)

for path in "${required_paths[@]}"; do
  if [[ ! -e "$ROOT/$path" ]]; then
    add_failure "Missing required path: $path"
  fi
done

manifest="$ROOT/.adlc/manifest.json"
if [[ -f "$manifest" ]]; then
  if command -v jq >/dev/null 2>&1; then
    if ! jq -e '.version' "$manifest" >/dev/null 2>&1; then
      add_failure "Invalid .adlc/manifest.json or missing version"
    fi
  elif command -v python3 >/dev/null 2>&1; then
    if ! python3 - "$manifest" <<'PY' >/dev/null 2>&1
import json
import sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
if not data.get("version"):
    raise SystemExit(1)
PY
    then
      add_failure "Invalid .adlc/manifest.json or missing version"
    fi
  elif command -v python >/dev/null 2>&1; then
    if ! python - "$manifest" <<'PY' >/dev/null 2>&1
import json
import sys
with open(sys.argv[1]) as f:
    data = json.load(f)
if not data.get("version"):
    raise SystemExit(1)
PY
    then
      add_failure "Invalid .adlc/manifest.json or missing version"
    fi
  else
    add_failure "Cannot validate manifest JSON: install jq or python"
  fi
fi

validate_schema_if_available() {
  local json_path="$1"
  local schema_path="$2"
  local label="$3"

  [[ -f "$json_path" && -f "$schema_path" ]] || return 0

  local py=""
  if command -v python3 >/dev/null 2>&1; then
    py="python3"
  elif command -v python >/dev/null 2>&1; then
    py="python"
  else
    return 0
  fi

  if ! "$py" - "$schema_path" "$json_path" <<'PY' >/dev/null 2>&1
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
PY
  then
    add_failure "$label does not match schema"
  fi
}

validate_schema_if_available "$ROOT/.adlc/manifest.json" "$ROOT/.adlc/schemas/manifest.schema.json" "manifest.json"
validate_schema_if_available "$ROOT/.adlc/projects.json" "$ROOT/.adlc/schemas/projects.schema.json" "projects.json"

while IFS= read -r -d '' file; do
  rel="${file#$ROOT/}"
  case "$rel" in
    .git/*|CHANGELOG.md|.adlc/MIGRATION.md|.adlc/tools/validate.ps1|.adlc/tools/validate.sh)
      continue
      ;;
  esac

  case "$file" in
    *.md|*.json|*.ps1|*.sh|*.txt)
      if grep -Eq '(\.github/)?copilot_modules' "$file"; then
        add_failure "Legacy copilot_modules reference in $rel"
      fi
      ;;
  esac
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -type f -print0)

while IFS= read -r -d '' file; do
  rel="${file#$ROOT/}"
  case "$rel" in
    .git/*)
      continue
      ;;
  esac

  if ! grep -q '## AI Sizing' "$file"; then
    add_failure "Task file missing AI Sizing section: $rel"
    continue
  fi
  if grep -Eq '\| Model Level \| \[1-7\] \|' "$file"; then
    add_failure "Task file has unpopulated Model Level: $rel"
  fi
  if grep -Eq '\| Risk Floor Applied \| \[none ' "$file"; then
    add_failure "Task file has unpopulated Risk Floor Applied: $rel"
  fi
  if grep -Eq '\| Input Tokens \| \[N\] \|' "$file"; then
    add_warning "Task file has unpopulated Input Tokens: $rel"
  fi
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -type f -name 'T-*.md' -print0)

while IFS= read -r -d '' file; do
  rel="${file#$ROOT/}"
  case "$rel" in
    .git/*)
      continue
      ;;
  esac

  if ! grep -q '## Risk and Model Floor' "$file"; then
    add_failure "Epic file missing Risk and Model Floor section: $rel"
  fi
  if ! grep -q '## Task Breakdown' "$file"; then
    add_failure "Epic file missing Task Breakdown section: $rel"
  fi
  if grep -Eq '\| \[LOW/MEDIUM/HIGH\] \|' "$file"; then
    add_failure "Epic file has unpopulated Risk row: $rel"
  fi
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -type f -name 'E-*.md' -print0)

context_file="$ROOT/_CONTEXT.md"
if [[ -f "$context_file" ]]; then
  if grep -Eq '\| Active Task Token Estimate \| \[input/output/total\] \|' "$context_file"; then
    add_warning "_CONTEXT.md has unpopulated Active Task Token Estimate"
  fi
  if grep -Eq '\| Active Task Model Level \| \[1-7\]' "$context_file"; then
    add_warning "_CONTEXT.md has unpopulated Active Task Model Level"
  fi
  if grep -Eq '\| Active Task \| \[TASK-ID\]' "$context_file"; then
    add_warning "_CONTEXT.md has unpopulated Active Task identifier"
  fi
fi

halt_file="$ROOT/.adlc/halt-triggers.yaml"
if [[ -f "$halt_file" ]]; then
  if ! grep -Eq '^version:[[:space:]]+[0-9]+' "$halt_file"; then
    add_failure ".adlc/halt-triggers.yaml missing version field"
  fi
  if ! grep -Eq '^triggers:' "$halt_file"; then
    add_failure ".adlc/halt-triggers.yaml missing triggers list"
  fi
fi

if (( ${#warnings[@]} > 0 )); then
  printf 'AI-DLC validation warnings:\n' >&2
  for warning in "${warnings[@]}"; do
    printf -- '- %s\n' "$warning" >&2
  done
  printf '(Run with --strict to fail on warnings.)\n' >&2
fi

if (( ${#failures[@]} > 0 )); then
  printf 'AI-DLC validation failed:\n' >&2
  for failure in "${failures[@]}"; do
    printf -- '- %s\n' "$failure" >&2
  done
  exit 1
fi

printf 'AI-DLC validation passed.\n'
