.PHONY: changelog release

changelog:
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s minor -o`

release:
	semtag final -s minor

.PHONY: test
test:

.PHONY: cloudformation
cloudformation:
	terraform -chdir=./cloudformation init
	terraform -chdir=./cloudformation apply -auto-approve
	aws s3 cp cloudformation/collection.yaml s3://observeinc/cloudformation/collection-`semtag final -s minor -o`.yaml
