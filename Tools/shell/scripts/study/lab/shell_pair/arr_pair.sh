#!/bin/bash
cd `dirname $0`


# 从文件的两列构建关联数组
function build_pair_from_file()
{
	declare -A srcdb
	db=(`cut -f1 db_tbl.conf|xargs`)
	tbl=(`cut -f2 db_tbl.conf|xargs`)

	if [ ${#db[@]} -ne ${#tbl[@]} ];then
		echo "构建字典的两个源数组的长度必须相同"
		return
	fi

	echo ${db[@]}
	echo ${tbl[@]}

	for db in ${db[@]};do
		for tbl in ${tbl[@]};do
			srcdb[$db]=$tbl
			echo -e $db"\t"$tbl
		done
	done


	for tbl in ${tbl[@]};do
		srcdb[$tbl]="${db[@]}"
		echo ${srcdb[$tbl]}
	done
}


# 从shell的两个数组构建关联数组
function build_pair_from_arr()
{
	p1=('a' 'b' 'c' 'd' 'e')
	p2=(1 2 3 4 5)

	if [ ${#p1[@]} -ne ${#p2[@]} ];then
		echo "构建字典的两个源数组的长度必须相同"
		return
	fi

	declare -A pair

	# 方法1:使用辅助下标
	i=0
	for item in ${p1[@]};do
		pair[$item]=${p2[$i]}
		i=$((i+1))
		echo "pair["$item"]"=${pair[$item]}
	done

	# echo ${pair[@]}

	# 方法2：
	# 暂时没有想到第二种实现方式
}

# 主入口
build_pair_from_file
build_pair_from_arr

exit 0