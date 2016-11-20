#!/bin/bash

#Get the date
currentDate=$(date +%Y-%m-%d_%H-%M-%S)

#Backup filename variable
backupFilename=$(hostname).bind_backup

#Backup directory
backupDir="backup"

#Bind directory
bindDir="/etc/bind"

#Array to hold list of files in the backup directory
backupFileList=( /backup/*.gz )

#The total number of Elements in the array
lastElementInTheArray=${#backupFileList[*]}

#The number of redundant elements in the array (all files older than the newst 5 files)
redundantElementsInTheArray=$(($lastElementInTheArray-5))

#The maximum number of backup files to keep at any one time (derived from the array so the indicie starts at zero eg: 0-4 = 5 elements)
totalFilesToKeep=4

#Start of actual script
printf "\n"
printf "\n"
printf "======================================================"
printf "\n"
printf "Backing up bind9 configuration and local zone files..."
printf "\n"
printf "======================================================"
printf "\n"
printf "\n"
#Compress the bind directory recursively, this will include the zone files (because my zone files are in /etc/bind/zones/*)
tar -zcvf /"$backupDir"/"$backupFilename.$currentDate.tar.gz" $bindDir
printf "\n"
printf "************************************************************************************"
printf "\n"
printf "Bind config and local zone files have been compressed and moved to backup directory."
printf "\n"
printf "************************************************************************************"
printf "\n"
printf "\n"
printf "Files in backup directory"
printf "\n"
for i in ${backupFileList[@]};
    do
        printf "$i"
        printf "\n"
    done
#Print out the last element in the array as well as the redundant elements in the array and their positions in the array.  Why?  just because...
printf "\n"
printf "\n"
printf "The total number of files in the array is: $lastElementInTheArray"
printf "\n"
printf "\n"
printf "The total number of redundant elements (files) in the array are from 0 - $redundantElementsInTheArray "
printf "\n"
printf "\n"
#The below if statment does the following: 
#   1) Checks the number of backup files is greater than 5, if there is less than 5 backup files, it prints a messge indicating that there are less than 5 backups in the directory and does nothing further
#   2) Uses a for loop to iterate through the array of backup filnames and deletes all but the most recent 5 backup files (newest backup files are the last 5 elenents in the array)

if [ "$lastElementInTheArray" -ge "$totalFilesToKeep" ];
    then
        for ((arrayValue=0; arrayValue<=$redundantElementsInTheArray; arrayValue++))
            do
                /bin/rm -f "${backupFileList[$arrayValue]}"
                printf "${backupFileList[$arrayValue]} - file deleted"
                printf "\n"
            done
    else
        printf "There are 5 or less backup files in this directory.  No files will be removed"
        printf "\n"
    fi
printf "\n"
printf "****************************************"
backupEndTime=$(date +%Y-%m-%d_%H-%M-%S)
printf "\n"
printf "Backup finished at: $backupEndTime"
printf "\n"
printf "****************************************"
printf "\n"
