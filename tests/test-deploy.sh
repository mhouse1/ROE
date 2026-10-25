#!/usr/bin/env bash
# Tests for deploying the ROE template to a sibling project.
# Usage: bash tests/test-deploy.sh

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROE_ROOT=$(dirname "$SCRIPT_DIR")
SCRIPT="$ROE_ROOT/scripts/deploy-project.sh"
PROJECT_NAME="deploy-test-$$"
TARGET_DIR="$(dirname "$ROE_ROOT")/$PROJECT_NAME"
NEW_PROJECT_NAME="deploy-test-new-$$"
NEW_TARGET_DIR="$(dirname "$ROE_ROOT")/$NEW_PROJECT_NAME"

cleanup() {
  rm -rf "$TARGET_DIR" "$NEW_TARGET_DIR"
}
trap cleanup EXIT

# A missing sibling directory is created, then populated.
[[ ! -e "$NEW_TARGET_DIR" ]]
bash "$SCRIPT" "$NEW_PROJECT_NAME" > /dev/null
[[ -f "$NEW_TARGET_DIR/AGENTS.md" ]]
[[ -f "$NEW_TARGET_DIR/.gitignore" ]]

# A name that escapes the parent directory is rejected.
if bash "$SCRIPT" "../$NEW_PROJECT_NAME" > /dev/null 2>&1; then
  echo "expected a project name containing '/' to be rejected" >&2
  exit 1
fi

# An existing sibling directory keeps its own files.

mkdir -p "$TARGET_DIR"
printf "keep me\n" > "$TARGET_DIR/README.md"

bash "$SCRIPT" "$PROJECT_NAME" > /dev/null

[[ "$(cat "$TARGET_DIR/README.md")" == "keep me" ]]
[[ -f "$TARGET_DIR/AGENTS.md" ]]
[[ -f "$TARGET_DIR/.gitignore" ]]
[[ ! -e "$TARGET_DIR/.git" ]]

echo "Deploy tests passed."