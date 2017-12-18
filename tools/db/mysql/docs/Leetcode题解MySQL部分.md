##LeetCode题解MySQL
[TOC]

### 题目

#### [rank scores](https://leetcode.com/problems/rank-scores/description/)

相等的同样的排序，然后后续接着来，中间不空

```mysql
# 排名问题
set @mycnt=0;
select a.price,c.rank from study.test a INNER join 
(select b.price,(@mycnt := @mycnt + 1) as rank  from (select DISTINCT price from study.test order by price)b)c
on a.price=c.price
order by a.price;
```

> 可根据实际情况进行倒排和正排等操作

#### [consecutive numbers](https://leetcode.com/problems/consecutive-numbers/description/)

连续数字问题，找出至少连续出现n次以上的数字

Write a SQL query to find all numbers that appear at least three times consecutively.

```
+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
```

```mysql
select distinct Num as ConsecutiveNums a where (select count(distinct Num) from Logs b where a.Num=b.Num)>=3;
```

> 暂未解决

#### [Employees Earning More Than Their Managers](https://leetcode.com/problems/employees-earning-more-than-their-managers/description/)

找出赚的比他的经理多的人

```
select Name as Employee from Employee a where (select Salary from Employee b where a.ManagerID=b.ID)<a.Salary;
```

####  [Department Highest Salary](https://leetcode.com/problems/department-highest-salary/description/)

组内最大值/前N大

The `Employee` table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

```
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+

```

The `Department` table holds all departments of the company.

```
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+

```

Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.

```
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
```

```mysql
#组内最大值 
SELECT
	b.Name AS Department,
	a.Name AS Employee,
	a.Salary AS Salary
FROM
	Employee AS a
INNER JOIN Department AS b ON a.DepartmentId = b.Id
WHERE
	a.Salary=(
		SELECT
			max(Salary)
		FROM
			Employee AS a1
		WHERE
			a1.DepartmentId = a.DepartmentId
		group by a1.DepartmentID
	)


# 组内前N大
SELECT
	b.Name AS Department,
	a.Name AS Employee,
	a.Salary AS Salary
FROM
	Employee AS a
INNER JOIN Department AS b ON a.DepartmentId = b.Id
WHERE
	 (
		SELECT
			count(distinct a1.Salary)
		FROM
			Employee AS a1
		WHERE
			a1.DepartmentId = a.DepartmentId
       	and 
       		a1.Salary>a.Salary
	)<3
ORDER BY
	b.Name DESC,a.Salary DESC;


# 组内前N大(本地测试)
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

#### [Nth Highest Salay](https://leetcode.com/problems/nth-highest-salary/description/)

分组第N大和不分组第N大

Write a SQL query to get the *n*^th^ highest salary from the `Employee` table.

```
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```

##### 不分组第N大

```mysql
# 参加以前的TopN
```

##### 分组第N大

```mysql
# groupTopN
```

#### [Rising Temperature](https://leetcode.com/problems/rising-temperature/description/)

相邻行之间的比较了，找出比前一行值高的记录

write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

```
+---------+------------+------------------+
| Id(INT) | Date(DATE) | Temperature(INT) |
+---------+------------+------------------+
|       1 | 2015-01-01 |               10 |
|       2 | 2015-01-02 |               25 |
|       3 | 2015-01-03 |               20 |
|       4 | 2015-01-04 |               30 |
+---------+------------+------------------+
```

```mysql
# 有问题(第一行的处理)
select ID from Weather a where a.Temperature>(select Temperature from Weather a1 where a.ID=a1.ID+1);

# 有问题（第一行的处理）
select a.ID from Weather a inner join Weather b on b.ID=a.ID-1 and a.Temperature>b.Temperature
union 
select a.ID from Weather a where a.ID=1 and a.Temperature>(select Temperature from Weather a1 where a1.ID=2);

# 问题总结：相邻行之间的比较采用inner join的方式
```

> 处理第一行的情况：
>
> - 若第二行小于第一行，则第一行满足条件

#### [Trips and Users](https://leetcode.com/problems/trips-and-users/description/)

连接表求比率，分类情况

方法1：存在的问题没有满足条件的时候无返回

```mysql
# 乘客取消率问题
SELECT
	b.Day,round(b.ccnt / d.tcnt, 2)
FROM
	(
		SELECT
			a.Request_at as Day,
			count(*) AS ccnt
		FROM
			Trips a
		WHERE
			a.Client_Id IN (
				SELECT
					Users_Id
				FROM
					Users
				WHERE
					Role = 'client'
				AND Banned = 'No'
			)
		AND	a.Status = 'cancelled_by_client'
		AND a.Request_at >= '2013-10-01'
		AND a.Request_at <= '2013-10-03'
        group by a.Request_at
	) b
INNER JOIN (
	SELECT
		c.Request_at as Day,
		count(*) AS tcnt
	FROM
		Trips c
	WHERE
		c.Client_Id IN (
			SELECT
				Users_Id
			FROM
				Users
			WHERE
				Role = 'client'
			AND Banned = 'No'
		)
	AND c.Request_at >= '2013-10-01'
	AND c.Request_at <= '2013-10-03'
    group by c.Request_at
) d
on b.Day=d.Day;
```

方法2：

```mysql
select 
t.Request_at Day, 
round(sum(case when t.Status like 'cancelled_%' then 1 else 0 end)/count(*),2) Rate
from Trips t 
inner join Users u 
on t.Client_Id = u.Users_Id and u.Banned='No'
where t.Request_at between '2013-10-01' and '2013-10-03'
group by t.Request_at
```

####  [Consecutive Numbers](https://leetcode.com/problems/consecutive-numbers/description/)

连续子串问题，求最少多少次连续的数字

方法1:(有问题)

```mysql
select id from stadium a where a.num=(select num from stadium a1 where a1.id=a.id+1)
union 
select id from stadium a where a.num=(select num from stadium a1 where a1.id=a.id-1)
```

方法2：

```mysql
SELECT DISTINCT
	l1.Num
FROM
	stadium l1,
	stadium l2,
	stadium l3
WHERE
	l1.Id = l2.Id - 1
AND l2.Id = l3.Id - 1
AND l1.Num = l2.Num
AND l2.Num = l3.Num
```

> 扩展：处理n连续问题

#### [Human Traffic of Stadium](https://leetcode.com/problems/human-traffic-of-stadium/description/)

霍夫曼流量问题，找出至少连续3天大于100的的记录，记录是依次连续的。也是满足条件的最长连续子序列问题

```
+------+------------+-----------+
| id   | date       | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
```

暂时未解决

```mysql
select (select a.* from stadium a inner join stadium b on b.id=a.id+1 and a.people>100 and b.people>100);
```

 ##参考