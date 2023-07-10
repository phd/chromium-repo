#!/bin/bash -e

cd $(dirname "$0")
DIR=$(pwd)

. config

RELEASE="${1}"
V1="${2}"
V2="${3}"

UBUNTU=${RELEASE%%/*}
MINT=${RELEASE#*/}

output="$((./copy-packages.sh ${RELEASE} ${V1} ${V2} || true) | tee ./copy-packages.sh.${UBUNTU}.log)"

./mail.sh "${EMAIL}" "chromium-browser updated in repository (${RELEASE})" "${V1}\n->\n${V2}\n\n[BEGIN]\n${output}\n[END]\n"

exit 0
