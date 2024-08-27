#!/bin/bash -e

repo()
{
    wget 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x869689FE09306074' \
        -O '/etc/apt/trusted.gpg.d/phd-chromium.asc'

    echo "deb https://freeshell.de/phd/chromium/$(lsb_release -sc) /" \
        | tee /etc/apt/sources.list.d/phd-chromium.list

    apt-get update -y
}

export -f repo

exec su root -c 'repo'

