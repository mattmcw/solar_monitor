#!/bin/bash

source ./src/common.sh

COOKIES=`mktemp`
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36"

mkdir -p "${CSV}"

req () {
	curl \
		--insecure \
		-A "${UA}" \
		--cookie-jar "${COOKIES}" \
		${@}
}

login () {
	# --data/--form
	req \
		-v \
		-H "Origin: ${URL}" \
		-H "Referer: ${URL}/" \
		-X POST \
		--data "username=${CONEXT_USERNAME}&password=${CONEXT_PASSWORD}" \
		"${URL}/auth"
}

response=`login`
authToken=`echo "${response}" | grep "authToken" | awk '{print $3}'`

#TMP=`mktemp`

req \
	-H "authToken: ${authToken}" \
	-o "${TMP}" \
	"${URL}/chart_data.csv"

#DAYSTR=`get_day "${TMP}"`
#FILENAME="${CSV}/${DAYSTR}.csv.gz"
#compress_csv "${TMP}" "${FILENAME}"

rm -rf "${COOKIES}"