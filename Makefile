.PHONY: test

test-dir:
	terraform -chdir=${DIR} init -upgrade
	terraform -chdir=${DIR} test

update-logwriter-binaries-csv:
	APP=logwriter RESOURCE=Subscriber utilities/update-binaries.sh > modules/subscriber/uris.csv

update-forwarder-binaries-csv:
	APP=forwarder RESOURCE=Forwarder utilities/update-binaries.sh > modules/forwarder/uris.csv
