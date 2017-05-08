#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
# KK_WORKSPACE=${KK_WORKSPACE:-"/usr/local/sandai/server"}
# source $KK_WORKSPACE/bin/common/global_var.sh
source /usr/local/sandai/server/bin/common/global_var.sh
cd $dir


date=$1
[ -z $date ]&&date=`date -d "-1 day" +%Y%m%d`
echo "CalcDay:"$date

datapath=${dir/\/bin/\/data}
[ ! -d $datapath ]&&mkdir -p $datapath



# 新的本地播放数据
function new_local_vod()
{
	# 原有的本地播放数据
	sql="select sum(local_vod) from pgv_stat.xmp_vod_detail where date='$date' and cnt_flag='uv'  and channel='all' and version=0;"
	echo "$sql"
	local_vod_uv=`${MYSQL10} -e "$sql"`

	sql="select sum(local_vod) from pgv_stat.xmp_vod_detail where date='$date' and cnt_flag='vv'  and channel='all' and version=0;"
	echo "$sql"
	local_vod_vv=`${MYSQL10} -e "$sql"`

	# 破解播放所占的数据
	sql="select sum(uv),sum(pv) from pgv_stat_yingyin.xmp_play_crack where date='$date';"
	echo "$sql"
	crack_res=`${MYSQL10} -e "$sql"`
	set $crack_res
	crack_uv=$1
	crack_pv=$2

	new_local_vod_uv=$((local_vod_uv-crack_uv))
	new_local_vod_vv=$((local_vod_vv-crack_pv))


}

# 新的在线播放数据
function new_online_vod()
{
	# 新在线线播放数据（原有的+破解播放的）
	sql="select a.vod_pv+b.cpv as '总在线播放次数',a.vod_uv+b.cuv as '总在线播放人数' from (select date ,vod_pv,vod_uv from pgv_stat.xmp_jingpin where date='$date') a inner join (select date ,sum(pv) as cpv,sum(uv) as cuv from pgv_stat_yingyin.xmp_play_crack where date='$date') b on a.date=b.date;"
	echo "$sql"

	online_res=(`${MYSQL10} -e "$sql"`)
	new_online_vod_pv=${online_res[0]}
	new_online_vod_uv=${online_res[1]}
}

# 新修正的数据结果合并展示
function new_vod_stat()
{

	if [ -z ${new_online_vod_uv} ]&& [ -z ${new_online_vod_pv} ] && [ -z ${new_local_vod_uv} ] && [ -z ${new_local_vod_vv} ];then
		csql="use pgv_stat_yingyin;create table if not exists online_local_vod_final(date varchar(10),online_vod_uv int,online_vod_pv,local_vod_uv int,local_vod_pv int)ENGINE=MyISAM charaset=utf8;"
		echo "$csql"
		${MYSQL10} -e "$csql"

		sql="use pgv_stat_yingyin;delete from online_local_vod_final where date='${date}';insert into online_local_vod_final(date,online_vod_uv,online_vod_pv,local_vod_uv,local_vod_pv) values('${date}',${new_online_vod_uv},${new_online_vod_pv},${new_local_vod_uv},${new_local_vod_vv});"
		echo "$sql"
		${MYSQL10} -e "${sql}"
	fi
}



# #####执行主体
new_local_vod
new_online_vod
#new_vod_stat

cd -
exit 0
