#!/bin/bash

# need to fix file names with spaces -> ouput file is currently _mp3

for filename in *;
do
        # get file extension
        ext=${filename##*.}
        if [ "$ext" == "mkv" ] || [ "$ext" == "mp4" ];
        then
                echo "re encoding "$filename" to mp3 audio"
                base_file=`basename -s .$ext "$filename"`
                output_file=$base_file"_mp3".$ext
                #echo $output_file
                ffmpeg -i "$filename" -acodec mp3 -vcodec copy $output_file
        else
                echo ""$filename" - is not an mkv or mp4, exiting"
        fi
done
