#!/bin/bash

PATH="/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin"

if [ $# -ne 1 ] ; then
    echo "usage: $0 <host>"
    exit 1
fi

host=$1

dir="/usr/local/monitor-base"

num=`cat $dir/log/gw.log | wc -l`

if [ $num -lt 1 ] ; then
    exit 1
fi

for i in `seq $num`
do
  gw_mac=`cat $dir/log/gw.log | grep at-${i}`
 
  #echo "$gw_mac"
 
  gw=`echo $gw_mac | awk '{print $1}'`
  mac=`echo $gw_mac | awk '{print $2}'`

  #echo "$gw"
  #echo "$mac"

  ping -c 1 $gw > /dev/null 2>&1

  sz=`arp -n $gw | grep -i $mac | wc -l`
  if [ $sz -eq 0 ]
  then
    sz=`arp -n $gw | grep $gw | awk '{print $3}'`
    $dir/bin/alarm.sh "$host arp alarm" "true [$gw - $mac]  false [$gw - $sz]" $host
  fi
done
