#!/bin/bash
#
# Author: Adam Fitzgerald
# Purpose: Script to iterate though a /8, /16 or /24 and output any A records within that subnet
# Version: 0.1

prefix=$1
subnetMask=$2

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
    printf "subnetCheck.sh <ip prefix> <subnet mask>"
    printf "\n"
    printf "\n"
    printf "Example:"
    printf "\n"
    printf "subnetCheck.sh 192.168.0.0 255.255.255.0"
    printf "\n"
    printf "\n"
    printf "Requirements:"
    printf "\n"
    printf "IP prefix and subnet mask are required for operation."
    printf "\n"
    printf "Only classful subnets are supported /8, /16 and /24 (A, B and C)"
}

# Function to check for correct ip address format (ipv4, four  octects and all octects are between 0 and 255)


#Function to check classfull subnet mask is supplied
checkSubnetMask()
{
    if ("$subnetMask" != "255.255.255.0" || "255.255.0.0" || "255.0.0.0");
        then
            printf "Invalid subnet mask supplied!"
            printf "\n"
            printf "\n"
            printf "Subnet mask must be one of the following:"
            printf "\n"
            printf "\n"
            printf "255.0.0.0 - Class A"
            printf "\n"
            printf "255.255.0.0 - Class B"
            printf "\n"
            printf "255.255.255.0 - Class C"
            printf "\n"
        else
            kill -INT $$ #exit the fuction/script and drop back to the shell prompt
    fi
}

#
# First check if arguments are passed to the script and if not print out the help/usage syntax:
#   - Check if either ip address or subnet mask have not been supplied
#   - Check if -h (help) flag has been specified
#   - If either of the above conditions are met, print out the script usage/help

if ([ -z "$prefix" ] || [ -z "$subnetMask" ]); 
    then
        subnetCheckUsage
    elif [ "$prefix" == "-h" ];
        then
            subnetCheckUsage
    else
        printf "\n"
        printf "Put the for loop to check the subnet"
        printf "\n"
    fi
printf "\n"
printf "\n"


