#!/bin/bash
# check filesystem badblock
# 20130913
dir='/usr/local/monitor-base'
fserr_old="$dir/log/fs_kern.log"
fserr_new="$dir/log/fserr.new"
err_str='EXT[34]-fs error \(device '

# 1.take bad pds found in dmesg to newlog
dmesg | egrep -i "$err_str" | uniq | tr -d '):|,' | awk '{for(i=1;i<=NF;i++) if($i~"sd[a-z]" || $i~"c0d[0-9]") {print$i}}' | sort | uniq > $fserr_new

# 2.check new log per line 
# pd failed exist in old log -> echo to old log, then continue loop
# pd failed not exist in old log -> echo to old log, then alarm
[ ! -f $fserr_old ] && touch $fserr_old
#message=
while read pd
do
        match_num=`cat $fserr_old | grep "$pd" | wc -l`
        if [ $match_num -gt 0 ];then
                continue
        else
                echo "$(date +%s) $pd" >> $fserr_old
                #message="$message $pd"
        fi
done < $fserr_new
#[ "x" != "x$message" ] && $dir/bin/alarm.sh "$HOSTNAME filesystem alarm" "$message I/O error" $HOSTNAME

# 3.clean record in fserr_old over than 24 hours
while read timestamp pd
do      
        [ -z $timestamp ] && continue
        [ $((`date +%s`-$timestamp)) -gt 86400 ] && sed -i "/$timestamp/d" $fserr_old
done < $fserr_old
