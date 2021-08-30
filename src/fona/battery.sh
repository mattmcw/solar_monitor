#!/bin/bash

RESPONSE=`bash ./src/fona/send.sh "AT+CBC"`

echo "${RESPONSE}" | grep "CBC:"