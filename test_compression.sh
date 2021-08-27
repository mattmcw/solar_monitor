#!/bin/bash

source ./common.sh

mkdir -p tmp

cp example/* tmp/

perc () {
	p=`echo "scale=2;(${2}/${1})*100" | bc`
	echo "[${3}] ${1} => ${2} ${p}%"
}

testmethod () {
	gzip -c "${1}.${2}" > "${1}.${2}.gz"
	uncomp=`filesize "${1}.${2}"`
	perc ${initial} ${uncomp} "${2}"
	comp=`filesize "${1}.${2}.gz"`
	perc ${initial} ${comp} "${2} gzip"
}

for i in "./tmp/"*.csv ; do
	initial=`filesize "${i}"`

	# gzip 
	gzip -c "${i}" > "${i}.gz"
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
