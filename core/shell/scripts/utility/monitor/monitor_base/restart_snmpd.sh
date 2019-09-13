#!/bin/bash

h=`date +%H`
if [ $h -gt 0 ];then
   exit
fi

day=`date +%d`

logfile="/usr/local/monitor-base/log/snmpdata.log"

if [ -n $logfile ]
then
    touch $logfile
fi

sz=`cat $logfile | grep $day | wc -l`

if [ $sz -lt 1 ]
then
    snmpd_conf="/usr/local/snmpd/snmpd.conf"
    if [ ! -f "$snmpd_conf" ]
    then
        snmpd_conf="/etc/snmp/snmpd.conf"
    fi
    killall snmpd
    sleep 3
    /usr/local/snmpd/sbin/snmpd -c $snmpd_conf  -p /usr/local/monitor-base/log/snmpd.pid
    echo "$day" > $logfile
fi
