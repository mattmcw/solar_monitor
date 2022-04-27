#!/bin/bash

source ./src/common.sh

mkdir -p tmp

datetime=`date_str`
filepath="./tmp/${datetime}.csv"

echo "Creating ${filepath}..."
bash src/csv/generate.sh "${datetime}" "${filepath}"

echo "Compressing ${filepath}"
gzip -c "${filepath}" > "${filepath}.gz"

echo "Uploading ${filepath}.gz"
bash src/csv/upload.sh "${filepath}.gz" "upload"