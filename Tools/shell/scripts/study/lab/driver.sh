#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

set -e

date=$1
[ -z $date ]&& date=`date +%Y%m%d`
echo "CalcDay:"$date
echo "======================$date======================="

datapath=$dir/data
[ ! $datapath ]&&mkdir $datapath


# #### 数据准备
function ready_data()
{
	echo "step1:数据备份:"
	highdur_log_path=/usr/local/nginx/logs/
	highdur_log_path_bak=/usr/local/nginx/logs/bak
	[ ! -d ${highdur_log_path_bak} ]&&mkdir ${highdur_log_path_bak}

	# 数据备份
	/bin/cp ${highdur_log_path}/access.log  ${highdur_log_path_bak}/access.log_${date}
	ret=$?
	[ "$ret" -eq "0" ]&&echo -n >${highdur_log_path}/access.log

	# 删除过期日志数据
	rm_date=`date -d "-3 day" +%Y%m%d`
	[ -z ${highdur_log_path_bak} ]&&exit 1
	local rm_data=${highdur_log_path_bak}/access.log_${rm_date}
	[ -f ${rm_data} ]&&rm -f ${rm_data}
	echo "del_src_data:"${rm_data}
}

# #####结果统计
function calc_stat()
{
	# 数据详细统计结果（暂时未纳入）
	echo "step2:开始计算:"
	/usr/local/bin/python2.7  highdur_stat.py $date


	# 删除过期处理数据
	rm_date=`date -d "-15 day" +%Y%m%d`
	[ -z ${datapath} ]&&exit 1
	local rm_data=${datapath}/highdur_proc_${rm_date}
	[ -f ${rm_data} ]&&rm -f ${rm_data}
	echo "del_proc_data:"${rm_data}
}


# #####邮件发送
function send_mail()
{
	# 数据发送
	echo "step3:数据发送:"
	logf=$datapath/highdur_stat.txt
	logm="$date from `hostname` highdur stat result"
	MAIL_TO="yuanjunmiao@cc.sandai.net" # luochuan@cc.sandai.net"
	if [ -f $logf ];then
		/usr/local/monitor-base/bin/sendEmail -s mail.cc.sandai.net -f monitor@cc.sandai.net -xu monitor@cc.sandai.net -xp 121212 -t ${MAIL_TO} -u "$logm" -m "$logm" -a "$logf"
	else
		echo " highdur stat data not exists"
	fi

	# 删除过期报表数据
	rm_date=`date -d "-15 day" +%Y%m%d`
	[ -z ${datapath} ]&&exit 1
	local rm_data=${datapath}/highdur_stat_${rm_date}
	[ -f ${rm_data} ]&&rm -f ${rm_data}
	echo "del_stat_data:"${rm_data}

}

# #### 执行主体
ready_data
# calc_stat
# send_mail


exit 0




