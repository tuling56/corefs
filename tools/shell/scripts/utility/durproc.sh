#!/bin/bash
set -e

if [ ${#*} -ne 3 ];then
    echo "Usage: [statrt_date] [end_date] [shell_script]"
    exit 1
else
    start_date=$1
    end_date=$2
    shell_script=$3
fi

if [ "${#start_date}" -ne "8" -o "${#end_date}" -ne "8" ];then
    echo -e "\e[1;31m[WRONG]\e[0m:date shouble be like 20170503"
    exit 1
fi

if [[ $start_date -gt $end_date ]];then
    echo -e "\e[1;31m[WRONG]\e[0m:start_date must less than end_date"
    exit 1
fi

if [ ! -f $shell_script -o ! -x $shell_script ];then
    echo -e "\e[1;20m[WARNING]\e[0m:add execute authority for $shell_script"
    chmod u+x $shell_script
fi


function durproc()
{
    
    #start_date=20170505 #`date -d"-7 day" +%Y%m%d`
    #end_date=20170515 #`date -d"-1 day" +%Y%m%d`
    while [[ $start_date -le $end_date ]];do
        echo -e "\e[1;31mstep:\e[0m"$start_date
        sh ${shell_script} ${start_date}
        start_date=`date -d${start_date}"+1 day" +%Y%m%d`
    done
}


# 程序主入口
durproc


exit 0
