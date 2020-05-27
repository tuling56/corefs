#########################################################################
# File Name: deleltepyc.sh
# Description:定期清除pyc和log文件
# Author:tuling56
# State:
# Created_Time: 2017-06-16 10:13
# Last modified: 2017-06-21 06:05:14 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
BASH_WORKSPACE=${BASH_WORKSPACE:-"/cygdrive/e/Code/Git/shared_common_libs/tools/shell/scripts/utility/"}
source ${BASH_WORKSPACE}/common/global_var.sh
source ${BASH_WORKSPACE}/common/global_fun.sh
cd $dir

echo "`date +%F\ %T: `清除pyc和log文件"

cd /cygdrive/e/Code/Git/Python/Projects

function delpyc()
{
	find . -type f \( -name "*.pyc" -o -name "*.log" \)
	find . -type f \( -name "*.pyc" -o -name "*.log" \) -exec rm {} \;
	#find . -type f -name "*.log" -exec rm {} \;
}

delpyc


exit 0
