#!/bin/bash -e

cd $(dirname "$0")
DIR=$(pwd)

. config

RELEASE="${1}"
V1="${2}"
V2="${3}"

UBUNTU=${RELEASE%%/*}
MINT=${RELEASE#*/}

./make-directories.sh

function redirect_tee {
    [ "${REDIRECT}" == '1' ] && tee "$1" || cat
}

cd "${UBUNTU}"

    rm -f pool/latest/*.REDIRECT
    rm -f 'pool/latest'

    mkdir -p 'pool'

    cd 'pool'

        mkdir -p "chromium_${V2}"

        cd "chromium_${V2}"

            echo "${REMOTE}chromium_${V2}.tar.xz"        | redirect_tee "chromium_${V2}.tar.xz.REDIRECT"
            echo
            echo "${REMOTE}chromium_${V2}_amd64.deb"     | redirect_tee "chromium_${V2}_amd64.deb.REDIRECT"
            echo
            echo "${REMOTE}chromium-dbg_${V2}_amd64.deb" | redirect_tee "chromium-dbg_${V2}_amd64.deb.REDIRECT"

            echo

            echo "$(date --utc +%Y-%m-%d) 0" | tee "chromium_${V2}.dsc.DOWNLOADS"
            echo "$(date --utc +%Y-%m-%d) 0" | tee "chromium_${V2}.tar.xz.DOWNLOADS"
            echo "$(date --utc +%Y-%m-%d) 0" | tee "chromium_${V2}_amd64.deb.DOWNLOADS"
            echo "$(date --utc +%Y-%m-%d) 0" | tee "chromium-dbg_${V2}_amd64.deb.DOWNLOADS"

            echo

            wget -c -o- --progress=dot -e dotbytes=1K  "${REMOTE}chromium_${V2}.dsc"
            echo
            wget -c -o- --progress=dot -e dotbytes=10K "${REMOTE}chromium_${V2}.tar.xz"
            echo
            wget -c -o- --progress=dot -e dotbytes=1M  "${REMOTE}chromium_${V2}_amd64.deb"
            echo
            wget -c -o- --progress=dot -e dotbytes=1M  "${REMOTE}chromium-dbg_${V2}_amd64.deb"

        cd ..

        "${DIR}/make-repo.sh" "${UBUNTU}"

        ln -s "chromium_${V2}" 'latest'

    cd ..

cd ..

touch "${UBUNTU}"
touch "${UBUNTU}/pool"

exit 0
