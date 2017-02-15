#/bin/bash

function pro()
{
    fileName=$0
    lineContent=$1
    lineNum=$2
	wordA=$3
	wordB=$4
	numA=`echo $lineContent|sed 's/\(${wordA}\)/\1\n/g'| grep -i -w ${wordA} | wc -l`
	numB=`echo $lineContent|sed 's/\(${wordB}\)/\1\n/g'| grep -i -w ${wordB} | wc -l`
	if [[ $numA == $numB ]]; then
		...
	else
		echo -e "Error:[$fileName]:[\t$lineNum:\t$lineContent]"
	fi
}
function starectify()
{
	# 统计文件
	allfiles=`find . -type f -name "shet.txt" -print`
	[ -z $allfiles ]&& echo "no file find" && exit -1
	
	wordA="setSize"
	wordB="resetSize"

	for file in allfiles; do
		cat $file | awk "BEGIN{print '--start--'}{pro $file $0 NR  $wordA $wordB}END{print '---end---'}"
	done
}

starectify