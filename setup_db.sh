#!/bin/bash

source ./src/common.sh

if [ ! -d data ]; then
	mkdir -p data
fi

SETUP=`cat sql/setup.sql`

db "${SETUP}"