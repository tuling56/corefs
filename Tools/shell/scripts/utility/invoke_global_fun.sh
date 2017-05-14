#########################################################################
# File Name: invoke_global_fun.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-05-09 17:15
# Last modified: 2017-05-13 08:15:25 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
source $dir/global_fun.sh
cd $dir

date=$1
[ -z $date ]&&date=`date -d "-1 day" +%Y%m%d`
echo "CalcDay:"$date

echo "调用info函数"
showstep "这是调用info函数"
