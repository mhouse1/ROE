#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROE_ROOT=$(dirname "$SCRIPT_DIR")
TEMPLATE_DIR="$ROE_ROOT/tests/test-output/ROE_TEMPLATE_PROJECT"
PROJECTS_DIR=$(dirname "$ROE_ROOT")  # @relation(DEPLOY-001, scope=line)

if [[ $# -ne 1 || -z "$1" ]]; then
  echo "usage: $(basename "$0") <project-name>" >&2
  exit 1
fi

PROJECT_NAME="$1"
TARGET_DIR="$PROJECTS_DIR/$PROJECT_NAME"

if [[ ! -d "$TARGET_DIR" ]]; then  # @relation(DEPLOY-003, scope=line)
  echo "error: project '$TARGET_DIR' does not exist" >&2
  exit 1
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "error: ROE template '$TEMPLATE_DIR' does not exist" >&2
  exit 1
fi

echo "Applying ROE to '$TARGET_DIR'"

for item in "$TEMPLATE_DIR"/* "$TEMPLATE_DIR"/.[!.]* "$TEMPLATE_DIR"/..?*; do
  [[ -e "$item" ]] || continue
  [[ "$(basename "$item")" == ".git" ]] && continue
  cp -an "$item" "$TARGET_DIR/"  # @relation(DEPLOY-004, scope=line)
done

echo "Done. Existing files were not overwritten."