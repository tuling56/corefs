#!/bin/bash 

file1=$1
file2=$2
cmpcol=$3
[ -z $cmpcol ]&&cmpcol=1

echo -e "\e[1;31m重合度统计\e[0m"
echo "-----------输入信息如下:"
echo "文件1:$file1"
echo "文件2::$file2"
echo "字段:$cmpcol"

echo "-----------统计信息如下:"
awk  '{if(NR==FNR){a[$1]=$1;num=0;f1num=f1num+1;}else{if($1 in a) num++}}END{print ARGV[1]"\t"f1num"\n"ARGV[2]"\t"FNR"\noverlap\t"num}' ${file1} ${file2}
