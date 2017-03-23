## HIVE积累

[TOC]

### 基础

#### 命令行

```shell
# 静音模式
$HIVE_HOME/bin/hive -S -e 'select a.col from tab1 a'
# #加入-S，终端上的输出不会有mapreduce的进度，执行完毕，只会把查询结果输出到终端上。这个静音模式很实用，,通过第三方程序调用，第三方程序通过hive的标准输出获取结果集。

# 设置
set <key>=<value>	修改特定变量的值
注意: 如果变量名拼写错误，不会报错
set	输出用户覆盖的hive配置变量
set -v	输出所有Hadoop和Hive的配置变量

# 资源和分布式缓存
add FILE[S] <filepath> <filepath>* 
add JAR[S] <filepath> <filepath>* 
add ARCHIVE[S] <filepath> <filepath>*	添加 一个或多个 file, jar,  archives到分布式缓存
list FILE[S] 
list JAR[S] 
list ARCHIVE[S]	输出已经添加到分布式缓存的资源。
list FILE[S] <filepath>* 
list JAR[S] <filepath>* 
list ARCHIVE[S] <filepath>*	检查给定的资源是否添加到分布式缓存
delete FILE[S] <filepath>* 
delete JAR[S] <filepath>* 
delete ARCHIVE[S] <filepath>*

# 执行
! <command>	从Hive shell执行一个shell命令
source FILE <filepath>	在CLI里执行一个hive脚本文件
```



### 创建表

#### 文本格式存储
```sql
use kankan_odl;drop table if exists hive_table_templete;
create external table if not exists hive_table_templete(
  subid int,
  peerid string,
  movieid int)
partitioned by (ds string)
row format delimited
fields terminated by '\t'
stored as textfile;
```

#### 序列化格式存储
```sql
use kankan_odl;drop table if exists hive_table_templete;
create external table if not exists union_install(
   Fu1 string,
   Fu2 string,
   Fu8 string,
   Fu9 string,
   Fip string,
   Finsert_time int,
   isp string
  )
partitioned by (ds string,hour string)
row format delimited
fields terminated by '\u0001'
stored as inputformat
  'org.apache.hadoop.mapred.SequenceFileInputFormat'
outputformat
  'org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat'
```

### 查询

#### 基本查询

> 不嵌套，只使用最基本的，无关联

#### 子查询

```mysql
select a.mt,count(*) as cnt from (select from_unixtime(finsert_time,'yyyyMMdd HH:mm:ss') as mt from xmp_odl.xmp_pv where ds='20161206') a group by a.mt order by cnt desc;
```

#### 正则

```mysql
 select  'abc'  regexp '^[a-z]*$'   from test.dual;
```



####  连接

```mysql
insert overwrite table download_union.register_web_all partition(dt='$dt',stat_source='tel') 
select utmp.mac, utmp.userdetails, utmp.createdtime, utmp.productflag 
from (
	select t1.mac, t1.userdetails, t1.createdtime, t1.productflag from 
    
    (select concat(substring(peerid,0,12),'0000') as mac, userdetails, createdtime, productflag from dbl.tb1 t where t.ds='$dt' and fproduct_type='web' and fisp='tel') t1 
	left outer join  
    (select concat(substring(peerid,0,12),'0000') as mac, userdetails, createdtime, productflag from db2.tb2 where stat_source='tel' ) t2 
	on (t1.mac = t2.mac) 
	where t2.mac is null or t2.mac=null
) utmp;

# 解读：
# 其中utmp表是t1表和t2表关联的结果（t1表和t2进行左连接，连接条件是两个表的mac地址相等，且t2的mac地址为空）
# 其中t1表结果来自dbl.tb1，t2表结果来自db2.tb2
```



### 数据导入导出

#### 导入数据

```shell
ihql="use kankan_odl;delete from tbname where ds='${date}';load data local inpath  '/home/work/test.txt' into table tbname;"
${HIVE} -e "{chql}"
```

#### 导出数据

```shell
esql="use kankan_odl;select '{date}',fu3,fu2,count(*) from xmpcloud2 where ds='{date}' and length(fu4)=16 group by fu3,fu2;"
${HIVE} -e "{esql}" > datapath/xmp_cloud_{date}
```

- 导出数据到本地文件(并指定字段分割方式)

```sql
insert overwrite local directory '/tmp/xx' row format delimited fields terminated by '\t' select * from test;
```

- hive写本地数据

```sql
insert overwrite local directory '/data/access_log/access_log.45491' row format delimited fields terminated by ' ' collection items terminated by ' ' select *
```

### 属性修改

#### 分区操作

##### 显示分区

`use xmp_odl;show partitions $tbl partition(ds='$date');`

##### 添加分区
`use xmp_odl;alter table $tbl add if not exists partition (ds='$date',hour='$hour');`

##### 删除分区
`use xmp_odl;alter table $tbl drop if exists partition(ds='20160808',hour='00');`

##### 修改分区
```sql
use xmp_odl;alter table $tbl partition(ds='20160808',hour='00') set location "/user/kankan/warehouse/..."
use xmp_odl;alter table $tbl partition(ds='20160808',hour='00') rename to partition(ds='20160808',hour='01')
```

#### 列操作


##### 添加列
`use xmp_odl;alter table $tbl add columns(col_name string);`

##### 修改列
`use xmp_odl;alter table $tbl change col_name newcol_name string [after x][first];`

##### 删除列

`use xmp_odl;alter table $tbl drop?`

#### 表操作

##### 表重命名

`use xmp_odl;alter table $tbl rename to new_tbl_name;`

##### 修改存储属性

```sql
# 修改存储格式
alter TABLE  pusherdc   SET FILEFORMAT
INPUTFORMAT "org.apache.hadoop.mapred.SequenceFileInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat";

# 修改字段分割方式
alter table xmp_subproduct_install set SERDEPROPERTIES('field.delim' = '\u0001');
```

##### 删除表

> 对外部表（存储在本地文件系统）和内部表（存储在MetaStore），删除语句相同
>
> ` drop table if exists $tbl`

### 函数

##### 日期时间操作

```mysql
# 整型时间戳转日期
select from_unixtime(finsert_time,'yyyyMMdd HH:mm:ss') from xmp_odl.xmp_pv where ds='20161206';
# 日期转时间戳
select unix_timestamp('20111207 13:01:03','yyyyMMdd HH:mm:ss') from test.dual;
```

## 参考

[官方参考手册](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DML#LanguageManualDML-Delete)

[hive array、map、struct使用](http://blog.csdn.net/yfkiss/article/details/7842014)

[HIVE 时间操作函数](http://www.cnblogs.com/moodlxs/p/3370521.html)