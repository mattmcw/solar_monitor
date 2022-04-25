#!/bin/bash

DEPS=(
	sqlite3
)

for dep in ${DEPS[@]}; do
	if ! command -v "${dep}" &> /dev/null
	then
	    echo "Application ${dep} could not be found"

	    sudo apt install "${dep}"

	    if ! command -v "${dep}" &> /dev/null
	    then
			echo "Please install ${dep} before running any scripts"
			exit 1
	    fi
	fi
done

echo "All dependencies are installed"

bash setup_db.sh