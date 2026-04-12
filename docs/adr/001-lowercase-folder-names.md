# ADR 001 — Lowercase Folder Names and the Exception for ARCHITECTURE.md

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Accepted | 2026-04-12 | 1.0.0           |

## Context

All subdirectories under `docs/` use lowercase names (e.g., `adr/`, `job-aid/`, `review/`). This was not accidental.

## Decision

Folder names under `docs/` are lowercase. No tooling enforces this.

## Reasons

- **One less key to press.** Shift is effort. Lowercase is faster to type and easier to tab-complete.
- **Pragmatism over convention.** There is no technical requirement for title case or uppercase. Lowercase works everywhere: Unix paths, URLs, CLI tab completion, and `make` targets.
- **Tone.** WRITING IN ALL CAPS IS WIDELY UNDERSTOOD AS SHOUTING. Folder names are not shouting. They are quiet, structural things that should not demand attention.

## Enforcement

None. Contributors are trusted to follow the pattern. A linter would be more ceremony than the problem warrants.

## Exception — ARCHITECTURE.md

`ARCHITECTURE.md` is uppercase by design. This is not a contradiction — it is a deliberate contrast.

Folder names are infrastructure. They are plumbing. They do not need to raise their voice.

`ARCHITECTURE.md` is a statement of intent. The architect of a project puts their name behind the decisions in that file: why the system is shaped the way it is, what forces drove the design, and what the cost of deviating will be. That document is not a suggestion. It is not a starting point for debate. It carries weight, and its name should reflect that weight.

Uppercase signals: *read this before you change anything*. It is the same reason `README.md`, `LICENSE`, and `Makefile` are capitalized in virtually every serious project — convention has taught developers to look for uppercase root-level files first. `ARCHITECTURE.md` belongs in that company.

Folders whisper. `ARCHITECTURE.md` speaks.

## Consequences

Folder names are consistent and calm. The rare contributor who creates a capitalized folder will be gently corrected by peer review, not by a failing CI check.

The uppercase exception for `ARCHITECTURE.md` is intentional and should not be normalized into lowercase. If a contributor asks why, point them here.
