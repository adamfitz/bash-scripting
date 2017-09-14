#!/bin/bash
#
# Author: Adam Fitzgerald
# Purpose: Read in  a list of directory names from a file and delete them
# Version: 0.1
#

# filename to be supplied as argument (required)
prefix=$1

# defining main at the top to more easily see what the script is doing
main()
{
    stop_and_check
}

# function to stop and wait for input
stop_and_check()
{
    printf "About to PERMANTENTLY delete all directories listed in $prefix, do you want to continue? ( y | n )"
    read -r -p "$* " choice
    if [ $choice = "y" ];
        then
            # if the user agrees call the delete function
            read_and_delete
        else
            printf "Exiting...\n"
            exit 1
    fi
}

# function to delete all directories found in the supplied text file
read_and_delete()
{
    # grab all the lines from a file and read into an array
    readarray -t items_to_delete < "$prefix"
    # iterate through all elements in the array
    for i in "${items_to_delete[@]}"
    do
        printf "Deleted directory: $i\n"
        rm -rf $i
        echo "$i" >> ./deleted_directories_test
    done

}

# start the script
main
