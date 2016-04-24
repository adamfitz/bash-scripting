#!/bin/bash
#
# Author: Adam Fitzgerald
# Purpose: Script to iterate though all IPs in a /24 and output any A records within that subnet
# Version: 0.1

prefix=$1

#Function to supply script usage
subnetCheckUsage()
{
    printf "\n"
    printf "\n"
    printf "Help:"
    printf "\n"
    printf "subnetCheck.sh -h (prints this help screen)"
    printf "\n"
    printf "\n"
    printf "Usage:"
    printf "\n"
    printf "subnetCheck.sh <ip prefix>"
    printf "\n"
    printf "\n"
    printf "Example:"
    printf "\n"
    printf "subnetCheck.sh 192.168.0.0"
    printf "\n"
    printf "\n"
    printf "Requirements:"
    printf "\n"
    printf "Only /24 subnet is checked."
}

# Function to check for correct ip address format (ipv4, four octects and all octects are between 0 and 255)


findAndPrintDNSRecords()
{
    # remove all characters after the last dot in the IP addres and assign to new variables
    subnetIP="${prefix%.*}"

    printf "\n"
    printf "\n"
    printf "All A records in $subnetIP.0/24 are:"
    printf "\n"
    printf "\n"

    # iterate though the subnet checking the DNS records
    for n in $(seq 1 254); 
        do IP=$subnetIP.${n}; 
            echo -e "${IP}\t$(dig -x ${IP} +short)" | grep 'com\|net\|local\|org';
        done
    printf "\n"
    printf "\n"
    printf "Operation completed. " 
}

#
# First check if arguments are passed to the script and if not print out the help/usage syntax:
#   - Check if -h (help) flag has been specified

if [ -z "$prefix" ]; 
    then
        subnetCheckUsage
    elif [ "$prefix" == "-h" ];
        then
            subnetCheckUsage
    else
        operationtartTime=$(($(date +%s%N)/1000000))
        printf "\n"
        printf "\n"
        findAndPrintDNSRecords
        printf "\n"
        printf "\n"
        operationEndTime=$(($(date +%s%N)/1000000))
        operationElapsedTime=($operationStartTime - $operationEndTime)
        printf "Script run time $operationElapsedTime"
        printf "\n"
    fi
printf "\n"
printf "\n"
