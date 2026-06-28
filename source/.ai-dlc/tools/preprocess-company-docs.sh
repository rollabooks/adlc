#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(pwd)"
FORCE=0

usage() {
  cat <<'EOF'
Usage: bash .ai-dlc/tools/preprocess-company-docs.sh [--project-root PATH] [--force]

Converts .ai-dlc/company/source/ DOCX/PDF/TXT/MD files into
.ai-dlc/company/processed/ Markdown files for agent consumption.

Requires pandoc for DOCX. PDF extraction uses pandoc when possible,
then falls back to pdftotext if available.
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
    --force)
      FORCE=1
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

SOURCE_DIR="$PROJECT_ROOT/.ai-dlc/company/source"
PROCESSED_DIR="$PROJECT_ROOT/.ai-dlc/company/processed"
INDEX="$PROCESSED_DIR/INDEX.md"
MANIFEST="$PROCESSED_DIR/manifest.json"
REPORT=()
MANIFEST_ITEMS=()

safe_name() {
  local name="$1"
  name="${name%.*}"
  printf '%s' "$name" | sed 's/[^A-Za-z0-9._-]/_/g'
}

add_report() {
  REPORT+=("$1")
}

json_escape() {
  local value="$1"
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$value"
  else
    printf '"%s"' "$(printf '%s' "$value" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  fi
}

add_manifest_item() {
  local source="$1"
  local output="$2"
  local status="$3"
  local tool="$4"
  local message="$5"
  local output_json tool_json
  if [[ -n "$output" ]]; then output_json="$(json_escape "$output")"; else output_json="null"; fi
  if [[ -n "$tool" ]]; then tool_json="$(json_escape "$tool")"; else tool_json="null"; fi
  MANIFEST_ITEMS+=("{\"source\":$(json_escape "$source"),\"output\":$output_json,\"status\":$(json_escape "$status"),\"tool\":$tool_json,\"message\":$(json_escape "$message")}")
}

mkdir -p "$SOURCE_DIR" "$PROCESSED_DIR"

{
  printf '# Company Process Processed Index\n\n'
  printf '> Generated from `.ai-dlc/company/source/`.\n\n'
} > "$INDEX"

shopt -s nullglob
for file in "$SOURCE_DIR"/*; do
  [[ -f "$file" ]] || continue
  filename="$(basename "$file")"
  ext="${filename##*.}"
  ext="$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"
  safe="$(safe_name "$filename")"
  target="$PROCESSED_DIR/$safe.md"

  if [[ -e "$target" && "$FORCE" -ne 1 ]]; then
    add_report "Skipped existing: $filename"
    add_manifest_item ".ai-dlc/company/source/$filename" ".ai-dlc/company/processed/$safe.md" "skipped" "" "Skipped existing"
    printf -- '- [%s.md](%s.md) — from `%s` (existing)\n' "$safe" "$safe" "$filename" >> "$INDEX"
    continue
  fi

  case "$ext" in
    docx)
      if ! command -v pandoc >/dev/null 2>&1; then
        add_report "Cannot process DOCX without pandoc: $filename"
        add_manifest_item ".ai-dlc/company/source/$filename" "" "failed" "" "Cannot process DOCX without pandoc"
        continue
      fi
      pandoc "$file" -t gfm -o "$target"
      add_report "Processed DOCX: $filename -> $safe.md"
      add_manifest_item ".ai-dlc/company/source/$filename" ".ai-dlc/company/processed/$safe.md" "processed" "pandoc" "Processed DOCX"
      printf -- '- [%s.md](%s.md) — from `%s`\n' "$safe" "$safe" "$filename" >> "$INDEX"
      ;;
    pdf)
      if command -v pandoc >/dev/null 2>&1 && pandoc "$file" -t gfm -o "$target" 2>/dev/null && [[ -s "$target" ]]; then
        add_report "Processed PDF with pandoc: $filename -> $safe.md"
        add_manifest_item ".ai-dlc/company/source/$filename" ".ai-dlc/company/processed/$safe.md" "processed" "pandoc" "Processed PDF"
        printf -- '- [%s.md](%s.md) — from `%s`\n' "$safe" "$safe" "$filename" >> "$INDEX"
        continue
      fi

      if command -v pdftotext >/dev/null 2>&1; then
        tmp="$PROCESSED_DIR/$safe.txt"
        pdftotext "$file" "$tmp"
        {
          printf '# %s\n\n' "$safe"
          printf '> Extracted from `%s` using pdftotext.\n\n' "$filename"
          printf '```text\n'
          cat "$tmp"
          printf '\n```\n'
        } > "$target"
        rm -f "$tmp"
        add_report "Processed PDF with pdftotext: $filename -> $safe.md"
        add_manifest_item ".ai-dlc/company/source/$filename" ".ai-dlc/company/processed/$safe.md" "processed" "pdftotext" "Processed PDF"
        printf -- '- [%s.md](%s.md) — from `%s`\n' "$safe" "$safe" "$filename" >> "$INDEX"
        continue
      fi

      add_report "Cannot process PDF without pandoc or pdftotext: $filename"
      add_manifest_item ".ai-dlc/company/source/$filename" "" "failed" "" "Cannot process PDF without pandoc or pdftotext"
      ;;
    md|txt)
      cp -f "$file" "$target"
      add_report "Copied text document: $filename -> $safe.md"
      add_manifest_item ".ai-dlc/company/source/$filename" ".ai-dlc/company/processed/$safe.md" "processed" "copy" "Copied text document"
      printf -- '- [%s.md](%s.md) — from `%s`\n' "$safe" "$safe" "$filename" >> "$INDEX"
      ;;
    *)
      add_report "Unsupported source format: $filename"
      add_manifest_item ".ai-dlc/company/source/$filename" "" "unsupported" "" "Unsupported source format"
      ;;
  esac
done

{
  printf '\n## Processing Report\n\n'
  for line in "${REPORT[@]}"; do
    printf -- '- %s\n' "$line"
  done
} >> "$INDEX"

{
  printf '{\n'
  printf '  "version": "1.0",\n'
  printf '  "generated_at": %s,\n' "$(json_escape "$(date -u +"%Y-%m-%dT%H:%M:%SZ")")"
  printf '  "project_root": %s,\n' "$(json_escape "$PROJECT_ROOT")"
  printf '  "documents": [\n'
  for i in "${!MANIFEST_ITEMS[@]}"; do
    if [[ "$i" -gt 0 ]]; then printf ',\n'; fi
    printf '    %s' "${MANIFEST_ITEMS[$i]}"
  done
  printf '\n  ]\n'
  printf '}\n'
} > "$MANIFEST"

printf 'Company document preprocessing complete.\n'
for line in "${REPORT[@]}"; do
  printf -- '- %s\n' "$line"
done
