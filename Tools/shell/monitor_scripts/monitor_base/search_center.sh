#!/bin/bash

dir="/usr/local/monitor-base"
log="$dir/log/center.log"



command()
{
    sz=`echo "$1" | grep conf| wc -l`
    if [ $sz -lt 1 ]
    then
        return
    fi
    if [ ! -f $dir/conf/on.conf ]
    then
        echo "$1" > $dir/conf/on.conf
        return
    fi
    sz=`echo "$1" | awk '{print$2}'`
    old=`cat $dir/conf/on.conf | grep "$sz" | wc -l`
    if [ $old -gt 0 ]
    then
        sed -i "/$sz/d" $dir/conf/on.conf
    fi
    echo "$1" >> $dir/conf/on.conf
    return
}

cmd="conf:  rsync     up.cc.sandai.net"
command "$cmd"
cmd="conf:  center      on.cc.sandai.net"
command "$cmd"
