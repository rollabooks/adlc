#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(pwd)}"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

assert_path() {
  if [[ ! -e "$1" ]]; then
    printf 'Expected path missing: %s\n' "$1" >&2
    exit 1
  fi
}

project="$TMP_DIR/apps/app-a"
mkdir -p "$project"

bash "$ROOT/.adlc/tools/init.sh" --project-root "$project" --framework-root "$ROOT" --context minimal --company
assert_path "$project/_CONTEXT.md"
assert_path "$project/PROGRESS.md"
assert_path "$project/.adlc/project/instructions.md"
assert_path "$project/.adlc/company/README.md"

printf 'Gate: security review\n' > "$project/.adlc/company/source/PROCESS.txt"
bash "$ROOT/.adlc/tools/preprocess-company-docs.sh" --project-root "$project"
assert_path "$project/.adlc/company/processed/INDEX.md"
assert_path "$project/.adlc/company/processed/manifest.json"

bash "$ROOT/.adlc/tools/update-projects.sh" --repo-root "$TMP_DIR"
assert_path "$TMP_DIR/.adlc/projects.json"

bash "$ROOT/.adlc/tools/validate.sh" "$ROOT"

# Negative cases for new validator checks
negative_root="$TMP_DIR/negative"
mkdir -p "$negative_root"

required=(
  "AGENTS.md" "CLAUDE.md" "GEMINI.md" "OPENCLAW.md"
  ".github/copilot-instructions.md"
  ".adlc/ADLC.md" ".adlc/INSTALL.md" ".adlc/VERSIONING.md" ".adlc/VERSION"
  ".adlc/manifest.json"
  ".adlc/tools/init.ps1" ".adlc/tools/init.sh"
  ".adlc/tools/preprocess-company-docs.ps1" ".adlc/tools/preprocess-company-docs.sh"
  ".adlc/tools/update-projects.ps1" ".adlc/tools/update-projects.sh"
  ".adlc/tests/test.ps1" ".adlc/tests/test.sh"
  ".adlc/schemas/manifest.schema.json" ".adlc/schemas/projects.schema.json"
  ".adlc/schemas/processed-company.schema.json"
  ".adlc/modules/01_CORE_RULES.md"
  ".adlc/modules/templates/EPIC_TEMPLATE.md"
  ".adlc/modules/templates/TASK_TEMPLATE.md"
  ".adlc/modules/templates/DECISION_RECORD_TEMPLATE.md"
  ".adlc/modules/templates/COMPANY_PROCESS_TEMPLATE.md"
  ".adlc/modules/templates/PROJECTS_TEMPLATE.json"
  "CHANGELOG.md"
)
for path in "${required[@]}"; do
  src="$ROOT/$path"
  dst="$negative_root/$path"
  mkdir -p "$(dirname "$dst")"
  if [[ -f "$src" ]]; then
    cp -f "$src" "$dst"
  fi
done

# 1. Unpopulated task -> failure
cat >"$negative_root/T-999.1_Bad.md" <<'EOF'
# T-999.1 - Bad
## AI Sizing
| Model Level | [1-7] |
| Risk Floor Applied | [none / MEDIUM>=3 / HIGH>=5] |
EOF
if bash "$ROOT/.adlc/tools/validate.sh" "$negative_root" >/dev/null 2>&1; then
  printf 'Negative test failed: unpopulated task should make validator exit non-zero\n' >&2
  exit 1
fi
rm -f "$negative_root/T-999.1_Bad.md"

# 2. Unpopulated epic -> failure
printf '# E-999 - Bad\n' >"$negative_root/E-999_Bad.md"
if bash "$ROOT/.adlc/tools/validate.sh" "$negative_root" >/dev/null 2>&1; then
  printf 'Negative test failed: epic without Risk and Model Floor should make validator exit non-zero\n' >&2
  exit 1
fi
rm -f "$negative_root/E-999_Bad.md"

# 3. Unpopulated _CONTEXT.md -> warn without --strict, fail with --strict
cat >"$negative_root/_CONTEXT.md" <<'EOF'
| Active Task | [TASK-ID] X |
| Active Task Token Estimate | [input/output/total] |
| Active Task Model Level | [1-7] X |
EOF
if ! bash "$ROOT/.adlc/tools/validate.sh" "$negative_root" >/dev/null 2>&1; then
  printf 'Negative test failed: unpopulated _CONTEXT.md should warn (not fail) without --strict\n' >&2
  exit 1
fi
if bash "$ROOT/.adlc/tools/validate.sh" "$negative_root" --strict >/dev/null 2>&1; then
  printf 'Negative test failed: unpopulated _CONTEXT.md should fail with --strict\n' >&2
  exit 1
fi
rm -f "$negative_root/_CONTEXT.md"

printf 'AI-DLC Bash tests passed.\n'
