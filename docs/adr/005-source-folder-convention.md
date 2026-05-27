# ADR 005 — Use source/ as the Default Project Code Directory

| Status | Date       | Project Version |
|--------|------------|-----------------|
| Draft  | 2026-05-27 | 1.0.0           |

## Context

ROE currently scaffolds project governance and documentation structure but does not create a dedicated directory for implementation code.

A common convention in software projects is `src/` because it is short and widely recognized by developers and tooling. However, ROE is intentionally used across mixed audiences, including contributors who may not be programmers. In those contexts, a fully spelled-out directory name improves immediate comprehension.

The historical tradeoff for `source/` has been extra typing overhead compared with `src/`. For ROE workflows, that cost is minimal because path typing is increasingly automated by modern shells, editors, and AI-assisted tooling.

## Decision

1. ROE will adopt `source/` as the default directory name for project implementation code in scaffolded projects.
2. The scaffold generator will create `source/` in every newly initialized project.
3. `source/` is a default convention, not a technical restriction. Projects may introduce additional language- or framework-specific layouts when needed.

## Rationale

- **Clearer to broader audiences:** `source/` is self-explanatory to non-programmers and cross-functional stakeholders.
- **Consistent default:** A named code location reduces ambiguity in newly created repositories.
- **Low practical cost:** Automation and editor tooling make longer path names effectively trivial to use.

## Consequences

- Newly scaffolded projects include `source/` by default.
- Existing projects are not forced to rename `src/`; migration remains optional.
- Documentation and onboarding material should reference `source/` as the default code location.

## Implementation Notes

- Update `scripts/initialize-new-project.sh` to create `source/` and track it with `.gitkeep`.
- Update scaffold tests to verify `source/` is present in generated output.
