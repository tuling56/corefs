## MySQL积累

[TOC]

### 基本

#### 基础

##### 安装

先检查已安装版本

```shell
 rpm -qa | grep mysql
 rpm -e --nodeps mysql_xxxx
```

包管理器安装

```shell
#1.下载mysql的repo源
$ wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

#2.安装mysql-community-release-el7-5.noarch.rpm包
$ sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
#安装这个包后，会获得两个mysql的yum repo源：
#/etc/yum.repos.d/mysql-community.repo
#/etc/yum.repos.d/mysql-community-source.repo

#3.安装mysql
$ sudo yum install mysql-server
```

配置开机启动

```shell
cp ./support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
```

##### 账号

创建新用户并设置密码

```
create user 'username'@'host' identified by 'password';
```

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

##### 编码

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

##### 变量

查看变量

```mysql
# 命令行：mysqladmin variables -p，这个操作也就相当于登录时使用命令 show global variables;

# 若查看某种类型的变量
show [global] variables like "%_time";
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



###### 操作

[增加字段](http://c.biancheng.net/cpp/html/1456.html)

```mysql
alter table table_name add field_name field_type;
alter table newexample add address varchar(110) after stu_id;
```

修改字段

```mysql
alter table table_name change old_field_name new_field_name field_type;
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

> 添加约束

```mysql
# 单列约束
ALTER TABLE Persons ADD UNIQUE (Id_P);
# 多列约束
ALTER TABLE Persons ADD CONSTRAINT uc_PersonID UNIQUE (Id_P,LastName);
```

> 撤销约束

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

注意`PRIMARY KEY`,`UNIQUE KEY`,	`KEY`的区别

**索引和约束**

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

```mysql
# 修改表的存储引擎
alter table table_name engine=innodb;

# 关闭InnoDB的存储引擎
#修改my.ini文件：
找到default-storage-engine=INNODB 改为default-storage-engine=MYISAM
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
3. 灵活应对功能的改变
4. 复杂的查询需求

通过更新视图更新真实表



更新视图的方法：

- 替代方式
- 具体化方式（中间表方式） 



### 高级

#### 锁

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

##### 死锁解决

//待添加

#### 存储过程

存储过程和函数的区别：

- 函数中表名和列名都不能是变量
- PREPARE语句只能用于5.0版本以上的存储过程里，不能用在函数或者触发器里
- 调用方法不一样
- 存储过程常用在事件和触发器中

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
  DECLARE datas CURSOR  FOR SELECT id FROM test;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET error_status=1;
  OPEN datas;
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
```

##### 调用

```mysql
call  sp_name;
# 存储过程的调用一般是在事件中进行
```

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

> 参数详细说明：
>
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

#### 触发器

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

##### 创建触发器

```mysql
CREATE TRIGGER trigger_name trigger_time trigger_event ON tbl_name FOR EACH ROW trigger_stmt
###参数说明：
# trigger_time是触发程序的动作时间。它可以是 before 或 after，以指明触发程序是在激活它的语句之前或之后触发。
# trigger_event指明了激活触发程序的语句的类型
	INSERT：将新行插入表时激活触发程序
	UPDATE：更改某一行时激活触发程序
	DELETE：从表中删除某一行时激活触发程序
#tbl_name：监听的表，必须是永久性的表，不能将触发程序与TEMPORARY表或视图关联起来。
#trigger_stmt：当触发程序激活时执行的语句。执行多个语句，可使用BEGIN...END复合语句结构
```

##### 删除触发器

```mysql
DROP TRIGGER [schema_name.]trigger_name
#可以使用old和new代替旧的和新的数据
#更新操作，更新前是old，更新后是new.
#删除操作，只有old.
#增加操作，只有new.
```

一个例子：

```mysql
create TRIGGER up_conter after insert on documents for each row BEGIN
set new.content=new.title; #注意不要在触发器的操作语句中使用update等操作
END
```

参考：

