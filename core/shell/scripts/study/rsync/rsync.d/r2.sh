#########################################################################
# File Name: r2.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-12-26 13:45
# Last modified: 2017-12-26 01:45:41 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir


echo r2:$(date)
