# README
# Input file: Text file with Mediafire links
# Outcome: Run wget jobs in background

# USAGE: ./mediafire.sh <input file>
# This script, for now, only works for Mediafire links that has no password, and when you are lucky
# to not encounter any captcha. Need fixing
# wget -b command throws download to background

INPUTFILE=$1

if [ -e ThisIsTheTempFileYouCannotMiss.txt ]
then
	rm ThisIsTheTempFileYouCannotMiss.txt
fi

cat $INPUTFILE | while read IMMATURELINK
do
	stringZ=$IMMATURELINK
	echo ${stringZ/download.php/} >> ThisIsTheTempFileYouCannotMiss.txt
done

cat ThisIsTheTempFileYouCannotMiss.txt | while read MATURELINK
do
	wget -b $(curl $MATURELINK | tr "\"" "\n" | grep ^http | grep -v "www" | grep -v "mediafire" | grep -v "twitter" | grep -v "gravatar" | grep -v "googleapis" | grep -v "macromedia" | grep -v "rubiconproject")
done

if [ -e ThisIsTheTempFileYouCannotMiss.txt ]
then
	rm ThisIsTheTempFileYouCannotMiss.txt
fi
