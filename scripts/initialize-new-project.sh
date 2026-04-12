#!/usr/bin/env bash
# sets up a new project with the necessary files and directories
# usage: ./initialize-new-project.sh <project-name>

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROE_ROOT=$(dirname "$SCRIPT_DIR")

# --- args ---
if [[ $# -lt 1 ]]; then
  echo "usage: $(basename "$0") <project-name>" >&2
  exit 1
fi

PROJECT_NAME="$1"
TARGET_DIR="$ROE_ROOT/test-output/$PROJECT_NAME"

if [[ -e "$TARGET_DIR" ]]; then
  echo "error: '$TARGET_DIR' already exists" >&2
  exit 1
fi

echo "Creating project '$PROJECT_NAME' at $TARGET_DIR"

# --- scaffold directories ---
mkdir -p \
  "$TARGET_DIR/.github" \
  "$TARGET_DIR/docs/adr" \
  "$TARGET_DIR/docs/job-aid" \
  "$TARGET_DIR/docs/performance" \
  "$TARGET_DIR/docs/code-review"

# keep empty docs dirs tracked by git
for dir in adr job-aid performance code-review; do
  touch "$TARGET_DIR/docs/$dir/.gitkeep"
done

ROE_VERSION=$(cat "$ROE_ROOT/VERSION")

# --- copy ROE files ---
cp "$ROE_ROOT/CLAUDE.md"                             "$TARGET_DIR/CLAUDE.md"
# Copy Makefile: keep only the standard commands section, strip the r target,
# then append a clean custom commands section for the new project.
awk '
  /Custom user-defined commands/ { exit }
  /^r:/                          { skip=1; next }
  skip && /^\t/                  { next }
  skip                           { skip=0 }
  /^\.PHONY:/                    { gsub(/ r /, " ") }
  { print }
' "$ROE_ROOT/Makefile" > "$TARGET_DIR/Makefile"
cat >> "$TARGET_DIR/Makefile" <<'MAKEFILE_CUSTOM'

# -----------------------------------------------------------------------------
# Custom user-defined commands
# Add your own targets below this line.
# -----------------------------------------------------------------------------
MAKEFILE_CUSTOM
cp "$ROE_ROOT/gitignore"                             "$TARGET_DIR/.gitignore"
cp "$ROE_ROOT/.github/copilot-instructions.md"       "$TARGET_DIR/.github/copilot-instructions.md"

# stamp which ROE version this project was scaffolded from
printf "roe_version=%s\ndate=%s\n" "$ROE_VERSION" "$(date +%Y-%m-%d)" > "$TARGET_DIR/.roe-version"

# --- starter README ---
cat > "$TARGET_DIR/README.md" <<EOF
# $PROJECT_NAME

> Brief description of the project.

## Quickstart

_Describe how to get started._

## docs/

All documentation lives under \`docs/\`. See \`CLAUDE.md\` for numbering and heading format rules.
EOF

# --- git init and initial commit ---
git -C "$TARGET_DIR" init -q
git -C "$TARGET_DIR" add .
git -C "$TARGET_DIR" commit -q -m "initial scaffold from ROE"

echo "Done. cd $PROJECT_NAME"
