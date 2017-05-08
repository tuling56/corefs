#!/bin/bash
cd "$(dirname $0)"
date=$1
[ -z "$date" ]&&date=$(date -d"-1 day" +%Y%m%d)


function arr1()
{
    for item in type subtype team group member year;do
        sql="use snh48;insert into exists snh48_listtag_click select date,'$item',$item,count(*) from snh48_listtag_click_detail where date=${date} group by $item;"
        echo "$sql"
    #	${MYSQL10} -e "${sql}"
    done
}


# 字符串处理成数组
function arr2()
{
    local a="1,2,3,5,5"
    a_arr_str=${a//,/ }
    echo $a_arr_str
    a_arr=(${a//,/ })
    echo ${a_arr[@]}

}


# 测试入口
arr2


exit 0
