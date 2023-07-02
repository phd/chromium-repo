#!/bin/bash -e

cd $(dirname "$0")

. config

RELEASE="${1}"
V1="${2}"
V2="${3}"

UBUNTU=${RELEASE%%/*}
MINT=${RELEASE#*/}

./make-directories.sh

cd "${UBUNTU}"

    mkdir -p 'pool'

    cd 'pool'

        wget -c -o- --progress=dot -e dotbytes=1K  "${REMOTE}chromium_${V2}.dsc"
        wget -c -o- --progress=dot -e dotbytes=10K "${REMOTE}chromium_${V2}.tar.xz"
        wget -c -o- --progress=dot -e dotbytes=1M  "${REMOTE}chromium_${V2}_amd64.deb"
        wget -c -o- --progress=dot -e dotbytes=1M  "${REMOTE}chromium-dbg_${V2}_amd64.deb"

    cd ..

cd ..

true > "${UBUNTU}/pool/.htaccess"

for LINK in $UBUNTU/$UBUNTU $LINKS; do

    SOURCE=${LINK%%/*}
    DEST=${LINK#*/}

    if [ "${SOURCE}" == "${UBUNTU}" ]; then

        echo "RewriteCond %{REQUEST_FILENAME} =${PWD}/${DEST}/pool/chromium_${V2}_amd64.deb" | tee -a "${DEST}/pool/.htaccess"
        echo "RewriteRule ^ ${REMOTE}chromium_${V2}_amd64.deb [L,R=301]"                     | tee -a "${DEST}/pool/.htaccess"

        echo "RewriteCond %{REQUEST_FILENAME} =${PWD}/${DEST}/pool/chromium-dbg_${V2}_amd64.deb" | tee -a "${DEST}/pool/.htaccess"
        echo "RewriteRule ^ ${REMOTE}chromium-dbg_${V2}_amd64.deb [L,R=301]"                     | tee -a "${DEST}/pool/.htaccess"

    fi

done

touch "${UBUNTU}"
touch "${UBUNTU}/pool"

./make-repo.sh ${UBUNTU}

exit 0
