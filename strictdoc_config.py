"""StrictDoc project config (ADR 007).

@relation(UID, scope=line) markers in scripts/*.sh and the Makefile bind
requirements to the code that implements them; the export fails with exit 1
when a marker names a UID that does not exist, or an sdoc relation dangles.
Paths are relative to the project root, which is the strictdoc invocation
input path — so `make reqs-gate` runs strictdoc against the repo root (.),
with document discovery scoped to docs/requirements only.

Pinned to strictdoc==0.27.1 (0.x tool: do not float — see docs/research/002
in the wingman project, the verified spike this project's adoption follows).
"""

from strictdoc.core.project_config import ProjectConfig


def create_config() -> ProjectConfig:
    return ProjectConfig(
        project_title="ROE Requirements",
        project_features=[
            "REQUIREMENT_TO_SOURCE_TRACEABILITY",
        ],
        include_doc_paths=[
            # .sdoc only: the committed markdown export lives beside the
            # source, and StrictDoc ingests .md as documents — matching them
            # re-declares the document UID and fails the build.
            "docs/requirements/*.sdoc",
        ],
        include_source_paths=[
            "scripts/*.sh",
            "Makefile",
        ],
    )
