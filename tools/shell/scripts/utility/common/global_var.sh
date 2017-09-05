#########################################################################
# File Name: global_var.sh
# Description:shell全局变量配置
# Author:tuling56
# State:持续更新中.....
# Created_Time: 2017-05-26 14:07
# Last modified: 2017-05-26 02:09:20 PM
#########################################################################
#!/bin/bash

sl='grep -i --exclude-dir=\.svn --exclude-dir=".git" -Rl --color'
sn='grep -i --exclude-dir=\.svn --exclude-dir=".git"  -Rn --color'

ld='find . -maxdepth 1 -type d|grep -v "^.$"'
lf='find . -maxdepth 1 -type f'
t2s="sed -i 's/\t/    /g'"

