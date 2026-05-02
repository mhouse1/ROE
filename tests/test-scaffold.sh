#!/usr/bin/env bash
# Tests for initialize-new-project.sh scaffold output.
# Usage: bash tests/test-scaffold.sh

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROE_ROOT=$(dirname "$SCRIPT_DIR")
SCRIPT="$ROE_ROOT/scripts/initialize-new-project.sh"
TEST_PROJECT="scaffold-test-$$"
TARGET_DIR="$ROE_ROOT/tests/test-output/$TEST_PROJECT"

pass=0
fail=0

check() {
  local desc="$1"
  local result="$2"
  if [[ "$result" == "ok" ]]; then
    echo "  PASS: $desc"
    (( pass++ )) || true
  else
    echo "  FAIL: $desc — $result"
    (( fail++ )) || true
  fi
}

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

echo "Running scaffold tests..."
bash "$SCRIPT" "$TEST_PROJECT" > /dev/null

# AGENTS.md must exist
if [[ -f "$TARGET_DIR/AGENTS.md" ]]; then
  check "AGENTS.md exists" "ok"
else
  check "AGENTS.md exists" "file not found"
fi

# ARCHITECTURE.md line count must not exceed 6
arch_file="$TARGET_DIR/docs/ARCHITECTURE.md"
arch_lines=$(wc -l < "$arch_file")
if [[ "$arch_lines" -le 6 ]]; then
  check "docs/ARCHITECTURE.md is at most 6 lines (got $arch_lines)" "ok"
else
  check "docs/ARCHITECTURE.md is at most 6 lines" "got $arch_lines lines"
fi

echo ""
echo "Results: $pass passed, $fail failed"
[[ "$fail" -eq 0 ]]
