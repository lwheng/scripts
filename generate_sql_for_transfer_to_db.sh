#!/bin/bash

function help() {
  echo -e "Usage:\n" \
          "   $0 <File_1> <File_2>\n\n" \
          "   <File_1> : The file with key:value pairs to be added to database\n" \
          "   <File_2> : The file to be compared against\n" \
          "   <Market ID> : The market ID\n\n" \
          "Output:\n" \
          "   An SQL file that contains INSERT statements for (File_1.keys - File_2.keys)" >&2;
          
}

if [[ -z "$1" ]]; then
  help
  exit 1;
fi

if [[ -z "$2" ]]; then
  help
  exit 1;
fi

if [[ -z "$3" ]]; then
  help
  exit 1;
fi

# Assign to variables
FILE1=$1
FILE2=$2

# Set Market ID here
MARKETID=$3

# Gather all keys from FILE1
cat $FILE1 | grep ^'[a-z]' | cut -f1 -d'=' | sort | uniq > FILE1_KEYS
cat $FILE2 | grep ^'[a-z]' | cut -f1 -d'=' | sort | uniq > FILE2_KEYS

# Format FILE1 properly
cat $FILE1 | grep ^'[a-z]' | sort | uniq > FILE1_FORMATTED
# Format FILE2 properly
cat $FILE2 | grep ^'[a-z]' | sort | uniq > FILE2_FORMATTED

for KEY in $(cat FILE1_KEYS)
  do
    grep -q ^$KEY'=' FILE2_FORMATTED
    if [ $? -ne 0 ]; then
      grep ^$KEY'=' FILE1_FORMATTED >> TO_BE_INSERTED
    fi
  done

for KEY in $(cat FILE2_KEYS)
  do
    grep -q ^$KEY'=' FILE1_FORMATTED
    if [ $? -ne 0 ]; then
      grep ^$KEY'=' FILE2_FORMATTED >> TO_BE_INSERTED
    fi
  done
rm FILE1_KEYS FILE1_FORMATTED FILE2_KEYS FILE2_FORMATTED

# while read LINE; do
#   INDEX=$(expr match "$LINE" '[a-z|\.]*=')
#   echo -ne "INSERT APPCONFIG (key_name, key_value, critical_value, marketid, modified_by) VALUES ('$(echo "$LINE" | cut -f1 -d'=')','"
#   printf "%b" "${LINE:$INDEX}"
#   echo -ne "',1,'${MARKETID}',1)\n"
# done < TO_BE_INSERTED

cat TO_BE_INSERTED | sort | sed "s/'/''/g" | sed "s/\([a-z|\.|0-9|_|A-Z]*\)=\(.*\)/INSERT APPCONFIG \(key_name, key_value, critical_value, marketid, modified_by\) VALUES \('\1', '\2', 1, '${MARKETID}', 1)/"

cp $FILE1 TEST
cat TO_BE_INSERTED | cut -f1 -d'=' > KEYS_TO_BE_DELETED

for SEARCH in $(cat KEYS_TO_BE_DELETED)
  do
    grep -v "$SEARCH" TEST > TEST1
    mv TEST1 TEST
  done

rm TO_BE_INSERTED
rm KEYS_TO_BE_DELETED
cp $FILE1 $FILE1.bak.properties
mv TEST $FILE1
