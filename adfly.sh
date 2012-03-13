# README
# Input file: Text file with adf.ly links
# Output: Mediafire links to stdout

# USAGE: ./adfly.sh <input file>

INPUTFILE=$1

cat $INPUTFILE | while read LINE
do
echo $(curl $(curl $LINE | tr "\"" "\n" | tr "\'" "\n" | grep "adf.ly/go/") | tr "=" "\n" | tr "\"" "\n" | grep mediafire) >> ThisIsTheTempFileYouCannotMiss.txt
done
cat ThisIsTheTempFileYouCannotMiss.txt
if [ -e ThisIsTheTempFileYouCannotMiss.txt ]
then
rm ThisIsTheTempFileYouCannotMiss.txt
fi
