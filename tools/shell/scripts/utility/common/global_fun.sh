#########################################################################
# File Name: global_fun.sh
# Description:shell全局函数
# Author:tuling56
# State:
# Created_Time: 2017-05-09 17:12
# Last modified: 2017-10-26 10:00:01 AM
#########################################################################
#!/bin/bash


########################### 信息显示 ##########################
nt=$(date +%Y%m%d\ %H:%M:%S)
nt2=$(date +%F\ %T)

# 区别显示
function istep()
{
    local info=$1
    echo -e "\e[1;31mstep:$info\e[0m-->$nt2"
}

function ilog()
{
    local info=$1
    echo -e "[$nt]$info"
}

function ierror()
{
    local info=$1
    echo -e "\e[1;31m[$nt]$info\e[0m"
}

function iwarn()
{
    local info=$1
    echo -e "\e[1;33m[$nt]$info\e[0m"
}

function isucc()
{
    local info=$1
    echo -e "\e[1;32m[$nt]$info\e[0m"
}

function iinfo()
{
    local info=$1
    echo -e "\e[1;34m[$nt]$info\e[0m"
}

function ihigh()
{
    local info=$1
    echo -e "\e[1;35m[$nt]$info\e[0m"
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
