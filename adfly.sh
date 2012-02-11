# README
# Input file: Text file with adf.ly links
# Output files: HTML file with Mediafire links, Text file with Mediafire links (Use with mediafire.sh)

# USAGE: ./adfly.sh <input file>

INPUTFILE=$1

if [ -e adflyweb.html ]
then
	rm adflyweb.html
fi

if [ -e adflytext.txt ]
then
	rm adflytext.txt
fi

echo "<html>" >> adflyweb.html
echo "<body>" >> adflyweb.html
cat $INPUTFILE | while read LINE
do
    echo $(curl $LINE | grep mediafire | tr "\'" "\n" | grep mediafire) >> adflytext.txt
done

cat adflytext.txt | while read LINE1
do
	echo "<a href=\"$LINE1\">$LINE1</a>" >> adflyweb.html
	echo "<br>" >> adflyweb.html
done

echo "</body>" >> adflyweb.html
echo "</html>" >> adflyweb.html



