#########################################################################
# File Name: dumplicate_col_filer.sh
# Description:筛选出某一列重复的那些行 
# Author:tuling56
# State:
# Created_Time: 2017-11-16 14:57
# Last modified: 2017-11-16 03:33:57 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir

file=$1
[ -z $file ]&&echo "please input file" && exit 1
col=$2
[ -z $col ]&&col=1


# 筛选出某一列重复的那些行
function filter_row_by_dumplicate_col()
{
    awk -v col=$col   '{
                            a[$col]=a[$col]"\n"$0;
                            num[$col]+=1;
                       }
                        END{
                            for(c in num){
                                if(num[c]>1) 
                                    print a[$col];
                            }
                        }' $file |sed -n '2,$p'
}


filter_row_by_dumplicate_col $file $col 


# 测试用例
#  ../../study/uniq/uniq.data 1


exit 0
