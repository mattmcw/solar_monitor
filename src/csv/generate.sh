#!/bin/bash

source ./src/common.sh

# "Date","Volts(V)","Current(A)","Temperature(°C)","State Of Charge(%)"
# "2021-08-16 00:00:00",52.352,-2.047,25,55

if [[ "${1}" == "" ]] || [[ "${2}" == "" ]]; then
	echo "Please provide 2 arguments, a date and a destination file"
	exit 1
fi

random_float () {
	start=$1
	end=$2
	precision=$3
	intval=`echo "scale=0; ($RANDOM % ($end - $start)) + $start" | bc`
	floatval=`echo "scale=$precision; ($RANDOM + 1000) / 1000" | bc | awk -F'.' '{print $2}'`
	echo "${intval}.${floatval}"
}

random_int () {
	start=$1
	end=$2
	echo "scale=0; ($RANDOM % ($end - $start)) + $start" | bc
}

random_volt () {
	random_float 50 55 3
}

random_current () {
	random_float -10 10 3
}

random_temp () {
	random_int -15 30
}

random_charge () {
	random_int 0 100
}

generate_csv () {
	echo '"Date","Volts(V)","Current(A)","Temperature(°C)","State Of Charge(%)"'
	for hour in $(seq -f "%02g" 00 23); do
		for minute in $(seq -f "%02g" 00 59); do
			timestamp="\"${1} ${hour}:${minute}:00\""
			volt=`random_volt`
			current=`random_current`
			temperature=`random_temp`
			charge=`random_charge`
			echo "${timestamp},${volt},${current},${temperature},${charge}"
		done
	done
}

generate_csv "${1}" > "${2}"