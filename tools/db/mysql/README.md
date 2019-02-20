## MySQL笔记

[TOC]

### 基础

#### 基本

##### 安装

先检查已安装版本

```shell
 # 查看已安装
 rpm -qa | grep mysql
 # 卸载
 rpm -e --nodeps mysql_xxxx
```

包管理器安装

```shell
#1.下载mysql的repo源
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
# 或者新版：http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm

#2.安装mysql-community-release-el7-5.noarch.rpm包
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
#安装这个包后，会获得两个mysql的yum repo源：
vim /etc/yum.repos.d/mysql-community.repo
vim /etc/yum.repos.d/mysql-community-source.repo

#3.安装mysql
sudo yum install mysql-server
```

配置开机启动

```shell
cp ./support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
```

客户端连接

```shell
# 指定编码
mysql --default-character-set-utf8 -uroot -proot

# 指定数据库
mysql --default-character-set-utf8 -uroot -proot -Ddbname

# 其它指定
```

信息查看

```shell
＃查看相关信息
status

#查看支持的字符集
show char set;
```

##### 配置

mysql的配置文件默认是`/etc/my.cnf`,其内容主要如下：

```mysql
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
default-storage-engine=MyISAM
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

# 开启bin-log
log-bin=/var/lib/mysql/mysql-bin

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

# 配置客户端，似乎可以直接登录使用
[client]
host=localhost
user=rxxx
password='xxxx'
default-character-set = utf8mb4 # 客户端连接字符集
```

###### 账号

