#!/bin/bash
#
# check if the livrary is loaded and add it if not
#
if grep -xq "include /usr/lib/frr" /etc/ld.so.conf;
    then
        printf "\nAlready there\n\n"
    else
        echo include /usr/lib/frr >> /etc/ld.so.conf
        printf "\nWasnt there added it\n\n"
        #ldconfig
fi
