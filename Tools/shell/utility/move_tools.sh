#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

# function:mainly used for file classification

set -e

# 文件归类
function mv_folder()
{
	ls 201*|while read i;do
		[ -d "$i" ]&&  continue
		echo -e "\e[1;31mNOW:\e[0m" "$i"
		cdir=`echo "$i" |awk -F'-' '/^20/{print $1"-"$2}'`
		[ ! -d $cdir ] && mkdir $cdir
		echo "mv $i $cdir"
		mv $i $cdir
	done
}

# 创建SUMMARY.md
function create_summary()
{
	for d in `ls -F |grep "/$"`;do
		if [[ "$d" =~ book ]];then
			continue
		fi

		echo "* [$d]"
		cd $d
		ls *.md|while read f;do
			echo -e "\t - [$f]($d$f)"
		done
		cd - >/dev/null 2>&1
	done
}


function test()
{

	for d in `ls -F |grep "/$"`;do
		if [[ "$d" =~ book ]];then
			echo -e "\033[1;31m击中:\033[0m"$d
			continue
		else
			echo $d
		fi
	done
}


# ### 击中
test

# create_summary>SUMMARY.md

exit 0
