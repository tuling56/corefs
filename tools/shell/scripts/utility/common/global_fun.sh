#########################################################################
# File Name: global_fun.sh
# Description:shell全局函数文件
# Author:tuling56
# State:持续更新中.....
# Created_Time: 2017-05-09 17:12
# Last modified: 2017-08-15 07:53:25 PM
#########################################################################
#!/bin/bash


########################### 信息显示 #######################
function showstep()
{
    local info=$1
    echo -e "\e[1;31mstep:$info\e[0m-->`date +%F\ %T`"
}

function showstep2()
{
    local info=$1
    echo -e "$info\t"$(date +%Y%m%d_%H:%M:%S)
}

function ierror()
{
    local info=$1
    echo -e "\e[1;31m$info\e[0m"
}

function iwarn()
{
    local info=$1
    echo -e "\e[1;33m$info\e[0m"
}

function isucc()
{
    local info=$1
    echo -e "\e[1;32m$info\e[0m"
}

function iinfo()
{
    local info=$1
    echo -e "\e[1;34m$info\e[0m"
}

function ihigh()
{
    local info=$1
    echo -e "\e[1;35m$info\e[0m"
}

# 计算百分比
function calcratio()
{
    local num=$1
    local total=$2

	# 方法1
    #r_o_ratio="`echo "scale=2;${num}*100/${total}"|bc`%"
 	# 方法2：使用awk（注意此语句中的BEGIN不能省略）
 	#r_o_ratio=$(awk -v a=$num -v b=$total 'BEGIN{printf("%4.2f%%",a*100/b);}')
 	# 方法2.1(注意通过管道传递过来的数据不能在begin中使用，可以在前面加上END)
 	r_o_ratio=$(echo "$num $total" | awk '{printf("%4.2f%%",$1*100/$2);}')

	echo ${r_o_ratio}
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

########################## 文件（夹）同步 ########################
# 判断key是否在关联数组中(关联数组如何作为参数进传递？？)
function isinkey()
{
	local skey=$1
	local arrs=$2
    for key in ${!count_result[*]};do
      if [ "$skey" = "$key" ];then
        return 1
      fi
    done

	return 0
}

# 判断文件的新旧（2:文件1>文件2,0:文件1=文件2,1:文件1<文件2）
function cmp_newer()
{
	local file1=$1
	local file2=$2

	file1_mt=`stat $file1 |grep ^Modify | awk '{split($3,arr,".");print $2,arr[1]}'`
	file2_mt=`stat $file2 |grep ^Modify | awk '{split($3,arr,".");print $2,arr[1]}'`

	file1_mts=`date -d"$file1_mt" +%s`
	file2_mts=`date -d"$file2_mt" +%s`

	# file1_dir=$(dirname $file1)
	# file2_dir=$(dirname $file2)

	if [ $file1_mts -gt $file2_mts ];then
	{
		echo -e "[$file1][$file1_mt]\n>\n[$file2][$file2_mt]"
		return 2
	}
	elif [ $file1_mts -lt $file2_mts ];then
	{
		echo -e "[$file2][$file2_mt]\n>\n[$file1][$file1_mt]"
		return 1
	}
	else
	{
		echo -e "[$file2][$file2_mt]\n=\n[$file1][$file1_mt]"
		return 0
	}
	fi
}

# shell判别实现的文件更新命令
function cmp_mv_file()
{
	local src=$1
	local dst=$2

	cmp_newer $src $dst
	cres=$?
	if [ $cres -eq 1 ];then
		rsync.exe -u -avP $dst $src
	elif [ $cres -eq 2 ];then
		rsync.exe -u -avP $src $dst
	else
		iwarn "same do nothing"
	fi
}

# shell判别实现的文件夹更新命令
function cmp_mv_dir()
{
	iinfo "文件加同步测试"
	local dir1=$1
	local dir2=$2
	if [ ! -d $dir1 -o ! -d $dir2 ];then
		echo "$1,$2 must be dir"
		return 1
	fi

	cd $dir1 &&	files1=$(find . -type f)
	cd $dir2 && files2=$(find . -type f)
	echo "$files1"
	echo "$files2"

	declare -A dict1
	for file in $files1;do
		local file=${file:2}
		local fpath=$(dirname $file)
		local fname=$(basename $file)
		local istarget_dir="$dir2/$fpath"
		local istarget_file="$dir2/$file"
		if [ ! -d $istarget_dir -o ! -f $istarget_file ];then
			mkdir -p $istarget_dir
			cp "$dir1/$file" ${istarget_file}
			iinfo "创建目录${istarget_dir},并复制文件${dir1}/${file}过去"
		else
			cmp_mv_file "$dir1/$file" ${istarget_file}
			iinfo "比较两个文件的新旧"
		fi
	done

	declare -A dict12
	for file in $files2;do
		local file=${file:2}
		local fpath=$(dirname $file)
		local fname=$(basename $file)
		local istarget_dir="$dir1/$fpath"
		local istarget_file="$dir1/$file"
		if [ ! -d $istarget_dir -o ! -f $istarget_file ];then
			mkdir -p $istarget_dir
			cp "$dir2/$file" ${istarget_file}
			iinfo "创建目录${istarget_dir},并复制文件${dir2}/${file}过去"
		else
			cmp_mv_file "$dir2/$file" ${istarget_file}
			iinfo "比较两个文件的新旧"
		fi
	done

}

# rsync实现的文件和文件夹更新命令
function cmp_mv_rsync()
{
	local src=$1
	local dst=/tmp
	rsync.exe -u -e 'ssh -p 122' -avP $src root@localhost:$dst
}