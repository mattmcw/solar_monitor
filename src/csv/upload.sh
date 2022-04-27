#!/bin/bash

source ./src/common.sh

FILEPATH=`pwd "${1}"`
PROTOCOL="http"
if [ "${SSL}" == "1" ]; then
	PROTOCOL="https"
fi

URL="${PROTOCOL}}://${REMOTE_USER}:${REMOTE_PASS}@${REMOTE}/upload"

curl -v --interface "${NETWORKDEVICE}"\
--form csv=@${FILEPATH}\ 
${URL}
