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

# source directory must exist
if [[ -d "$TARGET_DIR/source" ]]; then
  check "source/ directory exists" "ok"
else
  check "source/ directory exists" "directory not found"
fi

# docs/research directory must exist and be tracked by git
if [[ -d "$TARGET_DIR/docs/research" && -f "$TARGET_DIR/docs/research/.gitkeep" ]]; then
  check "docs/research/ directory exists with .gitkeep" "ok"
else
  check "docs/research/ directory exists with .gitkeep" "directory or .gitkeep not found"
fi

# ARCHITECTURE.md line count must not exceed 6
arch_file="$TARGET_DIR/docs/ARCHITECTURE.md"
arch_lines=$(wc -l < "$arch_file")
if [[ "$arch_lines" -le 6 ]]; then
  check "docs/ARCHITECTURE.md is at most 6 lines (got $arch_lines)" "ok"
else
  check "docs/ARCHITECTURE.md is at most 6 lines" "got $arch_lines lines"
fi

# Makefile must carry every standard command
makefile="$TARGET_DIR/Makefile"
missing=""
for target in c d f hooks n nb p q s squash t; do
  grep -q "^$target:" "$makefile" || missing+=" $target"
done
if [[ -z "$missing" ]]; then
  check "Makefile has every standard command" "ok"
else
  check "Makefile has every standard command" "missing:$missing"
fi

# Makefile must not inherit ROE's own targets, which call scripts the project lacks
leaked=""
for target in deploy reqs reqs-gate template test; do
  grep -qE "^$target:|^\.PHONY:.* $target( |\$)" "$makefile" && leaked+=" $target"
done
if [[ -z "$leaked" ]]; then
  check "Makefile has none of ROE's own targets" "ok"
else
  check "Makefile has none of ROE's own targets" "found:$leaked"
fi

# Makefile must parse
if make -C "$TARGET_DIR" -n s > /dev/null 2>&1; then
  check "Makefile parses" "ok"
else
  check "Makefile parses" "make -n s failed"
fi

# make nb must refuse a branch name that is also a make target, before git runs
nb_out=$(make -C "$TARGET_DIR" nb s 2>&1 || true)
if [[ "$nb_out" == *"is also a make target"* ]]; then
  check "make nb refuses a name that is a make target" "ok"
else
  check "make nb refuses a name that is a make target" "guard did not fire"
fi

# pre-push hook must ship executable, and pass a project with no test target yet
hook="$TARGET_DIR/.githooks/pre-push"
if [[ -x "$hook" ]]; then
  check ".githooks/pre-push exists and is executable" "ok"
else
  check ".githooks/pre-push exists and is executable" "missing or not executable"
fi
if (cd "$TARGET_DIR" && "$hook" < /dev/null > /dev/null 2>&1); then
  check "pre-push passes a project with no test target" "ok"
else
  check "pre-push passes a project with no test target" "hook exited non-zero"
fi

# Claude Code proceed skill must ship (ADR 009)
if [[ -f "$TARGET_DIR/.claude/skills/proceed/SKILL.md" ]]; then
  check ".claude/skills/proceed/SKILL.md exists" "ok"
else
  check ".claude/skills/proceed/SKILL.md exists" "file not found"
fi

echo ""
echo "Results: $pass passed, $fail failed"
[[ "$fail" -eq 0 ]]
