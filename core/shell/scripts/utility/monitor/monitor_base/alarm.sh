#!/bin/bash

if [ $# -ne 3 ] ; then
    echo "usage: $0 <obj> <content> <host>"
    exit 1
fi

obj=$1
con=$2
host=$3

dir="/usr/local/monitor-base"
type=`$dir/bin/getcmd.sh send_alarm 1`

sz="$con. from $host"

cen=`$dir/bin/getcmd.sh center 1`
if [ "$cen" != "on.cc.sandai.net" ];then
    type="web"
fi

if [ "$type" == "web" ];then
    upcen=`$dir/bin/getcmd.sh center 1`
    if [ "$upcen" != "" ];then
        url="http://on.cc.sandai.net/alarm/alarm?title=$obj&content=$sz"
        wget -e httpproxy=$upcen "$url" -O /dev/null -o /dev/null
        exit 1
    fi
fi

$dir/bin/sendEmail -s mail.cc.sandai.net  -f monitor@cc.sandai.net  -t alarm@cc.sandai.net  -xu monitor@cc.sandai.net  -xp 121212   -u "$obj" -m "$sz"
