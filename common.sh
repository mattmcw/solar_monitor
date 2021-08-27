#!/bin/bash

if [ ! -f ".env" ]; then
	echo "Please create a .env file with configuration values"
	exit 1
fi

source .env

db () {
	sqlite3 "${DB}" "${1}"
}

uuid () {
	uuidgen | tr "[:upper:]" "[:lower:]"
}

create_timestamp () {
	date +%s
}

filesize () {
	wc -c "${1}" | awk '{print $1}'
}

clean_quotes () {
	echo "${1}" | sed 's/"//g'
}

timestamp () {
	if [ "$(uname)" == "Darwin" ]; then
		ts=`TZ=$TZ date  -j -f "%Y-%m-%d %H:%M:%S" "${1}" "+%s"` #  2>/dev/null
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		ts=`TZ=$TZ date -d "${1}" "+%s"` # 2>/dev/null
	fi
	echo "${ts}"
}

celsius2farenheit () {
	echo "scale=2;(${1} × 9/5) + 32" | bc
}

col () {
	c=`echo "${2}" | awk -F',' '{ print $'${1}' }'`
	c=${c//[$'\t\r\n']}
	clean_quotes "${c}"
}

remove_header () {
	while read row; do
		raw_date=`col 1 "${row}"`
		if [[ "${raw_date}" == *"Date"* ]]; then
			continue
		fi
		echo "${row}"
	done < "${1}"
}

remove_quotes () {
	while read row; do
		clean_quotes "${row}"
	done < "${1}"
}

remove_date () {
	first_date=""
	while read row; do
		raw_date=`col 1 "${row}"`
		if [[ "${raw_date}" != *"Date"* ]] && [[ "${first_date}" == "" ]]; then
			first_date=`clean_quotes "${raw_date}" | awk '{print $1}'`
		elif [[ "${first_date}" != "" ]]; then
			row=`echo "${row//$first_date }"`
		fi
		echo "${row}"
	done < "${1}"
}

get_day () {
	first_date=""
	while read row; do
		raw_date=`col 1 "${row}"`
		if [[ "${raw_date}" != *"Date"* ]] && [[ "${first_date}" == "" ]]; then
			first_date=`clean_quotes "${raw_date}" | awk '{print $1}'`
			break
		fi
	done < "${1}"
	echo "${first_date}"
}