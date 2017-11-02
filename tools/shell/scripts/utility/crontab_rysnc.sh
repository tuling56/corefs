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
function rsync_pipeline()
{
	iinfo "同步本地pipelines...."
	local src=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/lichaotest/lichaotest/pipelines.py
	local dst=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/https_spider/https_spider/pipelines.py
	cmp_mv_file $src $dst

	iinfo "同步本piplelines到远程...."
	rdst_1="/home/yjm/Projects/python/pythondev/Projects/xmp/media_lib/lichaotest/lichaotest/pipelines.py"
	rdst_2="/home/yjm/Projects/python/pythondev/Projects/xmp/media_lib/https_spider/https_spider/pipelines.py"
	# rsync.exe -u -e 'ssh -i ~/.ssh/id_rsa -p 122' -avP $src root@localhost:$rdst_1
	# rsync.exe -u -e 'ssh -i ~/.ssh/id_rsa -p 122' -avP $src root@localhost:$rdst_2
}

# 本目录下的程序同步到shell版本管理库
function rsync_shell()
{
	iinfo "同步cygwin的定时脚本到shell版本库"
	#rsync.exe -avuP ./*.py  $BASH_WORSPACE
	rsync.exe -avuP ./*.sh  $BASH_WORKSPACE
}

# 爬虫同步
function rsync_db()
{
	MYSQL="mysql -uroot -proot -N"
	${MYSQL} -e "select * from study.datatype" > hhah
	
	return 0
}


# 主程序入口
# rsync_pipeline
rsync_shell
#rsync_db




exit 0
