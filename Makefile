.PHONY: test

test-dir:
	terraform -chdir=${DIR} init -upgrade
	terraform -chdir=${DIR} test

test-mock-dir:
	terraform -chdir=${DIR} init -upgrade -test-directory=mock_tests
	terraform -chdir=${DIR} test -test-directory=mock_tests
