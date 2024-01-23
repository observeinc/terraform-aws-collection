#!/bin/bash
set -euo pipefail

DIE() { echo "$*" 1>&2; exit 1; }

APP=${APP:-forwarder}
RESOURCE=${RESOURCE:-Forwarder}

VERSION=${VERSION:-latest}
BUCKET=${BUCKET:-observeinc}

REGIONS=$(aws ec2 describe-regions | jq -r '.Regions | map(.RegionName) |.[]')

echo "region,code_uri"
for REGION in ${REGIONS}; do \
    CODE_URI=`curl -s https://${BUCKET}-${REGION}.s3.amazonaws.com/apps/${APP}/${VERSION}/packaged.yaml | yq .Resources.${RESOURCE}.Properties.CodeUri`
    echo "${REGION},${CODE_URI}"
done;
