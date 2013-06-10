#!/bin/bash

# Gather all unique keys
echo "Gathering all keys..."
cat $(find . | grep utf8) | grep ^'[a-z]' | cut -f1 -d'=' | sort | uniq > allKeys
echo "All keys gathered!"

for FILENAME in $(find . | grep utf8)
  do
    echo $FILENAME
    temp=$(cat $FILENAME | grep ^'[a-z]' | cut -f1 -d'=' | sort | uniq)
    diff -yw --suppress-common-lines allKeys temp | cut -f1 -d' '
    echo
  done
