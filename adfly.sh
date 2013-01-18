# README
# Input file: Text file with adf.ly links
# Output: Mediafire links to stdout

# USAGE: ./adfly.sh <input file>

INPUTFILE=$1

for LINK in $(cat $INPUTFILE)
do
  LINE=${LINK/locked\//}
echo $(curl $(curl $LINE | tr "\"" "\n" | tr "\'" "\n" | grep "adf.ly/go/") | tr "=" "\n" | tr "\"" "\n" | grep mediafire) >> ThisIsTheTempFileYouCannotMiss.txt
done
cat ThisIsTheTempFileYouCannotMiss.txt
if [ -e ThisIsTheTempFileYouCannotMiss.txt ]
then
rm ThisIsTheTempFileYouCannotMiss.txt
fi
