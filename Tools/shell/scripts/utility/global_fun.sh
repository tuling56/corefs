#########################################################################
# File Name: global_fun.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-05-09 17:12
# Last modified: 2017-05-09 05:21:48 PM
#########################################################################
#!/bin/bash


########################### 信息显示 ##########################
function show_info()
{
    local info=$1
    echo -e "\e[1;31mstep:$info\e[0m-->`date +%F\ %T`"
}

######################### 字符串分割 ##########################
# 分割:pgv3_split_c2.xmp_subproduct_other_20170313_21
function split_s1_m1()
{
	local line='pgv3_split_c2.xmp_subproduct_other_20170313_21'
	echo $line
	iArray=(${line//./ })
	db=${iArray[0]}
	itable=${iArray[1]}

	tArray=(${itable//_/ })
	tArrayLen=${#tArray[@]}
	dl=$(($tArrayLen-2))
	hl=$(($dl-1))

	# 获取表
	table=
	for((i=0;i < $dl;i++));do
		if [ $i -ne $hl ];then
			table="$table${tArray[$i]}_"
		else
			table="$table${tArray[$i]}"
		fi
	done

	# 获取日期和实际
	local date=${tArray[($tArrayLen-2)]}
	local hour=${tArray[($tArrayLen-1)]}

	echo "[db]:"$db
	echo "[table]:"$table
	echo "[date]:"$date
	echo "[hour]:"$hour
}

function split_s1_m2()
{
	local line='pgv3_split_c2.xmp_subproduct_other_20170313_21'
	echo $line
	local db=${line%.*}
	local table_day_hour=${line#*.}
	local hour=${table_day_hour##*_}

	local table_day=${table_day_hour%_*}
	local day=${table_day##*_}

	local table=${table_day%_*}


	echo "[db]:"$db
	echo "[table]:"$table
	echo "[day]:"$day
	echo "[hour]:"$hour
}

# 分割:pgv3_split_c2.xmp_subproduct_other_2017031321
function split_s2_m1()
{
	local line='pgv3_split_c2.xmp_subproduct_other_2017031321'
	echo $line
	local iArray=(${line//./ })
	local db=${iArray[0]}
	local itable=${iArray[1]}

	local tArray=(${itable//_/ })
	local tArrayLen=${#tArray[@]}
	local tbl=$(($tArrayLen-1))
	local tbl_l1=$(($tbl-1))

	# 获取表
	local table=
	for((i=0;i < $tbl;i++));do
		if [ $i -ne ${tbl_l1} ];then
			table="$table${tArray[$i]}_"
		else
			table="$table${tArray[$i]}"
		fi
	done

	# 获取日期和实际
	local dh=${tArray[($tArrayLen-1)]}
	local day=${dh:0:8}
	local hour=${dh:8:2}

	echo "[db]:"$db
	echo "[table]:"$table
	echo "[day]:"$day
	echo "[hour]:"$hour
}


function split_s2_m2()
{
	local line='pgv3_split_c2.xmp_subproduct_other_2017031321'
	echo $line
	local db=${line%.*}
	local itable=${line#*.}
	local table=${itable%_*}
	local dhour=${line##*_}
	local day=${dhour:0:8}
	local hour=${dhour:8:10}


	echo "[db]:"$db
	echo "[table]:"$table
	echo "[day]:"$day
	echo "[hour]:"$hour

}
