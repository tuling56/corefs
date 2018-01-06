#!/bin/bash
# 日期填充

cd $(dirname $0)

MYSQL='mysql -uroot -proot -Dtest -N'

function filldate()
{
    local date=$1
    sql="select count(*) from holidays where date='$date';"
    res=$(${MYSQL} -e "$sql")
    echo "$res"
    if [ "$res" == "0" ];then
        echo "$date"无查证
    else
        echo "$date"有查证!
    fi
}


function main()
{
    start_date=20171001 #`date -d"-7 day" +%Y%m%d`
    end_date=20180101 #`date -d"-1 day" +%Y%m%d`
    while [[ $start_date -le $end_date ]];do
        echo -e "\e[1;31mstep:\e[0m"$start_date
        filldate ${start_date}
        sleep 1
        start_date=`date -d${start_date}"+1 day" +%Y%m%d`
    done
}


main

exit 0
