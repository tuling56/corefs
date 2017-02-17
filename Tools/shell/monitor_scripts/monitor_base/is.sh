#!/bin/bash

dir="/usr/local/monitor-base"

if [ ! -f "$dir/bin/getflowload" ]
then
    echo "make getflowload"
    $dir/src/make.sh
fi

center=`$dir/bin/getcmd.sh center 1`
if [ "$center" == "" ]
then
    echo "search center"
    $dir/bin/search_center.sh
fi
