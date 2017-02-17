#!/bin/sh
# 20140829 add option -nolog

dir="/usr/local/monitor-base"
infolog="$dir/log/dmidecode.log"
uname -n > $infolog
/usr/sbin/dmidecode --type 1, 27 >> $infolog
echo "" >> $infolog
echo "free" >> $infolog
free >> $infolog
echo "" >> $infolog
echo "df  -h" >> $infolog
df  -h >> $infolog
echo "" >> $infolog
echo "disk info" >> $infolog
$dir/bin/MegaCli -PDList -aALL -nolog >> $infolog
