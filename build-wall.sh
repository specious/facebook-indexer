#!/bin/bash
#
# Usage:
#   facebook-cli likes > likes.txt
#   awk 'NR % 3 == 2' likes.txt > urls.txt
#   cat urls.txt | ./build-wall.sh > index.html

mkdir -p images

while read url; do
  # Print a dot to stderr for every image request
  (>&2 echo -n ".")

  # Extract page id from page URL
  id=$(echo $url | cut -d '/' -f 4)

  # Compose URL to retrieve profile picture
  imgurl="http://graph.facebook.com/$id/picture?height=${2:-180}"

  # Fetch image (async; follow redirects)
  curl --connect-timeout 30 -sLo "images/$id" $imgurl &

  echo "<a href=\"$url\"><img src=\"images/$id\"></a>"
done < "${1:-/dev/stdin}"

# Wait for fetches to finish
wait