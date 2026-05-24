# ADR 003 — ROE Configuration File

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft | 2026-05-09 | 1.0.1           |

## Context

ROE is used by contributors across different project types and with different workflows. Currently, AI-assisted behaviors (such as auto-reviewing new ADRs or triggering agent actions when implementing decisions) are either always-on or require manual invocation. There is no per-project or per-user way to tune which agent automations run and how they behave.

A lightweight configuration file would let users opt into or out of specific behaviors without modifying the core rules or AGENTS.md.

Project characteristics can also change after ROE is first applied — a repository that begins as a closed-source project may later be published or open-sourced. The configuration must support this kind of transition: settings should be adjustable at any point in the project lifecycle without requiring ROE to be re-applied or re-scaffolded.

## Decision

Add a required `roe.config.json` (or `roe.config.yaml`) configuration file at the repository root. ROE must fail hard if the config file is missing or invalid. The config controls agent behaviors scoped to the project.

## Configuration Parameters

The following parameters are in scope for initial consideration:

### Project Type

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `open_source_project` | bool | `false` | Marks this repository as intended for public/open-source distribution. When `false` (or omitted), the project is treated as closed-source by default. In closed-source mode, the Makefile suppresses remote publication operations (`git push`, `gh pr create`, and similar). When `true`, ROE can enable open-source defaults (for example, public-facing templates or checks) without requiring manual setup in each project |
| `open_source_license` | string | _none_ | Required only when `open_source_project` is `true`. Allowed values: `"GPL"`, `"MIT"`, `"Apache"`. Ignored when `open_source_project` is `false` |

### Document Automation

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `auto_review_on_adr_create` | bool | `false` | Automatically trigger an AI review pass when a new ADR is created |
| `auto_review_on_adr_accept` | bool | `false` | Trigger review when an ADR status changes to Accepted |
| `auto_implement_adr` | bool | `false` | When an ADR is accepted, prompt the agent to draft implementation tasks |
| `adr_review_model` | string | `"default"` | Which Claude model to use for ADR review passes (`"sonnet"`, `"opus"`, `"haiku"`, `"default"`) |

### Workflow Hooks

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `require_adr_for_breaking_change` | bool | `false` | Warn (or block) when a breaking change is detected without a linked ADR |
| `roadmap_sync_on_adr_accept` | bool | `false` | When an ADR is accepted, automatically update the linked roadmap document status |
| `enforce_sequential_numbering` | bool | `true` | Enforce the zero-padded sequential numbering rule for all `docs/` subdirectories |

### Review Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enable_review_mode` | bool | `false` | Enables a restricted review-only execution mode. When `true`, review runs must: (1) only attempt command execution through Bash and `uv`, (2) auto-approve review actions that do not require additional user confirmation, and (3) never modify source files; output is limited to review artifacts (for example, under `docs/code-review/`) |
| `default_review_scope` | string | `"branch"` | Scope of code reviews: `"branch"` (changes since main) or `"full"` (entire repo) |
| `security_review_on_pr` | bool | `false` | Automatically run a security review pass on new PRs |
| `review_output_dir` | string | `"docs/code-review"` | Where generated review documents are written |

### Numbering and Formatting

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `diagram_format` | string | `"mermaid"` | Enforced diagram format. Currently only `"mermaid"` is supported; here for future extensibility |
| `version_source` | string | `"VERSION"` | File to read for the project version injected into document headers |

## Example Configuration

```json
{
  "open_source_project": true,
  "open_source_license": "MIT",
  "enable_review_mode": true,
  "auto_review_on_adr_create": true,
  "adr_review_model": "sonnet",
  "require_adr_for_breaking_change": true,
  "roadmap_sync_on_adr_accept": true,
  "security_review_on_pr": false,
  "review_output_dir": "docs/code-review",
  "enforce_sequential_numbering": true,
  "version_source": "VERSION"
}
```

## Validation Schema (Excerpt)

The following JSON Schema excerpt captures the core validation behavior for project visibility and licensing defaults:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "open_source_project": {
      "type": "boolean",
      "default": false
    },
    "open_source_license": {
      "type": "string",
      "enum": [
        "GPL",
        "MIT",
        "Apache"
      ]
    }
  },
  "if": {
    "properties": {
      "open_source_project": {
        "const": true
      }
    },
    "required": [
      "open_source_project"
    ]
  },
  "then": {
    "required": [
      "open_source_license"
    ]
  }
}
```

Implementation note: reject any `open_source_license` value outside `GPL`, `MIT`, and `Apache`.

## Implementation Tests

Tests for this ADR live in `tests/` at the ROE repository root (`/github/ROE/tests`).

- Valid config: `open_source_project: true` with `open_source_license: MIT` loads successfully.
- Valid config: omitted `open_source_project` defaults to closed-source behavior.
- Invalid config: `open_source_project: true` without `open_source_license` must fail hard.
- Invalid config: `open_source_license` value outside `GPL`, `MIT`, `Apache` must fail hard.
- Invalid config: missing `roe.config.json` (or `roe.config.yaml`) must fail hard.
- Runtime behavior: when `open_source_project: false` (explicit or default), remote publication targets are blocked with a clear error.
- Runtime behavior: when `open_source_project: true`, open-source defaults can be applied without changing core ROE rules.
- Runtime behavior: when `enable_review_mode: true`, review execution only attempts commands via Bash and `uv`.
- Runtime behavior: when `enable_review_mode: true`, review actions are auto-approved where no extra confirmation is required.
- Runtime behavior: when `enable_review_mode: true`, source files are never modified; only review outputs are written.

Validation failure behavior for all invalid cases above: stop execution immediately and return a non-zero exit code.

## Alternatives Considered

- **AGENTS.md-only configuration:** Embedding behavior flags directly in AGENTS.md is simpler but mixes rules (which are stable) with per-project tuning (which changes frequently). Keeping them separate avoids churn in the canonical rules file.
- **Environment variables only:** Suitable for CI overrides but not for persistent project-level defaults checked into the repo.
- **No configuration (convention only):** Acceptable for a single-user or single-project tool, but ROE is intended as a reusable scaffold across project types. Configuration makes it adaptable without forking.

## Consequences

- Contributors can enable automation incrementally rather than all-or-nothing.
- The config file should itself be validated on load (schema or required-field checks) so misconfiguration is caught early.
- A future ADR will be needed if the config schema undergoes breaking changes.
- The configuration file is mandatory. If it is missing, ROE tooling must stop immediately with a clear error and a non-zero exit code.
- When `open_source_project: false` (or absent), all Makefile targets that invoke remote git operations (`push`, `gh pr create`, etc.) must block and exit with an informational message. This prevents accidental publication of proprietary or restricted work.
- Closed-source projects may operate under stricter security classifications. Tool permissions granted in open-source project configurations (for example, broad GitHub API access) should be reviewed and scoped down whenever `open_source_project` is not enabled.
- The configuration is designed to be adjusted at any point in the project lifecycle — not just at initial setup. Changing `open_source_project` from `false` to `true` when a repo goes public takes effect immediately with no structural changes to the repository. Contributors should treat the config file as a living document that tracks the current state of the project, not a one-time scaffold choice.
- When `open_source_project: true`, `open_source_license` must be set to one of `GPL`, `MIT`, or `Apache`; invalid values must fail hard with a clear error and a non-zero exit code.
- When `enable_review_mode: true`, review automation is constrained to a non-mutating path: command attempts are limited to Bash and `uv`, actions are auto-approved within review flow, and source tree modifications are disallowed.
