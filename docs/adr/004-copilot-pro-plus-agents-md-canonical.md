# ADR 004 — Copilot Pro+ as the Single AI Platform and AGENTS.md as Canonical Policy

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Accepted | 2026-05-24 | 1.0.0           |

## Context

ROE has historically supported multiple AI-agent entry-point files, including a redirect pattern where `AGENTS.md` pointed to `CLAUDE.md`.

The team is standardizing on GitHub Copilot Pro+ as the single AI platform used for development workflows. As a result, the repository should prefer tool-agnostic, platform-aligned instruction discovery while minimizing policy duplication.

## Decision

1. Adopt GitHub Copilot Pro+ as the single supported AI platform for ROE-driven workflows.
2. Make `AGENTS.md` the canonical repository policy file.
3. Use `.github/copilot-instructions.md` as Copilot-native guidance that points to `AGENTS.md`.
4. Treat `CLAUDE.md` as optional legacy compatibility only, and remove it where no longer required.
5. Migrate repositories incrementally, one project at a time, rather than requiring a monorepo-wide cutover.

## Supersedes

This ADR supersedes ADR 002 (`AGENTS.md` redirects to `CLAUDE.md`).

ADR 002 remains immutable as historical record.

## Rationale

- **Platform alignment:** Copilot Pro+ is now the standard, so repository instructions should prioritize Copilot-native discovery.
- **Tool-agnostic clarity:** `AGENTS.md` is a clearer cross-tool canonical file name than provider-specific naming.
- **Single source of truth:** Canonical policy in one file reduces drift and contradictory instructions.
- **Safer rollout:** Per-project migration allows validation and avoids breaking active repositories simultaneously.

## Migration Approach

For each project repository:

1. Ensure `AGENTS.md` exists at repo root and contains authoritative policy.
2. Ensure `.github/copilot-instructions.md` exists and points to `AGENTS.md`.
3. Remove or reduce `CLAUDE.md` to a minimal compatibility shim only if needed by active tooling.
4. Validate agent behavior before removing legacy files entirely.

## Consequences

- New instruction updates are made in `AGENTS.md` first.
- Copilot behavior becomes more predictable through `.github/copilot-instructions.md`.
- Legacy workflows that only read `CLAUDE.md` may require temporary shims during transition.
- Migration effort is distributed over time and tracked project-by-project.
