#!/bin/bash -e

TO="${1}"
shift
SUBJECT="${1}"
shift
CONTENT="${@}"

echo -e "Subject: ${SUBJECT}\n\n${CONTENT}" | /usr/sbin/sendmail "${TO}" || true
