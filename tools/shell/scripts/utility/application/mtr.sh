#########################################################################
# File Name: mtr.sh
# Description:行列转置
# Author:tuling56
# State:
# Created_Time: 2017-11-02 13:01
# Last modified: 2017-11-14 02:32:35 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir

inputf=$1

inseq="\t"
outseq="\t"

#纯shell解决方案(内存超过:列超长)
function mtr_bash()
{
    iinfo "纯bash解决方案"
    headrow=($(head -1 $inputf))
    colnum=${#headrow[*]}
    for c in $(seq 1 $colnum);do
        if [ "$inseq" = "\t" ];then
            #cut -f$c $inputf |paste -d"$outseq" -s
            cut -f$c $inputf |tr '\n' ' '
        else
            #cut -d"$inseq" -f$c $inputf |paste -d"$outseq" -s
            cut -d"$inseq" -f$c $inputf |tr '\n' ' '
        fi
    done
}

#awk解决方案(输出不对)
function mtr_awk()
{
    iinfo "awk解决方案"
    #awk 'BEGIN{while(i<=NF){"col"i="";}}{while(i<=NF){"col"i="col"i" "$i;}}END{while(i<=NF){print "col"i"\n";}}' file.txt
    awk '{i=1;
          while(i<=NF){
            col="col"i;
            a[col]=a[col]" "$i;
            i=i+1;
            }
         }
         END{
            for(v in a){
                print substr(a[v],2);
            }
        }' $inputf
}

#awk解决方案2
function mtr_awk2()
{

    return 
}


# 测试入口
mtr_bash
mtr_awk
mtr_awk2


exit 0

