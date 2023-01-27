#!/bin/bash

function mostrequests () {
    sort $LOGFILE > sort.txt
    IPREPEAT=0.0.0.0
    NUM=1
    NUMMAX=1
    while IFS= read -r line
    do
        IP=$( echo $line | awk '{print $1}' )
        if [[ $IP == $IPREPEAT ]]
        then
            NUM=$(( $NUM + 1 ))
        else
            if [[ $NUM -gt $NUMMAX ]]
            then
                NUMMAX=$NUM
                IPMAX=$IPREPEAT
                NUM=1
            else
                NUM=1
            fi
            IPREPEAT=$IP
        fi
    done < sort.txt
    rm -f sort.txt
    echo "Most requests from $IPMAX - $NUMMAX times"

}

function mostpage () {

    echo "Most requested pages"
    awk -F\" '{print $2}' $LOGFILE | awk '{print $2}' | sort | uniq -c | sort -rn | awk '(NR >= 1 && NR <=3)'
    echo "Requests from iach IP"
    awk '{print $1}' $LOGFILE | sort | uniq -c | sort -rn
    echo "Non-existent pages"
    awk '($9 ~ /404/)' $LOGFILE | awk '{print $7}' | sort | uniq -c | sort -rn
    echo "Most request time"
    awk '{print $4}' $LOGFILE | sort | uniq -c | sort -rn | awk '(NR >= 1 && NR <=3)'
    echo "Search bots"
    awk -F\" '{print $6}' $LOGFILE | grep bot | sort | uniq

}

LOGFILE=$1


mostrequests
mostpage


