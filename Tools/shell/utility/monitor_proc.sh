#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

# ### monitor.sh
PROC_NAME="isearch"				 # 这里是你要监控的进程名
NUM=`ps aux|grep -v grep|grep $PROC_NAME|wc -l`  # 查询进程名，然后屏蔽掉grep， wc统计结果行数
if [ $NUM -eq 0 ];then                           # 如果是0 证明进程不在，重启这个进程即可。
	sleep 3
	cd /var/yuqing_4.0/isearch/bin		 # 程序所在目录
	echo "now start ${PROC_NAME}"
	nohup ./isearch.8056 >/dev/null 2>&1	 # 使用nohup启动
	sleep3
else
	echo "the isearch is alive"
fi

# ### watch_monitor.sh
PROC_NAME="monitor"
NUM=`ps aux|grep -v grep|grep $PROC_NAME|wc -l`
if [ $NUM -eq 0 ];then
	cd /var/yuqing_4.0/isearch
	echo "now start monitor script"
	nohup watch sh monitor.sh > /dev/null 2>&1   # 这个脚本跟上面大同小异，只是这里使用watch 监控。
	sleep3
else
	echo "the isearch monitor script is alive"
fi


exit 0
