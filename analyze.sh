#!/bin/bash

source ./src/common.sh

temp () {
	C=$1
	F=`echo "scale=1;($C * (9 / 5) ) + 32" | bc`
	echo "${F} F°"
}

TWENTYFOURHOURS=86400
NOW=`date "+%s"`
LASTDAY=`echo "${NOW}-${TWENTYFOURHOURS}" | bc`
LATEST=`db "SELECT MAX(timestamp) FROM conextstate;"`
LATESTDAY=`echo "${LATEST}-${TWENTYFOURHOURS}" | bc`

OFFQUERY=`cat ./sql/off.sql`
MAXQUERY=`cat ./sql/max_temp.sql`
MINQUERY=`cat ./sql/min_temp.sql`

OFFCOUNT=`db "${OFFQUERY}"`

if [[ $OFFCOUNT -gt 2 ]]; then
	echo $OFFCOUNT
fi

MAXTEMP=`db "${MAXQUERY}"`
MINTEMP=`db "${MINQUERY}"`

echo "MIN: $(temp $MINTEMP)"
echo "MAX: $(temp $MAXTEMP)"