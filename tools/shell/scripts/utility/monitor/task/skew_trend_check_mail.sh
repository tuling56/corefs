#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
source /usr/local/sandai/server/bin/common/global_var.sh
cd $dir

date=$1
[ -z $date ]&&date=`date -d "-1 day" +%Y%m%d`
#echo "CalcDay:"$date

lastwdate=$(date -d"-7 day" +%Y%m%d)

datapath=${dir/\/bin/\/data}
[ ! -d $datapath ]&&mkdir -p $datapath

# 同类型源倾斜检测
function skew_check()
{
        ## 当天
        # t源
        sel="sum(case when srcdb='pgv3_split_t1' then datasize else 0 end) as 'pgv3_split_t1',sum(case when srcdb='pgv3_split_t2' then datasize else 0 end) as 'pgv3_split_t2'"
        sql="select $sel from xmp_habor.xmp_source_stat where date='$date' and srcdb in ('pgv3_split_t1','pgv3_split_t2') group by date;"
        #echo "$sql"
        ts=(`${MYSQL10} -e "$sql"`)
        #echo "${ts[*]}"
        echo "${ts[*]}" | awk '{c=($1-$2)/($1+$2);if(c>0.02 || c<-0.02) printf("pgv3_split_t[12]源不均衡程度（2*差/和）%0.2f%%\n",c);}'

        # c源
        sel="sum(case when srcdb='pgv3_split_c1' then datasize else 0 end) as 'pgv3_split_c1',sum(case when srcdb='pgv3_split_c2' then datasize else 0 end) as 'pgv3_split_c2'"
        sql="select $sel from xmp_habor.xmp_source_stat where date='$date' and srcdb in ('pgv3_split_c1','pgv3_split_c2') group by date;"
        #echo "$sql"
        cs=(`${MYSQL10} -e "$sql"`)
        #echo "${cs[*]}"
        echo "${cs[*]}" | awk '{c=($1-$2)/($1+$2);if(c>0.09 || c<-0.09) printf("pgv3_split_c[12]源不均衡程度（2*差/和）%0.2f%%\n",c);}'

        # kk源
        sel="sum(case when srcdb='kk_xmp_stat_tel' then datasize else 0 end) as 'kk_xmp_stat_tel',sum(case when srcdb='kk_xmp_stat_cnc' then datasize else 0 end) as 'kk_xmp_stat_cnc'"
        sql="select $sel from xmp_habor.xmp_source_stat where date='$date' and srcdb in ('kk_xmp_stat_tel','kk_xmp_stat_cnc') group by date;"
        #echo "$sql"
        kks=(`${MYSQL10} -e "$sql"`)
        #echo "${kks[*]}"
        echo "${kks[*]}" | awk '{c=($1-$2)/($1+$2);if(c>0.15 || c<-0.15) printf("kk_xmp_stat_[tel/cnc]源不均衡程度（2*差/和）%0.2f%%\n",c);}'

        ## 上周
        # t源
        sel="sum(case when srcdb='pgv3_split_t1' then datasize else 0 end) as 'pgv3_split_t1',sum(case when srcdb='pgv3_split_t2' then datasize else 0 end) as 'pgv3_split_t2'"
        sql="select $sel from xmp_habor.xmp_source_stat where date='$lastwdate' and srcdb in ('pgv3_split_t1','pgv3_split_t2') group by date;"
        #echo "$sql"
        lw_ts=(`${MYSQL10} -e "$sql"`)
        #echo "${lw_ts[@]}"
        #echo $lw_ts | awk '{c=($1-$2)/($1+$2);if(c>0.10) printf("%0.2f%%\n",c);}'

        # c源
        sel="sum(case when srcdb='pgv3_split_c1' then datasize else 0 end) as 'pgv3_split_c1',sum(case when srcdb='pgv3_split_c2' then datasize else 0 end) as 'pgv3_split_c2'"
        sql="select $sel from xmp_habor.xmp_source_stat where date='$lastwdate' and srcdb in ('pgv3_split_c1','pgv3_split_c2') group by date;"
        #echo "$sql"
        lw_cs=(`${MYSQL10} -e "$sql"`)
        #echo "${lw_cs[@]}"
        #echo $lw_cs | awk '{c=($1-$2)/($1+$2);if(c>0.10) printf("%0.2f%%\n",c);}'

        # kk源
        sel="sum(case when srcdb='kk_xmp_stat_tel' then datasize else 0 end) as 'kk_xmp_stat_tel',sum(case when srcdb='kk_xmp_stat_cnc' then datasize else 0 end) as 'kk_xmp_stat_cnc'"
        lw_sql="select $sel from xmp_habor.xmp_source_stat where date='$lastwdate' and srcdb in ('kk_xmp_stat_tel','kk_xmp_stat_cnc') group by date;"
        #echo "$sql"
        lw_kks=(`${MYSQL10} -e "$sql"`)
        #echo "${lw_kks[@]}"
        #echo $lw_kks | awk '{c=($1-$2)/($1+$2);if(c>0.10) printf("%0.2f%%\n",c);}'
}

