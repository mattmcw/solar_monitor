#!/bin/bash

source ./src/common.sh

FILEPATH=`realpath "${1}"`
REMOTE_PATH="${2}"

PROTOCOL="http"
if [ "${SSL}" == "1" ]; then
	PROTOCOL="https"
fi

URL="${PROTOCOL}://${REMOTE_USER}:${REMOTE_PASS}@${REMOTE}/${REMOTE_PATH}"

curl -v --interface "${NETWORKDEVICE}" \
-A "${PI_UA}" \
--form 'csv=@'${FILEPATH} \
${URL}
