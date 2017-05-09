#########################################################################
# File Name: shellreturn.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-05-09 18:55
# Last modified: 2017-05-09 06:58:20 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

date=$1
[ -z $date ]&&date=`date -d "-1 day" +%Y%m%d`
echo "CalcDay:"$date

function f1()
{
    echo "hhxhh";
    echo "这是第二次返回值";
    return 1;
}

f1
echo "\$?返回值:"$?

res=`f1`
echo "res=\`f1\`返回值:"$res

exit 0




