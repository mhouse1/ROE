# ADR 003 — ROE Configuration File

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-05-09 | 1.0.1           |

## Context

ROE is used by contributors across different project types and with different workflows. Currently, AI-assisted behaviors (such as auto-reviewing new ADRs or triggering agent actions when implementing decisions) are either always-on or require manual invocation. There is no per-project or per-user way to tune which agent automations run and how they behave.

A lightweight configuration file would let users opt into or out of specific behaviors without modifying the core rules or CLAUDE.md.

Project characteristics can also change after ROE is first applied — a repository that begins as a private or local project may later be published or open-sourced. The configuration must support this kind of transition: settings should be adjustable at any point in the project lifecycle without requiring ROE to be re-applied or re-scaffolded.

## Decision

Add a `roe.config.json` (or `roe.config.yaml`) configuration file at the repository root. The file is optional — ROE operates with sensible defaults when it is absent. When present, it controls agent behaviors scoped to this project.

## Configuration Parameters

The following parameters are in scope for initial consideration:

### Project Type

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `local_project` | bool | `false` | Marks this repository as a local-only project not published to GitHub. When `true`, the Makefile suppresses all remote operations (`git push`, `gh pr create`, and similar). Local projects may also carry different security classifications and permission assumptions than open-source projects — consumers should review tool permissions accordingly. This flag can be toggled at any time as project visibility changes (e.g., transitioning from private to open source); no re-scaffolding is required |

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
  "local_project": false,
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

## Alternatives Considered

- **CLAUDE.md-only configuration:** Embedding behavior flags directly in CLAUDE.md is simpler but mixes rules (which are stable) with per-project tuning (which changes frequently). Keeping them separate avoids churn in the canonical rules file.
- **Environment variables only:** Suitable for CI overrides but not for persistent project-level defaults checked into the repo.
- **No configuration (convention only):** Acceptable for a single-user or single-project tool, but ROE is intended as a reusable scaffold across project types. Configuration makes it adaptable without forking.

## Consequences

- Contributors can enable automation incrementally rather than all-or-nothing.
- The config file should itself be validated on load (schema or required-field checks) so misconfiguration is caught early.
- A future ADR will be needed if the config schema undergoes breaking changes.
- The absence of the file must always be a valid, fully functional state — ROE cannot require the config to operate.
- When `local_project: true`, all Makefile targets that invoke remote git operations (`push`, `gh pr create`, etc.) must check the flag and exit cleanly with an informational message rather than failing or silently skipping. This prevents accidental publication of proprietary or restricted work.
- Local projects may operate under stricter security classifications. Tool permissions granted in open-source project configurations (e.g., broad GitHub API access) should be reviewed and scoped down before use in a `local_project` context.
- The configuration is designed to be adjusted at any point in the project lifecycle — not just at initial setup. Changing a flag (such as flipping `local_project` from `true` to `false` when a repo goes public) takes effect immediately with no structural changes to the repository. Contributors should treat the config file as a living document that tracks the current state of the project, not a one-time scaffold choice.
