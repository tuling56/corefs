#########################################################################
# File Name: mysql_tool.sh
# Description:mysql的shell处理工具 
# Author:tuling56
# State:
# Created_Time: 2017-12-19 10:47
# Last modified: 2017-12-19 10:59:35 AM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
COMMON_PATH=${COMMON_PATH:-/usr/local/shell/bin/common}
source $COMMON_PATH/global_fun.sh
source $COMMON_PATH/global_var.sh
cd $dir


# 批量修改mysql的存储引擎
function change_engine_batch()
{

    sql="select table_schema,table_name from information_schema.tables where table_type='base table' and engine='innodb' and table_schema!='mysql' and table_name not like '%innodb%';"
    db_tables="$(echo $sql|${MySQL} -N)"
    while read db table;do
        usql="use $db;alter table $table engine=MyISAM;"
        echo "$usql"
        ${MYSQL} -e "${usql}"
        ret=$?
        [ "$ret" -ne "0" ]&&ierror "修改${db}.${table}引擎失败"
    done<<<"$db_tables"

}

# 




# 程序入口
change_engine_batch
