# ADR 008 — Adopt Wingman's Workflow Improvements

| Status | Date       | Project Version |
|--------|------------|-----------------|
| Draft  | 2026-10-25 | 1.2.0           |

## Decision

Fix how ROE delivers its own changes, and adopt the parts of wingman's refined rules and Makefile that hold for any project.

Delivery fixes:

1. `make template` rebuilds `tests/test-output/ROE_TEMPLATE_PROJECT` from the current checkout. `make deploy` and `make test` run it first ([DEPLOY-002](../requirements/001-deploy.md), revised).
2. The Makefile's standard section holds only targets every project shares. ROE's own targets and their usage live under the custom section, which the scaffold never copies.

Adopted from wingman:

3. `make nb <name>` starts a branch from `origin/main` with no upstream, and refuses a name that is also a make target (which would otherwise run next).
4. `make hooks` and `.githooks/pre-push`: an opt-in hook that runs `make test` before each push, and lets a project with no `test` target through. Shipped in the scaffold.
5. `make test` runs every `tests/test-*.sh` instead of a hand-kept list.
6. `AGENTS.md`: new `## ADR — Shape` and `## README — Link Every Doc Reference` sections; three requirements bullets (identity in the UID, tunable values out of statements, generated exports exempt from the heading table); a Glob rationale that names itself as the exception to `## Command Execution`; and "ask before installing system tools".

Not adopted: wingman's Python threading and uv environment rules, its Docker and host-guard targets, and its `check` and `iterate` skills. Each is language-, tool- or project-specific, and ROE rules must be system-agnostic ([CONTRIBUTING](../../CONTRIBUTING.md)). Its `proceed` skill ships as a tracked exception, [ADR 009](009-claude-code-proceed-skill-agent-specific-exception.md).

## Consequences

- Every deploy ships the current rules and Makefile. `make deploy` and `make test` each spend about a second rebuilding the template.
- `make test` no longer depends on an earlier `make r`, so the pre-push hook works on a fresh clone.
- Projects scaffolded from 1.2.0 get `nb`, `hooks` and the hook script. A project deployed earlier gets the hook file on its next `make deploy`, but not the new targets: deploy never overwrites an existing Makefile (DEPLOY-004), so those are merged by hand.
- ROE version 1.2.0: minor, for new rules and scaffold additions.

## Context

Wingman, a sibling project that runs ROE's rules from its own `CLAUDE.md`, refined them under daily use after ROE 1.1.0. A comparison on 2026-10-25 found the improvements above, and two defects in delivery:

- `make deploy` rebuilt the template only when it was missing, so it shipped whatever an earlier `make r` left behind. The template on disk was ROE 1.0.0 from 2026-07-18, without the agent commit rule or `make q`.
- The scaffold copied everything above the Makefile's custom section, which by then held ROE's own `deploy` target and listed `reqs` and `reqs-gate` in `.PHONY`. A new project would have inherited a `deploy` target that calls scripts it does not have.

The adopted items each answer a failure wingman recorded: a branch reused after its PR merged conflicted with main in every file both touched (ROE's PRs #1 and #2 both came from the branch `080826`); a hand-kept test list had dropped 8 of 57 test files; and its ADRs grew until they cost more to read than the code they describe.

## Validation

- `make test` green, with scaffold checks for every standard target, no leaked ROE targets, the `nb` guard, and the hook.
- `make reqs-gate` green with DEPLOY-002's marker on the `deploy` rule.
