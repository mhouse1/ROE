
# ROE — Rules Of Engagement for Development

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Active   | 2026-04-11 | 1.0.0           |

Pragmatic, system-agnostic rules for documentation, code review, and collaboration. Applies to all work in this repository, whether firmware, hardware, or other systems. All contributors must follow these rules to ensure clarity, traceability, and maintainability.

## Project Philosophy

- **Pragmatism over bureaucracy:** Commands in the Makefile are intentionally short for frequent use. Documentation is concise and actionable.
- **docs/ folder:** All documentation lives under `docs/`, with subfolders for ADRs, job aids, performance notes, code reviews, and more. All subfolders start empty and are populated as needed.
- **System-agnostic:** These rules apply to any type of project or artifact managed in this repository.


## Sequential Numbering — All `docs/` Subdirectories

Every file created under any subdirectory of `docs/` must have a zero-padded three-digit prefix:

```
001-my-document.md
002-another-document.md
```

Before creating a new file in any `docs/` subdirectory, list the existing files in that folder to find the highest number and increment by 1. Never guess or reuse a number — gaps and collisions break the sequence across sessions.

This applies to: `docs/adr/`, `docs/job-aid/`, `docs/performance/`, `docs/code-review/`, `docs/roadmap/`, and any future subdirectory under `docs/`.


## ADR — Sequential Numbering

The general sequential numbering rule above applies. Additionally: before creating a new ADR, list the files in `docs/adr/` to find the highest existing number and increment by 1.


## ADR — Performance Changes

Performance ADRs must include actual measured data, not just estimates. Before/after measurements should come directly from real system logs or test results.


## ADR — Superseding Decisions

Do not modify an ADR that has status `Accepted`. If a decision is superseded, write a new ADR and reference the old one. This keeps the decision history intact.


## Diagrams

Always use Mermaid for diagrams in documentation. Never use ASCII text diagrams (no box-drawing characters, no `┌─┐` borders, no `→` arrow art). Wrap all diagrams in a fenced code block with the `mermaid` language tag.


## Document Heading Format

All new documents (job aids, performance docs, code reviews, ADRs, and any other docs under `docs/`) must begin with a title and a compact status/metadata table immediately after:

```
# <Document Type NNN> — <Title>

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-04-11 | See Makefile    |
```

- Read the version from the `VERSION` file at the repository root — never guess it.
- Use today's actual date.
- Use `Draft` for new documents; update to `Active` or `Accepted` once reviewed.
- **ADRs** use `Accepted` (not `Draft`) from the moment they are written — an ADR records a decision already made.
- This rule applies to **all** new docs, not just ADRs.


## Review Todos

Review files live in `docs/code-review/` and are numbered sequentially (`001-YYYY-MM.md`, `002-…`, etc.). Each file covers one review cycle and is closed (immutable) once all items resolve.


## Roadmap — Planned Features

Planned and future features are tracked in `docs/roadmap/`. Each entry is a lightweight document describing what is planned and why — not a full design. Use `docs/hldd/` for detailed high-level design once work is underway.

Files follow the standard sequential numbering rule: `001-feature-name.md`, `002-…`, etc.

Roadmap documents use `Draft` status until the feature ships, then update to `Active`. If a planned feature is cancelled, update the status to `Cancelled` and note the reason — do not delete the file.