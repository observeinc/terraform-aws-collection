.PHONY: changelog release

changelog:
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s minor -o`

release:
	semtag final -s minor

.PHONY: test
test:
	pre-commit run

.PHONY: test-slow
test-single-region: test
	cd ./test/ &&	python3 test.py > test-single-region.txt 2>&1

.PHONY: test-slower
test-all-regions: test
	cd ./test/ &&	python3 test.py --all-regions > test-all-regions.txt 2>&1
