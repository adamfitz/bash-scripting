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
    printf "Help:"
    printf "\n"
    printf "====="
    printf "\n"
    printf "subnetCheck.sh -h (prints this help screen)"
    printf "\n"
    printf "\n"
    printf "Usage:"
    printf "\n"
    printf "subnetCheck.sh <ip address>"
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
# Need to add validation to check the first octect does not start with a zero
validateIpAddress()
{
    if [[ $prefix =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; 
        then
            return 0
        else
            printf "\n"
            printf "Invalid IP address, please enter a valid IP address"
            printf "\n"
            printf "\n"
            exit 1
    fi
}   


findAndPrintDNSRecords()
{
    # remove all characters after the last dot in the IP addres and assign to new variables
    subnetIp="${prefix%.*}"

    printf "Checking $subnetIp.0/24 for any DNS records with a suffix of .com .net .org .edu or .gov"
    printf "\n"
    printf "\n"

    # iterate though the subnet checking the DNS records
    for n in $(seq 1 254); 
        do iP=$subnetIp.${n}; 
            printf "${iP}\t$(dig -x ${iP} +short)" | grep 'com\|net\|org\|gov\|edu';
        done
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
        validateIpAddress
        operationStartTime=$(($(date +%s%N)/1000000))
        printf "\n"
        printf "\n"
        findAndPrintDNSRecords
        printf "\n"
        printf "\n"
        operationEndTime=$(($(date +%s%N)/1000000))
        operationElapsedTime=$(($operationEndTime - $operationStartTime))
        printf "Operation completed in $operationElapsedTime msec. " 
        printf "\n"
    fi
printf "\n"
printf "\n"
