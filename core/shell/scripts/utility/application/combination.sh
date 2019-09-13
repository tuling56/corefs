#!/bin/bash
cd `dirname $0`
date=$1
[ -z $date ]&&date=`date -d "-1 day" +%Y%m%d`

remain_1d=`date -d"$date +1 day" +%Y%m%d`
remain_30d=`date -d"$date +30 day" +%Y%m%d`

key_action=("短视频" "下载" "搜索" "直播" "文件播放")
key_value=("online_shortvideo" "dcl_create" "search" "live_room_show" "native+bxbb")
remain_day=("$date" "${remain_1d}" "${remain_30d}")

for k in {0..4};do
	curk=${key_action[$k]}
	if [ $k -ne 4 ];then
		kn=$((k+1))
		curnk=${key_action[$kn]}
		echo $curk - $curnk
	fi
done
