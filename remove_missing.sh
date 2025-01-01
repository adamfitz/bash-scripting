#!/bin/bash

# read each line of the file
while IFS= read -r line; do
    # search through the csv file and if the text is matched delete that specific line only
    if grep -qF "$line" "./db_compare.csv"; then
        sed -i "/$line/d" "./db_compare.csv"
        echo "Removed $line from db_compare.csv"
    fi
done < "./not_in_db.txt"
