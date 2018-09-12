#########################################################################
# File Name: crontab_sysnology.sh
# Description:更新同步文件和文件夹
# Author:tuling56
# State:
# Created_Time: 2017年8月18日
# Last modified: 2017年8月18日
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
BASH_WORKSPACE=${BASH_WORKSPACE:-"/cygdrive/e/OneDrive - std.uestc.edu.cn/Code/Git/shared_common_libs/tools/shell/scripts/utility"}
source "${BASH_WORKSPACE}/common/global_var.sh"
source "${BASH_WORKSPACE}/common/global_fun.sh"
cd $dir

echo $(date +%F\ %T)

#set -e


ROOT_HOME=${ROOT_HOME:-"/cygdrive/e/OneDrive - std.uestc.edu.cn/"}
REMOTE_HOME=${REMOTE_HOME:-"/volume1/homes/tuling56/Drive/同步库/test/"}

# [本地->sysnology远程](账号和密码授权出现问题)
function rsync_onedrive_std()
{
	echo "[本地->sysnology] onedrive.std....."
	local local_dir="${ROOT_HOME}/算法"
	local remote_dir="${REMOTE_HOME}/"

	rsync.exe -u -avP -e 'ssh -i /cygdrive/c/Users/xl/.ssh/id_rsa -p122'  "$local_dir" tuling56@47.95.195.31:$remote_dir
	#rsync.exe -u -avP -e 'ssh -p122'  "$local_dir" tuling56@47.95.195.31:$remote_dir
	
}



#################################### 主程序入口
rsync_onedrive_std


exit 0
