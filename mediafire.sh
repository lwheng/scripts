# FILENAME is a text file that contains Mediafire links
# Example:
# http://www.mediafire.com/blablabla

# Not sure whether it is needed, remember to hit return after your last Mediafire link i.e. enter a blank line
# after

# This script, for now, only works for Mediafire links that has no password, and when you are lucky
# to not encounter any captcha. Need fixing
# wget -b command throws download to background

FILENAME=$1
cat $FILENAME | while read MEDIAFIRELINK
do
	wget -b $(curl $MEDIAFIRELINK | grep "<body" | tr '\<' '\n' | grep "Download" | tr "\"" "\n" | grep http) 
done