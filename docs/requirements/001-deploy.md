# ROE Deploy Requirements

**UID**: DOC-DEPLOY \
**Prefix**: DEPLOY-

Behaviour of `make deploy PROJECT_NAME`, which applies the ROE template to an
existing sibling project without disturbing that project's own files. ADR 006
recorded the original decision; these requirements state the properties it
must hold, checked against scripts/deploy-project.sh and the Makefile on
every `make test` via `make reqs-gate`.

## Deploy targets adjacent project folders

**UID**: DEPLOY-001

**Statement**: `make deploy PROJECT_NAME` shall resolve PROJECT_NAME as a directory that is
a sibling of the ROE repository (that is, in the parent of the ROE repository
root) and shall copy the ROE template into that directory.

**Rationale**: ADR 006: both repositories are directories under the same parent; this is
the invocation ROE deploy is built around. Implemented by the PROJECTS_DIR
and TARGET_DIR resolution in scripts/deploy-project.sh.

## Deploy is automated when the template has not been generated

**UID**: DEPLOY-002

**Statement**: `make deploy` shall not require a separate manual step to generate the ROE
template first: when tests/test-output/ROE_TEMPLATE_PROJECT does not already
exist, `make deploy` shall run `make r` itself before deploying.

**Rationale**: Requested so a first-time `make deploy` on a clean checkout does not fail
with a missing-template error. Implemented in the Makefile `deploy` target's
existence check ahead of scripts/deploy-project.sh.

## Deploy supports an empty destination folder

**UID**: DEPLOY-003

**Statement**: `make deploy PROJECT_NAME` shall succeed when the destination sibling
directory already exists but is empty, copying the full template into it.

**Rationale**: Covers adopting ROE into a sibling project that was created but not yet
populated. Verified by tests/test-deploy.sh, which deploys into a freshly
created empty directory.

## Deploy never overwrites existing destination files

**UID**: DEPLOY-004

**Statement**: `make deploy` shall not overwrite any file that already exists in the
destination directory. Only files absent from the destination shall be
written.

**Rationale**: SAFETY-tier: deploying into a live sibling project must never destroy that
project's own work. Implemented with `cp -an` (no-clobber) in
scripts/deploy-project.sh. Verified by tests/test-deploy.sh, which asserts a
pre-existing README.md survives deployment unchanged.
