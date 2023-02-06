NPM_TOKEN=$(shell awk -F'=' '{print $$2}' ~/.npmrc)
COMMIT_FILE = .git/.commit-msg-template
generate:
	./bin/init.js
patch: patch-message pr
minor: minor-message pr
major: major-message pr
npm:
	@echo $(NPM_TOKEN) > .git/npm
	gh secret set NPM_TOKEN < .git/npm
	rm .git/npm
patch-message:
	echo fix: title > $(COMMIT_FILE)
minor-message:
	echo feat: title > $(COMMIT_FILE)
major-message:
	echo feat!: title > $(COMMIT_FILE)
ifneq ("$(wildcard $(COMMIT_FILE))","")
pr:
	git rebase origin/main
	git reset origin/main
	git add .
	git commit
	git push -f
	gh pr create --fill
	rm $(COMMIT_FILE)
else
pr:
	@echo run \"make patch\" , \"make minor\", or \"make major\" to create conventional commits before creating PR
endif

gh:
	gh secret set GH_TOKEN < ~/.ssh/kawajevo/deploy_rsa
