#!/bin/bash

source ./common.sh

if [ ! -d data ]; then
	mkdir -p data
fi

SETUP=`cat setup.sql`

db "${SETUP}"