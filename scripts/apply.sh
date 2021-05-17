#!/usr/bin/env bash
printf "\n\n######## apply ########\n"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo ${DIR}/../openshift/build_template.yaml
envsubst < "${DIR}/../openshift/build_template.yaml" > "${DIR}/../openshift/build.yaml"

oc apply -f ${DIR}/../openshift/build.yaml
