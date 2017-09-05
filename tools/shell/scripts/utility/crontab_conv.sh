#########################################################################
# File Name: convtab2space.sh
# Description:定期转换tab为4个空格
# Author:tuling56
# State:文件名中含空格的暂时无法处理
# Created_Time: 2017-09-94 10:13
# Last modified: 2017-09-04 06:05:14 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
BASH_WORKSPACE=${BASH_WORKSPACE:-"/cygdrive/e/Code/Git/shared_common_libs/tools/shell/scripts/utility/"}
source ${BASH_WORKSPACE}/common/global_var.sh
cd $dir

echo "`date +%F\ %T: `tab转换为4个空格"

cd /cygdrive/e/Code/Git/Python/

# 方法1:无法处理名字中包含空格的问题
function method1()
{
	find . -type f -mtime -7 -name *.py
	sed -i 's/\t/    /g'  $(find . -type f -name "*.py")
}


# 方法2：解决了文件名中包含空格的问题
function method2()
{
	find . -type f -mtime -7 -name "*.py"|while read f;do
		sed -i 's/\t/    /g'  "$f"
		echo "$f"
	done
}

method2

exit 0
