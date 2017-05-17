## MySQL积累

[TOC]

### 基本

#### 创建

创建新用户并设置密码

create user 'username'@'host' identified by 'password';

授权管理

```mysql
grant privileges on databasename.tablename to 'username'@'host';
# 其中的privileges可以是SELECT , INSERT , UPDATE或者all等 
# 查看所有用户的授权
select * from information_schema.user_privileges;

# 查看所有的用户
select distinct concat('user: ''',user,'''@''',host,''';') as query from mysql.user;

# 查看某用户的授权
show grants for 'root'@'%';

# 查看某用户的所有信息
select * from mysql.user where user='cactiuser' \G;   
```

更改密码

```shell
# 命令:
 set password for 'username'@'host' = password('newpassword');
# 如果是当前登陆用户用
 set password = password("newpassword");
# 例子: set password for 'lin'@'%' = password("123456");

# 授权的同时修改密码
GRANT ALL PRIVILEGES ON `db1`.* TO 'root'@'%' IDENTIFIED by '123';
```

远程登陆

```shell
mysql -uroot -pxxx -P3316 -h127.0.0.1 -Ddb1
# 其中-P3316是本机的转发端口（如果不转发的话，直接是远程机器的端口），注意在cmder中输入命令，不要在GitBash中输入，后者正确之后无响应
```





#### 索引

##### 创建和删除索引

>加索引

mysql> alter table 表名 add index 索引名 (字段名1[，字段名2 …]);

>加主关键字的索引

mysql> alter table 表名 add primary key (字段名);

例子： mysql> alter table employee add primary key(id);

>加唯一限制条件的索引

 mysql> alter table 表名 add unique 索引名 (field1,filed2);

 例子： mysql> alter table employee add unique emp_name2(cardnumber);

>删除某个索引

mysql> alter table 表名 drop index 索引名;

##### 表指定key

```mysql
CREATE TABLE `user_follow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userID` varchar(16) NOT NULL DEFAULT '',
  `starID` varchar(16) NOT NULL DEFAULT '',
  `status_e` tinyint(4) NOT NULL DEFAULT '0',
  `follow_t` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `insert_t` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_t` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ts` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `follow` (`userID`,`starID`),
  KEY `userID` (`userID`),
  KEY `starID` (`starID`)
) ENGINE=MyISAM AUTO_INCREMENT=13912 DEFAULT CHARSET=utf8;
```

注意`PRIMARY KEY`,`UNIQUE KEY`,	`KEY`的区别

#### 字段

>增加字段

 mysql> ALTER TABLE table_name ADD field_name field_type;
 alter table newexample add address varchar(110) after stu_id;

> 修改原字段名称及类型

 alter table table_name change old_field_name new_field_name field_type;

> 删除字段

 alter table table_name drop field_name;

**参考**

http://c.biancheng.net/cpp/html/1456.html

#### 编码

查看字符数据库的字符集

```mysql
show variables like 'character\_set\_%';
show variables like 'collation_%';

# 或者直接使用status命令查看
```

设置数据库字符编码

```mysql
create database mydb character set utf8; 	# 创建的时候指定字符编码

# 以下修改是永久性的修改
alter database mydb character set utf8;		# 修改数据库编码(若之前的设置不是utf8编码的话)
alter table tbl character set utf8;			# 修改表的编码
alter table tbl modify col_name varchar(50) CHARACTER SET utf8;	# 修改字段的编码

# 以下的修改是基于窗口的修改，窗口关闭则失效
set names 'utf8'; 					# 等同于执行client,connection,results三个的设置
set character_set_client=utf8;		# 客户端编码方式
set character_set_connection=utf8;	# 建立连接使用的编码
set character_set_database=utf8;	# 数据库的编码
set character_set_results=utf8;		# 结果集的编码
set character_set_server=utf8;		# 数据库服务器的编码
set character_set_system=utf8;

set character_set_filesystem=binary; 

set collation_connection=utf8;
set collation_database=utf8;
set collation_server=utf8;
```

转换路径

