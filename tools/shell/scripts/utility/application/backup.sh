#########################################################################
# File Name: backup.sh
# Description: 备份工具
# Author:tuling56
# State:还存在着不能切换到调用命令的目录的问题
# Created_Time: 2017-11-16 16:58
# Last modified: 2017-11-16 05:46:47 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir

# 备份指定目录下
# 	1.排除dev子目录
#	2.指定的.py.sh.hql等类型的文件

backdir=$1
parentdir=$(dirname $dir/xx)
parentdir=${parentdir##*/}
[ -z $backdir ]&&cd .. &&backdir=$parentdir

function backup_tool()
{
    backtypes=(py sh hql sql json conf ini)
    for t in ${backtypes[@]};do
        backinfo="$backinfo -name \"*.$t\""
    done

    #zip $backdir.zip $(find $backdir -path "*dev*" -prune -o -type f  \( -name "*.py" -o -name "*.sh" -o -name "*.hql" -o -name "*.json" -o -name "*.conf" -o  -name "*.ini" \))
    iinfo "当前目录$(pwd),开始备份目录${backdir}...."
    ilog "zip $backdir.zip \$(find $backdir -path \"*dev*\" -prune -o -type f  \( $backinfo \))"
    zip $backdir.zip $(find $backdir -path "*dev*" -prune -o -type f  \( $backinfo \))
}



backup_tool $backdir

exit 0
