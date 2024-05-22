#!/bin/bash
set -euo pipefail

DIE() { echo "$*" 1>&2; exit 1; }

BUCKET=${BUCKET:-observeinc}

FILTERS=recommended.yaml

for FILTER in ${FILTERS}; do \
    curl -s https://${BUCKET}.s3.amazonaws.com/cloudwatchmetrics/filters/${FILTER} > modules/metricstream/filters/${FILTER}
done;

