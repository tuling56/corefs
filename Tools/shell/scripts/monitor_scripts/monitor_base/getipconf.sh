#!/bin/bash
PWD='/usr/local/monitor-base'
LOG="$PWD/log/ipconf.log"

uname -a > $LOG
cat /etc/issue >>$LOG
#/sbin/ifconfig |awk '/HWaddr/ {mac=$5} /inet / && mac != 0 {print mac,$2;mac=0}'|sed 's/addr:/ /g' >>$LOG
/sbin/ifconfig |awk '/eth/ {print $1} /HWaddr/ {mac=$5} /inet / && mac != 0 {print mac,$2;mac=0}'|sed 's/addr:/ /g' >> $LOG
