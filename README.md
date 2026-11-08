# ROE — Rules of Engagement for Development

| Status | Date       | Revised    | ROE Version |
|--------|------------|------------|-------------|
| Active | 2026-04-12 | 2026-10-25 | 1.2.0       |

Pragmatic, system-agnostic rules for documentation, code review, and AI-assisted collaboration. Apply this framework to any project — firmware, hardware, software, or otherwise.

## Why This Exists

Every design decision in ROE points to the same root cause: **project knowledge evaporates**.

Engineers leave. Decisions get relitigated. Systems go undocumented for years, then get handed to someone who has to reverse-engineer intent from code. ROE exists because the cost of that knowledge loss is real, and most of it is preventable with simple, consistent habits.

The rules here are not clever. They are not innovative. They are the minimum structure needed to ensure that the next person — or the same person years later — can understand what was built, why it was built that way, and what it will cost to change it.

ROE is a meta-project: it is not software that does something. It scaffolds other projects so they inherit documentation structure, decision records, and AI integration from day one — before there is anything to lose.

## Quickstart

ROE builds a template project, then delivers it. Two commands, two situations.

### Build the template

```bash
make r
```

Prompts for a project name (default `ROE_TEMPLATE_PROJECT`) and generates a fully scaffolded project under `tests/test-output/`, then runs the test suite. The template is a build artifact — `make r` deletes and regenerates `tests/test-output/` each time, so never keep work there.

### Deploy to a project

```bash
make deploy PROJECT_NAME
```

Copies the template into `../PROJECT_NAME`, a sibling directory of this repository, creating the directory if it does not exist. **Existing files are never overwritten** — only missing files are added, and the template's `.git` directory is excluded. Safe to run against a project that already has history. See [ADR 006](docs/adr/006-deploy-template-to-sibling-project.md).

`make deploy` rebuilds the template from the current checkout first, so a deploy always ships the rules and Makefile ROE holds now. See [ADR 008](docs/adr/008-adopt-wingman-workflow-improvements.md) and [DEPLOY-002](docs/requirements/001-deploy.md).

### Prerequisites

