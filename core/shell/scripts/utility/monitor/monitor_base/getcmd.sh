#!/bin/bash
if [ $# -ne 2 ] ; then
    echo "usage: $0 <cmd> <number parameter>"
    exit 1
fi

cmd=$1
num=$2

dir="/usr/local/monitor-base"

sz=""

if [ -f "$dir/conf/on.cmd" ]
then
    if [ $num -eq 2 ]
    then
        sz=`cat $dir/conf/on.cmd | grep "$cmd" | awk '{print $3,$4}'`
    else
        sz=`cat $dir/conf/on.cmd | grep "$cmd" | awk '{print $3}'`
    fi
fi

if [ "$sz" != "" ]
then
    echo "$sz"
    exit
fi

if [ -f "$dir/conf/on.conf" ]
then
    if [ $num -eq 2 ]
    then
        sz=`cat $dir/conf/on.conf | grep "$cmd" | awk '{print $3,$4}'`
    else
        sz=`cat $dir/conf/on.conf | grep "$cmd" | awk '{print $3}'`
    fi
fi

if [ "$sz" != "" ]
then
    echo "$sz"
    exit
fi
