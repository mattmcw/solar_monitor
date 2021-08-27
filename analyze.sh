#!/bin/bash

source ./common.sh

TWENTYFOURHOURS=86400
NOW=`date "+%s"`
LASTDAY=`echo "${NOW}-${TWENTYFOURHOURS}" | bc`
QUERY=""