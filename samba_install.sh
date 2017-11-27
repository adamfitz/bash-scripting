#!/bin/bash
#
# Author: Adam Fitzgerald
# Purpose: Script to install and configure samba share on Centos 7 with
# user authentication.
# Version: 0.1
#
# Usage:
# ======
# samba_install <samba username> <shared directory>
#
# This i
# Script will check if the given samba username already exists and use this to setup authentication on the given samba share
# if the given samba username does not exist then the script will create teh user and prompt for a password to set for the user and also set this given password as access to the samba share
#

function stop_and_wait()
    {
        read -p "$*"
    }

function install_samba()
    {
        package_1="samba-client"
        package_2="samba-common"
        # check if package_1 is installed and if yes check if package_2 is installed
        if yum list installed $package_1;
            then
                printf :"$package_1 is already installed skipping..."
                if yum list installed $package_2;
                    then
                        printf :"$package_1 is already installed skipping..."
                        return 1
                #if package_1 is installed but no package_2, install package_2
                else
                    printf :"Installing $package_2 ..."
                    yum -y install $package_2
        # if neither package is installed, install them both
        else
        printf "Installing Samba..."
        yum -y install samba samba-client samba-common
    }
