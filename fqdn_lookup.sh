#! /bin/bash

while read ip; do
  hostname=`host $ip`
  if [ $? -eq 0 ]; then
    echo $hostname
  else
    echo "UNKNOWN"
  fi
done < ./hostlist
