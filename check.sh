#!/bin/bash -e

cd $(dirname "$0")

. config

LIST=$(LS_COLORS=no lftp --norc --rcfile .lftprc -e 'cls -1; exit' "${REMOTE}" 2>/dev/null | grep -E '_amd64\.deb$' | grep -E '^chromium_' | sort -V)

for RELEASE in $RELEASES; do

    UBUNTU=${RELEASE%%/*}
    MINT=${RELEASE#*/}

        F_VERSION="check.sh.${UBUNTU}.version"
    F_VERSION_OLD="check.sh.${UBUNTU}.version.old"
        F_CHECKED="check.sh.${UBUNTU}.checked"

    V1=$(cat "${F_VERSION}" 2>/dev/null || true)
    V1=${V1:-'unknown'}

    V2=$(echo "${LIST}" | grep "+${MINT}_" | tail -n1)
    V2=${V2#'chromium_'}
    V2=${V2%'_amd64.deb'}

    if [[ -z "${V2}" ]]; then

        echo 'error'

        ./mail.sh "${EMAIL}" 'chromium-browser version check error' "${V1}\n->\nhttps://mirrors.edge.kernel.org/linuxmint-packages/pool/upstream/c/chromium/\n\n${V2}\n"

    elif [ "${V1}" != "${V2}" ]; then

        echo "${V2}"

        mv "${F_VERSION}" "${F_VERSION_OLD}" 2>/dev/null || true
        echo "${V2}" > "${F_VERSION}"
        touch "${F_VERSION}"
        ./mail.sh "${EMAIL}" "chromium-browser updated in Mint ($RELEASE)" "${V1}\n->\n${V2}\n"

        echo "${PWD}/copy-packages-run.sh ${RELEASE} ${V1} ${V2}" | at now

    fi

    touch "${F_CHECKED}"

done

exit 0
