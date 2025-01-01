#!/bin/bash

root_dir=$1

# Check all subdirectories
for directory in $root_dir/*; do
    # Skip 2 specific directories
    if [[ "$directory" == "Hentai" || "$directory" == "Light Novels" ]]; then
        continue
    fi

    # Step 1: Assign the output of the command to a variable
    file=$(ls -v "$directory" | tail -1)

    # Print the result
    echo "\"$directory\",\"$file\""
done
