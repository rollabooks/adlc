#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(pwd)"

usage() {
  cat <<'EOF'
Usage: bash .ai-dlc/tools/update-projects.sh [--repo-root PATH]

Scans for _CONTEXT.md files and regenerates .ai-dlc/projects.json.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-root)
      REPO_ROOT="$2"
      shift 2
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

mkdir -p "$REPO_ROOT/.ai-dlc"
output="$REPO_ROOT/.ai-dlc/projects.json"
tmp="$(mktemp)"

if command -v python3 >/dev/null 2>&1; then
  python3 - "$REPO_ROOT" "$output" <<'PY'
import json
import os
import sys
from datetime import datetime, timezone

repo = os.path.abspath(sys.argv[1])
output = sys.argv[2]
projects = []

for root, dirs, files in os.walk(repo):
    if ".git" in dirs:
        dirs.remove(".git")
    if "_CONTEXT.md" not in files:
        continue
    rel = os.path.relpath(root, repo)
    rel_posix = "." if rel == "." else rel.replace(os.sep, "/")
    project_id = "root" if rel_posix == "." else rel_posix.replace("/", "-")
    prefix = "" if rel_posix == "." else rel_posix + "/"
    projects.append({
        "id": project_id,
        "name": project_id,
        "root": rel_posix,
        "context": prefix + "_CONTEXT.md",
        "progress": prefix + "PROGRESS.md",
        "project_rules": prefix + ".ai-dlc/project",
        "company_extension": prefix + ".ai-dlc/company",
    })

manifest = {
    "version": "1.0",
    "generated_at": datetime.now(timezone.utc).isoformat(),
    "projects": sorted(projects, key=lambda item: item["root"]),
}

with open(output, "w", encoding="utf-8") as f:
    json.dump(manifest, f, indent=2)
    f.write("\n")

print(f"Updated: .ai-dlc/projects.json ({len(projects)} projects)")
PY
elif command -v python >/dev/null 2>&1; then
  python - "$REPO_ROOT" "$output" <<'PY'
import json
import os
import sys
from datetime import datetime

repo = os.path.abspath(sys.argv[1])
output = sys.argv[2]
projects = []

for root, dirs, files in os.walk(repo):
    if ".git" in dirs:
        dirs.remove(".git")
    if "_CONTEXT.md" not in files:
        continue
    rel = os.path.relpath(root, repo)
    rel_posix = "." if rel == "." else rel.replace(os.sep, "/")
    project_id = "root" if rel_posix == "." else rel_posix.replace("/", "-")
    prefix = "" if rel_posix == "." else rel_posix + "/"
    projects.append({
        "id": project_id,
        "name": project_id,
        "root": rel_posix,
        "context": prefix + "_CONTEXT.md",
        "progress": prefix + "PROGRESS.md",
        "project_rules": prefix + ".ai-dlc/project",
        "company_extension": prefix + ".ai-dlc/company",
    })

manifest = {
    "version": "1.0",
    "generated_at": datetime.utcnow().isoformat() + "Z",
    "projects": sorted(projects, key=lambda item: item["root"]),
}

with open(output, "w") as f:
    json.dump(manifest, f, indent=2)
    f.write("\n")

print("Updated: .ai-dlc/projects.json (%s projects)" % len(projects))
PY
else
  printf 'Cannot update projects.json: python is required.\n' >&2
  exit 1
fi

rm -f "$tmp"
