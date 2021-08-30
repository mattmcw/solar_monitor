#!/bin/bash

RESPONSE=`bash ./src/fona/send.sh "AT+CBC"`

CHARGE=`echo "${RESPONSE}" | grep "CBC:" | awk -F',' '{print $2}'`
VOLTAGE=`echo "${RESPONSE}" | grep "CBC:" | awk -F',' '{print $3}'`

echo "${CHARGE}% [${VOLTAGE} mV]"