URL=$1

curl $URL | grep Gamefront.part | tr "\"" "\n" | grep picbucks > ThisIsTheTempFileYouCannotMiss.txt

for LINK in $(cat ThisIsTheTempFileYouCannotMiss.txt)
do
  echo $(curl $LINK | grep gamefront | tr "\'" "\n" | grep http) >> ThisIsTheTempFileYouCannotMissPre.txt
done

cat ThisIsTheTempFileYouCannotMissPre.txt
rm ThisIsTheTempFileYouCannotMiss.txt
rm ThisIsTheTempFileYouCannotMissPre.txt
