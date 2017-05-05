#!/bin/bash
#
# test using sed to add a new line to the end of a file if it does not already exist
#
if grep -q "include /usr/lib/frr" "/etc/ld.so.conf"; then
    echo sed '$ a include /usr/lib/frr' /etc/ld.so.conf
    printf "The /usr/lib/frr library directory has been added to: /etc/ld.so.conf ===\n"
    echo ldconfig
else
    printf "The /usr/lib/frr library directory is already present in the /etc/ld.so.conf file\n"
fi
