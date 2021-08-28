#!/bin/bash

source ./src/common.sh

TWENTYFOURHOURS=86400
NOW=`date "+%s"`
LASTDAY=`echo "${NOW}-${TWENTYFOURHOURS}" | bc`
QUERY="SELECT * FROM conextstate WHERE \
	()	\
	;"