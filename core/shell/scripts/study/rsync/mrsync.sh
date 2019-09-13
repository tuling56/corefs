#########################################################################
# File Name: mrsync.sh
# Description:rsync命令测试 
# Author:tuling56
# State:
# Created_Time: 2017-12-20 14:49
# Last modified: 2017-12-26 01:47:04 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir

#src_dir="../subdir"
src_dir="/home/yjm/Projects/shell/study/subdir"
dst_dir="./subdir"

#echo $src_dir
#echo $dst_dir

# 单测试
function rsync_single()
{
    rsync  -avn --include-from=$dir/exinclude.conf --exclude='*' $src_dir  $dst_dir

    # 仅复制目录结构，而不复制里面的文件
    #rsync  -avn  --include='*/' --exclude='*' $src_dir  $dst_dir


    #rsync  -avn  --include "*.txt" --exclude "*" $src_dir  $dst_dir
}

# 批量执行是.sh
function rsync_batch()
{   
   
    for sf in $(ls rsync.d/*.sh);do
        echo "sh $sf"|bash
    done

}



rsync_batch

exit 
