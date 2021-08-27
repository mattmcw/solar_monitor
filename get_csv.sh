#!/bin/bash

source ./common.sh

COOKIES=`mktemp`
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36"

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
		-H "Origin: ${URL}" \
		-H "Referer: ${URL}/" \
		-X POST \
		--data "username=${CONEXT_USERNAME}&password=${CONEXT_PASSWORD}" \
		"${URL}/auth"
}

login

req "${URL}"

rm -rf "${COOKIES}"