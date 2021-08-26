#!/bin/bash

COOKIES=`mktemp`
UA="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0"
URL="http://192.168.100.1"

req () {
	curl -A "${UA}" --cookie-jar "${COOKIES}" ${@}
}

req "${URL}"

rm -rf "${COOKIES}"