#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

# 日志统计的驱动入口模板

#set -e

date=$1
[ -z $date ]&&date=`date +%Y%m%d`

datehour=`date +%Y%m%d_%H`
ststr=`date +%d\\\/%b\\\/%Y:%H`
echo "CalcDayHour:"$datehour

datapath=$dir/data
[ ! -d $datapath ]&&mkdir $datapath

# ############ 全局变量定义区 ##########################
log=xmp_acc
stat_res=$datapath/snh48_stat_hour_${date}.txt
mail_res=$datapath/snh48_stat_hour_${date}.txt

log_path=/usr/local/nginx/logs
log_path_bak=/usr/local/nginx/logs/bak/${date}
[ ! -d ${log_path_bak} ]&&mkdir ${log_path_bak}

# ############ 处理过程 ##########################
# #### 数据准备
function ready_data()
{
	echo "数据备份:"
	#log_path=/usr/local/nginx/logs
	#log_path_bak=/usr/local/nginx/logs/bak/${date}
	#[ ! -d ${log_path_bak} ]&&mkdir ${log_path_bak}

	# 数据备份
	sed -n "/${ststr}/p" "${log_path}/${log}" > "${log_path_bak}/${log}_${datehour}"

	# 删除过期数据
	local rm_date=`date -d "-10 day" +%Y%m%d`
	log_path_del=/usr/local/nginx/logs/bak/${rm_date}
	if [ ! -d ${log_path_del} ];then
		return 1
	fi

	local rm_data=${log_path_del}
	[ -d ${rm_data} ]&&rm -rf /usr/local/nginx/logs/bak/${rm_date}
	[ -d ${rm_data} ]&&echo "del_src_data:"${rm_data}
}

# ##### 结果统计
function calc_stat()
{
	# 数据详细统计结果（暂时未纳入）
	echo "开始计算:"
	# /usr/local/bin/python2.7  barrage_stat.py $date
	echo "======================$datehour=======================" >>${stat_res}
	awk -f snh48_log_hour.awk ${log_path_bak}/${log}_${datehour} >>${stat_res}

	# 删除过期数据(若有统计的中间数据保存的话)
	# local rm_date=`date -d "-10 day" +%Y%m%d`
	# [ -z ${datapath} ]&&exit 1
	# local rm_data=${datapath}/proc_res_${rm_date}
	# [ -f ${rm_data} ]&&rm -f ${rm_data}
	# echo "del_proc_data:"${rm_data}
}

# ##### 邮件报告
function send_mail()
{

	sendm="/usr/local/monitor-base/bin/sendEmail -s mail.cc.sandai.net -f monitor@cc.sandai.net -xu monitor@cc.sandai.net -xp 121212 "

	echo "数据发送:"
	mail_title="$date from `hostname` snh48 stat result"
	mail_to="yuanjunmiao@cc.sandai.net" # luochuan@cc.sandai.net"
	mail_body=${mail_title}

	if [ -f ${mail_res} ];then
		${sendm} -t ${mail_to} -u "${mail_title}" -m "${mail_body}" -a "${mail_res}"
	else
		echo "${mail_res} data not exists"
	fi

	# 删除过期的邮件结果数据(若邮件结果数据与结果数据不一致的话)
	# local rm_date=`date -d"-15 day" +%Y%m%d`
	# local rm_data=${mail_res}_${rm_date}
	# [ -f ${rm_data} ]&&rm -f ${rm_data}
	# echo "del_res_data:${rm_data}"
}

# #### 执行主体
ready_data
calc_stat
#send_mail


exit 0




