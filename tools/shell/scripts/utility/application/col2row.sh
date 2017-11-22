#########################################################################
# File Name: col2row.sh
# Description:列转行 
# Author:tuling56
# State:（注意awk中的注释）
# Created_Time: 2017-11-22 11:49
# Last modified: 2017-11-22 02:11:37 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir

file=$1
[ -z $file ]&&echo "please input file"&& exit 1
frontrow=$2
[ -z $frontrow ]&&frontrow=1


function col2row()
{
    local file=$1
    local frontrow=$2

    awks='BEGIN{
            #print "begin:"frow;
          }
          {
              # 列名获取
              if(NR==1){
                for(i=1;i<=NF;++i)
                    headers[i]=$i;
                next;
              }
              
              # 行头部
              rowf=$1;
              for(j=2;j<=frow;j++)
                 rowf=rowf"\t"$j;
              #print "rowf:"rowf;
              
              for(i=frow+1;i<=NF;++i){
                printf("%s\t%s\t%s\n",rowf,headers[i],$i);
              }
          }
          END{
            #print "done"
          }'
    
    awk -v frow=$frontrow "$awks" $file
}


col2row $file $frontrow

exit 0
