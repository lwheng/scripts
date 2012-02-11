# README
# I wrote to script simply to extract the Mediafire links from Adf.ly links
# because it gets very annoying to have the need to refresh the adf.ly pages,
# and wait for 5 seconds before you can click, and get redirected to the Mediafire
# page

# Usage: ./adfly.sh <file>
# Here <file> is a text file with all the adf.ly links
# eg.
# ./adfly.sh links.txt

# This script makes use of a temp.txt, and will write out an out.html,
# which contains all the Mediafire links in a nice html file.

FILENAME=$1
rm out.html
echo "<html>" >> out.html
echo "<body>" >> out.html
cat $FILENAME | while read LINE
do
    echo $(curl $LINE | grep mediafire) >> temp.txt
done

cat temp.txt | while read LINE1
do
	string=$LINE1
	link=${string:11:53}
	echo "<a href=\"$link\">$link</a>" >> out.html
	echo "<br>" >> out.html
	#substring=${$LINE1:10:9}
	#echo substring
done

echo "</body>" >> out.html
echo "</html>" >> out.html
rm temp.txt



