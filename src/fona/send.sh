#!/bin/bash

SERIAL="/dev/serial0"
BAUD="115200"

echo "${1}" | cu -s ${BAUD} -l "${SERIAL}"