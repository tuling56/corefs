#!/bin/bash
# 20140829 add option -nolog

if [ $# -ne 1 ] ; then
    echo "usage: $0 <host>"
    exit 1
fi

host=$1
dir="/usr/local/monitor-base"
[ `arch` == "x86_64" ] && diskutil="/opt/MegaRAID/MegaCli/MegaCli64" || diskutil="/opt/MegaRAID/MegaCli/MegaCli"
[ ! -f $diskutil ] && diskutil="$dir/bin/MegaCli"
disklog="$dir/log/disk_num.log"
if [ ! -f "$disklog" ];then
    echo "create disk log file."
    $diskutil -PDList -aALL -nolog> $disklog
fi
disknum=`cat $disklog | grep "Slot Number" | wc -l`
echo "disknum=$disknum"


log="$dir/log/check_disk_info.log"
fhour=`date +%H`

flag=`cat $log | grep FLAG-HOUR`

if [ "FLAG-HOUR:$fhour" == "$flag" ]
then
   echo "nop."
else
   $diskutil -PDList -aALL -nolog > $log
   echo "FLAG-HOUR:$fhour" >> $log
fi




num=`cat $log | grep "Slot Number" | wc -l`

#echo "$num"

if [ $num -ne $disknum ]
then
    sz="RAID CRITICAL - raid disk number check error."
    $dir/bin/alarm.sh "$host raid alarm"  "$sz" $host
    exit 1
fi
 
num=`cat $log | grep "Firmware state:" | grep -E 'Hotspare|Online|JBOD' | wc -l`
if [ $num -ne $disknum ]
then
    sz="RAID CRITICAL - raid disk Firmware state check error."
    $dir/bin/alarm.sh "$host raid alarm"  "$sz" $host
    exit 1
fi
  
#num=`cat $log | grep "Media Error Count: 0" | wc -l`
#if [ $num -ne $disknum ]
#then
#    sz="RAID CRITICAL - raid disk check error Count."
#    $dir/bin/alarm.sh "$host raid alarm"  "$sz" $host
#    exit 1
#fi

#num=`cat $log | grep "Other Error Count: 0" | wc -l`
#if [ $num -ne $disknum ]
#then
#    sz="RAID CRITICAL - raid disk check error Count."
#    $dir/bin/alarm.sh "$host raid alarm"  "$sz" $host
#    exit 1
#fi
