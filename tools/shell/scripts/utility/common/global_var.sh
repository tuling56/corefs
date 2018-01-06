#########################################################################
# File Name: global_var.sh
# Description:shell全局变量配置
# Author:tuling56
# State:全局变量
# Created_Time: 2017-05-26 14:07
# Last modified: 2017-10-26 03:01:39 PM
#########################################################################
#!/bin/bash

# 文件和目录
sl='grep -i --exclude-dir=\.svn --exclude-dir=".git" -Rl --color'
sn='grep -i --exclude-dir=\.svn --exclude-dir=".git"  -Rn --color'

ld='find . -maxdepth 1 -type d|grep -v "^.$"'
lf='find . -maxdepth 1 -type f'


MYSQL="/usr/bin/mysql -uroot -proot -N"



# 工具
SENDMAIL="/usr/sbin/sendemail -s mail.cc.sandai.net -f monitor@cc.sandai.net -xu monitor@cc.sandai.net -xp 121212 -o message-charset=utf8 "