#!/bin/bash
#
# Author: Adam Fitzgerald
# Purpose: Move a list of directories and their contents
# Version: 0.1
#

# filename to be supplied as argument (required)
filename_list=$1
# root of the destination directory
target_dir_root=$2

# defining main at the top to more easily see what the script is doing
main()
{
    stop_and_check
}

# function to stop and wait for input
stop_and_check()
{
    printf "About to move all directories and their contents listed in $filename_list, to $target_dir_root "\n" Do you want to continue? ( y | n )"
    read -r -p "$* " choice
    if [ $choice = "y" ];
        then
            # if the user agrees move the directories
            read_and_move
        else
            printf "User chose not to continue.  Exiting...\n"
            exit 1
    fi
}

# function to delete all directories found in the supplied text file
read_and_move()
{
    # grab all the lines from a file and read into an array
    readarray -t items_to_delete < "$filename_list"
    # iterate through all elements in the array
    for i in "${items_to_delete[@]}"
    do
        printf "Moving: $i\n"
        mv "$i" "$target_dir_root"
        # the below writes a "log file"
        echo "$i" >> ./dirs_moved.txt
    done
}

# start the script
main