#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
FORMAT="table"
VENDOR="all"

usage() {
  cat <<'EOF'
Usage: bash .ai-dlc/tools/show-models.sh [--root PATH] [--format table|json] [--vendor anthropic|openai|gemini|all]

Prints the model level mapping from .ai-dlc/manifest.json#model_levels.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    --vendor) VENDOR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 1 ;;
  esac
done

manifest="$ROOT/.ai-dlc/manifest.json"
if [[ ! -f "$manifest" ]]; then
  printf 'manifest.json not found at %s\n' "$manifest" >&2
  exit 1
fi

if [[ "$FORMAT" == "json" ]]; then
  if command -v jq >/dev/null 2>&1; then
    jq '.model_levels' "$manifest"
  else
    python3 -c "import json,sys; print(json.dumps(json.load(open(sys.argv[1]))['model_levels'], indent=2))" "$manifest"
  fi
  exit 0
fi

py() {
  if command -v python3 >/dev/null 2>&1; then python3 "$@"
  elif command -v python  >/dev/null 2>&1; then python  "$@"
  else printf 'python required for table format\n' >&2; exit 1
  fi
}

py - "$manifest" "$VENDOR" <<'PY'
import json, sys
manifest_path, vendor = sys.argv[1], sys.argv[2]
with open(manifest_path, encoding="utf-8") as f:
    data = json.load(f)
levels = data["model_levels"]

def col(lv, key): return lv.get(key, "")

if vendor == "all":
    headers = ["Level", "Anthropic", "OpenAI", "Gemini", "Tokens", "Purpose"]
    rows = [[k, col(v,"anthropic"), col(v,"openai"), col(v,"gemini"), col(v,"token_range"), col(v,"purpose")]
            for k, v in sorted(levels.items(), key=lambda kv: int(kv[0]))]
else:
    headers = ["Level", vendor.capitalize(), "Tokens", "Purpose"]
    rows = [[k, col(v,vendor), col(v,"token_range"), col(v,"purpose")]
            for k, v in sorted(levels.items(), key=lambda kv: int(kv[0]))]

widths = [max(len(str(r[i])) for r in [headers, *rows]) for i in range(len(headers))]
def line(r): return "  ".join(str(c).ljust(widths[i]) for i, c in enumerate(r))
print(line(headers))
print(line(["-"*w for w in widths]))
for r in rows:
    print(line(r))
PY
