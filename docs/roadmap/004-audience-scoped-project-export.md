# Roadmap 004 — Audience-Scoped Project Export

| Status   | Date       | Project Version |
|----------|------------|-----------------|
| Draft    | 2026-05-09 | 1.0.1           |

## Summary

Add a `roe export` command that produces a filtered snapshot of a project's documentation, scoped to a target audience defined in `roe.config.json`. Different roles (engineers, product managers, sales, executives) need access to different subsets of the docs tree. The export strips irrelevant material and produces a clean, portable output directory — or a rendered artifact — containing only what that audience should see.

## Problem

ROE projects accumulate docs across many domains: architecture decisions, requirements, roadmaps, code reviews, hardware specs, product strategy, and sales collateral. Sharing the full `docs/` tree with any single stakeholder group is noisy at best and a confidentiality risk at worst. There is currently no mechanism to produce a role-appropriate view without manually curating a separate copy.

## Proposed Approach

### Audience definitions in config

`roe.config.json` gains an `audiences` block. Each audience entry names a role and declares which `docs/` subdirectories (and optionally which file tags or status values) are included in its export.

```json
{
  "audiences": {
    "engineering": {
      "include": ["docs/adr", "docs/requirements", "docs/code-review", "docs/performance"],
      "exclude_status": ["Draft"]
    },
    "product": {
      "include": ["docs/roadmap", "docs/requirements", "docs/hldd"],
      "exclude_status": []
    },
    "sales": {
      "include": ["docs/roadmap"],
      "include_tags": ["external-facing"],
      "exclude_status": ["Draft", "Cancelled"]
    },
    "executive": {
      "include": ["docs/roadmap", "docs/adr"],
      "exclude_status": ["Draft"]
    }
  }
}
```

### Export command

```
roe export --audience engineering --output ./dist/engineering
roe export --audience sales --format pdf --output ./dist/sales
```

The command:
1. Reads the audience definition from config.
2. Walks the declared `include` directories, applying status and tag filters.
3. Copies matching files to the output directory, preserving relative paths.
4. Optionally renders Markdown to HTML or PDF for non-technical audiences.

### Tagging (optional metadata)

Documents may include an optional `tags` field in their frontmatter to further control inclusion:

```markdown
---
tags: [external-facing, product]
---
```

This allows fine-grained control within a directory (e.g., only some roadmap items are appropriate for sales).

## Audiences and Default Mappings

| Audience    | Typical Inclusions                                         | Typical Exclusions                         |
|-------------|------------------------------------------------------------|--------------------------------------------|
| Engineering | ADRs, requirements, code reviews, performance, HLDDs       | Roadmap (sales-facing), product strategy   |
| Product     | Roadmap, requirements, HLDDs                               | Code reviews, ADRs, performance deep-dives |
| Sales       | External-facing roadmap items only                         | Everything internal                        |
| Executive   | Roadmap (status summary), accepted ADRs (decisions made)   | Draft docs, code reviews, performance      |

## Why Not Just Use Folders or Git Branches

- Separate folders require manual maintenance and drift from the canonical source.
- Git branches for audiences create merge overhead and make it easy to forget to sync changes.
- A config-driven export keeps a single source of truth and makes audience scoping explicit and reviewable.

## Open Questions

- Should export be a standalone CLI or a Claude Code slash command (`/roe-export`)?
- Do we need a signing or integrity check on exports to detect if the source has changed since last export?
- Should `Draft` documents always be excluded from all exports, or remain opt-in per audience?
- Is PDF rendering in scope for v1, or output Markdown only?

## Dependencies

- ADR 003 (ROE configuration file) must be accepted and implemented before this feature can be built.
