# Roadmap 001 — ROE Adoption for Legacy Projects

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-05-22 | 1.0.0           |

## Summary

A structured process for applying the ROE conventions to existing or legacy projects that predate this repository. The goal is to bring an established project's documentation, code review, and decision history into alignment with the rules defined in CLAUDE.md without forcing a full historical rewrite.

## Problem

New projects can follow ROE from the start, but most real-world work involves codebases and teams that already have history. Without a defined adoption path, contributors either skip ROE entirely or apply it inconsistently, which creates two classes of projects: clean greenfield projects and undocumented legacy projects. A lightweight onboarding process lowers the barrier and makes adoption practical.

## Proposed Approach

- Start with a short adoption review that inventories the project’s current docs, decision records, and review process.
- Classify each gap as one of three cases: bring forward unchanged, document as a new ROE-era decision, or write a retroactive note only when the historical decision must be visible.
- Add the minimum required `docs/` structure first: ADRs for decisions, roadmap entries for planned work, and review records for active review cycles.
- Track migration progress with a simple status marker so contributors can see whether a project is not started, partially adopted, or fully aligned.
- Preserve existing historical artifacts when they are still useful; do not rewrite the past just to satisfy a formatting rule.
- Treat legacy Word documents as source material, not as a direct end state. Use automation for first-pass text conversion and image extraction, then finish the cleanup manually in Markdown.
- Keep pictures as first-class assets in a nearby numbered asset folder and reference them from the converted Markdown instead of trying to flatten them into text.

## Scope

- A checklist or job aid for assessing how far a legacy project deviates from ROE conventions
- Guidance on retrofitting `docs/` structure (ADRs, code reviews, roadmap entries) without requiring a full historical rewrite
- Rules for handling pre-existing decisions: when to write a retroactive ADR vs. when to simply note the decision in a new document
- A migration status convention so it is clear at a glance how far along a project's adoption is

## Success Criteria

- A reviewer can complete a legacy-project ROE assessment without consulting more than one supporting guide.
- A project can be marked as not started, in progress, or adopted using a single visible status convention.
- Existing decisions can be preserved without being rewritten, while new decisions still enter the normal ROE record flow.
- The adoption path works for firmware, software, and hardware projects without requiring separate rule sets.

## Out of Scope

- Automated tooling or scripts (covered separately if needed)
- Enforcing ROE on external repositories not managed here

## Recommendations

### Immediate

1. Define a single legacy-adoption checklist and make it the default entry point for all existing projects.
2. Use normal ADRs for new decisions made under ROE; reserve retroactive ADRs only for historical choices that need durable traceability.
3. Add one migration status field or badge per project so adoption progress is visible at a glance.

### Near-term

4. Add a small review template that asks whether the project has docs, ADRs, roadmap entries, and an active code review process.
5. Keep legacy content in place when it is still accurate, and wrap it with new ROE documents instead of rewriting history.
6. Publish one example adoption walkthrough for a representative legacy project so contributors can copy the pattern.
7. For Word-based legacy docs, document a hybrid migration workflow: export the text automatically where possible, extract images intact, then normalize the result into ROE Markdown by hand.

## Open Questions

- Should retroactive ADRs carry `Accepted` status or a distinct `Retroactive` status to distinguish them from decisions made under ROE?
- Is a single job aid sufficient, or does adoption complexity vary enough to warrant per-domain guides for firmware, software, and hardware?
