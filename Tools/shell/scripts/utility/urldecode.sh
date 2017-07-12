#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

# ### 功能：urldecode

#	\# 用来标志特定的文档位置 %23
#	% 对特殊字符进行编码 %25
#	& 分隔不同的变量值对 %26
#	+ 在变量值中表示空格 %2B
#	\ 表示目录路径 %2F
#	= 用来连接键和值 %3D
#	? 表示查询字符串的开始 %3F

declare -A map
map['%20']=' '
map['%23']='\#'
map['%25']='%'
map['%26']='&'
map['%2B']='+'
map['%2C']=','
map['%2D']='-'
map['%2F']='/'
map['%3A']=':'
map['%3D']='='
map['%3F']='?'
map['%5F']='_'

replace="sed - "
for item in ${!map[*]};do
	# echo "replace $item to ${map[$item]}"
	replace="$replace -e 's|${item}|${map[$item]}|g'"
done
replace=${replace%g*}"gp'"
# echo $replace


while read line;do
	echo "echo $line | $replace" |bash
done< url.data


