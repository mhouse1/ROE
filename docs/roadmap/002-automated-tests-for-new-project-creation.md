# Roadmap 002 — Automated Tests for New Project Creation

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-04-12 | 1.0.0           |

## What

Automated tests that verify `make r` (via `scripts/initialize-new-project.sh`) produces a correctly structured new project. Tests run against the actual script output and assert that the scaffolded result matches expectations.

## Why

`make r` is the entry point for every new project. If it silently produces a malformed scaffold — missing folders, wrong file prefixes, absent config files — errors propagate into the project before anyone notices. A test suite catches regressions before they escape.

## Scope

- Tests live under `tests/` and can be run without external dependencies
- Assert that all expected `docs/` subdirectories are created
- Assert that scaffold files follow the sequential numbering convention (`001-…`)
- Assert that `ARCHITECTURE.md` and other expected root-level files are present and non-empty
- Assert that `.roe-version` is written with the correct version and date
- A `make test` target that runs the suite and reports pass/fail

## Out of Scope

- Testing content quality or document correctness (human review handles that)
- CI integration (tracked separately if needed)

## Open Questions

- Should tests use a temp directory and clean up after themselves, or write to `tests/test-output/` for inspection?
- Is a shell-based test runner (e.g., `bats`) appropriate, or plain `bash` assertions?
