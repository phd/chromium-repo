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

cd "${UBUNTU}"

    rm -f 'pool/latest/.htaccess'
    rm -f 'pool/latest'

    mkdir -p 'pool'

    cd 'pool'

        mkdir -p "chromium_${V2}"

        cd "chromium_${V2}"

            wget -c -o- --progress=dot -e dotbytes=1K  "${REMOTE}chromium_${V2}.dsc"
            wget -c -o- --progress=dot -e dotbytes=10K "${REMOTE}chromium_${V2}.tar.xz"
            wget -c -o- --progress=dot -e dotbytes=1M  "${REMOTE}chromium_${V2}_amd64.deb"
            wget -c -o- --progress=dot -e dotbytes=1M  "${REMOTE}chromium-dbg_${V2}_amd64.deb"

            echo "RewriteRule ^(.+\.(deb|tar\..+))$ ${REMOTE}\$1 [L,R=302]" | tee '.htaccess'

        cd ..

        "${DIR}/make-repo.sh" "${UBUNTU}"

        ln -s "chromium_${V2}" 'latest'

    cd ..

cd ..

touch "${UBUNTU}"
touch "${UBUNTU}/pool"

exit 0
