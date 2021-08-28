#!/bin/bash

set -e

source ./src/common.sh

mkdir -p tmp

TODAY=`today`
YESTERDAY=`yesterday`

echo "Running daily script ${TODAY}..."

echo "Turning on FONA..."
turnFonaOn
echo "Turned on FONA."
#sleep 10


echo "Connect FONA ppp..."
#sudo pon fona
echo "Connected FONA ppp."
#sleep 10
#

lines_in_file example/2021-08-14.csv
lines_in_file example/2021-08-16.csv

echo "${CSV}/${TODAY}.csv.gz"
echo "${CSV}/${YESTERDAY}.csv.gz"

#sleep 10
echo "Disconnecting FONA ppp..."
#sudo poff fona
echo "Disconnected FONA ppp."
#sleep 10

echo "Turning off FONA..."
turnFonaOff
echo "Turned off FONA."