[创建和删除](https://www.cnblogs.com/wanghetao/p/3806888.html)

```mysql
# 创建新用户并设置密码
create user 'username'@'localhost' identified by 'password';
create user 'yjm'@'%' identified by 'a112233';

# 删除用户
drop user 'username'@'host';
```

> 注意：
>
> - 此处的"localhost"，是指该用户只能在本地登录，不能在另外一台机器上远程登录。如果想远程登录的话，将"localhost"改为"%"，表示在任何一台电脑上都可以登录。也可以指定某台机器可以远程登录。 

[授权管理](https://www.cnblogs.com/fnlingnzb-learner/p/5833337.html)

```mysql
grant privileges on databasename.tablename to 'username'@'host';
# 其中的privileges可以是select , insert , update或者all等 
# 查看所有用户的授权
select * from information_schema.user_privileges;

# 查看所有的用户
select distinct concat('user: ''',user,'''@''',host,''';') as query from mysql.user;

# 查看某用户的授权
show grants for 'root'@'%';

# 查看某用户的所有信息
select * from mysql.user where user='cactiuser' \G; 

# 取消授权
grant  all on *.* to   dba@localhost;  
revoke all on *.* from dba@localhost; 
```

更改密码

```shell
# 命令:
set password for 'username'@'host' = password('newpassword');
# 如果是当前登陆用户用
 set password = password("newpassword");
# 例子: set password for 'lin'@'%' = password("123456");

# 或者
update user set password=password('123456') where user='root';

# 授权的同时修改密码
GRANT ALL PRIVILEGES ON `db1`.* TO 'root'@'%' IDENTIFIED by '123';

# 授权给已有的用户
GRANT ALL PRIVILEGES ON `snh48`.* TO 'root'@'%';

# 使用mysqladmin修改密码
mysqladmin -u root -p password 'root' # 如果原始密码是空，直接回车即可
```

远程登陆

```shell
mysql -uroot -pxxx -P3316 -h127.0.0.1 -Ddb1
# 其中-P3316是本机的转发端口（如果不转发的话，直接是远程机器的端口），注意在cmder中输入命令，不要在GitBash中输入，后者正确之后无响应
```

###### 编码

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

tips:

```python
# python连接mysql的时候指定编码或者socket
 conn = MySQLdb.connect(host="localhost", user="xxxx", passwd="xxx",use_unicode=True, charset="utf8",unix_socket='/tmp/mysql_3309.sock')
```

###### 变量

类型转换

```mysql
# 字符串转整型
SELECT CONVERT(filedName, UNSIGNED INTEGER);
SELECT CAST(filedName as SIGNED);

```

查看变量

```mysql
# 命令行：mysqladmin variables -p，这个操作也就相当于登录时使用命令 show global variables;

# 若查看某种类型的变量
show [global] variables like "%_time";

# 查看数据存储路径
show global variables like '%datadir%';
```

修改变量

```shell
# 临时修改
set global long_query_time=2;

# 永久修改
在my.cnf的[mysqld]节点下添加
var_name=var_value
```

例子：

```mysql
# mysql表名大小写的敏感性配置：
show variables like '%lower_case_table_names%';
```

#### 表

#####  类型

共有5种类型的表格：

- MyISAM(默认)
- Heap(memory)
- Merge
- INNODB
- ISAM

###### MyISAM

//待补充

###### Heap

内存表的特点：

```shell
- 内存表不支持事务和AUTO_INCREMENT
- 内存表不支持BLOB/TEXT列
- 内存表大小可用　max_heap_table_size　参数来设置
- 只能使用比较运算符=，<，>，=>，= <
- 索引不能为NULL
```

[内存表使用小结](http://blog.csdn.net/adparking/article/details/6388946)

##### 基础

创建表

```mysql
# 创建库（创建的时候指定编码）
create database `test2` default character set utf8 collate utf8_general_ci;

#　创建表
CREATE TABLE if not exists `row2col_tbl` (
  `date` varchar(8) DEFAULT NULL,
  `xl_version` varchar(20) DEFAULT NULL,
  `stat_flag` varchar(10) DEFAULT NULL,
  `area` varchar(2) DEFAULT NULL,
  `cnt` int(11) DEFAULT NULL,
  `cnt_user` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
```

修改表名

```mysql
alter table media_relation_search_pc rename media_relation_search_pc_old_20170627;
# 或者
rename命令格式：rename table 原表名 to 新表名;
```

查看包含某字段的所有表名和所在的数据库

```mysql
#TABLE_SCHEMA字段为db的名称（所属的数据库），字段TABLE_NAME为表的名称。
SELECT TABLE_SCHEMA,TABLE_NAME FROM information_schema.columns WHERE column_name='brand_id';
show tables like "xxx%";
```

查看一个表的所有字段

```shell
# shell的方式（得到的结果是一串由空格分割的字符串，然后再进行遍历即可）
fields=$(echo "desc media_info.${TABLE_NAME};"| ${LOCAL_MYSQL} | grep -v Field | grep -v auto_increment | awk '{print $1}')
```

##### 字段

###### 类型

json

```mysql
mysql不支持map类型，
```

> [json类型](http://www.jb51.net/article/89219.htm)是在mysql5.7.8及之后的版本中添加的,函数[参考](https://blog.csdn.net/jiangyu1013/article/details/78917425)

整型

```mysql
bigint int smallint tinyint
```

浮点型

```shell
float decimal
```

字符串

```shell
char vachar text
```

日期时间

```shell
datetime timestamp
```

==综合测试==

```mysql
create table if not exists basic_test(
    ia_tiny tinyint unsigned,
    ib_small smallint unsigned,
    ib1_small smallint,
    ic_float float,
    id_double decimal,
    ie_boolen boolean
);
```

###### 操作

[增加字段](http://c.biancheng.net/cpp/html/1456.html)

```mysql
alter table table_name add field_name field_type;
alter table newexample add address varchar(110) after stu_id;
```

修改字段

```mysql
# 修改字段类型
alter table table_name change old_field_name new_field_name field_type;

# 例子：
alter table study.test change author author varchar(25) not null default '';
```

删除字段

```mysql
alter table table_name drop field_name;
```

更新字段

```mysql
UPDATE [LOW_PRIORITY] [IGNORE] table_reference
    SET col_name1={expr1|DEFAULT} [, col_name2={expr2|DEFAULT}] ...
    [WHERE where_condition]
    [ORDER BY ...]
    [LIMIT row_count]

UPDATE tbl SET col1 = col1 + 1, col2 = col1;
```

> 注意执行顺序

类型转换

```mysql
#sc.score是decimal(18,1)类型
avg(cast(sc.score as decimal(18,2)))
```

#### 索引

索引认知：

1. 索引是按照特定的数据结构把数据表中的数据放在索引文件中，以便于快速查找；


2. 索引存在于磁盘中，会占据物理空间。

##### 索引方法

索引文件按照不同的数据结构来存储，数据结构的不同产生了不同的索引类型，常见的[索引类型](https://segmentfault.com/a/1190000010264071)：

###### B-Tree索引

支持范围查找

###### 哈希索引

哈希表的优势与限制:

- 优势:
  1. 只需比对哈希值，因此速度非常快，性能优势明显；
- 限制:
  1. 不支持任何范围查询，比如`where price > 150`，因为是基于哈希计算，支持等值比较。
  2. 哈希表是无序存储的，因此索引数据无法用于排序。
  3. 主流存储引擎不支持该类型，比如`MyISAM`和`InnoDB`。哈希索引只有Memory, NDB两种引擎支持。

###### 空间数据索引（R-Tree）

地理数据存储

###### 全文索引

全文索引主要用于海量数据的搜索，只有InnoDB存储引擎支持

**总结**

```
1. B-Tree索引使用最广泛，主流引擎都支持。
2. 哈希索引性能高，适用于特殊场合。
3. R-Tree不常用。
4. 全文索引适用于海量数据的关键字模糊搜索。
```

##### 创建和删除

加索引

```mysql
# 加普通索引
alter table 表名 add index 索引名 (字段名1[，字段名2 …]);

# 加主索引
alter table 表名 add primary key (字段名);

# 加唯一索引
alter table 表名 add unique 索引名 (field1,filed2);
```

删除索引

```mysql
alter table 表名 drop index 索引名;
```

添加约束

```mysql
# 单列约束
ALTER TABLE Persons ADD UNIQUE (Id_P);
# 多列约束
ALTER TABLE Persons ADD CONSTRAINT uc_PersonID UNIQUE (Id_P,LastName);
```

撤销约束

```mysql
# unique是索引的一种
ALTER TABLE Persons DROP INDEX uc_PersonID;
```

##### 索引和KEY

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

注意`PRIMARY KEY`,`UNIQUE KEY`,`KEY`的区别

##### 索引和约束

`UNIQUE KEY`和`PRIMARY KEY`约束均为列或列集合提供了唯一性的保证，`PRIMARY KEY `拥有自动定义的 `UNIQUE` 约束,一个表可以有多个`UNIQUE KEY`约束，但是只能有一个`PRIMARY KEY`约束。

```mysql
CREATE TABLE Persons(
    Id_P int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255),
    UNIQUE (Id_P)
);

CREATE TABLE Persons(
    Id_P int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255),
    CONSTRAINT uc_PersonID UNIQUE (Id_P,LastName)
)
```

##### 索引和引擎

- 索引是在存储引擎中实现的
- 不同的存储引擎对同一类型的索引的具体实现也有差别

#### 引擎

存储引擎

```shell
# 修改表的存储引擎
alter table table_name engine=innodb;

# 查找使用InnoDB引擎的表
select table_schema,table_name from information_schema.tables where table_type='base table' and engine='innodb' and table_schema!='mysql' and table_name not like '%innodb%';

# 关闭InnoDB的存储引擎(修改默认的存储引擎)
#修改my.ini文件：
找到default-storage-engine=INNODB 改为default-storage-engine=MyISAM
找到#skip-innodb 改为skip-innodb
```

> MyISAM引擎格式的数据可以被文件复制，然后恢复，而InnoDB引擎不可以同步文件使用。

##### CSV

```
CSV（Comma-Separated Values逗号分隔值）
   使用该引擎的MySQL数据库表会在MySQL安装目录data文件夹中的和该表所在数据库名相同的目录中生成一个.CSV文件（所以，它可以将CSV类型的文件当做表进行处理），这种文件是一种普通文本文件，每个数据行占用一个文本行。该种类型的存储引擎不支持索引，即使用该种类型的表没有主键列；另外也不允许表中的字段为null。
```

#####  MEMORY

也称为HEAP

```
    该存储引擎通过在内存中创建临时表来存储数据。每个基于该存储引擎的表实际对应一个磁盘文件，该文件的文件名和表名是相同的，类型为.frm。该磁盘文件只存储表的结构，而其数据存储在内存中，所以使用该种引擎的表拥有极高的插入、更新和查询效率。这种存储引擎默认使用哈希（HASH）索引，其速度比使用B-+Tree型要快，但也可以使用B树型索引。由于这种存储引擎所存储的数据保存在内存中，所以其保存的数据具有不稳定性，比如如果mysqld进程发生异常、重启或计算机关机等等都会造成这些数据的消失，所以这种存储引擎中的表的生命周期很短，一般只使用一次。
```

##### InnoDB

待补充

##### MyISAM

###### InnoDB和MyISAM的区别

| 区别点                            | **MyISAM**                               | **InnoDB**                               |
| ------------------------------ | ---------------------------------------- | ---------------------------------------- |
| **构成上**                        | 每个MyISAM在磁盘上存储成三个文件。第一个文件的名字以表的名字开始，扩展名指出文件类型。  .frm文件存储表定义。  数据文件的扩展名为.MYD (MYData)。  索引文件的扩展名是.MYI (MYIndex)。 | 基于磁盘的资源是InnoDB表空间数据文件和它的日志文件，InnoDB 表的大小只受限于操作系统文件的大小，一般为 2GB |
| 事务处理上                          | MyISAM类型的表强调的是性能，其执行数度比InnoDB类型更快，但是不提供事务支持 | InnoDB提供事务支持事务，外部键等高级数据库功能               |
| SELECT ,UPDATE,INSERT，Delete操作 | 如果执行大量的SELECT，MyISAM是更好的选择               | **1.**如果你的数据执行大量的**INSERT****或****UPDATE**，出于性能方面的考虑，应该使用InnoDB表  **2.DELETE   FROM table**时，InnoDB不会重新建立表，而是一行一行的删除。  **3.LOAD   TABLE FROM MASTER**操作对InnoDB是不起作用的，解决方法是首先把InnoDB表改成MyISAM表，导入数据后再改成InnoDB表，但是对于使用的额外的InnoDB特性（例如外键）的表不适用 |
| 对AUTO_INCREMENT的操作             | 每表一个AUTO_INCREMEN列的内部处理。  **MyISAM****为****INSERT****和****UPDATE****操作自动更新这一列**。这使得AUTO_INCREMENT列更快（至少10%）。在序列顶的值被删除之后就不能再利用。(当AUTO_INCREMENT列被定义为多列索引的最后一列，可以出现重使用从序列顶部删除的值的情况）。  AUTO_INCREMENT值可用ALTER TABLE或myisamch来重置  对于AUTO_INCREMENT类型的字段，InnoDB中必须包含只有该字段的索引，但是在MyISAM表中，可以和其他字段一起建立联合索引  更好和更快的auto_increment处理 | 如果你为一个表指定AUTO_INCREMENT列，在数据词典里的InnoDB表句柄包含一个名为自动增长计数器的计数器，它被用在为该列赋新值。  自动增长计数器仅被存储在主内存中，而不是存在磁盘上  关于该计算器的算法实现，请参考  **AUTO_INCREMENT****列在****InnoDB****里如何工作** |
| **表的具体行数**                     | select count(*) from table,MyISAM只要简单的读出保存好的行数，注意的是，当count(*)语句包含   where条件时，两种表的操作是一样的 | InnoDB 中不保存表的具体行数，也就是说，执行select count(*) from table时，InnoDB要扫描一遍整个表来计算有多少行 |
| **锁**                          | 表锁                                       | 提供行锁(locking on row level)，提供与 Oracle 类型一致的不加锁读取(non-locking read in   SELECTs)，另外，InnoDB表的行锁也不是绝对的，如果在执行一个SQL语句时MySQL不能确定要扫描的范围，InnoDB表同样会锁全表，例如update table set num=1 where name like “%aaa%” |

##### FEDERATED

主要用于将不同的数据库服务器上的数据组合起来

```shell
# 开启引擎支持
在windows下只需要在mysql的配置文件 my.ini 最末尾加上一句federated 
```

参考：[MySQL中的各种引擎的区别](http://blog.csdn.net/gaohuanjie/article/details/50944782)

#### 视图

为什么要用视图？[视图的优点](https://www.toutiao.com/i6496010675456836110/)如下:

1. 安全性
2. 提高查询性能
3. 利用虚拟表灵活应对功能的改变
4. 复杂的查询需求，

通过更新视图更新真实表，更新视图的方法：

- 替代方式
- 具体化方式（中间表方式） 

##### 创建视图

创建视图标准语法

```mysql
CREATE [OR REPLACE] [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
    VIEW view_name [(column_list)]
    AS select_statement
    [WITH [CASCADED | LOCAL] CHECK OPTION]
```

其中视图的更新算法：

ALGORITHM可取三个值：MERGE、TEMPTABLE或UNDEFINED。

如果没有ALGORITHM子句，**默认算法是UNDEFINED（未定义的）**。算法会影响MySQL处理视图的方式。

对于MERGE，会将引用视图的语句的文本与视图定义合并起来，使得视图定义的某一部分取代语句的对应部分。

对于TEMPTABLE，视图的结果将被置于临时表中，然后使用它执行语句。

对于UNDEFINED，MySQL自己选择所要使用的算法。如果可能，它倾向于MERGE而不是TEMPTABLE，

这是因为MERGE通常更有效，而且如果使用了临时表，视图是不可更新的。

```mysql
 create or replace view v1(书名,价格) as
```

##### 查看视图

```mysql
# 查看视图基本结构
desc 视图名; 

# 查看视图详细信息
show table status like '%视图名%';

# 查看视图创建方式
show create view 视图名；
```

在MYSQL中，INFORMATION_SCHEMA VIEWS表存储了关于数据库中的视图的信息 

##### 删除视图

删除视图是指删除数据库中已存在的视图，删除视图时候，只能删除视图的定义，不会删除数据

```mysql
drop view if exists v1;
```

##### 修改视图

修改视图是指修改数据库中存在的视图，当基本表的某些字段发生变化时，可以通过修改视图来保持与基本表的一致性。视图的权限需要完善下

###### 更新

更新视图是指通过视图来插入、更新、删除表数据，因为视图是虚表，其中没有数据，通过视图更新的时候是转到基表进行更新的，如果对视图增加或者删除记录，实际上是对基表增加或删除记录

update

```mysql
ALTER VIEW  stu_class AS SELECT stuno,stuname FROM student;
UPDATE stu_class SET stuname='xiaofang' WHERE stuno=2；#stuno是表暴露给视图的
```

insert

```mysql
INSERT INTO stu_class VALUES(6,'haojie');
```

delete

```mysql
DELETE FROM stu_class WHERE stuno=1;
```

**注意：**

当视图中包含如下内容的时候，视图的更新操作将不能被执行

- 视图中包含基本表中被定义为非空的列
- 定义视图的select语句后的字段列表中使用了数学表达式或者聚合函数
- 定义视图的select语句中使用了distinct、union、group by、having等子句 

###### 修改

**方法1:**

```mysql
ALTER OR REPLACE [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]
```

其语法与创建语法类似，当视图不存在时创建，存在时则进行修改。

**方法2：**

```mysql
ALTER [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]
```

例子：

```mysql
alter view xxx as select * from student;
```

###### 删除

drop能够删除一个或多个视图，必须在每个视图上拥有drop权限

```mysql
DROP VIEW [IF EXISTS]
view_name1 [, view_name2] ...
[RESTRICT | CASCADE]
```

#### 子句

##### select

select子句

```mysql

```

##### where

```mysql
# 等原始字段的逻辑组合判断
where a='xx' 
	and a>b 
	and a like '%xx%'  
```

##### group by

group by子句是对where子句过滤后的数据按某些字段进行聚合操作,其聚合字段需要和select子句中严格一致

```mysql
group by xxx
```

##### having

having子句一般是伴随group by子句使用，对select子句中的聚合结果进行条件判断

```mysql
having sum(xx)>xx 
	and sum(xx)<sum(xx)
	and xxx like '%vv%'
	and (xxx in ('xxx','xxx') or xxx in ('xxx'))
	and ('a' in xx or 'b' in xx)  # 注意此处xx是使用group_concat等聚合之后的序列(待验证)
```

> having子句中可以使用别名

##### 执行顺序

理解这个执行顺序真的很重要

```mysql
(7)     SELECT
(8)     DISTINCT <select_list>
(1)     FROM <left_table>
(3)     <join_type> JOIN <right_table>
(2)     ON <join_condition>
(4)     WHERE <where_condition>
(5)     GROUP BY <group_by_list>
(6)     HAVING <having_condition>
(9)     ORDER BY <order_by_condition>
(10)    LIMIT <limit_number>
```

> 此处牵涉到别名的使用地点问题，只有在select和order by 中才能使用

#### 其它

##### 语句类型

DML、DDL、DCL区别 .

```shell
DML(data manipulation language)：
它们是SELECT、UPDATE、INSERT、DELETE，就象它的名字一样，这4条命令是用来对数据库里的数据进行操作的语言

DDL(data definition language)：
DDL比DML要多，主要的命令有CREATE、ALTER、DROP等，DDL主要是用在定义或改变表(TABLE)的结构，数据类型，表之间的链接和约束等初始化工作上，他们大多在建立表时使用

DCL(Data Control Language)：
是数据库控制功能。是用来设置或更改数据库用户或角色权限的语句，包括(grant,deny,revoke等)语句。在默认状态下，只有sysadmin,dbcreator,db_owner或db_securityadmin等人员才有权力执行DCL
```

##### 注释和别名

###### 注释

行注释

```mysql
# 到该行结束      # 这个注释直到该行结束 
-- 到该行结束    -- 这个注释直到该行结束（注意断划线后的空格）
```

块注释

```mysql
SELECT 1+
       /* 这是一个
          多行注释
          的形式
      */
      1;
```

###### 别名

使用位置

```mysql
# 别名只能在select、order by、group by、having中使用，不能在where中使用
select 
	xx as alias_name
from
 	xxxx
where xxxx
group by alias_name
having alias_name>10
order by alias_name
```

> 例子：
>
> ```mysql
> select version cv,count(*) as cnt
> from ad_funnel
> where version in ('v1','v2','v3')
> GROUP BY cv
> having cnt>2
> order by cnt;
> ```

##### 特殊处理

###### 结果处理

选取结果添加行号

```mysql
# 方法1 
set @mycnt=0;
select (@mycnt := @mycnt + 1) as ROWNUM , vv from task1_tbl order by vv;

# 方法2
# #将查询结果写入到某个拥有auto_increment字段的临时表中再做查询

# 方法3
# #用Python等脚本语言对查询结果进行二次组装
```

###### 自增列

```mysql
# 建表的时候指定
# > // id列为无符号整型，该列值不可以为空，并不可以重复，而且id列从100开始自增.
create table table_1 ( id int unsigned not null primary key auto_increment, 
                       name varchar(5) not null ) auto_increment = 100;

# 修改自增列的值
alter table table_1 auto_increment = 2;
```

只能修改单机的，集群修改[自增列](http://www.jb51.net/article/42883.htm)无效

###### NULL处理

```mysql
# NULL和任何值运算都是NULL，NULL是假
select 1=1,NULL=1,NULL=NULL,NULL in (1,2),if(NULL in (1,2),'12','e'); #结果：1 NULL NULL e
```

### 高级

#### 锁

数据库锁定机制是数据库为了保证数据的一致性而是各种共享资源在被并发访问变得有序所设计的一种规则。

引擎和锁类型的对应关系

| 表类型    | （支持的）锁类型 | 死锁   | 备注    |
| ------ | -------- | ---- | ----- |
| MyISAM | 表锁       | 不存在  |       |
| InnoDB | 行锁/表锁    | 存在   | 默认是行锁 |
| BDB    | 页锁/表锁    | 存在   |       |

加锁

```mysql

```

##### 锁类型

###### 表锁

表锁有两种模式：

- 表共享读锁（ReadLock）
- 表独占写锁（WriteLock）

MyISAM表的读和写是串行的，即在读操作时不能写操作，写操作时不能读操作。

###### 行锁

//待添加

###### 页锁

//待添加

##### 死锁

###### 原因

为什么会发生死锁

###### 解决

怎样解决死锁

#### 存储过程

存储过程和函数的区别：

- 函数中表名和列名都不能是变量
- PREPARE语句只能用于MySQL5.0版本以上的存储过程里，不能用在函数或者触发器里
- 调用方法不一样
- 存储过程常用在事件和触发器中，函数用在sql语句中

##### 创建

```mysql
CREATE PROCEDURE sp_name([IN|OUT|INOUT] param_name type) [characteristics] routine_body

#1.其中CREATE PROCEDURE为创建存储过程的关键字，sp_name为存储过程的名称，为指定存储过程的参数
#2.characteristics指定存储过程的特性
#3.routine_body是SQL代码的内容， 可以用BEGIG...END来表示SQL代码的开始和结束

#例子：
DROP PROCEDURE IF EXISTS test_add;
DELIMITER //
CREATE PROCEDURE test_add()
BEGIN
  DECLARE 1_id INT DEFAULT 1;
  DECLARE 1_id2 INT DEFAULT 0;
  DECLARE error_status INT DEFAULT 0;
  DECLARE datas CURSOR  FOR SELECT id FROM test;  # 声明游标
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET error_status=1;
  OPEN datas;  # 打开游标
    FETCH datas INTO 1_id;
    REPEAT
      SET  1_id2=1_id2+2;
      UPDATE test SET id2=1_id2 WHERE id=1_id;
      FETCH datas INTO 1_id;
      UNTIL  error_status
    END REPEAT;
  CLOSE  datas;
END
//

DELIMITER ;
```

存储过程相关信息：

```mysql
# 显示创建语句
show create procedure p1;
# 显示创建时间、创建者等详细信息
show procedure status like '%p1%';
```

###### 参数

存储过程的参数共有三种类型:in,out,inout

```mysql
create procedure p1(in numer int,out total decimal(8,2))
begin
	-- 这是存储过程中的注释
	select sum(1) from tbl1 where id=number into total;
end
```

###### 逻辑

在存储过程中包含业务规则和逻辑处理才是智能的存储过程。

```mysql
# 控制逻辑
if xx then
end if;

# 循环
repeat
until xxx
end repeat
```

##### 调用

可在一个存储过程里调用另一个存储过程，存储过程的调用一般是在事件中进行

```mysql
# 无参
call sp_name();

# 有参
call sp_name(@o1,@o2,'v',@io1);
select @o1,@o2,@io1;
```

###### 权限

存储过程的创建权限和调用权限是分开设计的，可根据实际情况进行配置。

##### 游标

mysql返回一组称为结果集的行，使用简单的查询语句无法得到第一行、下一行或者前十行，也不存在每次一行的处理所有行的简单办法。而且mysql中游标只能用于存储过程和函数。

游标的使用，遵循以下步骤：

- 声明游标
- 打开游标
- 检索数据
- 关闭游标

例子：

```mysql
create procedure p1()
begin
	DECLARE 1_id INT DEFAULT 1;
 	DECLARE terminal_flag INT DEFAULT 0;
	declare t decimal(8,2);
	declare flag bool default 0;
	# 声明游标
	declare cname cursor for select id from xxx.xxx;
	DECLARE CONTINUE HANDLER FOR <NOT FOUND> SET terminal_flag=1;
	# 打开游标
	open cname;
	
	# 检索数据
	repeat
		fetch cname into 1_id;
	until terminal_flag
	end repeat

	# 关闭游标
	close cname;
end;
```

> 备注：
>
> - 其中的`NOT FOUND`是错误码，更多的错误码可以参考官方的error_handling
> - 句柄必须在游标之后定义，句柄中使用的局部变量必须在游标前定义

#### 函数

##### 库函数

###### 字符串处理

日期字符串转换

```mysql
# 单字符串
## mysql法
concat_ws('/',substring(date,1,4),substring(date,5,2),substring(date,7,2))

## awk法
echo "20161212"| awk '{print substr($1,1,4)"/"substr($1,5,2)"/"substr($1,7,8)}'
echo "20161212"| awk '{printf("%s/%s/%s",substr($1,1,4),substr($1,5,2),substr($1,7,8))}'

## shell法(注意shell循环读入变量的方式)
a=20161212
while read line;do echo ${line:0:4}"/"${line:4:2}"/"${line:6:2}; done<<< "${a}"

# 文件
## mysql法
#导入导出麻烦

## awk法(指定列修改)
awk '{for(i=1;i<NF;i++) if(i==1) printf("%s/%s/%s",substr($i,1,4),substr($i,5,2),substr($i,7,8));else printf("\t%s",$i);printf("\n");}' user_pos_num

##shell法
fin='xxx.data'
while read line;do
    linearr=($line)
    for i in `seq 0 $((${#linearr[@]}-1))`;do
        if [ $i -eq 0 ];then
            echo -n ${line:0:4}"/"${line:4:2}"/"${line:6:2}
        else
            echo -n -e  "\t"${linearr[$i]}
        fi
    done
    echo 
done< "$fin"
```

> 备注： 日期从20161212转换成2016/12/12,后者的格式能容易被excel处理

trim函数

```mysql
#trim函数可以过滤指定的字符串： 
#完整格式：TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str) 
#简化格式：TRIM([remstr FROM] str) 
# 默认是BOTH和删除两端的空格

SELECT TRIM(TRAILING ',' FROM ',bar,xxyz,'); 
```

substring_index

```mysql

```

###### 类型转换

```mysql
# 字符串转数字
SELECT CAST('123' AS SIGNED);
SELECT CONVERT('123',SIGNED);
SELECT '123'+0;
```

###### IP处理

```mysql
# int->ip
select inet_ntoa(3507806248); #209.20.224.40 

# 还存在问题
select concat_ws('.',cast(3507806248/pow(256,3) as signed),cast((3507806248%pow(256,3))/pow(256,2) as signed),cast(3507806248/pow(256,1) as signed),cast(3507806248/pow(256,0) as signed));

# ip->int
select 209*pow(256,3)+20*pow(256,2)+224*pow(256,1)+40*pow(256,0); # 3507806248
select inet_aton('209.20.224.40'); # 3507806248
```

###### url处理

```mysql
# 提取url域名
select substring_index(substring_index('http://wz.cnblogs.com/my/search/?q=cookie','/',3),'/',-1);
```

###### 日期处理

```mysql
# 待补充
```

##### 自定义函数

语法

```mysql
delimiter /
use study;
drop function if exists `study`.`getchild`;
create function `getchild`(rootid varchar(36))
returns varchar(1000)
begin
    declare ptemp varchar(1000);
    declare ctemp varchar(1000);
    set ptemp = '#';
    set ctemp = rootid;
    while ctemp is not null do
        set ptemp = concat(ptemp, ',', ctemp);
        select group_concat(id)
        into ctemp
        from dim_parent_son2
        where find_in_set(pid, ctemp) > 0;
    end while;
    return ptemp;
end; /
delimiter ;
```

> [delimiter用法详解](https://blog.csdn.net/yuxin6866/article/details/52722913)

注意

###### 集锦

- Nth Highest

```mysql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
  BEGIN
	set N=N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT IFNULL((SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT N,1), NULL)  
    );
END
```

- 阶乘

```mysql
CREATE FUNCTION factorial(n INT) RETURNS INT
BEGIN
	-- 阶乘
	DECLARE i INT DEFAULT 1;
	DECLARE result INT DEFAULT 0;
	
	WHILE i<=n DO
		SET result=result*i;
		SET i=i+1;
	END WHILE;
	
	RETURN result;
END
```

- 树型查询

```mysql

```



##### 函数集锦

###### inerval

```mysql
# INTERVAL()函数进行比较列表(N，N1，N2，N3等等)中的N值。该函数如果N<N1返回0，如果N<N2返回1，如果N<N3返回2 等等。如果N为NULL，它将返回-1。列表值必须是N1<N2<N3的形式才能正常工作
SELECT INTERVAL(6,1,2,3,4,5,6,7,8,9,1); -- 返回比N大的位置
SELECT NOW()-INTERVAL 24 HOUR  -- 时间比较： 返回 前一天
```

###### group_concat

将组值多行合并成一列

```mysql
select name
	,GROUP_CONCAT(course SEPARATOR '_') as names
	,GROUP_CONCAT(score ORDER BY score SEPARATOR '_') as scores 
from name_course_score 
group by name;
```

> 支持自定义分割符，和组内排序

例子：

```
张三	语文	66
张三	数学	23
张三	英语	89
李四	语文	95
李四	数学	12
李四	物理	2

-- 转换成
张三	语文_数学_英语	23_66_89
李四	语文_数学_物理	2_12_95
```

> 反向拆分：
>
> 将一列拆分成多行，参见列转行部分

#### 事件 

类似于linux的crontab的事件调度器（event-scheduler），可定期执行某一个命令或者sql语句,通常的应用场景是通过事件来调用存储过程。

查看事件是否开启：

```
SHOW VARIABLES LIKE 'event_scheduler';
SELECT @@event_scheduler;
SHOW PROCESSLIST;
```

> 如果看到event_scheduler为on或者PROCESSLIST中显示有event_scheduler的信息说明就已经开启了事件。如果显示为off或者在PROCESSLIST中查看不到event_scheduler的信息，那么就说明事件没有开启，我们需要开启它。

##### 开启事件

```
SET GLOBAL event_scheduler = ON;
更改完这个参数就立刻生效了

注意：还是要在my.cnf中添加event_scheduler=ON。因为如果没有添加的话，mysql重启事件又会回到原来的状态了。

更改配置文件然后重启

在my.cnf中的[mysqld]部分添加如下内容，然后重启mysql。
event_scheduler=ON

通过制定事件参数启动
mysqld ... --event_scheduler=ON
```

##### 事件语法

创建

```mysql
CREATE
    [DEFINER = { user | CURRENT_USER }]
    EVENT
    [IF NOT EXISTS]
    event_name
    ON SCHEDULE schedule
    [ON COMPLETION [NOT] PRESERVE]
    [ENABLE | DISABLE | DISABLE ON SLAVE]
    [COMMENT 'comment']
    DO event_body;

schedule:
    AT timestamp [+ INTERVAL interval] ...
     | EVERY interval
    [STARTS timestamp [+ INTERVAL interval] ...]
    [ENDS timestamp [+ INTERVAL interval] ...]

interval:
  quantity {YEAR | QUARTER | MONTH | DAY | HOUR | MINUTE |WEEK | SECOND | YEAR_MONTH | DAY_HOUR |
			DAY_MINUTE |DAY_SECOND | HOUR_MINUTE |HOUR_SECOND | MINUTE_SECOND}
```

参数详细说明：

> DEFINER: 定义事件执行的时候检查权限的用户。
>
> ON SCHEDULE schedule: 定义执行的时间和时间间隔。
>
> ON COMPLETION [NOT] PRESERVE: 定义事件是一次执行还是永久执行，默认为一次执行，即NOT PRESERVE。
>
> ENABLE | DISABLE | DISABLE ON SLAVE: 定义事件创建以后是开启还是关闭，以及在从上关闭。如果是从服务器自动同步主上的创建事件的语句的话，会自动加上DISABLE ON SLAVE。
>
> COMMENT 'comment': 定义事件的注释。

更改

```mysql
alter ...
```

删除

```mysql
DROP EVENT [IF EXISTS] event_name
```

#### 事务

Myisam不支持事务，InnoDB支持事务，事务是用来维护数据库完整性的，它能保证成批的mysql操作，要么完全执行，要么完全不执行。

##### 处理过程

事务处理用来管理insert、update、delete操作，不能回退select、create、drop操作

```mysql
start transaction; # 开始事务
# 相关操作
commit;
rollback；
```

###### commit

一般的mysql语句都是直接针对数据库表执行和编写的，都是隐含提交，即提交操作都是自动进行的。但是在事务处理块中，提交不会隐含地进行，为进行明确的提交，需要使用commit语句。

设置自动提交

```mysql
set autocommit=1;
```

###### 保留点

复杂的事务处理需要部分提交或者回退。保留点的作用是在事务处理块中合适的位置放置占位符，如果需要回退的时候，可以回退到某个占位符。

```mysql
savepoint sp1;
#操作
rollback to sp1;
```

#### 外键

//外键的作用

#### 触发器

想要在某条语句或者某些语句在事件发生时自动执行，触发器是mysql响应insert、update、delete时候自动执行的一组mysql语句。

mysq表中允许有以下六种触发器:

- insert
  - before insert
  - after insert
- update
  - before update
  - after update
- delete
  - before delete 
  - after delete

##### 操作

###### 创建触发器

```mysql
CREATE TRIGGER trigger_name trigger_time trigger_event 
ON tbl_name FOR EACH ROW trigger_stmt

### 参数说明：
# trigger_name:触发器名称
# trigger_time:触发的动作时间before或after，以指明触发程序是在激活它的语句之前或之后触发。
# trigger_event:指明了激活触发程序的语句的类型
	INSERT：将新行插入表时激活触发程序
	UPDATE：更改某一行时激活触发程序
	DELETE：从表中删除某一行时激活触发程序
# tbl_name：监听的表，必须是永久性的表，不能将触发程序与TEMPORARY表或视图关联起来。
# trigger_stmt：当触发程序激活时执行的语句。执行多个语句，可使用BEGIN...END复合语句结构
```

一个例子：

```mysql
create TRIGGER up_conter after insert 
on documents for each row
BEGIN
	set new.content=new.title; # 注意不要在触发器的操作语句中使用update等操作
END
```

注意事项:

- 只有表才支持触发器，视图和临时表都不支持
- 触发器按每个表每个时间定义，所以每个表最多支持6个触发器
- 触发器不能关联多个表或者多个事件

权限：

创建触发器可能需要特殊权限，但是触发器的执行是自动，如果能执行insert、update、delete操作，则对应的触发器也能执行。

###### 删除触发器

```mysql
DROP TRIGGER [schema_name.]trigger_name
#可以使用old和new代替旧的和新的数据
#更新操作，更新前是old，更新后是new.
#删除操作，只有old.
#增加操作，只有new.
```

##### 应用

触发器之前不能根据条件选择触发器是否触发，但是可以在触发器的处理逻辑里进行条件判断，从而选择需要执行的操作。

触发器的执行单元必须是for each row吗？

触发器的一个重要应用是进行审计跟踪，把更高记录到另一表中。

mysql触发器内不支持调用存储过程？（后面的版本支持了吗）

###### insert触发器

可引用NEW的虚拟表，before insert触发器可允许在插入前更新被插入的值。

```mysql
create trigger t1 after insert on orders for each row
select new.order_num;
```

###### update触发器

可引用NEW、OLD的虚拟表，before update触发器可运行在更新前修改被更新的值。

```mysql
create trigger t1 before update on vendors for each row
set new.vend_state=upper(new.vend_state);
```

###### delete触发器

可引用OLD的虚拟表，OLD中的值全部是只读的，不能更新

```mysql
create trigger t1 before delete on vendors for each row
begin
	insert into tbl1(x,x,x) values(old.x,old.x,old.x)
end
```

参考：

[MySQL触发器简单实例](http://www.cnblogs.com/nicholas_f/archive/2009/09/22/1572050.html)

[already used by statement](https://stackoverflow.com/questions/15300673/mysql-error-cant-update-table-in-stored-function-trigger-because-it-is-already)

[MySQL触发器](http://www.toutiao.com/i6468771136527139341/)

#### 权限

视图和表的设置权限

### 查询

基础查询

```mysql
# 按汉字的首字母拼音排序
SELECT name_varchar from study.datatype order by CONVERT(name_varchar USING gbk) ;
```

#### 索引

从索引所使用的列的可区分为单索引和联合索引

从使用的索引方法可以分为以下几种： 

- 唯一索引：数据列不允许重复，允许为NULL值，一个表允许多个列创建唯一索引。


- 普通索引：基本的索引类型，没有唯一性的限制，允许为NULL值。
- 主键索引：:数据列不允许重复，不允许为NULL.一个表只能有一个主键。

索引的创建部分参考基础知识部分

##### 单索引

###### 主键索引

```mysql

```

###### 唯一索引

```mysql

```

###### 普通索引

```mysql
create table `ftbl_clean_channel_front_remain` (
  `ftime` varchar(20) default null,
  `fdim_channelid` varchar(50) default null,
  `fstart_date` varchar(20) default null,
  `fend_date` varchar(20) default null,
  `ffact_cnt` int(11) default null,
  key `index_time` (`ftime`),
  key `index_channelid` (`fdim_channelid`),
  key `index_start` (`fstart_date`),
  key `index_end` (`fend_date`),
  key `ins_startdate` (`fstart_date`)  # 索引重复
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
```

##### 联合索引

创建联合索引

```mysql

```

联合索引的注意事项

```shell

```

#### 匹配

mysql[正则](http://www.cnblogs.com/way_testlife/archive/2010/09/17/1829567.html)和模糊匹配的区别:

##### 正则

[not]regexp、[not]rlike

```mysql
# 正则判断（匹配返回1，不匹配返回0）
select 'JetPack 1000'  regexp '^1000';
```

注意：

> - MySQL中的正则表达式匹配不区分大小写。为区分大小写，可使用BINARY关键字（on也不区分大小写）
>
>   如：select 'JetPack we2x000'  REGEXP BINARY 'JetPack .000'
>
> - 若字段强制[区分大小写](https://www.2cto.com/database/201209/156617.html)，可以在建表的时候指定
>
> ```mysql
> create  table  table_name(    
>      name varchar (20) binary      
> );  
> ```

##### 模糊匹配

[通配字符](https://blog.csdn.net/lisliefor/article/details/6547861)：

_：代表单个字符(相当于正则表达式中的 ?  )

%：代表多个字符(相当于正则表达式中的 * )

[]：用于转义（事实上只有左方括号用于转义，右方括号使用最近优先原则匹配最近的左方括号）

^：用于排除一些字符进行匹配（这个与正则表达式中的一样）

```mysql
select * from xx where xx like '%_%'
```

###### 特殊字符

//主要处理一些包含元字符的字符串的匹配问题

#### 子查询

子查询是从最内层的查询开始执行的

##### 分类

根据子查询的返回值分：

- 单一值：变量子查询
- 一行: 行子查询
- 一列:列子查询
- 一个表:表子查询

根据子查询的出现位置分：

- where之后:where子查询
- from之后：from子查询

例子：

```mysql
# 内层不和外层联系
select id-(select pv_int from study.task where id=2) from study.task;

# 内层和外层联系-字段
select price-(select amount from study.test where articleid=t.articleid) from study.test t;

# 内存和外层联系-where
select ftime,funnel_pos,funnel_name
from ad_funnel_test t
where funnel_level=(select min(funnel_level) from ad_funnel_test where ftime=t.ftime and funnel_pos=t.funnel_pos);
```

##### 关键字

exists、any、all三个关键字，这些关键字此处配合的都是where子查询

###### exists关键字

内层查询语句不返回查询记录，而是返回一个真假值

```mysql
# 内层和外层无交互
select ename,gender from employee where exists(select * from employee where ename='成龙');

# 返回a表中满足id在b表中条件的记录（内层和外层交互）
select * from goods a where exists(select cat_id from category b where a.cat_id = b.cat_id);
select * from row2col_tbl a where exists(select * from row2col_tbl b where a.date=b.date and b.stat_flag='click');
```

###### any关键字

只要满足内存查询语句返回结果中的任意一个，就可以执行外层查询语句

```mysql
# 这个就是查询所有购买数量大于49的订单的信息！
select order_id,customer_id,order_number,order_date from `order` where order_id = any(select order_id from order_detail where buy_number>49);

# 注意返回的比较情况
select * from row2col_tbl a where date>any(select date from row2col_tbl b where a.date=b.date and b.stat_flag='click');
```

###### all关键字

```mysql
# 所有满足订单的总金额大于单价*10的订单的信息
select order_id,customer_id,order_number,order_date from `order` where total_money > all(select price*10 from order_detail);

select * from row2col_tbl a where date>=all(select date from row2col_tbl b where a.date=b.date and b.stat_flag='click');
```

==exists和in区别==

这两者的使用条件

```mysql
#这条语句适用于a表比b表大的情况
select * from ecs_goods a where cat_id in(select cat_id from ecs_category);

#这条语句适用于b表比a表大的情况
select * from ecs_goods a where EXISTS(select cat_id from ecs_category b where a.cat_id = b.cat_id);
```

##### 实战

基础

```mysql
use study;
SELECT article,author,(select price from test where author=t.author and article=t.article)pre from test t;
```

升级

```mysql
SELECT ftime,item_id,seq_id, user_cnt,order_amt,
    (
        SELECT
            user_cnt
        FROM
            hubble_vip_xl9_funnel_new_day
        WHERE
            ftime = t.ftime AND item_id = t.item_id
        AND seq_id = (
            SELECT
                pre_seq_id
            FROM
                v_d_funnel_process_new
            WHERE
                item_id = t.item_id AND seq_id = t.seq_id
        )
    )pre_user_cnt  # 这个查询的结果作为一个类似字段返回
FROM
    hubble_vip_xl9_funnel_new_day t
```

> 这个技巧可用于漏斗分析

#### 连接

#####  inner join

inner join 其实等同于join

```mysql
SELECT 
	Persons.LastName
   ,Persons.FirstName
   ,Orders.OrderNo
FROM Persons
INNER JOIN Orders
ON Persons.Id_P = Orders.Id_P；

# 等效于
SELECT
	Persons.LastName
   ,Persons.FirstName
   ,Orders.OrderNo
FROM
	Persons,
	Orders
WHERE
	Persons.Id_P = Orders.Id_P
```

> 不确定hive有没有这种写法

多表连接：

```mysql
# 方法1：
select a.ftime,a.dnu,b.dau,c.dcu,d.dpu from 
(select ftime,sum(dnu) as dnu from xmp_dnu group by ftime) a inner join 
(select ftime,sum(dau) as dau from xmp_dau group by ftime) b inner join
(select ftime,dcu from xmp_dcu) c inner join
(select ftime,total_vod as dpu from complat_xmp_vod_detail where channel='all' and cnt_flag='uv' ) d 
on a.ftime=b.ftime and a.ftime=c.ftime and a.ftime=d.ftime

# 方法2：
select a.ftime,a.dnu,b.dau,c.dcu,d.dpu 
from 
	(select ftime,sum(dnu) as dnu from xmp_dnu group by ftime) a 
inner join 
	(select ftime,sum(dau) as dau from xmp_dau group by ftime) b 
on a.ftime=b.ftime
inner join
	(select ftime,dcu from xmp_dcu) c
on a.ftime=c.ftime
inner join
	(select ftime,total_vod as dpu 
       from complat_xmp_vod_detail 
      where channel='all' and cnt_flag='uv' ) d 
on a.ftime=d.ftime;
```

##### outer join

###### left [outer] join

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

###### right [outer] join

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

###### full [outer] join

mysql本身不支持full join 需要变通解决

```mysql
# 本身不支持
```

##### union join

```mysql
# 请注意，UNION 内部的 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型。同时，每条 SELECT 语句中的列的顺序必须相同。
# 注释：默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。
SELECT	* from	persons
UNION All
SELECT	* from	persons;
```

##### cross join

笛卡尔积

```mysql
SELECT
	b.*
from
	student a,
	persons b
where
	a.stuno = b.Id_P;

# 等同于
#SELECT b.* from student a CROSS JOIN persons b where a.stuno=b.Id_P;

# 总结：
#1，带where子句的cross join 和inner join(或者join)等效
#2，不带where子句的产生的查询结果才是笛卡尔积
```

#####  注意事项

###### [on where的执行顺序](https://www.cnblogs.com/Jessy/p/3525419.html)	

- join的时候先对两张表做where条件筛选，然后再做join,这样可以减小联表的量

````mysql
# 在on条件中过滤
select
	a.x,a.z,b.y
from 
	tbla a
inner join 
	tblb b
on a.x=b.x and a.y='vvv' and b.z="vwew";  # 不加on条件相当于交叉积

# where中条件过滤
select
	a.x,a.z,b.y
from 
(select x,z from tbla where y='vvv')a
inner join 
(select x.y from tblb where z='vwer') b
on a.x=b.x 
where xxx; # 此处也可再进行过滤 
````

> on中单表条件的过滤是在join之前进行的,还是在join之后进行的，这个要进行测试

###### on多条件

直接把on的单表筛选条件放在on中，可以减少子查询这一环，但带来的性能消耗暂时不知

> 表1：study.t_join_a

| id   | amount |
| ---- | ------ |
| 1    | 100    |
| 2    | 200    |
| 3    | 300    |
| 4    | 400    |

> 表2：study.t_join_b

| id   | weight | exist |
| ---- | ------ | ----- |
| 2    | 22     | 0     |
| 4    | 44     | 1     |
| 5    | 55     | 0     |
| 6    | 66     | 1     |


**left join muti on**

```mysql
# left join on多条件支持(把on的所有条件作为匹配条件，不符合的右表都为null)
select * from t_join_a a left t_join_b b on a.id=b.id and a.amount=200;
select * from t_join_a a left t_join_b b on a.id=b.id;
```

![on多条件](http://tuling56.site/imgbed/2018-07-30_201552.png)



**inner join muti on**

```mysql 
select * from t_join_a a join t_join_b  b on a.id=b.id and a.amount=200;
# 等效于
select * from t_join_a a left join t_join_b  b on a.id=b.id where a.amount=200;
```

**right join muti on**

```mysql

```

###### 等值连接

条件运算，on支持等值的数学运算

```mysql
select a.ds,b.ds 
from tbl_a
inner join tbl_b
on a.ds=b.ds+1;
```

> on中的数学运算的计算负载有多高

###### 非等值连接

判断一个表中的一个字符串包含另一个表中一个字段的子串

```mysql
SELECT *
FROM table1
RIGHT JOIN table2
ON table2.x LIKE CONCAT('%' , table2.y , '%')；
```

###### 跨库Join

跨库甚至跨实例、跨机房、跨区域的join的出现是因为提高业务的高可用性而进行了数据库的水平拆分和垂直拆分，传统的方式是将所有数据先汇集到同一处，然后做离线查询分析，带来的问题是数据延迟、资源消耗及额外支出的运维成本，而且也无法满足实时性的需求。

跨库Join的几种方案：

- 字段冗余设计
- 表复制和同步到一个库中
- 链接表

**链接表**

链接表的使用要求FEDERATED 的打开，默认是关闭的

```mysql
# 链接表的创建
CREATE TABLE `link_tbl` (
`uninstalldate`  varchar(10)  NOT NULL DEFAULT '' ,
`newinstalldate`  varchar(10)  NOT NULL DEFAULT '' ,
`coverinstalldate`  varchar(10)  NOT NULL DEFAULT '' 
)
ENGINE=FEDERATED
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=COMPACT
CONNECTION='mysql://root:root@localhost:3306/task/xmp_uninstall'  
COMMENT='task.xmp_uninstall－链接表[3306]';
```

链接表的注意事项：

```
1.本地的表结构必须与远程的完全一样
2.远程数据库目前仅限MySQL（其它主流数据库暂不支持）
3.不支持事务
4.不支持表结构修改
```

更多参考：[如何玩转跨库Join-阿里云](https://m.aliyun.com/yunqi/articles/686027)

### 积累

#### 技巧

##### 运行技巧

###### 重定向和管道

```shell
# 方法1
${MYSQL10} < xmp_version_active.sql
#其中MYSQL10是:`/usr/bin/mysql -uroot -phive -N`


# 方法2
MYSQL="/usr/bin/mysql -uxxxx -pxxxx -hxxxx -Pxxxx"
sql="select movieid,pageurl from poster where image_type='poster' and ts >='${time_start}'"
echo "${sql}" | ${MYSQL} media_info |sed '1d' > ${file}

Local_MYSQL="/usr/bin/mysql -uxxxxx -pxxxx -hxxxxx media_info"
echo "alter table media_relation_search_pc rename media_relation_search_pc_old_$(date +'%Y%m%d');" | $Local_MYSQL

# 方法3
cat /data/rsync_data/kk_sql/videos.sql |$mysql video
echo "show tables;"| mysql -uroot -proot -Dsnh48
```

###### source方法

一次运行多个sql文件

```mysql
#在文件 batch.sql 中写下多个SQL文件
source file1.SQL
source file2.SQL
source file3.SQL
#然后运行 source batch.sql
```

##### 插入技巧

###### 一次性多插

```mysql
# 一次性插入多个值
INSERT into task_request(proposer,enddate) values ("鲁丽",'20170611'),("张一",'20170322'),("王二",'20170101');

# 从tb1中选出两列插入到tb2中
INSERT into tb2(proposer,enddate) select xx,yy from tb1;
```

###### 更新插入

方法1：insert into ... values ... [on dubplicate key] update  

```mysql
INSERT INTO tablename (field1, field2, field3, ...) VALUES ('value1', 'value2','value3', ...) ON DUPLICATE KEY UPDATE field1='value1', field2='value2', field3='value3', ...

# 这个语句的意思是，插入值，如果没有该记录执行
INSERT INTO tablename (field1, field2, field3, ...) VALUES ('value1', 'value2','value3', ...)
# 这一段，如果存在该记录，那么执行
UPDATE field1='value1', field2='value2', field3='value3', ...
```

> [一个例子](https://www.cnblogs.com/liaojie970/p/6824773.html)：

```mysql
INSERT INTO tablea (peerid,new_install_date,new_install_source,new_install_version,new_install_type,insert_date,insert_source,insert_version,insert_type) VALUES("%s","%s","%s","%s","%s","%s","%s","%s","%s") ON DUPLICATE KEY UPDATE new_install_type="%s"' 
```
方法2：[replace into](https://www.cnblogs.com/c-961900940/p/6197878.html)

```mysql
# 主键不存在则插入，主键或者唯一索引存在相同的值，则不更新
replace into table (id,name) values('1′,'aa'),('2′,'bb')
```

##### 筛选技巧

###### 字段和表类型筛选

查询某个字段匹配的的表和所在的数据库

```mysql
SELECT TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME from information_schema.`COLUMNS` where COLUMN_NAME like '%isover%';
```

筛选某种类型的表和所在的库

```mysql
select table_schema,table_name from information_schema.tables 
where table_type='base table' and engine='innodb' and table_schema!='mysql' and table_name not like '%innodb%';
```

###### [同一属性多值过滤](https://www.imooc.com/learn/449)

选出同时具有fei和bianhua能力的人

**Join实现**

```mysql
# 方法1：
SELECT DISTINCT a.name AS '念经&变化' 
from t_nameskills a 
JOIN t_nameskills b 
on a.name=b.name and b.skills='念经'
JOIN t_nameskills c 
on a.name=c.name and c.skills='变化';

# 方法1:(解释)
SELECT
	a.name,
	b.skills as bskill
	c.skills as cskill
FROM
	t_nameskills a
INNER JOIN 
	t_nameskills b 
on a.name = b.name and b.skills = 'nianjing';
INNER JOIN
	t_nameskills c 
on a.name = c.name and c.skills = 'fanren';
```

**groupby实现：**

```mysql
# 方法1(待确认)：
select name,group_concat(skills) as gcs 
from t_nameskills 
group by name 
having  find_in_set('念经',gcs) and find_in_set('变化',gcs); 


# 方法2：(效率低，like使得索引失效)
select name,group_concat(skills) as gcs 
from t_nameskills 
group by name 
having gcs like '%念经%' and gcs like '%变化%'; 
```

> 此处主要牵涉到集合操作，目前还没有比较好的实现方式

##### 更新技巧

###### 关联更新

根据另一个表的数据，更新当前表的数据:

```mysql
# 在a表和b表满足xx条件的时候更新a表的什么内容
update pgv_stat.xmp_version_active a 
inner join 
(select date,version,sum(online_user) user,sum(total_uv) vod 
from pgv_stat.xmp_total_vod where date='$dt' and channel='all' group by version) b 
on a.date=b.date and substring_index(a.version,'.',-1)=b.version 
set a.online_user=b.user,a.total_uv=b.vod where a.date='$dt';
```

```mysql
# 在a表和b表满足xx条件的时候更新a表的什么内容
UPDATE downloaddatas a, downloadfee b 
SET a.ThunderPrice=$PRICE, a.ThunderAMT=(a.ThunderCop+a.btdownnum3)*$PRICE 
WHERE a.CopartnerId=b.copartnerid AND b.inuse=1 AND a.BalanceDate>=DATE_FORMAT(b.starttime,'%Y-%m-%d') AND a.BalanceDate='$BALANCEDATE'

#在a表和b表满足xx条件的时候更新b表的什么内容
update union_kuaichuan_download_data a,downloaddatas b set b.ThunderQty=b.ThunderQty+a.copdowntimes 
where a.dayno=$d and b.BalanceDate=_gbk\"${dt}\" and b.CopartnerId=a.copid  and b.ProductNo=4
```

###### 批量更新

```mysql

```

##### 删除技巧

###### 删除重复

在删除的时候可能会根据某些条件保留其中的一条

```mysql
# 删除所有重复
//待补充

# 删部分重复，只保留其中id最小的
delete from Person 
where Id not in (select a.Id from (select min(Id) as Id from Person group by Email)a);
```

##### [累进税率](https://www.imooc.com/learn/449)

//这个要不断的完善，把相关的技巧融合进实战中




#### 日期时间

##### 上周同期

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

周同期2

```mysql
# 这周的数据
tablea="select date,sum(install_end) as s_install_end,sum(install_silence) as s_install_new from xmp_install where date>=date_sub(curdate(),interval 7 day) group by date"

# 上周的数据
tableb="select date,sum(install_end) as s_install_end,sum(install_silence) as s_install_new from xmp_install where date>=date_sub(curdate(),interval 14 day) group by date"

# 要统计的数据
whatis="a.date as '当前日期',b.date as '上周同期',a.s_install_end as '总安装量',b.s_install_end as '上周同期总安装量',concat(round((a.s_install_end-b.s_install_end)*100/b.s_install_end,2),'%') as '总装周同比'"

# 展示结果
sql = "SELECT {whatis} FROM ({tablea}) a INNER JOIN ({tableb}) b on b.date=DATE_FORMAT(DATE_SUB(a.date,INTERVAL 7 day),'%Y%m%d') order by a.date desc".format(whatis=whatis,tablea=tablea,tableb=tableb)
```

##### 选取指定日期

```mysql
select (DATEDIFF(DATE_ADD(curdate, INTERVAL - DAY(curdate)+ 1 DAY), date_add(curdate- DAY(curdate)+ 1, INTERVAL -1 MONTH)))  as '上月总天数', DATE_ADD(curdate,interval -day(curdate)+1 day) as '当月第一天', date_add(curdate-day(curdate)+1,interval -1 month ) as '上月第一天';
```

> 这段还没有完全调通



#### 字符串

##### 字符包含

###### 单字段包含

判断某个字段是否[包含](http://blog.csdn.net/hechurui/article/details/49278493)某个字符串的方法

```mysql
# 方法1：
SELECT * FROM users WHERE emails like "%b@email.com%";

# 方法2：find_in_set(subtr,str)函数是返回str中substr所在的位置索引，str必须以","分割开,若没有返回0。
SELECT find_in_set('3','13,33,36,39') as test;

# 方法3：locate(substr,str)函数，如果包含，返回>0的数，否则返回0 
# 例子：判断site表中的url是否包含'http://'子串,如果不包含则拼接在url字符串开头
update site set url =concat('http://',url) where locate('http://',url)=0;
```

例子：

```mysql
select if(b.channel_type is NULL,'其它',b.channel_type),a.channel from channels_data a LEFT JOIN channels_conf b on FIND_IN_SET(a.channel,b.channels)>0;
```

###### 多列组合包含

```mysql
select * from `magazine` where concat(ifnull(`title`,''),ifnull(`tag`,''),ifnull(`description`,'')) like '%关键字%';
```

> 注意多列组合包含的情况下，若一列为null，则整个为null,遗漏记录

##### 字符替换

###### 普通字符串替换

```mysql
select replace('com.pro.xuncle.Download','xuncle','');
```

> mysql不支持正则替换

###### 特殊字符替换

char(9)：水平制表符，char(10)：换行键，char(13)：回车键

```mysql
1> 回车符  char(13)
SELECT *, REPLACE(detail, CHAR(13) , '<br>') AS 显示替换后的内容 FROM Test

2>换行符
SELECT *, REPLACE(detail, CHAR(10), '<br>') AS 显示替换后的内容 FROM Test

3>回车换行符
SELECT *, REPLACE(detail, CHAR(13) + CHAR(10), '<br>') AS 显示替换后的内容 FROM Test

4>将回车换行符替换成<BR><BR>
UPDATE Test SET detail = REPLACE(detail, CHAR(13) + CHAR(10), '<br><br>');
```

##### 字符数组

字符分割的数组长度

```mysql
# imgName格式：bc9077f6.jpg,073eb23f.jpg
select if(imgName='',0,1+(length(imgName)-length(replace(imgName,',','')))) as arraycnt from contribute;
```

##### 字符串分割

```mysql

```

### 应用

#### 行列互转

##### 行转列

###### 行转多列

不存在分列情况下,有两种实现方式`case when`和`inner join`:

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

**例子:**

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

select 年, 
	max(case when 季度=1 then 销售量 else 0 end) as 一季度, 
	max(case when 季度=2 then 销售量 else 0 end) as 二季度, 
	max(case when 季度=3 then 销售量 else 0 end) as 三季度, 
	max(case when 季度=4 then 销售量 else 0 end) as 四季度 
from sales group by 年;

select 年, 
	max(if(季度=1,销售量,0) as 一季度, 
	max(if(季度=2,销售量,0) as 二季度, 
	max(if(季度=3,销售量,0) as 三季度, 
	max(if(季度=4,销售量,0) as 四季度 
from sales group by 年;

```

> 在sql server 2005中有[pivot函数](http://www.studyofnet.com/news/295.html)可以实现同样的功能

###### 行转单列

![行转单列](http://tuling56.site/imgbed/2018-09-13_212053.png)

```mysql
# 在行转多列的基础上，进行group_concat列合并成单列
select name,group_concat(course),group_concat(score) from name_course_score group by name;
```

##### 列转行

输入：

| name  | sign  | flag1 | flag2 | flag3 |
| ----- | ----- | ----- | ----- | ----- |
| zhang | 1_2_4 | a     | b     | c     |
| li    | 1_3   | c     |       | d     |
| er    | 5     | e     |       |       |

输出：

| name  | sign | flag |
| ----- | ---- | ---- |
| zhang | 1    | a    |
| zhang | 2    | b    |
| zhang | 4    | c    |
| li    | 1    | c    |
| li    | 3    | d    |
| er    | 5    | e    |

> sign和flag之间不再做笛卡儿积，此外在列转行的时候丢失了列的意义

###### 单列转行

有两种实现方式:`序列化表`和`union all` 

```mysql
# 1.利用序列化表的方式实现列转行
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

# 2.利用union实现列转行
SELECT user_name,'skills1' as 'jineng',skills1 from nameskills_col
UNION ALL
SELECT user_name,'skills2',skills2 from nameskills_col
UNION ALL
SELECT user_name,'skills2',skills3 from nameskills_col ORDER BY user_name;
```

> 这部分还有很多要完善的地方！进一步扩展的是求一行的最大值和最小值等

###### 多列转行

```mysql
select r.姓名,a.语文,b.数学,c.英语,d.物理 from study.name_course_score_tr r
inner join
(select 姓名,语文 from study.name_course_score_tr)a
on r.姓名=a.姓名
inner join
(select 姓名,数学 from study.name_course_score_tr)b
on r.姓名=b.姓名
inner join
(select 姓名,英语 from study.name_course_score_tr)c
on r.姓名=c.姓名
inner join
(select 姓名,物理 from study.name_course_score_tr)d
on r.姓名=d.姓名;
```

#### 区间分组

使用到interval和etl函数

```mysql
mysql> select * from k1;
+------+------+
| id   | yb   |
+------+------+
|    1 |  100 |
|    2 |   11 |
|    3 |    5 |
|    4 |  501 |
|    5 | 1501 |
|    6 |    1 |
+------+------+

select 
	elt(interval(d.yb,0, 100, 500, 1000), '1/less100', '2/100to500', '3/500to1000', '4/more1000') as yb_level, 
	count(d.id) as cnt
 from k1 d   
group by elt(interval(d.yb, 0, 100, 500, 1000), '1/less100', '2/100to500', '3/500to1000', '4/more1000K');
```

#### GTopN

问题描述：先分组，然后在从分组中选取前N个值，比如topN

##### mysql实现

```mysql
# 例子1：(遍历所有记录，取每条记录与当前记录做比较，只有当同一版本不超过3个比当前高时，才是前三名)。
SELECT
	*
FROM
	study.row2col_tbl AS e
WHERE
	(
		SELECT
			count(DISTINCT(e1.cnt))
		FROM
			study.row2col_tbl AS e1
		WHERE
			e1.date = e.date and e1.xl_version=e.xl_version
		AND e1.cnt > e.cnt) < 2
 ORDER BY e.date;

# 例子2:连接其它表
SELECT
	b.department_name AS Department,
	a.name AS Employee,
	a.salary AS Salary
FROM
	study.employes AS a
INNER JOIN study.department AS b ON a.department_id = b.id
WHERE
	(
		SELECT
			count(DISTINCT(a1.salary))
		FROM
			study.employes AS a1
		WHERE
			a1.department_id = a.department_id
		AND a1.salary > a.salary
	) < 3
ORDER BY
	b.department_name DESC,a.salary DESC;
```

> 用awk(shell),python,R等如何实现

##### awk实现

先分组，分组使用的四关联数组，但是关联数组只能存一个value，是否vlaue类型可支持关联数组，即数组嵌套

```shell
echo | awk 'BEGIN{arr["a"]=1;arr["b"]="b"";c=arr}{for(k in c) print c,arr[c];}' #error
```

##### python实现

```

```

##### R实现

```

```

### 调优

问题排查部分请单独查看性能部分

#### 规范

具体的规范设计和约束

#### 配置优化

##### 提高硬件配置

//balala

##### 优化代码逻辑

//待补充

##### 优化表结构

- 尽量使用int代替char
- 尽量使用char代替varchar
- 不要滥用bigint,参考[各种整型的取值范围](http://wayne173.iteye.com/blog/1631095)

##### 添加缓存(本地/redis)

//待补充

##### 优化查询语句

- 请尽量使用简单的查询，避免使用表链接
- 请尽量避免全表扫描，会造成全表扫描的语句包括但不限于：
  - where子句条件横真或为空
  - 使用LIKE
  - 使用不等操作符（<>、!=）
  - 查询含有is null的列
  - 在非索引列上使用or
- 多条件查询时，请把简单查询条件或则索引列查询置于前面
- 请尽量指定需要查询的列，不要偷懒使用select *
  - 如果不指定，一方面会返回多余的数据，占用宽带等
  - 另一方面MySQL执行查询的时候，没有字段时会先去查询表结构有哪些字段
- 大些的查询关键字比小写快一点点
- 使用子查询会创建临时表，会比链接（JOIN）和联合（UNION）稍慢
- 在索引字段上查询尽量不要使用数据库函数，不便于缓存查询结果
- 当只要一行数据时，请使用LIMIT 1，如果数据过多，请适当设定LIMIT，分页查询
- 千万不要 ORDER BY RAND()，性能极低

#### 优化方向

##### 索引

​	索引通过减少查询必须扫描的数据库中的数据量来提高查询效率，如何设计索引的使用，索引会引入额外的性能问题，比如插入会稍慢。

- 多列索引的设计及什么情况下索引会失效

###### 冗余和重复索引

mysql允许在相同列上创建多个索引，而mysql需要单独维护重复的索引，并且优化器在优化查询的时候也需要逐个地考虑，这会影响性能。

```mysql

```

其他不同类型的索引在[相同列上创建](https://www.cnblogs.com/happyflyingpig/p/7663000.html)（如哈希索引和全文索引）不会是B-Tree索引的冗余索引，而无论覆盖的索引列是什么。 

##### 慢查询

慢查询日志将日志记录写入文件，也将日志记录写入数据库表。

###### 配置

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

###### 分析

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

##### 读写分离

一写多读，写入的数据实时从写库同步到读库，开源代理插件360的atlas

##### 分库/分表

分布式和事务的控制，分库分表的前提条件是在执行查询语句之前，已经知道需要查询的数据可能会落在哪一个分库和哪一个分表中

用法和拆分原则要一开始的时候设计好

#### 具体建议

##### 字段属性

###### 尽可能不使用NULL

NULL的缺点：

- `NULL`使得索引维护更加复杂，强烈建议对索引列设置`NOT NULL`
- `NOT IN`、`!=`等负向条件查询在有`NULL`值的情况下返回永远为空结果，查询容易出错
- `NULL`列需要一个额外字节作为判断是否为`NULL`的标志位
- 使用`NULL`时和该列其他的值可能不是同种类型，导致问题。（在不同的语言中表现不一样）
- MySQL难以优化对可为`NULL`的列的查询

###### 字符串的长度

- 长度类型设置够用就行了，比如能够设置成varchar(10）就不要设置成varchar(100)

###### 整型代替字符串

数值型数据的处理起来的速度要比文本类型快很多

- 可以用整型`tinyint`表示的数据就不要使用字符串类型，例如性别等

##### 查询设计

###### 避免索引失效

- .索引可以加快查询速度但是有的操作却能破坏索引，比如：!=，<>操作符等会使索引失效。
- 尽量不要在 where 子句中使用 or 来连接条件，这样会破坏索引。
- 使用LIKE '%ABC'或LIKE '%ABC%'类型的查询也会破坏索引使索引失效，可以尝试使用全文搜索。
- 避免在 where 子句中对字段进行表达式操作或进行函数操作，这将导致引擎放弃使用索引而进行全表扫描

###### NeverSelect*

用具体的字段代表，不要返回任何使用不到的字段

###### 使用Union

将更多的查询合并到一个查询中，客户短查询结束时，临时表会自动删除

###### 事务

子查询（Sub-Queries）、连接（JOIN）和联合（UNION）来创建各种各样的查询，但不是所有的数据库操作都可以只用一条或少数几条SQL语句完成的。很多时候需要查询多张表，这是如果其中一条语句查询错误那么后面的执行对于需求来说将没有任何意义，这是就造成了不必要的操作，这是可以使用事务进行回滚，不去执行下面的错误语句。

###### 其它

- 避免频繁创建和删除临时表，以减少系统表资源的消耗。
- 尽量避免向客户端返回大数据量，若数据量过大，应该考虑相应需求是否合理。
- 尽量避免大事务操作，提高系统并发能力。



### 备份

备份对比

| 备份方法       | 备份速度 | 恢复速度 | 便捷性                 | 功能   | 应用场景      | 备注   |
| ---------- | ---- | ---- | ------------------- | ---- | --------- | ---- |
| cp         | 快    | 快    | 一般、灵活性低             | 很弱   | 少量数据备份    |      |
| mysqldump  | 慢    | 慢    | 一般、可无视存储引擎的差异       | 一般   | 中小型数据量的备份 |      |
| lvm2快照     | 快    | 快    | 一般、支持几乎热备、速度快       | 一般   | 中小型数据量的备份 |      |
| xtrabackup | 较快   | 较快   | 实现innodb热备、对存储引擎有要求 | 强大   | 较大规模的备份   |      |

#### 复制

只复制表结构

```mysql
create table xx_bak like xxx;
```

复制表结构和数据（不复制索引）

```mysql
create table if not exists xx_bak select * from xxx;
# 该语句只复制数据，不复制索引和key
```

若要完整的复制表，使用下面的方式：

```mysql
create table 复制表 like 表;
insert into 复制表 select * from 表
```

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

```shell
# 首先将数据导出成可运行的sql语句，然后
> source xxx.sql
# 或者
mysql -uxxxx -pxxx < xxx.sql
mysql -uxxxx -pxxx --default-character-set=utf8 < xxx.sql
### 注意使用这种方式的时候，在xxx.sql里最好指定编码，例如使用set names utf8
```

##### 导出

- 导出可执行的sql语句,可跨平台执行

```shell
#1.导出整个数据库(结构和数据)
#mysqldump -u用户名 -p密码  数据库名 > 导出的文件名 
mysqldump -uroot -pmysql db1   > e:\db1.sql 

#2.导出一个表，包括表结构和数据 
#mysqldump -u用户名 -p密码  数据库名 表名> 导出的文件名 
mysqldump -uroot -pmysql db1 tb1 tb2> e:\tb1_tb2.sql 

#3.导出整个数据库结构 
mysqldump -uroot -pmysql -d db1 > e:\db1.sql 

#4.导出一个表，只有表结构 
#mysqldump -u用户名 -p 密码 -d数据库名  表名> 导出的文件名 
mysqldump -uroot -pmysql -d db1 tb1> e:\tb1.sql 
```

注意：

> 可以给mysqldump添加以下参数，来设置输出格式：
>
> fields terminated by '字符串'：设置字符串为字段之间的分隔符，可以为单个或多个字符。默认值是“\t”。
> fields enclosed by '字符'：设置字符来括住字段的值，只能为单个字符。默认情况下不使用任何符号。
> fields optionally enclosed by '字符'：设置字符来括住CHAR、VARCHAR和TEXT等字符型字段。默认情况下不使用任何符号。
> fields escaped by '字符'：设置转义字符，只能为单个字符。默认值为“\”。
> lines starting by '字符串'：设置每行数据开头的字符，可以为单个或多个字符。默认情况下不使用任何字符。
> lines terminated by '字符串'：设置每行数据结尾的字符，可以为单个或多个字符。默认值是“\n”。
>
> 导出中文乱码的解决方式：
>
> >  --default-character-set=gb2312

[mysqldump导出优化](https://www.toutiao.com/i6515239530671374855/)

```shell
show variables like '%max_allowed_packet%';
show variables like '%net_buffer_length%';

mysqldump --defaults-extra-file=/etc/my.cnf  test -e --max_allowed_packet=1048576  --net_buffer_length=16384 > test.sql

# 导出的时候指定编码
mysqldump --default-character-set=gbk -uroot -proot -d study > e:\study.sql
```

- 导出成文件

```shell
# 方法1：mysql语句
> select * from db1.tb1 limit 2 into outfile '/tmp/xxx.xls'  fields terminated by ',' ;
# 注意mysql用户是否具有写的权限，另外可配置是否显示列名

# 方法2：重定向(查询自动写入文件,查询结果不再显示在窗口
> pager cat >> /tmp/test.xls;

# 方法3:输出重定向
mysql -h 127.0.0.1 -u root -p XXXX -P3306 -e "select * from table"  > /tmp/test.xls
# 若不想显示列名，加—N参数即可
```

tips:导出某些表的表结构

```shell
tbls=($(echo "show tables;"| mysql -uroot -proot -Dsnh48))
for tbl in ${tbls[@]:1};do
	#mysqldump -uroot -proot -d study $tbl> ${tbl}.sql 
	echo "mysqldump -uroot -proot -d snh48 $tbl> ${tbl}.sql "
done
```

#### 同步

##### mysql之间同步

- 导入导出法

```
- 不同机器之间的数据库只能利用导入和导出法
- 不同数据库之间利用导入和导出的方法
	- 也可以利用外连接表的方法
- 同数据库不同表之间可以利用insert select的方法
```

- 利用navicat premium工具

```
该工具可完成以上所有情况下的任务，但是需要手动操作，不能自动化
```

- 利用logstash

```
logstash的更强大的功能待挖掘
```

- 自写工具

```
通过编程利用mysql的api操作完成
```

- rsync

```
对MyISAM引擎存储的文件，可以使用文件同步的方法
```

##### mysql导入到redis

- 遍历插入法

```
利用各自的接口api实现
```

- 命令行法

```shell
# 方法1：创建shell脚本mysql2redis_mission.sh,（在mysql的结果中进行命令行的组合）内容如下：
mysql db_name --skip-column-names --raw < mission.sql | redis-cli [--pipe]
# 进化方法
mysql -uroot -proot -N <redis_pipe.sql |redis-cli

# 例如
(echo "set key1 vale1\r\n get key1\r\n") |redis-cli ［--pipe］#最后这个pipe选项可能导致问题
#　或者（能得到返回结果）
(echo -en "set key3 vale3\r\n get key2\r\n") |nc localhost 6379

# 方法2：直接将文件内容输入到流
cat xxx.file |redis-cli [--pipe]
```

- logstash

```shell
输入源是mysql,输出源是redis,可以利用中间的filter达到初步的处理
```

#### 恢复

##### binlog

查看binlog状态

```shell
show variables like '%log_bin%';  
```

开启binlog

```shell
log_bin=ON  
log_bin_basename=/var/lib/mysql/mysql-bin  
log_bin_index=/var/lib/mysql/mysql-bin.index  
# 或者简便方式
log-bin=/var/lib/mysql/mysql-bin

# 说明
# 第一个参数是打开binlog日志
# 第二个参数是binlog日志的基本文件名，后面会追加标识来表示每一个文件
# 第三个参数指定的是binlog文件的索引文件，这个文件管理了所有的binlog文件的目录
```

#### Restful接口

##### sandman2

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

> 问题是中文的查询结果是unicode显示，命令行配置jq才能正常显示，而web访问还没有查到显示中文的方式

##### [xmysql](http://blog.csdn.net/dev_csdn/article/details/78480522)

为mysql数据库快速生成restful api

### 性能

#### 日志

```mysql
show variables like '%_log%';
```

##### 错误日志

##### 查询日志

###### 普通查询日志

```mysql
set global general_log = ON;
show variables like '%general_log%';
set global general_log = OFF;
```

###### 慢查询日志

慢查询日志是用来记录执行时间超过指定时间的查询语句，建议开启，对服务器的性能影响微乎其微

```shell
vi/data/3306/my.cnf
[mysqld_safe]
	long_query_time= 1
	log-slow-queries= /data/3306/slow.log
	log_queries_not_using_indexes
```



##### 二进制日志

记录数据被修改的相关信息，由参数log-bin指定位置和文件名

```mysql
show variables like '%log_bin';
```

###### Statememt Level

SQL语句级别，默认

###### Row Level

行级模式

###### Mixed Level

混合模式，官方推荐

#### 进程/状态/变量

##### 进程

状态查看命令

```mysql
show processlist;
```

##### 状态

mysql[状态指标描述](https://www.toutiao.com/i6585469878314992132/)

```mysql
show global status;
show global status like '%table%';
```

##### 变量

```mysql
show global variables;
show global variables like '%character%';
```

#### 指标和监控

##### 指标

性能指标计算和监控，指标关注如下：

| 指标        | 定义        | 备注   |
| --------- | --------- | ---- |
| tps/qps   | 每秒事务数/查询数 |      |
| 线程状态      |           |      |
| 流量状态      |           |      |
| innodb读写  |           |      |
| innodb日志  |           |      |
| innode行   |           |      |
| myisam读写  |           |      |
| myisam缓冲池 |           |      |
| 临时表       |           |      |
| 响应时间      |           |      |
| 其它        |           |      |
|           |           |      |
|           |           |      |

##### 监控

###### explain命令

核心优先使用explain一下查问题,对explain基础知识的理解

```mysql
explain format=json select avg(k) from sbtest1 where id between 1000 and 2000 \G
```

注意查询开销`query_cost`

###### extended-status命令

```shell
# 累计值
mysqladmin -uroot -proot extended-status

# 当前状态（指定刷新频率）
mysqladmin -uroot -proot extended-status --relative -i1
#或者
mysqladmin -uroot -proot extended-status --relative --seleep=1
```

#### 辅助工具

##### percona-toolkit

好好掌握

#####  MySQL Utilities Client

工具一览

```shell
mysqluc> help utilities
Utility            Description
-----------------  --------------------------------------------------------
mysqlauditadmin    audit log maintenance utility
mysqlauditgrep     audit log search utility
mysqlbinlogmove    binary log relocate utility
mysqlbinlogpurge   purges unnecessary binary log files
mysqlbinlogrotate  rotates the active binary log file
mysqldbcompare     compare databases for consistency
mysqldbcopy        copy databases from one server to another
mysqldbexport      export metadata and data from databases
mysqldbimport      import metadata and data from files
mysqldiff          compare object definitions among objects where the
                   difference is how db1.obj1 differs from db2.obj2
mysqldiskusage     show disk usage for databases
mysqlfailover      automatic replication health monitoring and failover
mysqlfrm           show CREATE TABLE from .frm files
mysqlgrants        display grants per object
mysqlindexcheck    check for duplicate or redundant indexes
mysqlmetagrep      search metadata
mysqlprocgrep      search process information
mysqlreplicate     establish replication with a master
mysqlrpladmin      administration utility for MySQL replication
mysqlrplcheck      check replication
mysqlrplms         establish multi-source replication
mysqlrplshow       show slaves attached to a master
mysqlrplsync       replication synchronization checker utility
mysqlserverclone   start another instance of a running server
mysqlserverinfo    show server information
mysqlslavetrx      skip transactions on slaves
mysqluserclone     clone a MySQL user account to one or more new users
```

###### 具体使用

```shell
 # 显示文件使用
 mysqldiskusage --server=root:root@localhost study
 
 # 数据库复制
 mysqldbcopy --source=root:root@localhost --destination=xxx:xxx@xxx study:study
```

##### SQL Advisor审核工具

是一款审核和调试工具

```shell

```

### 问题

#### 面试

##### 索引和主键

###### 自增主键

问题描述：

​	一张表，里面有ID自增主键，当insert了17条记录之后，删除了第15,16,17条记录，再把Mysql重启，再insert一条记录，这条记录的ID是18还是15 ？

解决方法：

![自增主键](http://p1.pstatp.com/large/46de00042bde76f17e9a)



## 参考

- 基础

  [新手MySQL工程师命令必备手册](https://www.toutiao.com/i6556743086267957763/)

  [MyCli:支持自动补全和语法高亮的MySQL客户端](http://hao.jobbole.com/mycli-mysql/)

  [percona-toolkit工具包的安装和使用（推荐）](http://blog.51cto.com/jonyisme/1754247)(功能待挖掘)

  [Linux下修改mysql的root密码](http://www.tuicool.com/articles/yQNZFfr)

  [MySQL字符编码深入详解](http://www.jb51.net/article/29960.htm)

  [yum安装最新版mysql](http://blog.csdn.net/xyang81/article/details/51759200)

  [关于sql和mysql的语句执行顺序](http://blog.csdn.net/u014044812/article/details/51004754)

  [视图的修改更新和删除](https://www.cnblogs.com/xinwenpiaoxue/p/7278023.html)

  [我的MYSQL学习心得-视图](http://www.cnblogs.com/lyhabc/p/3801527.html)

- 高级

  [SQL的存储过程和函数](http://www.toutiao.com/a6391569028531831041/)

  [MySQL行级锁、表级锁和页级锁](http://www.jb51.net/article/50047.htm)

  [mysql锁机制](https://www.toutiao.com/i6586230829708476931/)


- 查询

  [MySQL如何对汉字排序](https://www.toutiao.com/i6501470153962684941/)

  [MySQL最左前缀原理与实现](https://www.toutiao.com/i6548007500254282247/)

  [MySQL分组后选取指定值问题](http://www.jb51.net/article/31590.htm)

  [MySQL实现full join](https://www.cnblogs.com/liuyifan/p/4985512.html)

  [MySQL存储过程的动态行转列](http://www.tuicool.com/articles/FNRVJvb)

  [重温SQL:行转列，列转行](http://mp.weixin.qq.com/s/pd4sEFa9oq0Lw5aaagmsxw)

  [慕课网:MySQL行列互转](http://www.imooc.com/learn/427)

  [跨库Join解决方法](http://blog.csdn.net/u011277123/article/details/54374780)

  [GroupTopN问题解决](http://blog.csdn.net/wzy_1988/article/details/52871636)

  [MySQL分组取TopN](http://www.jb51.net/article/31590.htm)

  [Mysql区间分组统计](https://www.cnblogs.com/lazyx/p/5577105.html)

  [MySQLjoin详解（强烈推荐）](https://www.cnblogs.com/blueoverflow/p/4714470.html)

- 积累

  [MySQL日期操作（推荐）](https://www.toutiao.com/i6558233017058329091/)

  [MySQL语句概述（各种语句的区别）](https://www.2cto.com/database/201610/555167.html)

  [根据MySQL表格自动生成restfull接口](https://segmentfault.com/q/1010000008335958)

  [是否存在根据MySQL表格自动生成restful接口的技术](https://segmentfault.com/q/1010000008335958?_ea=1878275)

  [MySQL知识点积累（推荐）](http://www.cnblogs.com/emanlee/category/95551.html)

  [MySQL面试题集锦（推荐）](https://www.toutiao.com/i6488851831869932046/)

  [58同城MySQL规范](https://www.toutiao.com/a6538937654111633933/)

  [互联网MySQL规范](https://www.toutiao.com/a6535777088434078211/)

  [我的私藏SQL练习题](https://www.jianshu.com/p/6f9dec217055)

  [find_in_set|like|in的区别](https://blog.csdn.net/sunny1660/article/details/78613000)

- 调优

  [MySQL性能监控](https://www.percona.com/doc/percona-monitoring-and-management/deploy/index.html)

  [MySQL慢查询日志的使用](http://www.cnblogs.com/kerrycode/p/5593204.html)

  [MySQL慢查询官方参考](https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html)

  [性能调优攻略:SQL语句优化](http://www.toutiao.com/a6391314783630770433/)

  [mysql exists和in的效率比较](http://www.cnblogs.com/meibao/p/4973043.html)

  [MySQL索引专题(推荐)](https://segmentfault.com/a/1190000010264071)

  [学会写MySQL索引（推荐）](http://mp.weixin.qq.com/s/Z10w5aBgxJvoxmOlrL_IXw)

  [项目中常用的19条MySQL优化（推荐）](https://segmentfault.com/a/1190000012155267)

  [MySQL大表优化方案](https://www.toutiao.com/i6533174790650331655/)

  [MySQL优化小建议](http://www.cnblogs.com/youyoui/p/8657331.html)

  [从认识索引到索引优化（推荐）](https://www.toutiao.com/i6586542647928685060/)

- 备份

  [mysql导入导出中文乱码的解决方法](http://www.jb51.net/article/31615.htm)

  [学会用各种姿势备份MySQL](http://www.cnblogs.com/liangshaoye/p/5464794.html)

  [数据库频道:MySQL大表备份策略](http://database.51cto.com/art/201011/234560.htm)

  [Xtrabackup热备份MySQL](http://www.tuicool.com/articles/MJzEFnE)

  [不同mysql之间数据同步](http://blog.csdn.net/ityouknow/article/details/52710655)

  [主从服务器之间数据同步](http://blog.csdn.net/alangmei/article/details/21075055)

  [innobackupex的安装和使用](http://blog.csdn.net/dbanote/article/details/13295727)

  [mysql的binlog的配置](http://blog.csdn.net/king_kgh/article/details/74800513)

  [xtrabackup 备份与恢复（推荐）](https://www.toutiao.com/i6511520757447655949/)

- 性能

  [MySQL日志基础知识及基本操作](https://www.toutiao.com/a6538541360855646728/)

  [MySQL性能指标及计算方法](https://www.toutiao.com/i6504034560555090446/)

  [percona toolkit使用系列（推荐）](http://blog.51cto.com/jonyisme/1754250)

  [美图SQLAdvisor审查工具](https://www.toutiao.com/a6572706820882694660/)

  [SQLAdvisor优化工具详解](https://www.cnblogs.com/beliveli/articles/6541936.html)

