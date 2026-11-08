# ADR 009 — Ship the Claude Code `proceed` Skill as an Agent-Specific Exception

| Status | Date       | Project Version |
|--------|------------|-----------------|
| Draft  | 2026-10-25 | 1.2.0           |

## Decision

Ship wingman's `proceed` skill at `.claude/skills/proceed/SKILL.md`, in ROE and in every scaffolded project, as a deliberate exception to two standing rules:

- ROE rules and scaffold content are system-agnostic ([CONTRIBUTING](../../CONTRIBUTING.md)).
- GitHub Copilot Pro+ is the single supported AI platform ([ADR 004](004-copilot-pro-plus-agents-md-canonical.md)).

The exception covers this one file, and is bounded:

1. **It carries no rules.** [AGENTS.md](../../AGENTS.md) stays the only policy source (ADR 004). The skill only says how to act on "proceed": implement the recommendation already given, at its stated scope, without re-asking.
2. **It is inert elsewhere.** Agents other than Claude Code do not read `.claude/`, so a project that never uses Claude Code is unaffected beyond one extra directory.
3. **It sets no precedent.** Any further agent-specific file needs its own ADR until [Roadmap 006](../roadmap/006-agent-specific-configuration.md) ships.

The skill is copied from wingman with its project-specific worked example generalised and "operator" changed to "user".

## Consequences

- Claude Code users get `/proceed` in every ROE project, ROE included.
- Every scaffolded project gets a `.claude/` directory whether or not it uses Claude Code. Deleting it is safe.
- A project deployed earlier gets the skill on its next `make deploy`. An existing copy, such as wingman's, is never overwritten (DEPLOY-004).
- Roadmap 006 supersedes this exception when it ships: per-agent configuration decides which agents' files a project receives, and this skill becomes one option among them instead of a default.

## Context

`proceed` began in wingman, where one word approves a recommendation already stated. [ADR 008](008-adopt-wingman-workflow-improvements.md) adopted wingman's general-purpose improvements and left its Claude Code skills out for the system-agnostic reason above. `proceed` is the one that fits any project: it names no wingman file, target or tool. The decision was to ship it now as a tracked exception rather than wait for per-agent configuration.

## Validation

- `make test` green, including a scaffold check that `.claude/skills/proceed/SKILL.md` exists.
