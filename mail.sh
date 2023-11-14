#!/bin/bash -e

#TO="${1}"
#shift
#SUBJECT="${1}"
#shift
#CONTENT="${@}"

TO="${1}"
SUBJECT="${2}"
CONTENT="$(cat)"

echo -e "Subject: ${SUBJECT}\n\n${CONTENT}" | /usr/sbin/sendmail "${TO}" || true
