#########################################################################
# File Name: testdir.sh
# Description: 
# Author:tuling56
# State:
# Created_Time: 2017-05-18 19:51
# Last modified: 2017-05-18 07:56:05 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

file=$1

echo "global_curdir:"$dir
echo "global_filename:"`basename $0`




