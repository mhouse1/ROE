#!/usr/bin/env bash
# Tests for deploying the ROE template to an existing sibling project.
# Usage: bash tests/test-deploy.sh

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROE_ROOT=$(dirname "$SCRIPT_DIR")
SCRIPT="$ROE_ROOT/scripts/deploy-project.sh"
PROJECT_NAME="deploy-test-$$"
TARGET_DIR="$(dirname "$ROE_ROOT")/$PROJECT_NAME"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

mkdir -p "$TARGET_DIR"
printf "keep me\n" > "$TARGET_DIR/README.md"

bash "$SCRIPT" "$PROJECT_NAME" > /dev/null

[[ "$(cat "$TARGET_DIR/README.md")" == "keep me" ]]
[[ -f "$TARGET_DIR/AGENTS.md" ]]
[[ -f "$TARGET_DIR/.gitignore" ]]
[[ ! -e "$TARGET_DIR/.git" ]]

echo "Deploy tests passed."