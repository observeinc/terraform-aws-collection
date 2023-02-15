#!/usr/bin/env bash

# The first few lines up to the usage() function are copied from
# https://github.com/observeinc/manifests/blob/acf66e63cc79e61c1f2882532f9121804c6bb690/scripts/test.sh
set -o errexit
set -o pipefail

DIE() { echo "${R}E! $*${r}" 1>&2; exit 1; }
INFO() { echo "${B}I: $*${r}" 1>&2; }
DEBUG() { test -z "$VERBOSE" || echo "D: $*" 1>&2; }

R="[1;31m"
B="[1;34m"
r="[m"

usage() {
    echo "${B}$0 [-havs]"
    echo "  -a     test all regions Observe supports. Note that this takes 30+ minutes."
    echo "  -v     verbose"
    echo "  -s     don't call terraform destroy"
    echo "  -h     this help"
    echo
    exit 1
}

while getopts 'havs' OPTION; do
    case $OPTION in
        a) ALL_REGIONS=1 ;;
        s) SKIP_DESTROY=1 ;;
        v) VERBOSE=1 ;;
        *) usage ;;
    esac
done

[[ -n "$ALL_REGIONS" ]] && export ALL_REGIONS
[[ -n "$VERBOSE" ]] && export VERBOSE
[[ -n "$SKIP_DESTROY" ]] && export SKIP_DESTROY


if [[ -n "$ALL_REGIONS" ]]; then
    regions=("us-east-1"
        "us-east-2" \
        "us-west-1" \
        "us-west-2" \
        "ap-south-1" \
        "ap-northeast-1" \
        "ap-northeast-2" \
        "ap-northeast-3" \
        "ap-southeast-1" \
        "ap-southeast-2" \
        "eu-central-1" \
        "eu-west-1" \
        "eu-west-2" \
        "eu-west-3" \
        "eu-north-1" \
        "sa-east-1")
else
    regions=("us-west-2")
fi

INFO "AWS Profile: ${AWS_PROFILE}"
INFO "Regions: ${regions[@]}"
test_module_name=observe-${USER}
INFO "TF Module Name: ${test_module_name}"


AWS_REGION=$region terraform init -no-color

for region in ${regions[@]}; do
    DEBUG "Testing region $region"
    export AWS_REGION=$region
    terraform apply -auto-approve -no-color -var="name=${test_module_name}"
    terraform output
    RESULT=$(terraform output -json result)
    if [ "$RESULT" != "true" ]; then
        echo "Test failed"
        exit 1
    fi
    if [[ -n "$SKIP_DESTROY" ]]; then
        echo "Destroy skipped. Please destroy manually."
    else
        terraform destroy -auto-approve -no-color -var="name=${test_module_name}"
    fi
done
