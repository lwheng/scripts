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
# Thanks to nhahtdh for checking whether wget installed

# Check whether curl is installed
command -v curl >/dev/null 2>&1 || {
  echo "$0: curl utility not found." >&2
  echo "$0: Please install curl package or check PATH variable." >&2
  exit 1
}

# Check whether wget is installed
WGET_INSTALLED=true

command -v wget >/dev/null 2>&1 || { 
  WGET_INSTALLED=false
}

function help() {
   echo -e \
        "Usage:\n" \
        "  $0 INPUT_FILE\n\n" \
        "    INPUT_FILE\n" \
        "      A text file containing links to files hosted on Mediafire\n" \
        "      Each link should be on one line\n" >&2;
}

if [[ -z "$1" ]]; then
  help
  exit 1;
fi

INPUTFILE=$1

for LINK in $(cat $INPUTFILE)
    do
    temp1=${LINK/download.php/}
    temp=${temp1/file\//\?}
    RESULT=$(curl $temp | grep kNO | tr "\"" "\n" | grep -E 'http://([0-9]{1,3}\.){3}([0-9]{1,3})')
    if [ -z "$RESULT" ]
    then
      echo "$temp is password protected"
      echo "Please enter password:"
      read password
      RESULT1=$(curl -d "downloadp=$password" $temp | tr "\'" "\n" | tr "\"" "\n" | grep -E 'http://([0-9]{1,3}\.){3}([0-9]{1,3})')
      if $WGET_INSTALLED; then
        wget -b --quiet $RESULT1
      else
        curl -L -O -J $RESULT1 &
      fi
    else
      if $WGET_INSTALLED; then
        echo "Down"
        wget -b --quiet $RESULT
      else
        curl -L -O -J $RESULT &
      fi
    fi
done
