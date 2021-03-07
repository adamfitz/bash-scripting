# Author: Adam Fitzgerald
# Purpose: convert default audio of mkv file to eng
# Version: 0.1
#

for file in *;
do
  filename="$(basename $file .mkv)"
  if [[ "$file" != *.mkv ]];
  then
    printf "File is not an *.mkv file: $file\n" | tee conversion.log
  elif [[ "$filename" == *"eng-default"* ]];
  then
    printf "File has already been converted: $file\n" | tee conversion.log
  else
    # -n to skip overwrite output file if it already exists
    ffmpeg -n -i "$file" -map 0:v -map 0:m:language:eng -c copy "$filename"-eng-default.mkv | tee conversion.log
    printf "File converted: $file\n"
  fi
done