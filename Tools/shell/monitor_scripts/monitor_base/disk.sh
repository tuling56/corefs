#!/bin/bash
# 20140829 fix deny bug: /data11 deny with /data1

if [ $# -ne 2 ]
then
    echo "Usage: $0  <5070>    <2>"
    exit
fi

size=$(($1*1024))
perc=$((100-$2))

DF=`df -kP`
DIR='/usr/local/monitor-base'
log_result="$DIR/log/result.log"
host=`hostname`

echo "$DF" > "$DIR/log/df.log" || $DIR/bin/alarm.sh "$host r/w file alarm" "FILERW CRITICAL - read write file $DIR/log/df.log failed." $host

## ignore file system listed in disk.deny ##
if [ -f "$DIR/log/disk.deny" ]
then
    for fs in `cat "$DIR/log/disk.deny"`
    do
        DF=`echo "$DF" |awk '$6 != "'"$fs"'" {print}'`
    done
fi
##

## check disk free space ##
sz1=`echo "$DF"|awk -F"[ \t%]+" ' ($6 ~ /^\// && $6 !~ /\/dev/) && ($4 <= 512*1024) {print "free space:",$6,$4/1024,"MB (" 100-$5 "% left)|total="$2/1024 "MB"}'`
 
sz2=`echo "$DF"|awk -F"[ \t%]+" ' ($6 ~ /^\// && $6 !~ /\/dev/) && ($4 <= 2048*1024) && ($4 >=512*1024) {print "free space:",$6,$4/1024,"MB (" 100-$5 "% left)|total="$2/1024 "MB"}'`
 
sz3=`echo "$DF"|awk -F"[ \t%]+" ' ($6 ~ /^\// && $6 !~ /\/dev/) && ($4 <= '$size' && $4 >= 2048*1024 && $5 >= '$perc') {print "free space:",$6,$4/1024,"MB (" 100-$5 "% left)|total="$2/1024 "MB"}'`
sz="$sz1$sz2$sz3"
if [ -n "$sz1" ]
then
    alarm="[CRITICAL!!]"
elif [ -n "$sz2" ]
then
    alarm="[ERROR!!]"
else
    alarm="[WARNNING!!]"
fi

#send alarm 
if [ -n "$sz" ]
then
    body=`echo "$sz1$sz2$sz3"|sed 's/^/DISK ALARM - /'`
    subj="$alarm $host disk alarm"
    echo "$subj"
    echo "$body"
    $DIR/bin/alarm.sh "$subj" "$body" $host
fi

## check disk free inode ##
DFI=`df -iP`
echo "$DFI" > "$DIR/log/df_i.log"
sz=`echo "$DFI"|awk -F"[ \t%]+" ' ($6 ~ /^\// && $6 !~ /\/dev/) && ($5 >= '$perc') {print "DISK WARNING - free inode:",$6,$4," ("100-$5 "% left)|total="$2}'`

## send alarm
if [ -n "$sz" ]
then
    subj="$host disk alarm"
    echo "$subj"
    echo "$sz"
    $DIR/bin/alarm.sh "$subj" "$sz" $host
fi


#check disk write
con=`date +%s`
write()
{
    dir=`cat $DIR/log/df.log | grep "$1" | awk '{print $6}'`
    if [ -f "$DIR/log/disk.deny" ]
    then
         sz=`cat $DIR/log/disk.deny| grep -w $dir |wc -l`
         if [ $sz -gt 0 ]
         then
             return
         fi
    fi
    echo "$dir"

    file="$dir/check_rw.log"
    echo $con > $file
    sz=`cat $file`
    #echo $sz
    if [ "$sz" != "$con" ]
    then
        sz="FILERW CRITICAL - read write file $file failed."
        $DIR/bin/alarm.sh "$host r/w file alarm" "$sz" $host
    fi
}
sz=`cat $DIR/log/df.log |awk '{print $1}'| grep dev`
echo $sz
for i in $sz
  do
   write $i
done
