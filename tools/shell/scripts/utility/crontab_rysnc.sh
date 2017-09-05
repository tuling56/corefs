#########################################################################
# File Name: crontab_rsync.sh
# Description:更新同步文件和文件夹
# Author:tuling56
# State:
# Created_Time: 2017年8月18日
# Last modified: 2017年8月18日
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
BASH_WORKSPACE=${BASH_WORKSPACE:-"/cygdrive/e/Code/Git/shared_common_libs/tools/shell/scripts/utility/"}
source ${BASH_WORKSPACE}/common/global_var.sh
source ${BASH_WORKSPACE}/common/global_fun.sh
cd $dir

echo $(date +%F\ %T)

#set -e

# 管道文件同步
function pipeline()
{
	echo -e "\e[1;35m同步pipelines....\e[0m"
	local src=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/lichaotest/lichaotest/pipelines.py
	local dst=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/https_spider/https_spider/pipelines.py
	cmp_mv_file $src $dst
}

# 本目录下的程序同步到shell库
function rsync_shell()
{
	#rsync.exe -avuP ./*.py  $BASH_WORSPACE
 	rsync.exe -avuP ./*.sh  $BASH_WORKSPACE
}



# 主程序入口
pipeline
rsync_shell



exit 0
