#!/bin/bash
#check if memory total changed
dir="/usr/local/monitor-base"
mem_total="$dir/log/mem.fix"

#check if mem_total exsit
if [ ! -f "$mem_total" ];then
        free -m | awk '/Mem:/{print$2}' > $mem_total
fi

#check value
current=`free -m | awk '/Mem:/{print$2}'`
echo "Current memory total:$current"
previous=`cat $mem_total`
echo "Previous memory total:$previous"

if [ $current -ne $previous ] ; then
        $dir/bin/alarm.sh "$HOSTNAME memory alarm" "Previous memory total:$previous\nCurrent memory total:$current" "$HOSTNAME"
fi
