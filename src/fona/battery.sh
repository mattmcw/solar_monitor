#!/bin/bash

RESPONSE=`bash ./src/fona/send.sh "AT+CBC" | grep "CBC:"`

CHARGE=`echo "${RESPONSE}"  | awk -F',' '{print $2}'`
VOLTAGE=`echo "${RESPONSE}" | awk -F',' '{print $3}'`
#VOLTAGE=`echo "scale=3;${VOLTAGE}/1000;" | bc`

echo "charge=${CHARGE}"
echo "voltage=${VOLTAGE}"