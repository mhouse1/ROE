SHELL := /bin/bash

# -----------------------------------------------------------------------------
# Usage
#
#   make <target> [args]
#
#   c              Stage all and commit with message "clean up"
#   d              Show unstaged diff
#   f              Stage all and create a fixup commit for HEAD
#   hooks          Opt in to the pre-push hook (runs make test before every push)
#   n              Stage all and commit with message "new feature"
#   nb <name>      Start a new branch from origin/main (run after a PR is merged)
#   p [msg]        Stage all, commit (default message: "wip"), and push
#                    e.g.  make p "fix login bug"
#   q              Pull the latest changes (origin main if the branch has no upstream)
#   s              Show git status
#   squash         Interactive rebase with autosquash against origin/main
#   t              Stage all and commit with message "temporary commit"
#
#   Project-specific targets are listed under "Custom user-defined commands".
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Standard commands
# Single-letter targets are intentional — these commands are typed constantly.
# Every keystroke saved compounds. Shift is effort. Brevity is the convention.
# Every ROE project shares this section; project-specific targets go under the
# custom commands section below.
# -----------------------------------------------------------------------------

.PHONY: c d f hooks n nb p q s squash t

c:
	git add .
	git commit -am "clean up"

d:
	git diff

f:
	git add .
	git commit --fixup HEAD

# Opt in to the versioned pre-push hook, which runs `make test` before every
# push. `git push --no-verify` skips it once; `git config --unset core.hooksPath`
# removes it.
hooks:
	git config core.hooksPath .githooks
	@echo "pre-push hook installed: make test runs before every push (skip one with git push --no-verify)"

n:
	git add .
	git commit -am "new feature"

# Start a new branch from the remote main (e.g. make nb login-fix), typically
# after a PR is merged. Reusing a merged branch carries its old history into the
# next PR, and under squash-merge it conflicts with main in every file both
# touched. --no-track leaves the new branch without an upstream, so the first
# push creates origin/<name> instead of pointing at main; until then, q pulls
# origin main. The name is captured the same way as the message for 'p'.
ifeq ($(firstword $(MAKECMDGOALS)),nb)
  _NB_NAME := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifneq ($(_NB_NAME),)
.DEFAULT:
	@:
  endif
endif

# The name is also a make goal, so a name that matches a target (s, test) would
# run that target next. The grep refuses those before git does anything.
nb:
	@test -n "$(_NB_NAME)" || { echo "usage: make nb <branch-name>"; exit 1; }
	@! grep -qE '^([^#[:space:]:=][^#:=]* )?$(_NB_NAME)( [^:=]*)?:([^=]|$$)' $(firstword $(MAKEFILE_LIST)) || \
		{ echo "make nb: '$(_NB_NAME)' is also a make target and would run next. Pick another name."; exit 1; }
	git fetch origin
	git switch -c "$(_NB_NAME)" --no-track origin/main

# Capture extra words after 'p' as the commit message (e.g. make p "my message").
# .DEFAULT absorbs the extra goal at execution time, avoiding eval which parses
# the string as makefile syntax and breaks on words like "include" or "define".
ifeq ($(firstword $(MAKECMDGOALS)),p)
  _P_MSG := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifneq ($(_P_MSG),)
.DEFAULT:
	@:
  endif
endif

p:
	git add .
	git commit -am "$(if $(_P_MSG),$(_P_MSG),wip)"
	git push

# A new local branch has no upstream until its first push; pull main instead.
q:
	@if git rev-parse --verify --quiet @{u} > /dev/null; then \
	  echo "git pull"; git pull; \
	else \
	  echo "git pull origin main  (no upstream yet)"; git pull origin main; \
	fi

s:
	git status

squash:
	git rebase -i --autosquash origin/main

t:
	git add .
	git commit -am "temporary commit"

# -----------------------------------------------------------------------------
# Custom user-defined commands
# Add your own targets below this line.
#
# ROE's own targets. scripts/initialize-new-project.sh copies everything above
# this section into new projects, and nothing below it.
#
#   deploy PROJECT  Apply the ROE template to a sibling project without overwriting files
#   r              Re-initialize project (prompts for name), then runs tests
#   reqs           Validate docs/requirements/*.sdoc and refresh their markdown export
#   reqs-gate      Validate docs/requirements/*.sdoc source traceability only
#   template       Rebuild tests/test-output/ROE_TEMPLATE_PROJECT from this checkout
#   test           Run every tests/test-*.sh, then reqs-gate
# -----------------------------------------------------------------------------

.PHONY: deploy r reqs reqs-gate template test

ifeq ($(firstword $(MAKECMDGOALS)),deploy)
  _DEPLOY_PROJECT := $(word 2,$(MAKECMDGOALS))
  ifneq ($(_DEPLOY_PROJECT),)
.DEFAULT:
	@:
  endif
endif

deploy: template  # @relation(DEPLOY-002, scope=line)
	bash scripts/deploy-project.sh "$(_DEPLOY_PROJECT)"

r:
	@rm -rf tests/test-output
	@read -p "Project name: " name && bash scripts/initialize-new-project.sh "$${name:-ROE_TEMPLATE_PROJECT}"
	$(MAKE) test

# Rebuild the template from this checkout (ADR 008). deploy and test both start
# here, so neither works from a template left behind by an earlier run.
template:
	@rm -rf tests/test-output/ROE_TEMPLATE_PROJECT
	@bash scripts/initialize-new-project.sh ROE_TEMPLATE_PROJECT > /dev/null

# Every tests/test-*.sh runs, so a new test is picked up without editing this
# target (ADR 008).
test: template
	@for t in tests/test-*.sh; do echo "bash $$t"; bash "$$t" || exit 1; done
	$(MAKE) reqs-gate

# Validate docs/requirements/*.sdoc and their scripts/*.sh, Makefile source
# markers resolve in both directions (ADR 007). Pinned to strictdoc==0.27.1
# via uvx — no project-level Python packaging required.
reqs-gate:
	uvx --from strictdoc==0.27.1 strictdoc export . --formats=markdown --output-dir tests/test-output/strictdoc
	@echo "PASS: requirements + source traceability validated"

# Regenerate the committed markdown export beside the .sdoc sources.
reqs: reqs-gate
	cp tests/test-output/strictdoc/markdown/docs/requirements/*.md docs/requirements/
	@echo "docs/requirements markdown export refreshed"
