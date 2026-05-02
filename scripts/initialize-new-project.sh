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
TARGET_DIR="$ROE_ROOT/tests/test-output/$PROJECT_NAME"

if [[ -e "$TARGET_DIR" ]]; then
  echo "error: '$TARGET_DIR' already exists" >&2
  exit 1
fi

echo "Creating project '$PROJECT_NAME' at $TARGET_DIR"

# --- scaffold directories ---
mkdir -p \
  "$TARGET_DIR/.github" \
  "$TARGET_DIR/docs/adr" \
  "$TARGET_DIR/docs/hldd" \
  "$TARGET_DIR/docs/job-aid" \
  "$TARGET_DIR/docs/performance" \
  "$TARGET_DIR/docs/performance/logs" \
  "$TARGET_DIR/docs/code-review" \
  "$TARGET_DIR/docs/roadmap" \
  "$TARGET_DIR/docs/workflow"

# keep empty docs dirs tracked by git
for dir in adr hldd job-aid performance code-review roadmap workflow; do
  touch "$TARGET_DIR/docs/$dir/.gitkeep"
done
# keep logs dir tracked by git
touch "$TARGET_DIR/docs/performance/logs/.gitkeep"

ROE_VERSION=$(cat "$ROE_ROOT/VERSION")
PROJECT_VERSION="0.0.1"

# --- create VERSION early so other steps can reference it ---
printf "%s\n# Initial Version\n" "$PROJECT_VERSION" > "$TARGET_DIR/VERSION"

# --- copy ROE files ---
cp "$ROE_ROOT/CLAUDE.md"                             "$TARGET_DIR/CLAUDE.md"
cp "$ROE_ROOT/AGENTS.md"                             "$TARGET_DIR/AGENTS.md"
# Copy Makefile: keep only the standard commands section, strip the r target,
# then append a clean custom commands section for the new project.
awk '
  /Custom user-defined commands/ { exit }
  /^r:/                          { skip=1; next }
  skip && /^\t/                  { next }
  skip                           { skip=0; next }
  /^\.PHONY:/                    { gsub(/ r /, " "); gsub(/ test/, "") }
  { print }
' "$ROE_ROOT/Makefile" > "$TARGET_DIR/Makefile"
cat >> "$TARGET_DIR/Makefile" <<'MAKEFILE_CUSTOM'

# -----------------------------------------------------------------------------
# Custom user-defined commands
# Add your own targets below this line.
# -----------------------------------------------------------------------------

.PHONY: r

r:
	@echo "This is project specific, you'll have to define this yourself"
MAKEFILE_CUSTOM
cp "$ROE_ROOT/gitignore"                             "$TARGET_DIR/.gitignore"
cp "$ROE_ROOT/.github/copilot-instructions.md"       "$TARGET_DIR/.github/copilot-instructions.md"
cp "$ROE_ROOT/docs/assets/CONTRIBUTING_generic.md"   "$TARGET_DIR/CONTRIBUTING.md"

# stamp which ROE version this project was scaffolded from
printf "roe_version=%s\ndate=%s\n" "$ROE_VERSION" "$(date +%Y-%m-%d)" > "$TARGET_DIR/.roe-version"

# --- starter ARCHITECTURE ---
cat > "$TARGET_DIR/docs/ARCHITECTURE.md" <<EOF
# Architecture

| Status | Date       | Project Version |
|--------|------------|-----------------|
| Draft  | $(date +%Y-%m-%d) | $PROJECT_VERSION     |
EOF

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
