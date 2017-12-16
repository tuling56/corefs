#########################################################################
# File Name: compile_install.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-12-14 13:39
# Last modified: 2017-12-14 01:39:55 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir


./configure --prefix=/usr/local/apache --enable-so  --enable-proxy --enable-rewrite --enable-ssl --enable-cgi --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-pcre=/usr/local/pcre  
make & make install
