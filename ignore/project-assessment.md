# ROE — Project Assessment

## What ROE Is

A **meta-project** — not software that does something, but a governance and scaffold system that other projects inherit. `make r` bootstraps a new project with the full structure, conventions, and AI integration baked in from day one.

---

## What Type of Engineer Built It

**A seasoned systems engineer who has been burned by poorly documented projects.**

Every design decision points to someone who has lived through the pain these rules prevent:

**Unix/CLI fluency is deep.** Bash with `set -euo pipefail`, Makefiles as the primary interface, zero external dependencies. No Python wrapper, no Go binary — just tools that are available everywhere. The Makefile commands (`make s`, `make d`, `make c`) are single letters because this person types them constantly and every keystroke compounds.

**They think in years, not sprints.** The `.roe-version` file written into each scaffolded project records which version of the rules it was initialized from. The sequential numbering rule exists to prevent collision when people aren't in the same room. ADRs exist because they've watched decisions get relitigated after the engineer who made them left. This is someone who has been the person who inherited an undocumented system.

**Skeptical of tooling, trusting of people.** Enforcement is peer review, not linters or pre-commit hooks. ADR 001 says it plainly: "A linter would be more ceremony than the problem warrants." This only works if you've built culture through clear, justified rules — which is exactly what CLAUDE.md is.

**AI-aware and security-conscious.** Claude and Copilot are treated as first-class contributors, but constrained. `.claude/settings.json` locks Claude to specific git commands. The Copilot instructions deliberately don't duplicate rules — they point to CLAUDE.md. This is someone who has thought about agent drift and rule rot.

**Confident enough to ship 1.0.0, humble enough to have a roadmap.** Not 0.1.0 (experimental), not 0.9.0 (almost). The rules are solid. But the test suite is a roadmap item, not a checkbox already ticked — iterative and honest.

---

## The Sharpest Signal

The decision to strip the `r` target from the Makefile when copying it into new projects. A scaffolded project shouldn't be able to scaffold other projects. That's a quiet, precise detail that nobody documents — they just know it matters. That's the fingerprint of someone who has debugged the thing they just built, not just designed it.

---

## Profile in Short

Unix-native, systems-minded, probably embedded or infrastructure background, has managed or worked on multi-year projects with team turnover, values clarity over cleverness, and has strong opinions about what deserves ceremony and what doesn't.