```
信息输入路径：client→connection→server；
信息输出路径：server→connection→results。

换句话说，每个路径要经过3次改变字符集编码。以出现乱码的输出为例，server里utf8的数据，传入connection转为latin1，传入results转为latin1，utf-8页面又把results转过来。如果两种字符集不兼容，比如latin1和utf8，转化过程就为不可逆的，破坏性的。所以就转不回来了。
```

解决办法

```
# CLIENT SECTION
[mysql] 
default-character-set=utf8

# SERVER SECTION
[mysqld]
default-character-set=utf8
# init_connect='SET NAMES utf8' # 设定连接mysql数据库时使用utf8编码，以让mysql数据库为utf8运行
# character-set-server=utf8 	# 其它类似的设置都可以在这里指定(有问题，设置不了)，# The default 									character set that will be used when a new schema or table is
								created and no character set is defined
```

> 以上两个设置会导致以下的字符集设置为utf8:
>
> - character_set_database utf8
> - character_set_server utf8
> - character_set_system utf8
>
> 而以下的的设置还是默认值（当换成[client]目录下的修改，则生效）：
>
> - character_set_client latin1
> - character_set_connection latin1
> - character_set_results latin1

然后重启mysql服务`service mysql restart`,或者`/etc/init.d/mysql restart`

命令行链接的时候指定编码:

```
mysql --default-character-set=utf8  -uroot -proot -Dpgv_stat_yingyin
```

汇总：

> 需要保证的是，以下4个的编码方式一致：
>
> - character_set_database utf8
> - character_set_client utf8
> - character_set_connection utf8
> - character_set_results utf8
>
> 可通过以下方式达到：
>
> - 客户端在连接的时候使用set names utf8;
>
>
> - 创建数据库的时候指定create database mydb character set utf8;
>
>
> - 在load数据的时候保证文件是utf8编码的

#### 信息查看编码

>  查看全局变量

命令行：mysqladmin variables -p，这个操作也就相当于登录时使用命令 show global variables;

### 积累

#### 运行方式技巧

```shell
${MYSQL10} < xmp_version_active.sql
#其中MYSQL10是:`/usr/bin/mysql -uroot -phive -N`
```

#### restful接口

```shell
pip install sandman2
sandman2ctl 'mysql+mysqldb://root:root@localhost/pgv_stat_yingyin'
* Running on http://0.0.0.0:5000/
```

