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

连续数字问题，找出连续出现n次以上的数字

```mysql
select distinct Num as ConsecutiveNums a where (select count(distinct Num) from Logs b where a.Num=b.Num)>=3;
```

> 暂未解决

#### [Employees Earning More Than Their Managers](https://leetcode.com/problems/employees-earning-more-than-their-managers/description/)

```
select Name as Employee from Employee a where (select Salary from Employee b where a.ManagerID=b.ID)<a.Salary;
```

####  [Department Highest Salary](https://leetcode.com/problems/department-highest-salary/description/)

组内最大值/前N大

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

#### [Rising Temperature](https://leetcode.com/problems/rising-temperature/description/)

相邻行之间的比较

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

连接表求比率

```mysql

#
select round(c.ccnt/d.tcnt,2) from (
  select count(*) as ccnt from Trips a where a.Client_Id in (select Users_Id from Users where Role='client' and Banned='No') where a.Status='cancelled_by_client' and a.Request_at>='2013-10-01' and a.Request_at<='2013-10-03'
)c
inner join
(
select count(*) as tcnt from Trips a where a.Client_Id in (select Users_Id from Users where Role='client' and Banned='No') and a.Request_at>='2013-10-01' and a.Request_at<='2013-10-03')d;

```

####  [Consecutive Numbers](https://leetcode.com/problems/consecutive-numbers/description/)

连续子序列问题

```mysql
select id from stadium a where a.num=(select num from stadium a1 where a1.id=a.id+1)
union 
select id from stadium a where a.num=(select num from stadium a1 where a1.id=a.id-1)
```





霍夫曼交通问题

```mysql
select (select a.* from stadium a inner join stadium b on b.id=a.id+1 and a.people>100 and b.people>100);
```



 ##参考