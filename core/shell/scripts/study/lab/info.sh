#!/bin/bash
cd `dirname $0`

set -e

start_date=20161224 # `date -d"-7 day" +%Y%m%d`
end_date=20161224   #`date -d"-1 day" +%Y%m%d`
while [[ $start_date -le $end_date ]];do
	echo -e "\e[1;31mstep:\e[0m"$start_date
	src_data=./data/barrage_proc_${start_date}
    awk -F,  -v dt=$start_date '{if($1~/upload/){total_num++;total_people[$6]=1;total_movie[$4_$5]=total_movie[$4_$5]+1;}}END{print "============="dt"信息汇总============";
    print dt"\t"total_num"\t"length(total_people)"\t"length(total_movie);
    for(k in total_movie){print k,total_movie[k]|"sort -r -n -k2|head";}}' upload.log
	start_date=`date -d${start_date}"+1 day" +%Y%m%d`
done


exit 0 
