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
#command -v curl >/dev/null 2>&1 || {
#  echo "$0: curl utility not found." >&2
#  echo "$0: Please install curl package or check PATH variable." >&2
#  exit 1
#}
# Check whether wget is installed

{
	[ -x /usr/xpg4/bin/grep ] && GREP=/usr/xpg4/bin/grep 
} || {
	[ -x /usr/bin/grep ] && GREP=/usr/bin/grep
} || {
	[ -x /bin/grep ] && GREP=/bin/grep
}

{
	$(!command -v curl >/dev/null 2>&1) || {
		DL_PAGE_CMD="curl %u"
		DL_PAGE_CMD_P="curl -d \"downloadp=%p\" %u"
		DL_FILE_CMD="curl -L -O %u"
	}

} || {
	$(!command -v wget >/dev/null 2>&1) || {
		DL_PAGE_CMD="wget -qO- %u"
		DL_PAGE_CMD_P="wget -qO- --post-data=\"downloadp=%p\" %u"
		DL_FILE_CMD="wget -b --quiet %u &"
	}
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
	RESULT=$(${DL_PAGE_CMD/'%u'/$temp} | tr "\'" "\n" | tr "\"" "\n" | $GREP -E 'http://([0-9]{1,3}\.){3}([0-9]{1,3})')
	if [ -z "$RESULT" ]
	then
		echo "$temp is password protected"
		echo "Please enter password:"
		read password
		sub_url=${DL_PAGE_CMD_P/'%u'/$temp}
		RESULT1=$(${sub_url/'%p'/$password} | tr "\'" "\n" | tr "\"" "\n" | $GREP -E 'http://([0-9]{1,3}\.){3}([0-9]{1,3})')
		${DL_FILE_CMD/'%u'/$RESULT1} > /dev/null 2>&1 &
	else
		${DL_FILE_CMD/'%u'/$RESULT} > /dev/null 2>&1 &
	fi
done
