#########################################################################
# File Name: invoke_global_fun.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-05-09 17:15
# Last modified: 2017-11-14 11:27:01 AM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

SBIN_HOME=${SBIN_HOME:-"/usr/local/shell/bin"}
source ${SBIN_HOME}/common/global_var.sh
source ${SBIN_HOME}/common/global_fun.sh

date=$1
[ -z $date ]&&date=`date -d "-1 day" +%Y%m%d`
echo "CalcDay:"$date

echo "调用info函数"
iinfo "这是调用info函数"


res=$(${sl} while) 
echo "$res"
