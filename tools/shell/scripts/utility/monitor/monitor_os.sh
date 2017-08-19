#!/bin/bash
free_mem=$(free -m | grep "buffers/cache" | awk '{print $4}')
load_5min=$(cat /proc/loadavg | awk '{print $2}')
cpu_idle=$(sar 1 5 | grep -i 'Average' | awk '{print $NF}')
tx_speed=$(sar -n DEV 10 5 | grep "Average" | grep "$interface" | awk '{print $6}')
httpd_status=$(ps -ef | grep 'httpd' | grep -v 'grep')
header="{";
name="'hostname':'"
host=`hostname`
end="'}"
echo "{'hostname':'"$host"','freemem':"$free_mem",'load':"$load_5min",'cpuidle':"$cpu_idle",'txspeed':"$tx_speed",'httpstatus':'"$httpd_status"'}"