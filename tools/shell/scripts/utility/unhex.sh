#########################################################################
# File Name: unhex.sh
# Description:字符串unhex
# Author:tuling56
# State:
# Created_Time: 2017-07-10 17:33
# Last modified: 2017-07-10 06:29:50 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

input=$1
python unhex.py "$input"

MYSQL="mysql -uroot -proot -N"
echo "select unhex(replace('$input','%',''));"|${MYSQL}


exit 0
