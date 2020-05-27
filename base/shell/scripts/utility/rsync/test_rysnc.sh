#########################################################################
# File Name: test_rsync.sh
# Description:rsync命令使用笔记
# Author:tuling56
# State:持续更新中
# Created_Time: 2017年9月05日
# Last modified: 2017年9月05日
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
BASH_WORKSPACE=${BASH_WORKSPACE:-"/cygdrive/e/Code/Git/shared_common_libs/tools/shell/scripts/utility/"}
source ${BASH_WORKSPACE}/common/global_var.sh
source ${BASH_WORKSPACE}/common/global_fun.sh
cd $dir

echo $(date +%F\ %T)

#set -e

# 本目录下的程序同步到shell库
function mrsync()
{
 	rsync.exe -avuP ./*.sh  $BASH_WORKSPACE
}

# 筛选
function rsync_include_exclude()
{
	local src=$1
	local dst=$2

	rsync.exe -avuP --include-from=include_rules --exclude-from=exclude_rules $src $dst  
}



# 主程序入口
rsync_


exit 0
