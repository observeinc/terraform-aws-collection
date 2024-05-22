.PHONY: test

test-dir:
	terraform -chdir=${DIR} init -upgrade
	terraform -chdir=${DIR} test

update-binaries-logwriter:
	APP=logwriter RESOURCE=Subscriber utilities/update-binaries.sh > modules/subscriber/uris.csv

update-binaries-forwarder:
	APP=forwarder RESOURCE=Forwarder utilities/update-binaries.sh > modules/forwarder/uris.csv

update-binaries: update-binaries-logwriter update-binaries-forwarder

update-filters: utilities/update-filters.sh

