#########################################################################
# File Name: minotify.sh
# Description: 文件检测工具inotify学习
#             https://www.toutiao.com/i6503742233206850061/
# Author:tuling56
# State:
# Created_Time: 2017-12-28 10:14
# Last modified: 2017-12-28 10:23:46 AM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir


function mi()
{
    DESTHOST=172.16.100.6
    DESTHOSTDIR=/www/htdocs/
    SRCDIR=/www/htdocs/
    inotifywait -mr --timefmt '%d/%m/%y %H:%M' --format '%T %w %f' -e create,delete,modify,attrib $SRCDIR | while read DATE TIME DIR FILE; do 
        $FILECHANGE=${DIR}${FILE}
        rsync -avze 'ssh' $SRCDIR root@${DESTHOST}:${DESTHOSTDIR} &>/dev/null && 
        echo "At ${TIME} on ${DATE}, file $FILECHANGE was backed up via rsync" >> /var/log/filesync.log
    done
}


mi

exit
