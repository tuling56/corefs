#########################################################################
# File Name: filldate.sh
# Description:日期数据库
# Author:tuling56
# State:待完善
# Created_Time: 2017-11-22 11:49
# Last modified: 2018-01-03 09:12:22 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir


MYSQL='mysql -uroot -proot -Dtest -N'

function filldate()
{
    local date=$1
    local wk=$(date -d"$date" +%u)
    sql="select count(*) from holidays where date='$date';"
    res=$(${MYSQL} -e "$sql")
    if [ "$res" == "0" ];then
        if [ $wk -eq 7 -o $wk -eq 6 ];then
            iswork=0
        else
            iswork=1
        fi
        isql="insert into holidays(date,weekend,isholiday,iswork) values('$date','$wk','0','$iswork');"
        echo "$isql"
        ${MYSQL} -e "$isql"
    else
        echo "$date"有查证!
    fi
}


function main()
{
    start_date=20110101 #`date -d"-7 day" +%Y%m%d`
    end_date=20180101 #`date -d"-1 day" +%Y%m%d`
    while [[ $start_date -le $end_date ]];do
        echo -e "\e[1;31mstep:\e[0m"$start_date
        filldate ${start_date}
        start_date=`date -d${start_date}"+1 day" +%Y%m%d`
    done
}


main

exit 0
