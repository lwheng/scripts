# README
# Input file: Text file with some links
# Output file: Mediafire links to stdout
# Note: The links are 'simple' such that there is no redirection, and mediafire links are easily grep-able

INPUTFILE=$1

cat $INPUTFILE | while read LINE
do
echo $(curl $LINE | tr "\"" "\n" | grep mediafire) >> ThisIsTheTempFileYouCannotMiss.txt
done
cat ThisIsTheTempFileYouCannotMiss.txt
if [ -e ThisIsTheTempFileYouCannotMiss.txt ]
then
rm ThisIsTheTempFileYouCannotMiss.txt
fi
