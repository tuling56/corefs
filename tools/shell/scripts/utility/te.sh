#########################################################################
# File Name: tabexpand.sh
# Description:tab展开成空格 
# Author:tuling56
# State:
# Ref:http://blog.csdn.net/jfkidear/article/details/7403425
# Created_Time: 2017-05-27 14:29
# Last modified: 2017-05-27 07:42:16 PM
#########################################################################
#!/bin/bash

file=$1

exe="sed -i 's/\t/    /g' $file"
echo -e "\e[1;31m[执行]:'$exe'\e[0m"

sed -i 's/\t/    /g' $file
