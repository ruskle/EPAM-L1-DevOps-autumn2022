#!/bin/bash

logtime(){
   time="$(date +"%y-%m-%d %T") $@"
   echo -n $time >>$LOGFILE
}

LOGFILE=$2.log/task3log
ls $1 | while read i
do
    if [ -e "$2/$i" ]
    then 
        if [ `stat -c %Y $1/$i` -gt `stat -c %Y $2/$i` ] 
        then
            # replace old file
            cp -f $1$i $2
            logtime
            echo " $i // replace old file " >> $LOGFILE
        fi
    else
        # copy new file
        cp -f $1$i $2
        logtime
        echo " $i // copy new file" >> $LOGFILE
    fi
done

ls $2 | while read i  
do
    if [ ! -e "$1/$i" ]
    then
        # remove deleted file
        rm $2$i
        logtime
        echo " $i // remove deleted file" >> $LOGFILE
    fi
done