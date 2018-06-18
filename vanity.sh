#!/bin/bash

if [[ $1 == "" ]]; then
    echo "Search for vanity keys - Usage : ./vanity.sh STRING"
    exit 1
fi

echo "Finding keys containing : $1"
STRING=$(echo "$1" | tr '[:upper:]' '[:lower:]')

while true; do
    output=$(cleos create key)
    pub=$(cut -d ' ' -f 5 <<< "${output//[$'\r\n']}")
    pub=$(echo "$pub" | tr '[:upper:]' '[:lower:]')
    if [[ $pub =~ .*$STRING.* ]]; then
      echo $output
      break
    fi
done
