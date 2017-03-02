## MySQL积累

[TOC]

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

### 备份

#### 导入和导出 

## 参考

[SQL的存储过程和函数](http://www.toutiao.com/a6391569028531831041/)

[MySQL存储过程的动态行转列](http://www.tuicool.com/articles/FNRVJvb)

[性能调优攻略:SQL语句优化](http://www.toutiao.com/a6391314783630770433/)

[mysql exists和in的效率比较](http://www.cnblogs.com/meibao/p/4973043.html)

