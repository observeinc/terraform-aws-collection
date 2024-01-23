.PHONY: test

test-dir:
	terraform -chdir=${DIR} init -upgrade
	terraform -chdir=${DIR} test
