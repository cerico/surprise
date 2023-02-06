NPM_TOKEN=$(shell awk -F'=' '{print $$2}' ~/.npmrc)
AA=$(shell awk -F'=' '{print $$2}' ~/.npmrc)
COMMIT_FILE = commit
generate:
	./bin/init.js
ee:
	echo $(AA) > dogs
npm:
	@echo $(NPM_TOKEN) > npm
	gh secret set NPM_TOKEN < npm
	gh secret set NODE_AUTH_TOKEN < npm
	rm npm
patch:
	echo fix: title > $(COMMIT_FILE)
	vi $(COMMIT_FILE)
minor:
	echo feat: title > $(COMMIT_FILE)
	vi $(COMMIT_FILE)
major:
	echo feat!: title > $(COMMIT_FILE)
	vi $(COMMIT_FILE)

ifneq ("$(wildcard $(COMMIT_FILE))","")
pr:
	git rebase origin/main
	git reset origin/main
	git add .
	git commit -F $(COMMIT_FILE)
	git push -f
	gh pr create --fill
	rm $(COMMIT_FILE)
else
pr:
	@echo run \"make patch\" , \"make minor\", or \"make major\" to create conventional commits before creating PR
endif

gh:
	gh secret set GH_TOKEN < ~/.ssh/kawajevo/deploy_rsa
