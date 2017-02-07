#!/bin/bash
#
# Compile list of Facebook pages with title and cover image from a list of page URLs
#
# Prepare the input file:
#   facebook-cli likes > likes.txt
#   awk 'NR % 3 == 2' likes.txt > urls.txt
#
# Generate HTML from stdin:
#   cat urls.txt | ./build-wall.sh > index.html
#
# Generate JSON from 'urls.txt':
#   ./build-wall.sh -f json -i urls.txt > index.json
#
# Show help:
#   ./build-wall.sh -h

FORMATS="html json"

function HELP {
  echo "Usage: $0 [-i input-file] [-f output-format] [-s icon-size] > output-file"
  echo
  echo "Icon size specifies the height of the cover images.  Default is: 180"
  echo
  echo "Valid output formats: $FORMATS"
  exit 1
}

FILE=/dev/stdin
FORMAT=html
PICSIZE=180

while getopts i:f:s:h FLAG; do
  case $FLAG in
    i)
      FILE=$OPTARG
      ;;
    f)
      if echo $FORMATS | grep -w $OPTARG > /dev/null; then
        FORMAT=$OPTARG
      else
        echo "Valid formats: $FORMATS"
        exit 1
      fi
      ;;
    s)
      PICSIZE=$OPTARG
      ;;
    h)
      HELP
      ;;
    \?)
      # Unrecognized option
      echo ; HELP
      ;;
  esac
done

mkdir -p images

if [ $FORMAT == "json" ]; then
  echo "["
  FIRSTLINE=1
fi

while read url; do
  # Print a dot to stderr for every image request
  (>&2 echo -n ".")

  # Extract page id from page URL
  id=$(echo $url | cut -d '/' -f 4)

  # Compose URL to retrieve profile picture
  imgurl="http://graph.facebook.com/$id/picture?height=$PICSIZE"

  # Fetch image (async; follow redirects)
  curl --max-time 30 -sLo "images/$id" $imgurl &

  # Resolve Facebook page name
  name=$(facebook-cli api --get name "$id")

  # Escape double quotes
  name=$(echo $name | sed s/\"/\\\\\"/g)

  if [ $FORMAT == "json" ]; then
    if [ $FIRSTLINE -ne 1 ]; then
      echo ","
    else
      FIRSTLINE=0
    fi

    echo -n "  {\"id\": \"$id\", \"title\": \"$name\"}"
  else
    echo "<a href=\"$url\"><img src=\"images/$id\" title=\"$name\"></a>"
  fi
done < "$FILE"

if [ $FORMAT == "json" ]; then
  echo
  echo "]"
fi

# Wait for fetches to finish
wait