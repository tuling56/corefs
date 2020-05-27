#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
source /usr/local/sandai/server/bin/common/global_var.sh
cd $dir


#  Have one argument,the argument is a directory
function checkisdir()
{
    for i in `ls $1 | sed -e 's/ /\n/g'`
    do
        if [ -d $1/$i ];then
            if [ $i == "bin" -o $i == "lib" -o $i == "include" ];then  # 不想检测的目录(这里是使用virtualenv生成的环境文件)
                continue
            fi
            dir="$1/$i"
            checkisdir $dir
        else
            files=$files'\n'$1'/'$i
        fi
    done
    echo -e $files
}

# 循环监测
while true;do
    if [ -e /tmp/stat.tmp ];then
        for i in `checkisdir $1`;do
            if [ -e /tmp/patch.tmp ];then
                stat $i | grep Change > /tmp/nstat.tmp
                rm -f /tmp/patch.tmp
                continue
            fi
            stat $i | grep Change >> /tmp/nstat.tmp
        done
        diff /tmp/stat.tmp /tmp/nstat.tmp > /tmp/patch.tmp
        if [ $? -eq 0 ];then
            sleep 10
        else
            /etc/init.d/uwsgi.py restart          # 将此处更改为想要做的操作
            patch /tmp/stat.tmp /tmp/patch.tmp
        fi
    else
        for i in `checkisdir $1`;do
            stat $i | grep Change >> /tmp/stat.tmp
        done
        continue
    fi
done