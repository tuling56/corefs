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
BASH_WORKSPACE=${BASH_WORKSPACE:-"/cygdrive/e/OneDrive - std.uestc.edu.cn/Code/Git/shared_common_libs/tools/shell/scripts/utility"}
source "${BASH_WORKSPACE}/common/global_var.sh"
source "${BASH_WORKSPACE}/common/global_fun.sh"
cd $dir

echo $(date +%F\ %T)

#set -e

# [本地->远程]管道文件同步
function rsync_pipeline()
{
	iinfo "同步本地之间的pipelines...."
	local src=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/lichaotest/lichaotest/pipelines.py
	local dst=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/https_spider/https_spider/pipelines.py
	cmp_mv_file $src $dst

	iinfo "同步本pipelines到远程...."
	rdst_1="/home/yjm/Projects/python/pythondev/Projects/xmp/media_lib/lichaotest/lichaotest/pipelines.py"
	rdst_2="/home/yjm/Projects/python/pythondev/Projects/xmp/media_lib/https_spider/https_spider/pipelines.py"
	# rsync.exe -u -e 'ssh -i ~/.ssh/id_rsa -p 122' -avP $src root@localhost:$rdst_1
	# rsync.exe -u -e 'ssh -i ~/.ssh/id_rsa -p 122' -avP $src root@localhost:$rdst_2
}

# [本地->本地]本目录下的程序同步到shell版本管理库
function rsync_shell()
{
	iinfo "[本地-->本地] 同步cygwin的定时脚本到shell版本库"
	rsync.exe -u -avP ./*.py  "$BASH_WORSPACE/cygwin"
	rsync.exe -u -avP ./*.sh  "$BASH_WORKSPACE/cygwin"
}

# [本地->本地]工作手册同步
function rsync_complat()
{
	iinfo "[本地-->本地] 同步工作git文档到OneDrive等"
	local src="/cygdrive/e/Platform/gitserver/online/docs/thunder_android_product_doc/Requirement/hubble/"
	local target='/cygdrive/e/OneDrive - std.uestc.edu.cn/Work/Platform/gitserver/hubble/'
	rsync.exe -u -avP "$src" "$target"


	local src="/cygdrive/e/Platform/gitserver/online/docs/XL_iOS_DOC/Requirement/hubble/"
	local target='/cygdrive/e/OneDrive - std.uestc.edu.cn/Work/Platform/gitserver/hubble_ios/'
	rsync.exe -u -avP "$src" "$target"
	
	local src="/cygdrive/e/Platform/gitserver/online/code/"
	local target='/cygdrive/e/OneDrive - std.uestc.edu.cn/Work/Platform/gitserver/code/'
	rsync.exe -u -avP --exclude=".git/" "$src" "$target"

}

# [本地->远程]数据库同步
function rsync_db()
{
	echo "[本地->远程] 数据库同步....."
	MYSQL="mysql -uroot -proot -N"
	ALecsSQL="mysql -h47.995.195.31 -uroot -p123 -Dstudy"
	ALyosSQL="mysql -hbdm295290494.my3w.com -ubdm295290494  -pyunosa112233 -Dbdm295290494_db"

	# 方式1：
	${MYSQL} -e "select * from study.datatype" > hhah
	${ALecsSQL} 

	# 方法2:
	mysqldump -uroot -proot study > study.sql
	${ALecsSQL} < study.sql
	rm -f study.sql

	return 0
}

# [本地->alecs远程]查询sql同步
function rsync_query()
{
	echo "[本地->远程] 查询sql同步....."
	local local_sql='/cygdrive/c/Users/xl/Documents/Navicat/MySQL/servers/*'
	local remote_sql='/home/yjm/Projects/mysql/sql'

	rsync.exe -u -e 'ssh -i /cygdrive/c/Users/xl/.ssh/id_rsa' -avP --delete $local_sql root@47.95.195.31:$remote_sql
}

# [本地->alecs远程]study数据库(文件所属主存在问题,导致数据库无法读取表)
function rsync_studydb()
{
	echo "[本地->alecs远程] study数据库同步....."
	local local_db='/cygdrive/c/ProgramData/MySQL/MySQL Server 5.5/data/study/'
	local remote_db='/var/lib/mysql/study/'

	#rsync.exe -u -og -e 'ssh -i /cygdrive/c/Users/xl/.ssh/id_rsa' -avP --include="*/" --include="*.frm" --include="*.MYD" --include="*.MYI" --exclude='*' "$local_db" root@47.95.195.31:$remote_db
	rsync.exe -u -avP -e 'ssh -i /cygdrive/c/Users/xl/.ssh/id_rsa' -avP --include="*/" --include="*.frm" --include="*.MYD" --include="*.MYI" --exclude='*' "$local_db" root@47.95.195.31:$remote_db
	# 修补方案更改文件的所属主 
	ssh -i /cygdrive/c/Users/xl/.ssh/id_rsa root@47.95.195.31 "cd /var/lib/mysql;chown -R mysql:mysql study;"

}


# [本地->OneDrive]文档图片等同步
function rsync_docimg()
{
	echo "[本地->OneDrive] 文档图片等同步...."
	local local_dimg='/cygdrive/c/Users/xl/Downloads/Documents/表情包'
	local remote_dimg='/cygdrive/e/OneDrive/图片'

	rsync.exe -avP "$local_dimg" "$remote_dimg"
}

# [Git->OneDrive]Excel笔记同步(有问题为解决)
function rsync_excel()
{
	echo "[Git->OneDrive] excel等同步...."
	local local_dimg='/cygdrive/c/Users/xl/Downloads/Documents/表情包'
	local remote_dimg='/cygdrive/e/OneDrive/图片'

	rsync.exe -avP "$local_dimg" "$remote_dimg"
}

# [本地->OneDrive]gitbash的配置
function rsync_gitconf()
{
	echo "[本地->OneDrive] gitbash的配置同步...."
	local local_conf='/cygdrive/c/Program Files/Git/etc/'
	local remote_conf='/cygdrive/e/OneDrive - std.uestc.edu.cn/Code/Git/mdotfiles/git/gitbash/conf/'
	rsync.exe -u -avP --include="bash.bashrc" --include="vimrc" --exclude="*" "$local_conf" "$remote_conf"
}


#################################### 主程序入口
# rsync_pipeline
rsync_shell
#rsync_studydb
rsync_query
rsync_complat
#rsync_docimg
#rsync_gitconf


exit 0
