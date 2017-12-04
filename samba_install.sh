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
#
# Script will check if the given samba username already exists and use this to setup authentication on the given samba share
# if the given samba username does not exist then the script will create teh user and prompt for a password to set for the user and also set this given password as access to the samba share
#

function stop_and_wait()
    {
        read -p "$*"
    }

# install samba
printf"\n"
printf "Installing Samba...\n"
yum -y install samba samba-client samba-common

# create a user account and set the password
printf "Creating user account - shareuser\n"
useradd shareuser
# set the new users password
printf "Please set the password for the shareuser:\n"
passwd shareuser
# create a group to allow share access
printf "Creating group datashare...\n"
groupadd shareuser
# add the user account to the group share acces group
printf"\n"
printf "Adding shareuser account to the datashare group...\n"
usermod -aG datashare shareuser
printf"\n"

# setup the samba configuration

# Once this is working, automate writing the smb.conf file based on the input from the user

#[movies]
    #comment = Movies
    #writable = yes
    #browsable = yes # test this and perhaps remove
    #valid users = @datashare
    #path = /mnt/storage/movies
    #create mode = 0660
    #directory mode = 0770

# make the above share directory
printf"\n"
printf "Create the directory to share...\n"
mkdir /mnt/storage/movies
printf"\n"

#change the owner group of the new directory to the data share group
printf"\n"
printf "Changing the owner group of the shared directory...\n"
chgrp datashare /mnt/storage/movies
printf"\n"

# set the directory mode on the new directory
printf"\n"
printf "Changing share directory permissions to 770...\n"
chmod 770 /mnt/storage/movies
printf"\n"
