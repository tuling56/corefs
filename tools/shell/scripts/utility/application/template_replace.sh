#!/bin/bash
# sql文件参数替换

sqlf=template.sql

cp  $sqlf  ${sqlf}.bak
ret=$?
[ "$ret" -ne "0" ]&&exit $ret

sed -i -e 's/start_ftime/20171101/g'  -e 's/end_ftime/20171130/g' $sqlf
cat $sqlf
mv  ${sqlf}.bak  $sqlf

exit 0
