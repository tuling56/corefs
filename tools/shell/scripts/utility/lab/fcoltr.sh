#########################################################################
# File Name: fcoltr.sh
# Description:首列转换 
# Author:tuling56
# State:
# Created_Time: 2017-11-17 13:10
# Last modified: 2017-11-17 01:20:45 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir

file=$1

function shell_tr()
{
    
    return 
}



function awk_tr()
{
    local file=$1

    awk '{
            for(i=1;i<NF;++i){
                if(i==1)
                    printf("%s/%s/%s",substr($1,1,4),substr($1,5,2),substr($1,7,2));
                else
                    printf("\t%s",$i);
            }
            print "";
         }
         END{
            
        }' $file
    return
}


awk_tr $file
