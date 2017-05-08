#!/bin/bash
cd `dirname $0`
set -x 
set -e 

free_mem=$(free -m | grep "buffers/cache" | awk '{print $4}')
load_5min=$(cat /proc/loadavg | awk '{print $2}')
cpu_idle=$(sar 1 5 | grep -i 'Average' | awk '{print $NF}')
# tx_speed=$(sar -n DEV 10 5 | grep "Average" | grep "$interface" | awk '{print $6}')  #$interface没有定义
httpd_status=$(ps -ef | grep 'httpd' | grep -v 'grep')
host=`hostname`

# 结果输出
echo "{'hostname':"$host",'freemem':"$free_mem",'load':"$load_5min",'cpuidle':"$cpu_idle",'txspeed':"$tx_speed",'httpstatus':"$httpd_status"}"
