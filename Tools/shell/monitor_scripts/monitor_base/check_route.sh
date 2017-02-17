#!/bin/sh
if [ $# -ne 1 ] ; then
    echo "usage: $0 <host>"
    exit 1
fi

host=$1
dir="/usr/local/monitor-base"
pre_host=${host:0:2}
if [ "$pre_host" != "tw" ]; then
  exit 0
fi

dest_tel="202.96.128.86"
dest_cnc="202.96.64.68"

tel_sz=`/sbin/ip route get $dest_tel` 
cnc_sz=`/sbin/ip route get $dest_cnc`

tel_gw=`echo $tel_sz | grep $dest_tel | awk '{print $3}'`
cnc_gw=`echo $cnc_sz | grep $dest_cnc | awk '{print $3}'`

echo $tel_gw
echo $cnc_gw

if [ "$tel_gw" != "$cnc_gw" ]; then
  echo "OK"
else
  echo "error"
  sz="$host same tel traceroute:$dest_tel->$tel_gw, cnc traceroute:$dest_cnc->$cnc_gw."
  $dir/bin/alarm.sh "$host route  alarm"  "$sz" "$host"
fi
