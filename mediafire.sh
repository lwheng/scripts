#!/bin/bash

# README
# Input file: Text file with Mediafire links
# Outcome: Run wget jobs in background

# USAGE: ./mediafire.sh <input file>
# So far this script has yet to encounter captcha
# wget -b command throws download to background

# NOTE:
# Make sure you are using the correct grep
# i.e. the one with the -E option

# Thanks to rctay for regex
# Thanks to benjamin for idea of curl POST-ing

INPUTFILE=$1

for LINK in $(cat $INPUTFILE)
    do
    temp1=${LINK/download.php/}
    temp=${temp1/file\//\?}
    RESULT=$(curl $temp | tr "\"" "\n" | grep -E 'http://([0-9]{1,3}\.){3}([0-9]{1,3})')
    if [ -z "$RESULT" ]
    then
    echo "$temp is password protected"
    echo "Please enter password:"
    read password
    RESULT1=$(curl -d "downloadp=$password" $temp | tr "\"" "\n" | grep -E 'http://([0-9]{1,3}\.){3}([0-9]{1,3})')
    wget -b --quiet $RESULT1
    else
    wget -b --quiet $RESULT
    fi
    done
