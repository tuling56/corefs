#########################################################################
# File Name: dur_proc.sh
# Description:批处理 
# Author:tuling56
# State:
# Created_Time: 2018-01-08 14:12
# Last modified: 2018-01-08 02:38:32 PM
#########################################################################
#!/bin/bash
#dir=`dirname $0` && dir=`cd $dir && pwd`
#COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
#source $COMMON_PATH/global_fun.sh
#source $COMMON_PATH/global_var.sh
#cd $dir


script=$1
[ -z $script ]&&echo "please input script"&&exit 1

start_date=$2
[ -z $start_date ]&&echo "use yesterday"&&start_date=`date -d"-1 day" +%Y%m%d`

end_date=$3
[ -z $end_date ]&&echo "use yesterday"&&end_date=`date -d"-1 day" +%Y%m%d`


function main()
{
    while [[ $start_date -le $end_date ]];do
        echo -e "\e[1;31mstep:\e[0m"$start_date
        sh $script ${start_date}
        start_date=`date -d${start_date}"+1 day" +%Y%m%d`
    done
}

main

exit 0
