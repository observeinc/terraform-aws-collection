.PHONY: changelog release

changelog:
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s minor -o`

release:
	semtag final -s minor

.PHONY: test
test:
	pre-commit run

.PHONY: test-single-region
test-single-region: test
	cd ./test/ &&	./test.sh

.PHONY: test-all-regions
test-all-regions: test
	cd ./test/ &&	./test.sh -a
