# Roadmap 001 — ROE Adoption for Legacy Projects

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-04-12 | 1.0.0           |

## What

A structured process for applying the ROE conventions to existing or legacy projects that predate this repository. This covers incrementally bringing an established project's documentation, code review, and decision history into alignment with the rules defined in CLAUDE.md.

## Why

New projects can follow ROE from the start, but most real-world work involves codebases and teams that already have history. Without a defined adoption path, contributors either skip ROE entirely or apply it inconsistently — creating two classes of projects. A lightweight onboarding process lowers the barrier and makes adoption practical.

## Scope

- A checklist or job aid for assessing how far a legacy project deviates from ROE conventions
- Guidance on retrofitting `docs/` structure (ADRs, code reviews, roadmap entries) without requiring a full historical rewrite
- Rules for handling pre-existing decisions: when to write a retroactive ADR vs. when to simply note the decision in a new document
- A migration status convention so it is clear at a glance how far along a project's adoption is

## Out of Scope

- Automated tooling or scripts (covered separately if needed)
- Enforcing ROE on external repositories not managed here

## Open Questions

- Should retroactive ADRs carry `Accepted` status or a distinct `Retroactive` status to distinguish them from decisions made under ROE?
- Is a single job aid sufficient, or does adoption complexity vary enough to warrant per-domain guides (firmware vs. software vs. hardware)?
