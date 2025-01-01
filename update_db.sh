#!/bin/bash

# Database path
DB_PATH="./mangaList.db"

# CSV file path
CSV_FILE="./db_compare.csv"

# Read each line of the CSV file
while IFS= read -r line; do
    # Extract the manga name and chapter number using regex
    manga_name=$(echo "$line" | awk -F, '{ print $1 }' | sed 's/^"//;s/"$//')
    chapter_number=$(echo "$line" | awk -F, '{ print $2 }')

    # Trim any leading or trailing spaces
    manga_name=$(echo "$manga_name" | xargs)
    chapter_number=$(echo "$chapter_number" | xargs)

    # Debugging: Print extracted values
    echo "Processing: Manga Name='$manga_name', Chapter Number='$chapter_number'"

    # Execute SQLite update command
    sqlite3 "$DB_PATH" <<-EOF
        UPDATE chapters
        SET current_dld_chapter = '$chapter_number'
        WHERE name = '$manga_name';
EOF

    # Check if the update succeeded
    if [[ $? -eq 0 ]]; then
        echo "Successfully updated $manga_name with chapter $chapter_number."
    else
        echo "Failed to update $manga_name. Check your database or CSV file."
    fi

done < "$CSV_FILE"

