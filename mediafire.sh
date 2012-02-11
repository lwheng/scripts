# README
# Input file: Text file with Mediafire links
# Outcome: Run wget jobs in background

# USAGE: ./mediafire.sh <input file>
# This script, for now, only works for Mediafire links that has no password, and when you are lucky
# to not encounter any captcha. Need fixing
# wget -b command throws download to background

INPUTFILE=$1
cat $INPUTFILE | while read MEDIAFIRELINK
do
	wget -b $(curl $MEDIAFIRELINK | grep "<body" | tr '\<' '\n' | grep "Download" | tr "\"" "\n" | grep http) 
done