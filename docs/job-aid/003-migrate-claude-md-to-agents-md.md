# Job Aid 003 — Migrate Project Rules from CLAUDE.md to AGENTS.md

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-05-24 | 1.0.0           |

## Purpose

Use this job aid when a project currently uses `CLAUDE.md` as the policy file and you want to switch to `AGENTS.md` as the authoritative rules source.

## Scope

- Repository-level migration of policy entrypoint from `CLAUDE.md` to `AGENTS.md`
- Copilot integration update via `.github/copilot-instructions.md`
- Cleanup of legacy hidden agent folders and stale agent settings
- Reference updates in documentation
- Optional removal of legacy `CLAUDE.md`

## Success Criteria

- `AGENTS.md` exists at project root and contains the active rules.
- `.github/copilot-instructions.md` points to `AGENTS.md` as authoritative.
- Legacy Claude-only local config is removed or intentionally retained with documented reason.
- Documentation references to `CLAUDE.md` are migrated (or intentionally retained only as historical text).
- `CLAUDE.md` is either removed, or explicitly marked legacy and non-authoritative.

## Migration Steps

1. Inspect current policy files.

- Confirm whether `AGENTS.md` already exists.
- Confirm whether `CLAUDE.md` still exists.
- Check `.github/copilot-instructions.md` for the current policy link.
- Check for hidden migration targets: `.claude/`, `.vscode/`, and any agent-specific instruction files.

2. Create or refresh `AGENTS.md`.

- If no `AGENTS.md` exists, create it from `CLAUDE.md` content.
- If `AGENTS.md` already exists, verify it is the full and current policy source.

3. Set Copilot entrypoint.

Create or update `.github/copilot-instructions.md` to point to `AGENTS.md` using this structure:

```md
# Copilot Instructions

All project rules are defined in [AGENTS.md](../AGENTS.md) at the repository root.
Read that file before making any changes.

Precedence:
- AGENTS.md is the authoritative source for repository policy.
- If any legacy file conflicts, follow AGENTS.md.
```

If `.github/copilot-instructions.md` does not exist, create it.

4. Update documentation references.

- Replace references to `CLAUDE.md` with `AGENTS.md` in project markdown docs where the reference indicates the current policy source.
- Keep old references only when they are historical artifacts in old review notes.

5. Choose legacy strategy for `CLAUDE.md`.

Option A (recommended): remove `CLAUDE.md`.

Option B: keep `CLAUDE.md` with a short banner that says policy moved to `AGENTS.md`.

6. Clean up hidden Claude-era files.

- Remove `.claude/` if it exists and contains only legacy project-local Claude settings.
- If `.claude/` contains still-needed runtime configuration, keep only what is required and document why.
- Review `.vscode/` settings only for agent-entrypoint assumptions (for example references to `CLAUDE.md`) and update those references to `AGENTS.md`.
- Do not delete unrelated editor settings.

7. Validate migration.

- Search the full repo (not only docs) for remaining `CLAUDE.md` mentions.
- Confirm `.github/copilot-instructions.md` exists and links to `AGENTS.md`.
- Confirm `AGENTS.md` is present and complete.
- Confirm `CLAUDE.md` is removed (or explicitly marked legacy if intentionally retained).
- Confirm `.claude/` is removed or intentionally retained with documented reason.
- Report remaining `CLAUDE.md` matches as either historical references or migration misses.

## Copilot Prompt Template

Use this prompt in a future repo:

```md
Switch this project from CLAUDE.md to AGENTS.md as the policy source.

Requirements:
1. If AGENTS.md does not exist, create it from CLAUDE.md.
2. Ensure .github/copilot-instructions.md points to AGENTS.md as authoritative.
3. Update references from CLAUDE.md to AGENTS.md where they refer to active policy (README, CONTRIBUTING, architecture docs, job aids, and integration docs).
4. Remove CLAUDE.md after verifying AGENTS.md is complete.
5. Remove legacy .claude folder unless it contains still-required non-legacy settings; if retained, explain why.
6. Check relevant hidden config folders (for example .vscode) and update only agent-entrypoint references to AGENTS.md.
7. Report exactly what changed and list any remaining CLAUDE.md mentions, grouped as historical vs needing follow-up.

Constraints:
- Do not change unrelated content.
- Keep migration minimal and reversible.
- Validate with search before and after edits.
- If a file is historical and should keep CLAUDE.md references, leave it unchanged and call it out explicitly.
```

## Notes

- Run this migration in a dedicated commit so policy-entrypoint changes stay easy to audit.
- If multiple repos share templates, update the template repo first, then downstream repos.
