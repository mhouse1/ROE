# ADR 006 — Deploy the ROE Template to a Sibling Project

| Status | Date       | Project Version |
|--------|------------|-----------------|
| Draft  | 2026-08-23 | 1.0.0           |

## Context

ROE can create a new project under its test output directory, but existing sibling repositories need a simple way to adopt the same governance files. A deployment must not replace project-owned files. The intended invocation is `make deploy PROJECT_NAME` from the ROE repository, where both repositories are directories under the same parent.

## Decision

Add `make deploy PROJECT_NAME` to the ROE Makefile. The command will:

1. Resolve `PROJECT_NAME` as a directory beside the ROE repository.
2. Copy the contents of `tests/test-output/ROE_TEMPLATE_PROJECT` into that directory.
3. Preserve every existing file and directory in the destination.
4. Exclude the template repository's `.git` directory so deployment cannot replace or initialize the destination repository metadata.

The implementation will use a dedicated shell script so path resolution and copy behavior can be tested independently of Make.

## Consequences

- Existing sibling projects can adopt ROE with one command.
- Files already present in the destination are never overwritten.
- New template files are copied, including hidden files other than `.git`.
- The destination project must already exist beside ROE.
- Updating the template does not automatically update previously deployed projects.

## Implementation Notes

- Add `scripts/deploy-project.sh` for validation, sibling path resolution, and no-clobber copying.
- Add `tests/test-deploy.sh` to verify sibling deployment, preservation of an existing file, hidden-file copying, and `.git` exclusion.
- Include the deployment test in the `make test` target.