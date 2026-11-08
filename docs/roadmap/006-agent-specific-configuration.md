# Roadmap 006 — Agent-Specific Configuration

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-10-25 | 1.2.0           |

## Summary

Let a project choose which AI agents it supports, and give it only those agents' files. [AGENTS.md](../../AGENTS.md) stays the single, agent-neutral rule set; what varies is the thin, agent-specific layer around it: entry points such as `.github/copilot-instructions.md`, and behaviour such as the Claude Code `proceed` skill.

## Problem

ROE ships one fixed set of agent files to every project. [ADR 004](../adr/004-copilot-pro-plus-agents-md-canonical.md) names Copilot Pro+ as the single platform, yet Claude Code is in daily use, and [ADR 009](../adr/009-claude-code-proceed-skill-agent-specific-exception.md) had to ship a Claude-only skill as a one-off exception. Every further agent-specific file would need its own exception, and every project receives files for agents it may never run.

## Proposed Approach

- Declare the supported agents per project, most likely as an `agents` list in `roe.config.json` ([ADR 003](../adr/003-roe-configuration-file.md)), for example `["copilot", "claude-code"]`.
- Keep each agent's files in its own source location in ROE, so the scaffold and `make deploy` copy only the selected agents' files.
- Make the setting adjustable later, like the rest of ADR 003: adding an agent to an existing project adds its files without re-scaffolding.
- Fold the ADR 009 exception in: the `proceed` skill becomes the Claude Code option's content, not a default for every project.

## Open Questions

- Default when no agents are declared: today's full set, or `AGENTS.md` only?
- Whether removing an agent from the list should delete its files, given that deploy never deletes or overwrites anything (DEPLOY-004).

## Done When

- A project declares its agents, and scaffolding and deploy deliver only those agents' files.
- ADR 009 is superseded by the ADR that records the shipped design.
