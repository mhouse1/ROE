# ADR 002 — AGENTS.md Redirects to CLAUDE.md

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Accepted | 2026-05-02 | 1.0.0           |

## Context

Different AI coding agents look for their rule files under different names:

- Claude reads `CLAUDE.md`
- OpenAI Codex reads `AGENTS.md`
- Google Gemini reads `GEMINI.md`

The ROE repository defines its authoritative rules in `CLAUDE.md`. As Codex and other agents are added to typical workflows, they would not load those rules without a file matching their expected name.

## Decision

Create a minimal `AGENTS.md` at the repository root that:

1. Directs agents to load `CLAUDE.md` as the authoritative source.
2. Includes a one-line summary of the most critical rule (sequential numbering under `docs/`) as a fallback for agents that do not follow the redirect.

This is the simplest approach that achieves compliance without duplicating content. If the number of agent-specific entry-point files grows, migrating to a neutral canonical file (e.g., `RULES.md`) with thin wrappers should be reconsidered at that time.

## Alternatives Considered

**Neutral canonical file (`RULES.md`) with thin wrappers** — Cleanest long-term solution, but introduces unnecessary indirection for a two-agent scenario. Deferred until a third agent warrants it.

**Duplicate files** — `AGENTS.md` as a full copy of `CLAUDE.md`. Rejected: content will diverge over time, violating single-source-of-truth.

## Consequences

- One additional file read per Codex session (negligible cost).
- Agents that do not follow redirects still receive the most critical constraint inline.
- Future agent entry-point files (`GEMINI.md`, etc.) should follow the same redirect pattern until Option B is warranted.
