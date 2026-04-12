SHELL := /bin/bash

.PHONY: r s d c t f n p squash

r:
	@read -p "Project name: " name && bash scripts/initialize-new-project.sh "$$name"

s:
	git status

d:
	git diff

c:
	git add .
	git commit -am "clean up"

t:
	git add .
	git commit -am "temporary commit"

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

squash:
	git rebase -i --autosquash origin/main
