#!/bin/bash
#
# Author: Adam Fitzgerald
# Purpose: write output mkv file with default audio language set to english
# Version: 0.1
#

for file in *;
do
  filename="$(basename $file .mkv)"
  if [[ "$filename" == *"eng-default"* ]];
  then
    printf "File has already been converted: $file\n" | tee conversion.log
  else
    printf "Converting file: $file\n"
    # -n to skip overwrite output file if it already exists
    ffmpeg -i "$file" -map 0:v -map 0:m:language:eng -c copy "$filename"-eng-default.mkv
  fi
done