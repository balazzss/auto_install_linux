#!/bin/bash
ROUTER=$(route -n | sed -nr 's/(0\.0\.0\.0) +([^ ]+) +\1.*/\2/p')
GOOGLE_DNS="8.8.8.8"
GOOGLE="google.com"
CLOUDFLARE="1.1.1.1"
FILE=ping_errors.txt
COMPLETE_FILE=ping_ALL.txt

echo "The router IP is : !!!!! $ROUTER !!!!!!"
touch $FILE
touch $COMPLETE_FILE
while true;
do
    DATE=$(date '+%d/%m/%Y %H:%M:%S')
    ping -c 1 $GOOGLE_DNS &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "ERROR "$DATE
        echo "ERROR "$DATE >> $FILE
        echo "ERROR "$DATE >> $COMPLETE_FILE
    else
        echo "OK "$DATE
        echo "OK "$DATE >> $COMPLETE_FILE
    fi
        sleep 1
done
