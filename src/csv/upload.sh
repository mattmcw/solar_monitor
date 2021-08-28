#!/bin/bash

source ./src/common.sh

FILEPATH=`pwd "${1}"`

scp "${FILEPATH}" ${REMOTE}:~/csv/
