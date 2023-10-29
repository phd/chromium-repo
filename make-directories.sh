#!/bin/bash -e

cd $(dirname "$0")
DIR=$(pwd)

. config

for RELEASE in $RELEASES; do
    UBUNTU=${RELEASE%%/*}
    MINT=${RELEASE#*/}
    mkdir -p "${UBUNTU}/pool" || true
done

for LINK in $LINKS; do
    SOURCE=${LINK%%/*}
    DEST=${LINK#*/}
    ln -sfn "${SOURCE}" "${DEST}" || true
done

exit 0
