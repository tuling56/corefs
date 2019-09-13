#!/bin/bash
# 20140828 cancel getlog
# 20140829 upload disk.deny
if [ $# -ne 1 ] ; then
    echo "usage: $0 <host>"
    exit 1
fi

export LANG=en 
host=$1
[ `date +%H` -ne 5 ] && exit 1
m=`date +%b`
d=`date +%d`
day=`date +%Y%m%d`
dir="/usr/local/monitor-base"
sec="$dir/log/secure.$day"
msg="$dir/log/messages.$day"
log="$dir/log/day.log"
info="$dir/log/info.$day"
ipinfo="$dir/log/ipconf.log"
diskinfo="$dir/log/disk.log"
diminfo="$dir/log/dmidecode.log"
iptableslog="$dir/log/iptables.log"
netstatinfo="$dir/log/netstatinfo.log"
netstatsinfo="$dir/log/netstatsinfo.log"
ifconfiginfo="$dir/log/ifconfiginfo.log"
hwinfo="$dir/log/hwinfo-$(/usr/sbin/dmidecode --type 1, 27 | grep 'Serial Number' | awk '{print $3}').log"
diskdeny="$dir/log/disk.deny"

if [ $d -lt 10 ]
then
   sz="$m `echo "$d" | sed 's/0/ /'`"
else
   sz="$m $d"
fi

##############################################
if [ ! -f "$log" ]
then
    echo "$sz" > $log
    exit
fi
old=`cat $log`
if [ "$sz" == "$old" ]
then
    exit 1
fi

####################################################
rm -rf $dir/log/secure.* 
rm -rf $dir/log/messages.*
rm -rf $dir/log/info.*
 
echo "$sz" > $dir/log/day.log
/sbin/iptables -nvL > $iptableslog
#cat /var/log/secure | grep "$old" | grep -v "refused connect" > $sec
#cat /var/log/messages | grep "$old" |grep -v snmpd |grep -v kernel > $msg
#$dir/bin/getlog $sec $host > $info
#$dir/bin/getlog $msg $host >> $info
$dir/bin/getipconf.sh 
$dir/bin/get_device_info.sh

#######################disk and mem log ########################333
df -h > $diskinfo
df -i >> $diskinfo
echo "free ---------------" >> $diskinfo
free >> $diskinfo
#########################################################
netstat -nlp > $netstatinfo
netstat -s > $netstatsinfo
/sbin/ifconfig > $ifconfiginfo
uname -a > $hwinfo
/usr/sbin/dmidecode --type 1, 27 >> $hwinfo
/usr/sbin/lshw -short >> $hwinfo
$dir/bin/check_disk/check_phy_disk.sh all
cat $dir/log/raid_all.log >> $hwinfo

###################### upload #########################################
center=`$dir/bin/getcmd.sh center 1`
if [ "$center" != "on.cc.sandai.net" ];then
    proxy_str="-e httpproxy=$center"
fi
#for i in $info $ipinfo $diminfo $diskinfo $iptableslog $netstatinfo $netstatsinfo $ifconfiginfo $hwinfo;do
for i in $ipinfo $diminfo $diskinfo $iptableslog $netstatinfo $netstatsinfo $ifconfiginfo $hwinfo $diskdeny;do
    filename=`echo $i | awk -F'/' '{print$NF}'`
    wget $proxy_str -o /dev/null -O /dev/null "http://up.cc.sandai.net/file.php?host=$host&filename=$filename" --post-file=$dir/log/$filename --header=ACCEPT-CHARSET:gzip
done 
