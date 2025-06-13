#!/bin/bash -e

cd $(dirname "$0")
DIR=$(pwd)

. config

UBUNTU="${1}"

if [ -z "${UBUNTU}" ]; then
  echo "error: repository name missing"
  exit 1
fi

cd "${UBUNTU}"

#dpkg-scanpackages -m pool 2>/dev/null | gzip > Packages.gz

apt-ftparchive packages . > Packages
gzip -c Packages > Packages.gz
apt-ftparchive release  . > Release

gpg -o - --clearsign Release > InRelease
gpg -o - -abs        Release > Release.gpg

exit 0
