#########################################################################
# File Name: w2lx.sh
# Description:windows格式的文件转变成linux格式并赋予执行权限 
# Author:tuling56
# State:
# Created_Time: 2017-05-18 15:35
# Last modified: 2017-05-18 03:37:08 PM
#########################################################################
#!/bin/bash

file=$1

dos2unix $file
chmod u+x $file

exit 0

