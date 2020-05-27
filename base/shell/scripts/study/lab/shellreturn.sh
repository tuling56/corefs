#########################################################################
# File Name: shellreturn.sh
# Description:测试shell函数的返回值和返回状态码 
# Author:tuling56
# State:
# Created_Time: 2017-05-09 18:55
# Last modified: 2017-05-09 08:17:12 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

MYSQL='/usr/bin/mysql -uroot -proot'

function f1()
{
    echo "返回值的使用方式";
    #echo "这是第二次返回值";
    sql="use pgv_stat_yingyin;select * from websites;"
    #echo "$sql"
    ${MYSQL} -e "$sql"

    return 'retvalue';
}

f1
echo "\$?返回值:"$?

res=`f1`
echo -e "res=\`f1\`返回值:\n"$res

exit 0




