SHELL := /bin/bash

# -----------------------------------------------------------------------------
# Standard commands
# Single-letter targets are intentional — these commands are typed constantly.
# Every keystroke saved compounds. Shift is effort. Brevity is the convention.
# -----------------------------------------------------------------------------

.PHONY: c d f n p r s squash t test

c:
	git add .
	git commit -am "clean up"

d:
	git diff

f:
	git add .
	git commit --fixup HEAD

n:
	git add .
	git commit -am "new feature"

p:
	git add .
	git commit -am "wip"
	git push

r:
	@rm -rf tests/test-output
	@read -p "Project name: " name && bash scripts/initialize-new-project.sh "$$name"
	$(MAKE) test

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
# -----------------------------------------------------------------------------
test:
	bash tests/test-scaffold.sh