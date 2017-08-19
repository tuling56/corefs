#########################################################################
# File Name: deltype.sh
# Description:搜索指定类型的文件 
# Author:tuling56
# State:
# Created_Time: 2017-05-25 18:17
# Last modified: 2017-06-26 02:35:13 PM
#########################################################################
#!/bin/bash

type=$1
if [ -z "$type" -o "$type" = "*" ];then
    echo -e "\e[1;31m[warning]:type is unset,will search all file\e[0m"
fi

content=$2
if [ -z $content ];then
    echo "please input the search content"
    exit 1
fi

exec="grep -i -n --color $content `find . -type f -name \"*.${type}\"`"
echo "grep -i -l --color $content find . -type f -name \"*.${type}\""
eval $exec

exit 0
