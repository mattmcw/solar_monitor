#!/bin/bash

source ./src/common.sh

mkdir -p tmp

#cp example/* tmp/

for day in $(seq 0 30); do
	if [ "$(uname)" == "Darwin" ]; then
		datetime=`TZ=$TZ date -j -v "+${day}d" "+%F"`
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		datetime=`TZ=$TZ date -d "+${day} day" "+%F"`
	fi
	bash generate_csv.sh "${datetime}" "./tmp/${datetime}.csv"
done

perc () {
	p=`echo "scale=2;(${2}/${1})*100" | bc`
	echo "[${3}] ${1} => ${2} ${p}%"
}

testmethod () {
	compress_csv "${1}.${2}" "${1}.${2}.gz"
	uncomp=`filesize "${1}.${2}"`
	perc ${initial} ${uncomp} "${2}"
	comp=`filesize "${1}.${2}.gz"`
	perc ${initial} ${comp} "${2} gzip"
}

for i in "./tmp/"*.csv ; do
	initial=`filesize "${i}"`

	# gzip 
	compress_csv "${i}" "${i}.gz"
	compressed=`filesize "${i}.gz"`
	perc ${initial} ${compressed} "gzip"

	name="noheader"
	remove_header "${i}" > "${i}.${name}"
	testmethod "${i}" "${name}"

	name="noquote"
	remove_quotes "${i}" > "${i}.${name}"
	testmethod "${i}" "${name}"

    name="noheaderquote"
	remove_quotes "${i}.noheader" > "${i}.${name}"
	testmethod "${i}" "${name}"

	name="nodate"
	remove_date "${i}.noheaderquote" > "${i}.${name}"
	testmethod "${i}" "${name}"
done

rm -rf tmp/*
