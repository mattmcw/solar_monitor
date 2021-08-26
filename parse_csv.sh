#!/bin/bash

# "Date","Volts(V)","Current(A)","Temperature(°C)","State Of Charge(%)"
# "2021-08-16 00:00:00",52.352,-2.047,25,55

timestamp () {
	if [ "$(uname)" == "Darwin" ]; then
		ts=`date  -j -f "%Y-%m-%d %H:%M:%S" "${1}" "+%s"` #  2>/dev/null
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		ts=`date  -D "%Y-%m-%d %H:%M:%S" -d "${1}" "+%s"` # 2>/dev/null
	fi
	echo "${ts}"
}

col () {
	echo "${2}" | awk -F',' '{ print $'${1}' }'
}

parse_csv () {
	while read row; do
		raw_date=`col 1 "${row}"`
		timestamp "${raw_date}"
	done < "${1}"
}

parse_csv "${1}"