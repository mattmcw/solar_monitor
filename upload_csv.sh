#!/bin/bash

source ./common.sh

upload () {
	curl \
		-A "${PI_UA}" \
		-H "Content-Type: application/gzip" \
		--data-binary "@tmp/upload.csv.gz" \
		${@}
}

mkdir -p tmp
cp "${1}" "tmp/upload.csv.gz"
