#!/bin/bash

if [ ! -f ".env" ]; then
	echo "Please create a .env file with configuration values"
	exit 1
fi

source .env


##########
## NET  ##
##########

getIP () {
	line=`ifconfig "${NETWORKDEVICE}" | grep "inet" | head -1`
	ip=`echo "${line}" | awk '{print $2}'`
	echo "${ip}"
}

##########
## GPIO ##
##########

BASE_GPIO_PATH="/sys/class/gpio"
ON="1"
OFF="0"
FONA_SWITCH="18"

exportPin () {
  if [ ! -e $BASE_GPIO_PATH/gpio$1 ]; then
    echo "$1" > $BASE_GPIO_PATH/export
  fi
}

setOutput () {
  echo "out" > $BASE_GPIO_PATH/gpio$1/direction
}

setPinState () {
  echo $2 > $BASE_GPIO_PATH/gpio$1/value
}

turnFonaOn () {
	if [ "$(uname)" == "Darwin" ]; then
		echo "exportPin ${FONA_SWITCH}"
		echo "setOutput ${FONA_SWITCH}"
		echo "setPinState ${FONA_SWITCH} ${ON}"
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		exportPin ${FONA_SWITCH}
		echo "exportPin ${FONA_SWITCH}"
		setOutput ${FONA_SWITCH}
		echo "setOutput ${FONA_SWITCH}"
		setPinState ${FONA_SWITCH} ${ON}
		echo "setPinState ${FONA_SWITCH} ${ON}"
	fi
}

turnFonaOff () {
	if [ "$(uname)" == "Darwin" ]; then
		echo "setPinState ${FONA_SWITCH} ${OFF}"
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		setPinState ${FONA_SWITCH} ${OFF}
		echo "setPinState ${FONA_SWITCH} ${OFF}"
	fi
}

########
## DB ##
########

db () {
	sqlite3 "${DB}" "${1}"
}


col () {
	c=`echo "${2}" | awk -F',' '{ print $'${1}' }'`
	c=${c//[$'\t\r\n']}
	clean_quotes "${c}"
}

col_or_null () {
	res=`col "${@}"`
	if [[ "${res}" == "" ]]; then
		echo "NULL"
		exit
	else
		echo "${res}"
	fi
}

uuid () {
	uuidgen | tr "[:upper:]" "[:lower:]"
}

filesize () {
	wc -c "${1}" | awk '{print $1}'
}

lines_in_file () {
	if [ -f "${1}" ]; then
		wc -l "${1}" | awk '{print $1}'
	else 
		echo -1
	fi
}

clean_quotes () {
	echo "${1}" | sed 's/"//g'
}

###########
## DATES ##
###########

timestamp () {
	if [ "$(uname)" == "Darwin" ]; then
		ts=`TZ=$TZ date  -j -f "%Y-%m-%d %H:%M:%S" "${1}" "+%s"` #  2>/dev/null
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		ts=`TZ=$TZ date -d "${1}" "+%s"` # 2>/dev/null
	fi
	echo "${ts}"
}

create_timestamp () {
	date +%s
}

today () {
	TZ=$TZ date "+%F"
}

yesterday () {
	if [ "$(uname)" == "Darwin" ]; then
		TZ=$TZ date  -j -v "-1d" "+%F"
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		TZ=$TZ date -d "-1d" "+%F"
	fi
}

celsius2farenheit () {
	echo "scale=2;( ${1} * 9/5) + 32" | bc
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

#########
## CSV ##
#########

csv_exists () {
	if [ -f "${CSV}/${1}.csv.gz" ]; then
		return 1
	fi
	return 0
}

csv_complete () {
	gzip -d "${CSV}"
	COMP_FILE="${CSV}/${1}.csv.gz"
	DECOMP_FILE="tmp/${1}.csv"
	decompress_csv "${COMP_FILE}" "${DECOMP_FILE}"
	LINES=`lines_in_file "${DECOMP_FILE}"`
	rm "${DECOMP_FILE}"
	if [ ${LINES} -eq 1400 ]; then
		return 1
	fi
	return 0
}

compress_csv () {
	gzip -c "${1}" > "${2}"
}

decompress_csv () {
	gzip -dc "${1}" > "${2}"
}
