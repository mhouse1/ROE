# Contributing to ROE

| Status | Date       | Project Version |
|--------|------------|-----------------|
| Active | 2026-04-11 | —               |

Practical guide for working on the ROE project itself.

---

## Adding or changing a rule

Rules live in [CLAUDE.md](CLAUDE.md). Each rule should be:

- **Actionable** — specific enough that an agent or human can follow it without interpretation.
- **System-agnostic** — no language, toolchain, or platform assumptions unless the rule is explicitly scoped to one.
- **Self-contained** — the rule must make sense without reading surrounding rules.

For a significant rule change (new section, removal, or a change in intent), write an ADR in `docs/adr/` first. For minor clarifications (wording, examples), edit `CLAUDE.md` directly.

---

## Adding a new agent integration

Agent-specific instruction files live alongside their tooling:

| Agent | File |
|-------|------|
| Claude Code | `CLAUDE.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |

New integrations follow the same pattern: a thin file that summarises the key rules and points to `CLAUDE.md` as the source of truth. Do not duplicate rule content — only summarise and link.

---

## Updating the scaffold script

[scripts/initialize-new-project.sh](scripts/initialize-new-project.sh) copies files from this repo into new projects. When adding a new file that all projects should inherit, add the copy step to the script. When removing a file, remove the corresponding copy step.

Test the script before committing:

```bash
bash scripts/initialize-new-project.sh test-project
ls ../test-project
rm -rf ../test-project
```

---

## Branches and commits

Use short Makefile targets for routine commits (`make c`, `make n`). For non-trivial work, use a descriptive branch name and a proper commit message.

---

## ADRs

Every decision that affects the rules, scaffold structure, or agent integrations warrants an ADR. See `CLAUDE.md` for the numbering and format rules.
