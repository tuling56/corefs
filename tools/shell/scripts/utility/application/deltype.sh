#########################################################################
# File Name: deltype.sh
# Description:删除指定类型的文件 
# Author:tuling56
# State:
# Created_Time: 2017-05-25 18:17
# Last modified: 2017-05-25 06:46:20 PM
#########################################################################
#!/bin/bash

type=$1
if [ -z "$type" -o "$type" = "*" ];then
    echo -e "\e[1;31mtype is illegal\e[0m,pleace check your type:$type"
    exit 1
fi

exec="find . -type f -name \"*.${type}\" -exec rm {} \;"
echo -e "\e[1;31m[EXEC]:${exec}\e[0m"
read -p "Confirm:Y/N?"
if [ "$REPLY" = "Y" -o "$REPLY" = "y" ];then
    eval $exec
else
    echo "plese input Y,y,N,n"    
fi

exit 0