function trend_check()
{
    t1=${ts[0]}
    t2=${ts[1]}
    c1=${cs[0]}
    c2=${cs[1]}
    kkt=${kks[0]}
    kkc=${kks[1]}

    lw_t1=${lw_ts[0]}
    lw_t2=${lw_ts[1]}
    lw_c1=${lw_cs[0]}
    lw_c2=${lw_cs[1]}
    lw_kkt=${lw_kks[0]}
    lw_kkc=${lw_kks[1]}

    #echo "ts源:${ts[*]}"
    #echo "cs源:${cs[*]}"
    #echo "kks源:${kks[*]}"
    #echo "lw_ts源:${lw_ts[*]}"
    #echo "lw_cs源:${lw_cs[*]}"
    #echo "lw_kks源:${lw_kks[*]}"

    echo -e "$t1\t$lw_t1" | awk '{c=($1-$2)*100/$2;if(c<-5) printf("pgv3_split_t1源周同比下降%4.2f%%\n",c);}END{}'
    echo -e "$t2\t$lw_t2" | awk '{c=($1-$2)*100/$2;if(c<-5) printf("pgv3_split_t2源周同比下降%4.2f%%\n",c);}END{}'
    echo -e "$c1\t$lw_c1" | awk '{c=($1-$2)*100/$2;if(c<-5) printf("pgv3_split_c1源周同比下降%4.2f%%\n",c);}END{}'
    echo -e "$c2\t$lw_c2" | awk '{c=($1-$2)*100/$2;if(c<-5) printf("pgv3_split_c2源周同比下降%4.2f%%\n",c);}END{}'
    echo -e "$kkt\t$lw_kkt" | awk '{c=($1-$2)*100/$2;if(c<-5) printf("kk_xmp_stat_tel源周同比下降%4.2f%%\n",c);}END{}'
    echo -e "$kkc\t$lw_kkc" | awk '{c=($1-$2)*100/$2;if(c<-5) printf("kk_xmp_stat_cnc源周同比下降:%4.2f%%\n",c);}END{}'
}




# 测试入口
skew_check  > $datapath/skewtrend_check_$date
trend_check >> $datapath/skewtrend_check_$date


## step3: 邮件报警 ###########
logw=$datapath/skewtrend_check_$date
logu="源数据量下降和不均衡报警 [$date from $(hostname)]"
logucn=$(echo $logu | iconv -f utf-8 -t GBK)
MAIL_TO="yuanjunmiao@cc.sandai.net luochuan@cc.sandai.net"
if [ -s $logw ];then
   logm="`cat $logw`"
   logm="$logm\n\n请前往哈勃数据中心源量统计查看:http://tongji.xunlei.com/auto_plain?reportId=104352&elmId=209527&productId=-111018"
   logmcn=$(echo "$logm"| iconv -f utf-8 -t GBK)
   ${SENDMAIL} -t ${MAIL_TO} -u "$logucn" -m "$logmcn" -a "$logw"
else
   cd $datapath && rm -f skewtrend_check_$date
fi


exit 0