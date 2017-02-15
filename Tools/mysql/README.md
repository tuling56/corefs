## MySQL积累

### 基本

#### 创建



#### 索引

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

#### 字段

>增加字段

 mysql> ALTER TABLE table_name ADD field_name field_type;
 alter table newexample add address varchar(110) after stu_id;

> 修改原字段名称及类型

mysql> ALTER TABLE table_name CHANGE old_field_name new_field_name field_type;

> 删除字段

MySQL ALTER TABLE table_name DROP field_name;

**参考**

http://c.biancheng.net/cpp/html/1456.html



#### 信息查看

>  查看全局变量

命令行：mysqladmin variables -p，这个操作也就相当于登录时使用命令 show global variables;

### 应用

#### 行转列



### 查询

#### 子查询



### 备份

#### 导入和导出

**参考**

[MySQL存储过程的动态行转列](http://www.tuicool.com/articles/FNRVJvb)

