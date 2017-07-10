#!/bin/bash
cd `dirname $0`



function build_pair_from_file()
{
	declare -A srcdb
	db=(`cut -f1 db_tbl.conf|xargs`)
	tbl=(`cut -f2 db_tbl.conf|xargs`)

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


function build_pair_from_arr()
{
	p1=('a' 'b' 'c' 'd' 'e')
	p2=(1 2 3 4 5 6)


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

}


build_pair_from_arr

exit 0