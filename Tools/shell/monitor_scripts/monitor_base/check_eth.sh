#!/bin/bash
#modify by 20130712
if [ $# -ne 1 ]
then
    echo "Usage: $0 hostname"
    exit 1
fi

host=$1
dir='/usr/local/monitor-base'
conf="$dir/log/eth.conf"

if [ ! -f "$conf" ]
then
    echo "create eth conf file"
    ifinfo=`/sbin/ifconfig | awk '/eth[0-9] /{print $1}'`
    if [ `echo $ifinfo | grep eth | wc -l` -gt 0 ] ;then
        echo "eth0 eth1" >$conf
	else
        echo "em1 em2" >$conf
    fi
fi

function check_ethn {
local ethn=$1
local SPEED=$2
ethn_log="$dir/log/$ethn.log"
/sbin/ethtool $ethn >$ethn_log
sz=`cat $ethn_log |grep 'No data available'|wc -l`
if [ $sz -eq 0 ]
then
    stat0=`cat $ethn_log |awk '/Link detected/ {print $3}'`
    echo "$ethn Link detected: $stat0"
    if [ "$stat0" != "yes" ]
    then
        sz="ETH WARNING - $host $ethn Link detected: $stat0"
        $dir/bin/alarm.sh "$host eth  alarm" "$sz" $host
    else
        speed0=`cat $ethn_log |awk '/Speed/ {print $2}'`
        echo "$ethn Speed: $speed0"
        if [ "$speed0" != "${SPEED}Mb/s" ]
        then
            sz="ETH WARNING - $host $ethn Speed: $speed0"
            $dir/bin/alarm.sh "$host eth  alarm" "$sz" $host
        fi
	duplex=`cat $ethn_log | awk '/Duplex:/ {print$2}'`
	echo "$ethn Duplex: $duplex"
	if [ x"$duplex" != x"Full" ]
	then
	    sz="ETH WARNING - $host $ethn Duplex: $duplex"
 	    $dir/bin/alarm.sh "$host eth  alarm" "$sz" $host
	fi
    fi
else
    sz="ETH WARNING - $host $ethn is not there"
    $dir/bin/alarm.sh "$host eth  alarm" "$sz" $host
    echo "$ethn is not there"
fi
}

for conf in `cat $conf`
do
	echo "$conf" | grep '=' || conf="$conf=1000"
	interface=`echo $conf | awk -F'=' '{print$1}'`
	speed=`echo $conf | awk -F'=' '{print$2}'`
    check_ethn $interface $speed
done

####################### check packets, errors, dropped,
iflog="$dir/log/if.log"
function check_ifconfig {
   pack=`echo "$2"|cut -d ":" -f2`
   err=`echo "$3"|cut -d ":" -f2` 
   dor=`echo "$4"|cut -d ":" -f2`
   
   if [ $pack -lt 1 ]; then
       return
   fi
   derr=`echo "$err*1000/$pack" |bc`
   dpor=`echo "$dor*1000/$pack" |bc`
   
   if [ $derr -gt 0 ]; then
       sz="IFCONFIG WARNING - $host ifconfig errors packet >=%0.1"
       $dir/bin/alarm.sh "$host ifconfig  alarm" "$sz" $host
   fi
   if [ $dpor -gt 1 ]; then
       sz="IFCONFIG WARNING - $host ifconfig dropped packet >=%0.2"
       $dir/bin/alarm.sh "$host ifconfig  alarm" "$sz" $host
   fi
}

#/sbin/ifconfig|grep packets > $iflog
#while read LINE
#do
    #check_ifconfig $LINE
#done < $iflog

################# check packets errors increasement ############
netdev_log="$dir/log/netdev.log"
check_packets_log="$dir/log/check_packets.log"
report_log="$dir/log/report.log"

get_info()
{
        #squeeze eth em interface to each line,then get packet errors string
        /sbin/ifconfig | sed 's/^$/~/g' | tr -d '\n' | tr '~' '\n' | grep -wE 'eth[0-9] |em[1-9] ' | tr -s ' ' | awk '/errors/{for(i=1;i<=NF;i++) if($i~"error") {print $1,$(i-2),$i}}'
}

>$report_log
if [ -f $netdev_log ];then
        #get current errors to another log
        get_info > $check_packets_log
        while read line
        do
                increasement=0
                log_desc=`echo $line | awk '{print$1,$2}'`
                echo "log_desc=$log_desc"
                log_errors=`echo $line | awk '{print$3}' | cut -d: -f2`
                echo "log_errors=$log_errors"
                cur_errors=`cat $check_packets_log | grep "$log_desc" | awk '{print$3}' | cut -d: -f2`
                echo "cur_errors=$cur_errors"
                increasement=$(($cur_errors-$log_errors))
                [ $increasement -gt 0 ] && echo "$log_desc 5min new add errors $increasement" >> $report_log
        done < $netdev_log
        #if the size of message file greater than zero,then alarm and update the log file 
        [ -s $report_log ] && $dir/bin/alarm.sh "$host packets alarm" "`cat $report_log`" "$host"
        cat $check_packets_log > $netdev_log
else
        #first run write a log
        get_info > $netdev_log
fi
