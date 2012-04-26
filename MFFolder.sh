#!/bin/bash

# Author: Hong Dai Thanh

function help() {
  echo -e \
       "Usage:\n" \
       "  $0 URL [--no-recurse] [-s]\n\n" \
       "    URL\n" \
       "      Link to Mediafire folder.\n" \
       "      e.g. www.mediafire.com/?sample or mediafire.com/?sample\n\n" \
       "    --no-recurse\n" \
       "      List only files under the current folder.\n" \
       "      Default option is to recursively list all files.\n\n" \
       "    -s, --silent\n" \
       "      Supress all error messages.\n" >&2;
}

RECURSE=true
LINK=
SILENT=false

# Parse arguments
for var in "$@"
do
  if [[ $var = "--no-recurse" ]]; then
    # Folder will be recursively downloaded by default
    # Disable with with --no-recurse option
    RECURSE=false
  elif [[ $var = "-s" || $var = "--silent" ]]; then
    # Silent mode will suppress error messages
    SILENT=true
  elif [[ $var = "--help" || $var = "-h" ]]; then
    help
    exit 0
  elif [[ ! $var =~ ^-.* && -z "$LINK" ]]; then
    # Use the first string that is not starting with dash (-) as link
    LINK=$var
  elif [[ $var =~ ^-.* ]]; then
    echo "$0: Unrecognized option: $var" >&2
    echo "$0: Type '$0 --help' for assistance" >&2
    exit 1
  else
    echo "$0: Unrecognized extra token: $var" >&2
    echo "$0: Type '$0 --help' for assistance" >&2
    exit 1
  fi
done

# echo "$0: $RECURSE $LINK" >&2

# Check whether the link is provided
# Print out help if the link is not provided
[[ ! -z "$LINK" ]] || {
  help 
  exit 1
}

if $RECURSE;
then 
  RECURSE=yes
else
  RECURSE=no
fi

# Must check whether a link is provided first before supressing output
if $SILENT;
then
  exec 2> /dev/null
fi

# Test against Mediafire regular expression
MF_LINK_REGEX="^(http://)?(www\.)?mediafire\.com.*\?([a-z0-9]+)$"

[[ $LINK =~ $MF_LINK_REGEX ]] || {
  echo "$0: Please provide a valid link to Mediafire." >&2
  exit 1
}

# Folder key
KEY=${BASH_REMATCH[3]}

# echo "$0: $KEY" >&2

# Download folder information
FOLDER_INFO_API="http://www.mediafire.com/api/folder/get_info.php?folder_key=$KEY&recursive=$RECURSE&response_format=xml"

# echo "$0: $FOLDER_INFO_API" >&2

echo "$0: Downloading folder information..." >&2

FOLDER_INFO=$(curl $FOLDER_INFO_API -s)

[[ $? = 0 ]] || {
  echo "$0: Error occurred while downloading." >&2
  exit 1
}

echo "$0: Folder information downloaded." >&2

# Check success or not
SUCCESS_STRING='<result>Success</result>'

[[ $FOLDER_INFO =~ $SUCCESS_STRING ]] || {
  echo "$0: The Mediafire folder does not exist." >&2
  exit 1
}

# Extract quickkeys
QUICKKEY_REGEX='<quickkey>([a-z0-9]+)</quickkey>'

QUICKKEYS=$(echo $FOLDER_INFO | grep -o -P $QUICKKEY_REGEX)

for var in $QUICKKEYS
do
  [[ $var =~ $QUICKKEY_REGEX ]]
  echo "http://www.mediafire.com/?${BASH_REMATCH[1]}"
done 
