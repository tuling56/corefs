#!/bin/bash
# 区间统计（自动参数设置）
# 日期:2017年5月2日
# 作者：tuling56
# 测试数据：dur_stat.data

durseq=$1
colnum=$2
file=$3

echo -e"\e[1;31m区间分布统计\e[0m"
echo "-----------------输入信息如下:---------------------------------"
echo "步长durstep:$durseq"
echo "统计列colnum:$colnum"
echo "输入file:$file"
echo "-----------------统计结果如下:---------------------------------"

# 方法1:直接运行
awk -v durseq=$durseq -v colnum=$colnum 'BEGIN{}
                                        { 
                                            v=int($colnum/durseq);
                                            dur[v]++;
                                        }
                                        END{
                                            for(i in dur){
                                                 print "["i*durseq"~"(i+1)*durseq")\t"dur[i]"\t",substr(dur[i]*100/NR,1,5)"%"|"sort -t\"~\" -n -k1.2|column -t";
                                            }
                                        }'	$file 


# 方法2:引用awk脚本
# awk -f "/usr/local/shell/bin/dur_stat.awk"  "durseq=$durseq"  "colnum=$colnum"  $file


exit 0
