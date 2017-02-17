#!/bin/sh

PATH="/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin"

DATE=`date`

file="/usr/local/monitor-base/log/gw.log"

if [ ! -f "$file" ];then
    touch $file
fi

sz=`cat $file|grep at|wc -l`
if [ $sz -gt 0 ];then
    exit 0
fi

ug=`route -n | grep "UG" | wc -l`
if [ $ug -eq 0 ];then
   exit 0
fi


dest_tel="202.96.128.86"
dest_cnc="202.96.64.68"

tel_sz=`ip route get $dest_tel` 
cnc_sz=`ip route get $dest_cnc`

tel_gw=`echo $tel_sz | grep $dest_tel | awk '{print $3}'`
cnc_gw=`echo $cnc_sz | grep $dest_cnc | awk '{print $3}'`

if [ "$tel_gw" = "$cnc_gw" ];then
   list_gw="$tel_gw"
else
   list_gw="$tel_gw $cnc_gw"
fi


num=1

for i in $list_gw
do
   mac=`arp -n $i |grep ether| awk '{print $3}'`
   echo "$i  $mac at-$num" >> $file
   num=`expr $num + 1`
done
