#########################################################################
# File Name: colsum.sh
# Description: 计算列和
# Author:tuling56
# State:
# Created_Time: 2017-05-18 15:26
# Last modified: 2017-05-18 06:39:20 PM
#########################################################################
#!/bin/bash

file=$1
col=$2

echo -e "\e[1;31m列和统计\e[0m"
echo "--------------输入信息如下:"
echo "File:$file"
echo "Col:$col"

echo "--------------统计信息如下:"
awk -v col=$col 'BEGIN{c_sum=0;}{c_sum+=$col;}END{print "col"col"_sum= "c_sum }' $1


exit 0