[MySQL触发器简单实例](http://www.cnblogs.com/nicholas_f/archive/2009/09/22/1572050.html)

[already used by statement](https://stackoverflow.com/questions/15300673/mysql-error-cant-update-table-in-stored-function-trigger-because-it-is-already)

[MySQL触发器](http://www.toutiao.com/i6468771136527139341/)

### 查询

#### 索引

单索引和联合索引

##### 索引类型

索引类型是基于索引方法的，有各自的特点 

- 唯一索引


- 普通索引
- 主键索引

区别在于：

```
主键索引:数据列不允许重复，不允许为NULL.一个表只能有一个主键。
唯一索引:数据列不允许重复，允许为NULL值，一个表允许多个列创建唯一索引。
普通索引:基本的索引类型，没有唯一性的限制，允许为NULL值。
```

#### 正则

mysql[正则](http://www.cnblogs.com/way_testlife/archive/2010/09/17/1829567.html)和模糊匹配的区别:

##### 正则

```mysql
# 正则判断（匹配返回1，不匹配返回0）
select 'JetPack 1000'  regexp '^1000';
```

> 注：
>
> - MySQL中的正则表达式匹配不区分大小写。为区分大小写，可使用BINARY关键字。
>
>   如：select 'JetPack we2x000'  REGEXP BINARY 'JetPack .000'

##### 模糊匹配



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

##### 关键字

###### exists关键字

内层查询语句不返回查询记录，而是返回一个真假值。

```mysql
select employee_name,gender,email,job_title from employee where exists(select * from employee where employee_name='成龙');

# 返回a表中满足id在b表中条件的记录
select * from ecs_goods a where EXISTS(select cat_id from ecs_category b where a.cat_id = b.cat_id);
```

###### any关键字

只要满足内存查询语句返回结果中的任意一个，就可以执行外层查询语句

```mysql
#这个就是查询所有购买数量大于49的订单的信息！
select order_id,customer_id,order_number,order_date from `order` where order_id = any(select order_id from order_detail where buy_number>49);
```

###### all关键字

```mysql
#所有满足订单的总金额大于单价*10的订单的信息
select order_id,customer_id,order_number,order_date from `order` where total_money > all(select price*10 from order_detail);
```

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

### 积累

#### 基础

##### 运行方式技巧

```shell
# 方法1
${MYSQL10} < xmp_version_active.sql
#其中MYSQL10是:`/usr/bin/mysql -uroot -phive -N`

# 方法2
MYSQL="/usr/bin/mysql -uxxxx -pxxxx -hxxxx -Pxxxx"
sql="select movieid,pageurl,posterurl from poster_to_down where image_type='poster' and ts >='${time_start}'"
echo "${sql}" | ${MYSQL} media_info |sed '1d' > ${file}

Local_MYSQL="/usr/bin/mysql -uxxxxx -pxxxx -hxxxxx media_info"
echo "alter table media_relation_search_pc rename media_relation_search_pc_old_$(date +'%Y%m%d');" | $Local_MYSQL

# 方法3
cat /data/rsync_data/kk_sql/videos.sql |$mysql video
echo "show tables;"| mysql -uroot -proot -Dsnh48
```

一次运行多个sql文件

```mysql
#在文件 batch.sql 中写下多个SQL文件
source file1.SQL
source file2.SQL
source file3.SQL
#然后运行 source batch.sql
```

##### 插入技巧

```mysql
# 一次性插入多个值
INSERT into task_request(proposer,enddate) values ("鲁丽",'20170611'),("张一",'20170322'),("王二",'20170101');

# 从tb1中选出两列插入到tb2中
INSERT into tb2(proposer,enddate) select xx,yy from tb1;
```

##### 自增列

```mysql
# 建表的时候指定
# > // id列为无符号整型，该列值不可以为空，并不可以重复，而且id列从100开始自增.
create table table_1 ( id int unsigned not null primary key auto_increment, 
                       name varchar(5) not null ) auto_increment = 100;

# 修改自增列的值
alter table table_1 auto_increment = 2;
```

只能修改单机的，集群修改[自增列](http://www.jb51.net/article/42883.htm)无效

##### 信息筛选

查询某个字段匹配的的表和所在的数据库

```mysql
SELECT TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME from information_schema.`COLUMNS` where COLUMN_NAME like '%isover%';
```

#### restful接口

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

> 问题是中午的查询结果是unicode显示，命令行配置jq才能正常显示，而web访问还没有查到显示中文的方式

##### [xmysql](http://blog.csdn.net/dev_csdn/article/details/78480522)

为mysql书宽恕成rest api

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

#### 字符包含问题

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

#### 跨库Join问题

- 字段冗余设计
- 表复制和同步到一个库中
- 链接表

> 链接表的使用要求FEDERATED 的打开，默认是关闭的

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

1.本地的表结构必须与远程的完全一样

2.远程数据库目前仅限MySQL（其它主流数据库暂不支持）

3.不支持事务

4.不支持表结构修改

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

#### 列转行

有两种实现方式:`序列化表`和`union all` 

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

> 这部分还有很多要完善的地方！，进一步扩展的是求一行的最大值和最小值等

#### 同一属性多值过滤

选出同时具有fei和bianhua能力的人

```mysql
# 方法一
SELECT DISTINCT a.name AS 'feibianren' from nameskills a 
JOIN  nameskills b on a.name=b.name and b.skills='fei'
join  nameskills c on a.name=c.`name` and c.skills='bianhua';

# 方法二：
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

#### 不存在则插入，存在则更新

```mysql
INSERT INTO tablename (field1, field2, field3, ...) VALUES ('value1', 'value2','value3', ...) ON DUPLICATE KEY UPDATE field1='value1', field2='value2', field3='value3', ...

# 这个语句的意思是，插入值，如果没有该记录执行
INSERT INTO tablename (field1, field2, field3, ...) VALUES ('value1', 'value2','value3', ...)
# 这一段，如果存在该记录，那么执行
UPDATE field1='value1', field2='value2', field3='value3', ...
```

一个例子：

```mysql
INSERT INTO tablea (peerid,new_install_date,new_install_source,new_install_version,new_install_type,insert_date,insert_source,insert_version,insert_type) VALUES("%s","%s","%s","%s","%s","%s","%s","%s","%s") ON DUPLICATE KEY UPDATE new_install_type="%s"' 
```

#### 删除重复数据

在删除的时候可能会根据某些条件保留其中的一条

```mysql
# 删除重复邮件地址，重复的多条，只保留其中id最小的
delete from Person 
where Id not in (select a.Id from (
  									select min(Id) as Id from Person group by Email
									)a
                );
```

#### GroupTopN

问题描述：先分组，然后在从分组中选取前N个值，比如topN

```mysql
# 例子1：(遍历所有记录，取每条记录与当前记录做比较，只有当同一版本不超过3个比当前高时，这个才是前三名)。
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

> 用awk如何实现

### 调优

#### 性能监控

- explain命令

核心优先使用explain一下查问题,对explain基础知识的理解

```mysql
explain format=json select avg(k) from sbtest1 where id between 1000 and 2000 \G
```

注意查询开销`query_cost`

#### 配置优化

//待补充

#### 具体方法

##### 索引

索引通过减少查询必须扫描的数据库中的数据量来提高查询效率，如何设计索引的使用，索引会引入额外的性能问题，比如插入会稍慢。

- 多列索引的设计及什么情况下索引会失效

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

##### 分库

分布式和事务的控制

#####  分表

用法和拆分原则要一开始的时候设计好



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

- 利用navicate premium工具

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

##### mysql导入到redis

- 遍历插入法

```
//待实现
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

```
输入源是mysql,输出源是redis,可以利用中间的filter达到初步的处理
```

### 问题

#### 面试

##### 自增主键

问题描述：

​	一张表，里面有ID自增主键，当insert了17条记录之后，删除了第15,16,17条记录，再把Mysql重启，再insert一条记录，这条记录的ID是18还是15 ？

解决方法：

![自增主键](http://p1.pstatp.com/large/46de00042bde76f17e9a)



## 参考

- 基础

  [MyCli:支持自动补全和语法高亮的MySQL客户端](http://hao.jobbole.com/mycli-mysql/)

  [percona-toolkit工具包的安装和使用](http://blog.51cto.com/jonyisme/1754247)(功能待挖掘)

  [Linux下修改mysql的root密码](http://www.tuicool.com/articles/yQNZFfr)

  [MySQL字符编码深入详解](http://www.jb51.net/article/29960.htm)

- 高级

  [SQL的存储过程和函数](http://www.toutiao.com/a6391569028531831041/)

  [MySQL行级锁、表级锁和页级锁](http://www.jb51.net/article/50047.htm)


- 查询

  [MySQL分组后选取指定值问题](http://www.jb51.net/article/31590.htm)

  [MySQL存储过程的动态行转列](http://www.tuicool.com/articles/FNRVJvb)

  [重温SQL:行转列，列转行](http://mp.weixin.qq.com/s/pd4sEFa9oq0Lw5aaagmsxw)

  [慕课网:MySQL行列互转](http://www.imooc.com/learn/427)

  [跨库Join解决方法](http://blog.csdn.net/u011277123/article/details/54374780)

  [GroupTopN问题解决](http://blog.csdn.net/wzy_1988/article/details/52871636)

  [MySQL分组取TopN](http://www.jb51.net/article/31590.htm)

- 积累

  [根据MySQL表格自动生成restfull接口](https://segmentfault.com/q/1010000008335958)

  [是否存在根据MySQL表格自动生成restful接口的技术](https://segmentfault.com/q/1010000008335958?_ea=1878275)

  [MySQL知识点积累（推荐）](http://www.cnblogs.com/emanlee/category/95551.html)

  [MySQL面试题集锦（推荐）](https://www.toutiao.com/i6488851831869932046/)

- 调优部分

  [MySQL性能监控](https://www.percona.com/doc/percona-monitoring-and-management/deploy/index.html)

  [MySQL慢查询日志的使用](http://www.cnblogs.com/kerrycode/p/5593204.html)

  [MySQL慢查询官方参考](https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html)

  [性能调优攻略:SQL语句优化](http://www.toutiao.com/a6391314783630770433/)

  [mysql exists和in的效率比较](http://www.cnblogs.com/meibao/p/4973043.html)

  [MySQL索引专题(推荐)](https://segmentfault.com/a/1190000010264071)

  [学会写MySQL索引（推荐）](http://mp.weixin.qq.com/s/Z10w5aBgxJvoxmOlrL_IXw)

  [项目中常用的19条MySQL优化（推荐）](https://segmentfault.com/a/1190000012155267)

- 备份

  [mysql导入导出中文乱码的解决方法](http://www.jb51.net/article/31615.htm)

  [学会用各种姿势备份MySQL](http://www.cnblogs.com/liangshaoye/p/5464794.html)

  [数据库频道:MySQL大表备份策略](http://database.51cto.com/art/201011/234560.htm)

  [Xtrabackup热备份MySQL](http://www.tuicool.com/articles/MJzEFnE)

  [不同mysql之间数据同步](http://blog.csdn.net/ityouknow/article/details/52710655)

  [主从服务器之间数据同步](http://blog.csdn.net/alangmei/article/details/21075055)

  ​
