# ROE — Rules of Engagement for Development

Pragmatic, system-agnostic rules for documentation, code review, and AI-assisted collaboration. Apply this framework to any project — firmware, hardware, software, or otherwise.

## Quickstart

Bootstrap a new project with the ROE structure:

```bash
make r
```

## Makefile Commands

Commands are intentionally short — you will type them constantly.

| Command | What it does |
|---------|-------------|
| `make s` | `git status` |
| `make d` | `git diff` |
| `make c` | Stage all and commit as "clean up" |
| `make t` | Stage all and commit as "temporary commit" |
| `make f` | Stage all and commit as a fixup for HEAD |
| `make n` | Stage all and commit as "new feature" |
| `make p` | Stage all, commit, and push |
| `make squash` | Interactive rebase with autosquash against origin/main |

## docs/ Structure

All documentation lives under `docs/`. Subdirectories are created as needed — they start empty.

| Folder | Purpose |
|--------|---------|
| `docs/adr/` | Architecture Decision Records |
| `docs/job-aid/` | Step-by-step reference guides |
| `docs/performance/` | Performance measurements and analysis |
| `docs/review/` | Review cycle records |

Every file in any `docs/` subdirectory gets a zero-padded three-digit prefix (`001-`, `002-`, …). See `CLAUDE.md` for the full numbering and heading format rules.

## Versioning

| File | Purpose |
|------|---------|
| `VERSION` | Current ROE version — bump this when rules or scaffold change |
| `.roe-version` | Written into each new project at scaffold time; records which ROE version and date it was initialised from |

`VERSION` follows semantic versioning: bump **patch** for clarifications, **minor** for new rules or scaffold additions, **major** for breaking changes to the rules structure.

## AI Assistant Integration

Rules for AI agents are maintained in one place and referenced by each agent's config file:

| File | Loaded by |
|------|-----------|
| `CLAUDE.md` | Claude Code (source of truth) |
| `.github/copilot-instructions.md` | GitHub Copilot |

When the rules change, update `CLAUDE.md` only.

## Philosophy

- **Pragmatism over bureaucracy** — short commands, concise docs, no ceremony for its own sake.
- **Knowledge preservation** — it may be years between changes and project owners may turn over. Docs prevent relitigation of settled decisions.
- **System agnostic** — the rules here apply regardless of what is being built.
