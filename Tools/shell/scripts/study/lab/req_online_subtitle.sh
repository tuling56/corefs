#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
source /usr/local/sandai/server/bin/common/global_var.sh
cd $dir

set -e

if [ -z $1 ];then
        dt=`date -d"-1 day" +%Y%m%d`
else
        dt=$1
fi

datapath="."

function method_1()
{

    awk -v date=$date -F',' '{print $4;if(NR==FNR){a[$4]=$0;num=0;}else{print $1;if($1 in a) {print a[$1]",Yes";num++;}else print a[$1]",No";}}' hoturl_cid.csv  $datapath/play_subtitle_cido_${date} #> hoturl_cid_hit.csv

}


function method_2()
{
    while read line;do
        lines=${line//,/ }
        echo $lines
        local date=`echo $line|awk -F"," '{print $1}'`
        local cid=`echo $line|awk -F"," '{print $4}'`
        ishit=`grep -c $cid $datapath/play_subtitle_cid_distinct_${date}`
        if [ "$ishit" -ne "0" ];then
                echo -e "$line,Yes"
        else
                echo -e "$line,No"
        fi
    done < hoturl_cid.csv
}

function main()
{
	start_date=`date -d"-4 day" +%Y%m%d`
	end_date=`date -d"-2 day" +%Y%m%d`
	while [[ $start_date -le $end_date ]];do
		echo -e "\e[1;31mstep:\e[0m"$start_date
		export_cid ${start_date}
		start_date=`date -d${start_date}"+1 day" +%Y%m%d`
	done
}


# 程序入口
#main
calc_overlap


cd -
exit 0