其中mysql的链接方式可以有[以下几种](http://docs.sqlalchemy.org/en/latest/core/engines.html#mysql)：

```python
# default
engine = create_engine('mysql://scott:tiger@localhost/foo')

# mysql-python
engine = create_engine('mysql+mysqldb://scott:tiger@localhost/foo')

# MySQL-connector-python
engine = create_engine('mysql+mysqlconnector://scott:tiger@localhost/foo')

# OurSQL
engine = create_engine('mysql+oursql://scott:tiger@localhost/foo')
```

sandman2ctl的配置有以下：

```
optional arguments:
  -h, --help            show this help message and exit
  -d, --debug           Turn on debug logging
  -p PORT, --port PORT  Port for service to listen on
  -l, --local-only      Only provide service on localhost (will not be
                        accessible from other machines)
  -r, --read-only       Make all database resources read-only (i.e. only the
                        HTTP GET method is supported)
  -s SCHEMA, --schema SCHEMA
                        Use this named schema instead of default
```

> 问题是中午的查询结果是unicode显示，命令行配置jq才能正常显示，而web访问还没有查到显示中文的方式

#### 选取结果添加行号

```mysql
# 方法1 
set @mycnt=0;
select (@mycnt := @mycnt + 1) as ROWNUM , vv from task1_tbl order by vv;

# 方法2
# #将查询结果写入到某个拥有auto_increment字段的临时表中再做查询

# 方法3
# #用Python等脚本语言对查询结果进行二次组装
```

#### 近段时间数据修复

```mysql
# 用上周同期的数据浮动修复本周的数据
delete from db2.tb1 where date>=20160818 and date<=20160821;
insert into db2.tb1 select
	date_format(date_add(date, interval 7 day),'%Y%m%d'),
	channel,
	version,
	install_begin + round(install_begin / 100),
	install_end + round(install_end / 100),
	uninstall+round(uninstall/100)
from
	db2.tb1
where
	date >= '20160811' and date <= '20160814';

# 用除了修复日期外其它近段时间的数据平均修复
delete from db2.tb1 where date='20170313';
insert into db2.tb1 select
	'20170313',
	channel,
	version,
	avg(install_begin),
	avg(install_end),
from
	db2.tb1
where
	date='20170309'  and  date<='20170315' and date!='20170313';
```

#### 选取指定日期

```mysql
select (DATEDIFF(DATE_ADD(curdate, INTERVAL - DAY(curdate)+ 1 DAY), date_add(curdate- DAY(curdate)+ 1, INTERVAL -1 MONTH)))  as '上月总天数', DATE_ADD(curdate,interval -day(curdate)+1 day) as '当月第一天', date_add(curdate-day(curdate)+1,interval -1 month ) as '上月第一天';
```

> 这段还没有完全调通

#### GroupSelect问题

问题描述：先分组，然后在从分组中选取某些值，比如topN

```mysql
//待补充
```

用awk如何实现

### 高级

#### 过程和函数

创建存储过程

```sql
CREATE PROCEDURE sp_name([IN|OUT|INOUT] param_name type) [characteristics] routine_body

1.其中CREATE PROCEDURE为创建存储过程的关键字，sp_name为存储过程的名称，为指定存储过程的参数
2.characteristics指定存储过程的特性
3.routine_body是SQL代码的内容， 可以用BEGIG...END来表示SQL代码的开始和结束
```

调用存储过程：Call  sp_name;

#### 事件 

### 应用

#### 行转列

有两种实现方式`case when`和`inner join`:

```mysql
# 原始的的数据格式是按行的，现在想拼接为列，其中还有汇总和所占比，实现方式如下:
select a.date,a.f1 as '总量',b.f2 as '360域名总量',
round(c.f3*100/b.f2,2) as 'http://hao.360.cn/?src=lm&ls=n4abc0a4199',
round(d.f4*100/b.f2,2) as 'http://hao.360.cn/?src=lm&ls=n79f40a409c',
round(e.f5*100/b.f2,2) as 'http://hao.360.cn/?src=lm&ls=n110c004e9b',
round(f.f6*100/b.f2,2) as 'https://hao.360.cn/?src=lm&ls=n556c014b9f'
from
(select date,sum(cnts) as f1 from pgv_stat.xmpcloud2_ie_stat where date>=20161201 group by date) a
inner join
(select date,sum(cnts) as f2 from pgv_stat.xmpcloud2_ie_stat where date>=20161201 and host_url='360.cn' group by date) b on a.date=b.date
inner join
(select date,cnts as f3 from pgv_stat.xmpcloud2_ie_stat  where  date>=20161201 and url='http://hao.360.cn/?src=lm&ls=n4abc0a4199') c on a.date=c.date
inner join
(select date,cnts as f4 from pgv_stat.xmpcloud2_ie_stat  where  date>=20161201 and url='http://hao.360.cn/?src=lm&ls=n79f40a409c') d on a.date=d.date
inner join
(select date,cnts as f5 from pgv_stat.xmpcloud2_ie_stat  where  date>=20161201 and url='http://hao.360.cn/?src=lm&ls=n110c004e9b') e on a.date=e.date
inner join
(select date,cnts as f6 from pgv_stat.xmpcloud2_ie_stat  where  date>=20161201 and url='https://hao.360.cn/?src=lm&ls=n556c014b9f') f on a.date=f.date
order by a.date desc;
```

案例参考：

| 年    | 季度   | 销售量  |
| ---- | ---- | ---- |
| 1991 | 1    | 11   |
| 1991 | 2    | 12   |
| 1991 | 3    | 13   |
| 1991 | 4    | 14   |
| 1992 | 1    | 21   |
| 1992 | 2    | 22   |
| 1992 | 3    | 23   |
| 1992 | 4    | 24   |

| 年    | 一季度  | 二季度  | 三季度  | 四季度  |
| ---- | ---- | ---- | ---- | ---- |
| 1991 | 11   | 12   | 13   | 14   |
| 1992 | 21   | 22   | 23   | 24   |

```mysql
# 实现的sql语句(借鉴意义很广泛)
select 年, 
sum(case when 季度=1 then 销售量 else 0 end) as 一季度, 
sum(case when 季度=2 then 销售量 else 0 end) as 二季度, 
sum(case when 季度=3 then 销售量 else 0 end) as 三季度, 
sum(case when 季度=4 then 销售量 else 0 end) as 四季度 
from sales group by 年;
```

#### 列转行

有两种实现方式:`序列化表`和`union`

```mysql
# 利用序列化表的方式实现列转行
SELECT
	user_name,
	REPLACE (SUBSTRING(SUBSTRING_INDEX(mobile, ',', a.id), CHAR_LENGTH(SUBSTRING_INDEX(mobile, ',', a.id - 1)) + 1), ',', '') as moblie
FROM
	seq_tb a
CROSS JOIN (
	SELECT
		CONCAT(mobile, ',') as mobile,
		LENGTH(mobile) - LENGTH(REPLACE(mobile, ',', '')) + 1 size
	FROM
		user1 b
) b on a.id <= b.size;

# 利用union实现列转行
SELECT user_name,'skills1' as 'jineng',skills1 from nameskills_col
UNION ALL
SELECT user_name,'skills2',skills2 from nameskills_col
UNION ALL
SELECT user_name,'skills2',skills3 from nameskills_col ORDER BY user_name;
```

#### 同一属性多值过滤

```mysql
# 方法一
#选出同时具有fei和bianhua能力的人
SELECT DISTINCT a.name AS 'feibianren' from nameskills a 
JOIN  nameskills b on a.name=b.name and b.skills='fei'
join  nameskills c on a.name=c.`name` and c.skills='bianhua';

# 方法二：
# 同一属性多值过滤问题
SELECT
	a.`name`,
	b.skills as bskill
	#c.skills as cskill
from
	nameskills_row a
INNER JOIN join nameskills_row b on a.name = b.name
and b.skills = 'nianjing';
#join nameskills_row c on a.name = c.name
#and c.skills = 'fanren';
```

#### 关联更新

根据另一个表的数据，更新当前表的数据:

```mysql
# 在a表和b表满足xx条件的时候更新a表的什么内容
update pgv_stat.xmp_version_active a inner join (select date,version,sum(online_user) user,sum(total_uv) vod from pgv_stat.xmp_total_vod where date='$dt' and channel='all' group by version) b on a.date=b.date and substring_index(a.version,'.',-1)=b.version set a.online_user=b.user,a.total_uv=b.vod where a.date='$dt';
```

```mysql
# 在a表和b表满足xx条件的时候更新a表的什么内容
UPDATE downloaddatas a, downloadfee b SET a.ThunderPrice=$PRICE, a.ThunderAMT=(a.ThunderCop+a.btdownnum3)*$PRICE WHERE a.CopartnerId=b.copartnerid AND b.inuse=1 AND a.BalanceDate>=DATE_FORMAT(b.starttime,'%Y-%m-%d') AND a.BalanceDate='$BALANCEDATE'

#在a表和b表满足xx条件的时候更新b表的什么内容
update union_kuaichuan_download_data a,downloaddatas b set b.ThunderQty=b.ThunderQty+a.copdowntimes where a.dayno=$d and b.BalanceDate=_gbk\"${dt}\" and b.CopartnerId=a.copid  and b.ProductNo=4"
```

#### 周同期

```python
# 这周的数据
tablea="select date,sum(install_end) as s_install_end,sum(install_silence) as s_install_new from xmp_install where date>=date_sub(curdate(),interval 7 day) group by date"

# 上周的数据
tableb="select date,sum(install_end) as s_install_end,sum(install_silence) as s_install_new from xmp_install where date>=date_sub(curdate(),interval 14 day) group by date"

# 要统计的数据
whatis="a.date as '当前日期',b.date as '上周同期',a.s_install_end as '总安装量',b.s_install_end as '上周同期总安装量',concat(round((a.s_install_end-b.s_install_end)*100/b.s_install_end,2),'%') as '总装周同比'"

# 展示结果
sql = "SELECT {whatis} FROM ({tablea}) a INNER JOIN ({tableb}) b on b.date=DATE_FORMAT(DATE_SUB(a.date,INTERVAL 7 day),'%Y%m%d') order by a.date desc".format(whatis=whatis,tablea=tablea,tableb=tableb)
```

#### 字符分割的数组长度

```mysql
# imgName格式：bc9077f6.jpg,073eb23f.jpg
select if(imgName='',0,1+(length(imgName)-length(replace(imgName,',','')))) as arraycnt from contribute;
```



### 查询

#### 索引

单索引和联合索引

#### 子查询

#### 连接

##### join

###### inner join

```mysql
#SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo
#FROM Persons
#INNER JOIN Orders
#ON Persons.Id_P = Orders.Id_P
#ORDER BY Persons.LastName;

# 该语句等效于
SELECT
	Persons.LastName,
	Persons.FirstName,
	Orders.OrderNo
FROM
	Persons,
	Orders
WHERE
	Persons.Id_P = Orders.Id_P
```

###### left join

```mysql
SELECT
	Persons.LastName,
	Persons.FirstName,
	Orders.OrderNo
FROM
	Persons
LEFT JOIN Orders ON Persons.Id_P = Orders.Id_P
WHERE persons.LastName like 'C%'
ORDER BY
	Persons.LastName 

```

###### right join

```mysql
SELECT
	Persons.LastName,
	Persons.FirstName,
	Orders.OrderNo
FROM
	Persons
RIGHT JOIN Orders ON Persons.Id_P = Orders.Id_P
ORDER BY
	Persons.LastName
```

###### union(all)

```mysql
# 请注意，UNION 内部的 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型。同时，每条 SELECT 语句中的列的顺序必须相同。
# 注释：默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。
SELECT	* from	persons
UNION All
SELECT	* from	persons;
```

##### exists和in

```mysql
#这条语句适用于a表比b表大的情况
select * from ecs_goods a where cat_id in(select cat_id from ecs_category);

#这条语句适用于b表比a表大的情况
select * from ecs_goods a where EXISTS(select cat_id from ecs_category b where a.cat_id = b.cat_id);
```

### 调优

#### 索引

如何调优索引的使用

#### 慢查询

慢查询日志将日志记录写入文件，也将日志记录写入数据库表。

##### 配置

```mysql
# 查询慢日志是否开启及文件存储位置
show variables  like '%slow_query_log%';

# 查询慢日志查询时间
show variables like 'long_query_time%';
#　注意：使用命令 set global long_query_time=4修改后，需要重新连接或新开一个会话才能看到修改值。你用show variables like 'long_query_time'查看是当前会话的变量值，你也可以不用重新连接会话，而是用show global variables like 'long_query_time'; 

# 输出存储格式
show variables like '%log_output%';
# MySQL数据库支持同时两种日志存储方式，配置的时候以逗号隔开即可，如：log_output='FILE,TABLE'

# 未使用索引的查询是否被记录到慢查询日志中
show variables like 'log_queries_not_using_indexes';

# 系统变量log_slow_admin_statements表示是否将慢管理语句例如ANALYZE TABLE和ALTER TABLE等记入慢查询日志
show variables like 'log_slow_admin_statements';


# 如果你想查询有多少条慢查询记录，可以使用系统变量。  
show global status like '%Slow_queries%';
```

##### 分析

mysqldumpslow分析工具提供对慢日志查询的分析

```
-s, 是表示按照何种方式排序，
  c: 访问计数
  l: 锁定时间
  r: 返回记录
  t: 查询时间
  al:平均锁定时间
  ar:平均返回记录数
  at:平均查询时间
-t, 是top n的意思，即为返回前面多少条的数据；
-g, 后边可以写一个正则匹配模式，大小写不敏感的；
```

```mysql

# 得到返回记录集最多的10个SQL。
mysqldumpslow -s r -t 10 /database/mysql/mysql06_slow.log

# 得到访问次数最多的10个SQL
mysqldumpslow -s c -t 10 /database/mysql/mysql06_slow.log

# 得到按照时间排序的前10条里面含有左连接的查询语句。
mysqldumpslow -s t -t 10 -g “left join” /database/mysql/mysql06_slow.log

# 另外建议在使用这些命令时结合 | 和more 使用 ，否则有可能出现刷屏的情况。
mysqldumpslow -s r -t 20 /mysqldata/mysql/mysql06-slow.log | more
```



### 备份

#### 导入和导出 

##### 导入

`load data方法` :将数据文件加载进mysql: [官方参考](https://dev.mysql.com/doc/refman/5.6/en/load-data.html)

```shell
# 指定编码，分割符之类的，如果不指定编码，容易出现乱码
mysql -uroot -proot -e "delete from db1.tb1;load data local infile './members.csv' into table db1.tb1 character set utf8  fields terminated by ',' LINES TERMINATED BY '\n';"

# 指定导入到哪几列(这几列不一定要连续)
sql="load data local infile '$datapath/db1.odl_put_context_${date}' into table  odl_put_context(Fdb,Ftbl,Fdate,Fhour,Fput_status);"
```

运行插入语句

```
首先将数据导出成可运行的sql语句，然后source xxx.sql,或者mysql -uxxxx -pxxx <xxx.sql
```

##### 导出

导出可执行的sql语句,可跨平台执行

```shell
#1.导出整个数据库 
#mysqldump -u用户名 -p密码  数据库名 > 导出的文件名 
mysqldump -uroot -pmysql db1   > e:\db1.sql 

#2.导出一个表，包括表结构和数据 
#mysqldump -u用户名 -p密码  数据库名 表名> 导出的文件名 
mysqldump -uroot -pmysql db1 tb1 tb2> e:\tb1_tb2.sql 

#3.导出一个数据库结构 
mysqldump -uroot -pmysql -d db1 > e:\db1.sql 

#4.导出一个表，只有表结构 
#mysqldump -u用户名 -p 密码 -d数据库名  表名> 导出的文件名 
mysqldump -uroot -pmysql -d db1 tb1> e:\tb1.sql 
```

导出成文件

```shell
# 方法1：mysql语句
> select * from db1.tb1 into outfile '/tmp/xxx.xls';
# 注意mysql用户是否具有写的权限，另外可配置是否显示列名

# 方法2：重定向(查询自动写入文件,查询结果不再显示在窗口
> pager cat >> /tmp/test.xls;

# 方法3:输出重定向
mysql -h 127.0.0.1 -u root -p XXXX -P3306 -e "select * from table"  > /tmp/test.xls
# 若不想显示列名，加—N参数即可
```

#### mysql导入到redis

方法1：

> 遍历插入法

方法2：

命令行法

```shell
#创建shell脚本mysql2redis_mission.sh,（在mysql的结果中进行命令行的组合）内容如下：
mysql db_name --skip-column-names --raw < mission.sql | redis-cli [--pipe]
#进化方法
mysql -uroot -proot -N <redis_pipe.sql |redis-cli

# 例如
(echo "set key1 vale1\r\n get key1\r\n") |redis-cli ［--pipe］#最后这个pipe选项可能导致问题
#　或者（能得到返回结果）
(echo -en "set key3 vale3\r\n get key2\r\n") |nc localhost 6379

# 直接将文件内容输入到流
cat xxx.file |redis-cli [--pipe]
```



## 参考

[SQL的存储过程和函数](http://www.toutiao.com/a6391569028531831041/)

[MyCli:支持自动补全和语法高亮的MySQL客户端](http://hao.jobbole.com/mycli-mysql/)

[是否存在根据MySQL表格自动生成restful接口的技术](https://segmentfault.com/q/1010000008335958?_ea=1878275)

[Linux下修改mysql的root密码](http://www.tuicool.com/articles/yQNZFfr)

[MySQL字符编码深入详解](http://www.jb51.net/article/29960.htm)

- 查询技巧

[MySQL分组后选取指定值问题](http://www.jb51.net/article/31590.htm)

[MySQL存储过程的动态行转列](http://www.tuicool.com/articles/FNRVJvb)

[重温SQL:行转列，列转行](http://mp.weixin.qq.com/s/pd4sEFa9oq0Lw5aaagmsxw)

- 调优部分

[MySQL慢查询日志的使用](http://www.cnblogs.com/kerrycode/p/5593204.html)

[MySQL慢查询官方参考](https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html)

[性能调优攻略:SQL语句优化](http://www.toutiao.com/a6391314783630770433/)

[mysql exists和in的效率比较](http://www.cnblogs.com/meibao/p/4973043.html)