- Bash and GNU Make
- [`uv`](https://docs.astral.sh/uv/) — provides `uvx`, used to run StrictDoc for `make reqs` and `make test`

## Makefile Commands

Commands are intentionally short — you will type them constantly.

| Command | What it does |
|---------|-------------|
| `make s` | `git status` |
| `make d` | `git diff` |
| `make q` | `git pull`, or `git pull origin main` on a branch not yet pushed |
| `make nb <name>` | Start a new branch from `origin/main`, with no upstream until its first push |
| `make c` | Stage all and commit as "clean up" |
| `make t` | Stage all and commit as "temporary commit" |
| `make n` | Stage all and commit as "new feature" |
| `make f` | Stage all and commit as a fixup for HEAD |
| `make p [msg]` | Stage all, commit (default message "wip"), and push |
| `make squash` | Interactive rebase with autosquash against `origin/main` |
| `make hooks` | Opt in to the pre-push hook, which runs `make test` before every push |
| `make r` | Rebuild the template project (prompts for name), then run tests |
| `make template` | Rebuild the template project from this checkout, without prompting |
| `make deploy PROJECT` | Apply the template to a sibling project without overwriting files |
| `make test` | Rebuild the template, run every `tests/test-*.sh`, then the requirements gate |
| `make reqs-gate` | Validate requirement-to-source traceability |
| `make reqs` | Run the gate, then refresh the committed requirements export |

`make p` takes an optional message: `make p "fix login bug"`. `make nb` takes a branch name, `make nb login-fix`, and refuses one that is also a make target, since that target would run next. `git push --no-verify` skips the pre-push hook for one push.

Scaffolded projects get the commands from `make s` through `make hooks`, plus an empty `make r` to define for themselves. The rest are ROE's own.

## docs/ Structure

All documentation lives under `docs/`. Subdirectories are created as needed — they start empty.

| Folder | Purpose |
|--------|---------|
| `docs/adr/` | Architecture Decision Records |
| `docs/hldd/` | High-level design documents |
| `docs/requirements/` | StrictDoc requirements with source traceability |
| `docs/job-aid/` | Step-by-step reference guides |
| `docs/roadmap/` | Planned features and future work |
| `docs/research/` | Investigation notes and spikes |
| `docs/performance/` | Performance measurements and analysis |
| `docs/code-review/` | Review cycle records |
| `docs/workflow/` | Process and workflow documentation |

[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) sits at the top level of `docs/` and is the only uppercase name — deliberate emphasis, per [ADR 001](docs/adr/001-lowercase-folder-names.md).

Every file in any `docs/` subdirectory gets a zero-padded three-digit prefix (`001-`, `002-`, …) and opens with a title and status table. See [AGENTS.md](AGENTS.md) for the full numbering and heading format rules.

## Requirements and Traceability

Requirements are managed with [StrictDoc](https://strictdoc.readthedocs.io/), pinned to `strictdoc==0.27.1` and run through `uvx` — no Python packaging is added to the project. See [ADR 007](docs/adr/007-adopt-strictdoc-for-requirements-management.md).

- `docs/requirements/*.sdoc` is the source of truth; the matching `.md` is a generated export — regenerate it with `make reqs`, never hand-edit it.
- Requirements needing code traceability carry a UID, matched by an `@relation(UID, scope=line)` comment on the implementing line.
- `make reqs-gate` fails if any relation dangles in either direction, and runs as part of `make test`.

## Versioning

| File | Purpose |
|------|---------|
| `VERSION` | Current ROE version — bump when rules or scaffold change |
| `.roe-version` | Written into each project at scaffold time; records which ROE version and date it was initialised from |

`VERSION` follows semantic versioning: bump **patch** for clarifications, **minor** for new rules or scaffold additions, **major** for breaking changes to the rules structure.

The version in the [AGENTS.md](AGENTS.md) header is the version of *the rules*, not of the project they govern. It travels with the file when a project is scaffolded, so any project can report which revision of ROE it inherited.

## AI Assistant Integration

Rules for AI agents are maintained in one place and referenced by each agent's config file:

| File | Loaded by |
|------|-----------|
| [AGENTS.md](AGENTS.md) | Canonical policy — read by Copilot, Claude Code, Codex |
| [.github/copilot-instructions.md](.github/copilot-instructions.md) | GitHub Copilot (points to [AGENTS.md](AGENTS.md)) |
| [.claude/skills/proceed/SKILL.md](.claude/skills/proceed/SKILL.md) | Claude Code only: the `/proceed` skill, an agent-specific exception ([ADR 009](docs/adr/009-claude-code-proceed-skill-agent-specific-exception.md)) |

When the rules change, update [AGENTS.md](AGENTS.md) only. See [ADR 004](docs/adr/004-copilot-pro-plus-agents-md-canonical.md).

## Repository Layout

| Path | Contents |
|------|----------|
| [AGENTS.md](AGENTS.md) | The rules — canonical source of truth |
| `Makefile` | Command interface |
| `.githooks/` | Opt-in pre-push hook (`make hooks`), copied into scaffolded projects |
| `.claude/skills/` | Claude Code skills, copied into scaffolded projects |
| `scripts/` | Scaffold and deployment scripts |
| `tests/` | Test suite; `tests/test-output/` holds the generated template |
| `docs/` | ROE's own documentation, following its own rules |
| `gitignore` | Template `.gitignore` copied into scaffolded projects |
| `strictdoc_config.py` | StrictDoc project configuration |

## Philosophy

- **Pragmatism over bureaucracy** — short commands, concise docs, no ceremony for its own sake.
- **Knowledge preservation** — it may be years between changes and project owners may turn over. Docs prevent relitigation of settled decisions.
- **System agnostic** — the rules here apply regardless of what is being built.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add or change a rule, update the scaffold, and when an ADR is required.

## License

GPL-3.0. See [LICENSE](LICENSE).
