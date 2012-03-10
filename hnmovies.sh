# For hnmovies.com
# INPUT: URL of the download page of a movie on hnmovies.com
# OUTPUT: q.gs links to stdout

LINK=$1

curl $(curl $LINK | grep download.hnmovies.com | tr "\"" "\n" | grep ^http) | tr "\"" "\n" | grep ^http | grep q.gs