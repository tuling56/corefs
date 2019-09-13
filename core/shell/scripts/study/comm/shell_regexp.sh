#########################################################################
# File Name: shell_regexp.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-11-02 14:40
# Last modified: 2017-11-02 02:56:53 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir


function shell_regexp()
{
    # 基础shell
    while read line;do
        if [ [[ "$line" =~ "[0-9]{3}-[0-9]{3}-[0-9]{3}" ]] -o [[ "$line" =~ "([0-9]{3}) [0-9]{3}-[0-9]{3}" ]] ];then
            echo "$line"
        fi
    done<file.txt
}

function awk_regexp()
{
    #awk '$0~/[0-9]{3}-[0-9]{3}-[0-9]{3}/{print $0}' file.txt
    awk '$0~/^[0-9]{3}-[0-9]{3}-[0-9]{3}$/ || $0 ~/^\([0-9]{3}\) [0-9]{3}-[0-9]{3}$/{print $0}' file.txt
}


#shell_regexp
awk_regexp


exit 0
