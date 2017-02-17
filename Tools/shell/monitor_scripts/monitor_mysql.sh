#!/bin/sh
Dir="/tmp"
Log="$Dir/mysql.log"
i=0
pcount=0
[ ! -f ${Log} ] && touch ${Log}

while [ $i -lt 3 ]
do
    i=$(($i+1))

    pcount=` ps aux |grep mysql.sock |grep datadir|wc -l`
    echo "#${i}: $pcount"
    if [ $pcount -ne 1 ];then
           sleep 2
           continue
    fi

   break;
 done

datetime=`date +'%Y%m%d %H:%M:%S'`

if [ $pcount -ne 1 ];then
        echo -e "\033[31m$DATE mysql is down!\033[0m"
        echo -e "\033[31m${datetime} start mysql now\033[0m" 
        echo -e "\033[31m${datetime} start mysql  now\033[0m" > ${Log}
	/usr/local/mysql/bin/mysqld_safe  --user=mysql &
fi

