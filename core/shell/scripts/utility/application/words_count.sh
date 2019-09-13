#########################################################################
# File Name: words_count.sh
# Description:统计文档中单词的频率 
# Author:tuling56
# State:
# Created_Time: 2017-11-02 10:52
# Last modified: 2017-11-02 11:17:39 AM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir


# 单词计数
function words_count()
{
    declare -A cn
    while read line;do
        for w in $line;do
            cn[$w]=$((${cn[$w]}+1))
        done
    done < words.txt

    #echo -n > temp.txt
    res=""
    head=0
    for wc in ${!cn[*]};do
        #echo -e "$wc\t${cn[$wc]}" >> temp.txt
        #echo -e "$wc\t${cn[$wc]}" |sort -k2 -rn
        #if [ "$head" -eq "0" ];then
        if [ -z $res ];then
            ct="$wc\t${cn[$wc]}"
            #head=$((head+1))
        else
            ct="\n$wc\t${cn[$wc]}"
        fi
        res="$res$ct"
    done
    #sort -k2 -rn temp.txt
    echo -e "$res"|sort -k2 -rn
}


words_count
