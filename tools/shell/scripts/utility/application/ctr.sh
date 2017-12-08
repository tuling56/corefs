#########################################################################
# File Name: ctr.sh
# Description:转换第一列为指定的日期格式 
# Author:tuling56
# State:
# Created_Time: 2017-12-06 10:12
# Last modified: 2017-12-06 10:25:30 AM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir

fin=$1


function ctr_awk()
{
    local fin=$fin

    awk '{for(i=1;i<NF;i++) if(i==1) printf("%s/%s/%s",substr($i,1,4),substr($i,5,2),substr($i,7,8));else printf("\t%s",$i);printf("\n");}' $fin
}



function ctr_shell()
{
    local fin=$fin

    while read line;do
        linearr=($line)
        for i in `seq 0 $((${#linearr[@]}-1))`;do
            if [ $i -eq 0 ];then
                echo -n ${line:0:4}"/"${line:4:2}"/"${line:6:2}
            else
                echo -n -e  "\t"${linearr[$i]}
            fi
        done
        echo 
    done< "$fin"
}


# 程序入口
ctr_awk $fin
ctr_shell $fin


exit 0


