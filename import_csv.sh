#!/bin/bash

source ./common.sh

# "Date","Volts(V)","Current(A)","Temperature(°C)","State Of Charge(%)"
# "2021-08-16 00:00:00",52.352,-2.047,25,55

col_or_null () {
	res=`col "${@}"`
	if [[ "${res}" == "" ]]; then
		echo "NULL"
		exit
	else
		echo "${res}"
	fi
}

import_csv () {
	while read row; do
		raw_date=`col 1 "${row}"`
		if [[ "${raw_date}" == *"Date"* ]]; then
			continue
		fi

		time=`timestamp "${raw_date}"`
		volts=`col_or_null 2 "${row}"`
		current=`col_or_null 3 "${row}"`
		temperature=`col_or_null 4 "${row}"`
		charge=`col_or_null 5 "${row}"`

		query="INSERT OR IGNORE INTO \
			conextstate ( timestamp_str,timestamp,volts,current,temperature,charge ) \
			VALUES ( '${raw_date}',${time},${volts},${current},${temperature},${charge} );"
		
		echo "${query}"
		db "${query}"
	done < "${1}"
}

import_csv "${1}"