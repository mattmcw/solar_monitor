#!/bin/bash

source ./common.sh

FILEPATH=`pwd "${1}"`

scp "${FILEPATH}" ${REMOTE}:~/csv/
