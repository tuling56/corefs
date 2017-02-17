#!/bin/bash
# 20140828 disk num not include FAILED, eth upload
if [ $# -ne 1 ] ; then
    echo "usage: $0 <host>"
    exit 1
fi

dir="/usr/local/monitor-base"
nu="/dev/null"
out="$dir/conf/on.cmd"

center=`$dir/bin/getcmd.sh center 1`
if [ "$center" == "" ]
then
    exit 1
fi

host=$1
sz=`$dir/bin/getflowload 10`
echo "" > $out

#########################################################
# packets error drop overrun, 20130625
packlog="$dir/log/pack.log"

function get_stat() {
    rx_info=`/sbin/ifconfig $1 | grep "RX packets"`
    tx_info=`/sbin/ifconfig $1 | grep "TX packets"`
    rx_err=`echo $rx_info | awk '{print$3}' | cut -d':' -f2`
    rx_drop=`echo $rx_info | awk '{print$4}' | cut -d':' -f2`
    rx_over=`echo $rx_info | awk '{print$5}' | cut -d':' -f2`
    tx_err=`echo $tx_info | awk '{print$3}' | cut -d':' -f2`
    tx_drop=`echo $tx_info | awk '{print$4}' | cut -d':' -f2`
    tx_over=`echo $tx_info | awk '{print$5}' | cut -d':' -f2`
}

if [ ! -f $packlog ];then
    /sbin/ifconfig | grep -wE 'eth[0-9] |em[1-9] ' | cut -d' ' -f1 | while read int;do
        get_stat $int
        echo "$int $rx_err $rx_drop $rx_over $tx_err $tx_drop $tx_over" >> $packlog
    done

else
    while read int old_rx_err old_rx_drop old_rx_over old_tx_err old_tx_drop old_tx_over;do
        get_stat $int
        rx_err_inc=$(($rx_err-$old_rx_err))
        rx_drop_inc=$(($rx_drop-$old_rx_drop))
        rx_over_inc=$(($rx_over-$old_rx_over))
        tx_err_inc=$(($tx_err-$old_tx_err))
        tx_drop_inc=$(($tx_drop-$old_tx_drop))
        tx_over_inc=$(($tx_over-$old_tx_over))
        pack="$pack$int:r:${rx_err_inc},${rx_drop_inc},${rx_over_inc},t:${tx_err_inc},${tx_drop_inc},${tx_over_inc};"
        sed -i "/$int/c$int $rx_err $rx_drop $rx_over $tx_err $tx_drop $tx_over" $packlog
    done < $packlog
fi

#########################################################
# serial, 20130821
seri=`/usr/sbin/dmidecode --type 1, 27 | grep "Serial Number" | awk '{print $3}'`
# memory size(with esx support), 20130820
ostype=`uname -r | grep ESX >/dev/null && echo esx || echo linux`
mem=`[ "$ostype" == "esx" ] && /usr/sbin/esxcfg-info -w | grep "Physical Memory" | awk -F[.\ ] '{print $(NF-1)}' || free | awk '/Mem/{print$2}'`

#########################################################
## disk num and size check, 20130822
disklog="$dir/log/check_disk_num.log"
disknum="$dir/bin/check_disk/check_disk_num.fix"
fhour=`date +%H`
# first disklog
if ! grep "id" $disklog;then  
    echo "FLAG-HOUR:$fhour" > $disklog
    $dir/bin/check_disk/check_phy_disk.sh >> $disklog
fi
# first disknum
[ ! -f $disknum ] && cat $disklog | egrep -v 'ctrl|FLAG-HOUR|critical_num' | wc -l >$disknum
# check disk per hour
if [ "FLAG-HOUR:$fhour" != "`cat $disklog | grep FLAG-HOUR`" ];then
    echo "FLAG-HOUR:$fhour" > $disklog
    $dir/bin/check_disk/check_phy_disk.sh >> $disklog
fi
# detect disk num change
cur_num=`cat $disklog | egrep -v 'Failed|ctrl|FLAG-HOUR|critical_num' | wc -l`
old_num=`cat $disknum`
critical_num=`awk -F: '/critical_num/{print$2}' $disklog`
critical_num=${critical_num:=0}
[ $cur_num -ne $old_num -o $critical_num -ne 0 ] && failed="!" || failed="="
ph=`echo -n $failed;cat $disklog | egrep -v 'ctrl|FLAG-HOUR|critical_num|Failed' | awk '{print$NF}' | sort | uniq -c | sed -r -e 's/\s+//' -e 's/\s+/\*/' | tr '\n' '+' | sed 's/+$//'`
raid=`cat $disklog | awk -F: '/id/ {print$NF}'`

#########################################################
## check logical disk free and rw, 20130823
ud=`df -kP | awk '{if($1 ~ "cciss" && $6 !~ "/boot|/var/log"){DISK=substr($1,match($1,"0d")+2)}else if($1 ~ "dev" && $6 !~ "/boot|/var/log"){DISK=substr($1,8)}else{next};USED=substr($5,0,match($5,"%")-1);if(system("touch " $6"/check_disk.log &>/dev/null")==1){ERR="!"}else{ERR=":"};if($4 <= 2048*1024){ERR="!"};printf("%s%c%d,",DISK,ERR,USED)}'`
# check inodes
ui=`df -ikP | awk '$1 ~ "dev" {iUSED=substr($5,0,match($5,"%")-1);if(iUSED>95){if($1 ~ "cciss"){DISK=substr($1,match($1,"0d")+2)}else{DISK=substr($1,8)};printf("%s!i%d,",DISK,iUSED)}}'`
# check_badblock, 20130913
badblock=`cat $dir/log/fs_kern.log  | awk '{if($2 ~ "cciss"){DISK=substr($2,match($2,"0d")+2)}else{DISK=substr($2,3)};{printf("%s:|",DISK)}}' | sed 's/|$//'`
# check_smart, 20130917
log_hour=`awk -F: '/FLAG-HOUR/{print$2}' $dir/log/smart.log`
log_hour=${log_hour:=0}
cur_hour=`date +%H`
if [ "$log_hour" != "$cur_hour" ];then
    echo "FLAG-HOUR:`date +%H`" >$dir/log/smart.log
    mnt_dev=(`df -kP | awk '/\/dev\/sd/{print substr($1,0,8)}' | sort | uniq`)
    for i in ${mnt_dev[@]};do
        /usr/sbin/smartctl -H $i >/dev/null
        smartstat=$(($? & 8))
        [ $smartstat -ne 0 ] && \
        echo -e "\033[31;1m${i:5:3} smart FAILED!\033[0m" && \
        echo "${i:5:3}" >>$dir/log/smart.log
    done
fi
smartfailed=`grep -v 'FLAG-HOUR' $dir/log/smart.log | awk '{DISK=substr($1,3)}{printf("%s[1-9]:|",DISK)}' | sed 's/|$//'`
# generate formated lg param
# identifier as follow
# ! => mount point r/w fail
# - => pd smart fail
# * => dmesg detect filesystem error
# : => all OK
OLD_IFS=$IFS
IFS=,
ud_array=($ud)
IFS=$OLD_IFS
for i in ${ud_array[@]};do
    if [ ! -z "$smartfailed" ] && echo "$i" | egrep "$smartfailed" >/dev/null;then
        udx="$udx,`echo "$i" | tr ':' '-'`"
    elif [ ! -z "$badblock" ] && echo "$i" | egrep "$badblock" >/dev/null;then
        udx="$udx,`echo "$i" | tr ':' '*'`"
    else
        udx="$udx,$i"
    fi
done
lg="${udx:1}$ui"

#########################################################
#check_eth 20140828
ethconf="$dir/log/eth.log"
function search_eth(){
    echo "DAY:`date +%d`" > $ethconf
    /sbin/ifconfig |grep Ethernet |grep -E '^eth|^em|^vmnic' |awk '$1 !~ ":"{print $1}' >> $ethconf 
}
if [ ! -f "$ethconf" ];then
    search_eth
else
    old_day=`cat $ethconf |grep DAY|cut -d':' -f2`
    now_day=`date +%d`
    if [ $now_day -ne $old_day ];then
        search_eth
    fi
fi

nc=""
for ethn in `cat $ethconf |grep -v DAY`
do
   ethn_log="$dir/log/$ethn.log"
   /sbin/ethtool $ethn &> $ethn_log
   s=`cat $ethn_log |grep 'No data available'|wc -l`
   if [ $s -eq 1 ];then
        nc="$nc""$ethn""?,"
        search_eth
        continue
    fi 
  
    LINK=`awk '/Link detected/{print $3}' $ethn_log`
    if [ "$LINK" == "no" ];then
        nc="$nc""$ethn""!,"
        continue
    fi

    SPEED=`awk '/Speed/{print substr($2,0,match($2,"Mb")-1)}' $ethn_log`
    nc="$nc""$ethn"":""$SPEED,"
done

#########################################################
param="host=$host&seri=$seri&$sz&pack=$pack&mem=$mem&raid=$raid&ph$ph&lg=$lg&nc=$nc"

if [ "$center" == "on.cc.sandai.net" ]
then
    wget -o $nu -O $out "http://on.cc.sandai.net/ontime/on_time?$param"
else
    
    wget -e httpproxy=$center -o $nu -O $out "http://on.cc.sandai.net/ontime/on_time?$param"
fi

# time alarm, 20130529
local_time=`stat $dir/conf/on.cmd -c %Z`
center_time=`cat $dir/conf/on.cmd | grep OK | awk '{print$3}'`
offset=`expr ${local_time} - ${center_time}`
[ `cat $dir/conf/on.cmd | grep OK | awk '{print NF}'` -eq 3 ] && [ ${offset#-} -ge 60 ] && $dir/bin/alarm.sh "$host time alarm" "time offset = ${offset} seconds" $host

command()
{
    sz=`echo "$1" | grep conf| wc -l`
    if [ $sz -lt 1 ]
    then
        return
    fi

    if [ ! -f $dir/conf/on.conf ]
    then
        echo "$1" > $dir/conf/on.conf
        return
    fi

    sz=`echo "$1" | awk '{print$2}'`
    old=`cat $dir/conf/on.conf | grep "$sz" | wc -l`
    if [ $old -gt 0 ]
    then
        sed -i "/$sz/d" $dir/conf/on.conf
    fi
    echo "$1" >> $dir/conf/on.conf
    return
}

while read LINE
do
    command "$LINE"
done < $out
