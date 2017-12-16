#创建视图
use School;
CREATE TABLE student (stuno INT ,stuname NVARCHAR(60));
CREATE TABLE stuinfo (stuno INT ,class NVARCHAR(60),city NVARCHAR(60));

INSERT INTO student VALUES(1,'wanglin'),(2,'gaoli'),(3,'zhanghai');
INSERT INTO stuinfo VALUES(1,'wuban','henan'),(2,'liuban','hebei'),(3,'qiban','shandong');

-- 创建视图
CREATE VIEW stu_class (id , NAME , glass) AS
    SELECT
        student.`stuno`, student.`stuname`, stuinfo.`class`
    FROM
        student,
        stuinfo
    WHERE
        student.`stuno` = stuinfo.`stuno`;


#说明
create view 'viewname' as select colunm from table_name where contion;
-- 视图总是显示最新的数据。每当用户查询视图时，数据库引擎通过使用SQL语句来重建数据
-- 视图例子
CREATE VIEW [Products Above Average Price] AS
SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice>(SELECT AVG(UnitPrice) FROM Products) #注意这里是如何直接求大于平均值，where子句中不能使用聚合函数

# 更新视图
create or replace 'viewname' as	select [modify]colunm from table_name where contion;
-- 这里只是多了or replace这个关键字,同时可以对列和条件扥改进修改

# 视图的其它操作
drop view 'viewname'   //删除视图
create view v_name as select *,* ;  //创建视图
alter view v_name(v1,v2) as select *;  //修改视图（相当于直接创建新的视图）


##游标示例
MYSQL 游标示例:
目的是显示一个数据库中的所有表的结构信息
use task3;
drop PROCEDURE if exists p1;
delimiter //
CREATE PROCEDURE p1()
BEGIN
    DECLARE v_a INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR SELECT distinct a FROM data;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur1;
    WHILE done=0 DO
        set @sqlstmt='SELECT * from data INTO OUTFILE D:\\hah.txt';
        PREPARE stmt1 FROM @sqlstmt;
        EXECUTE stmt1 ;
        DEALLOCATE PREPARE stmt1;
        FETCH cur1 INTO v_a;
    END WHILE;
END;//
delimiter ;

call p1();

#存储过程
DECLARE v_cnt INT;
DECLARE v_timestr INT;
DECLARE rowcount BIGINT;
set v_timestr=date_format(now(),'%Y%m%d')
SELECT round(rand()*100,0)+1 INTO v_cnt;
START TRANSAction;
UPdate order_seq set order_sn=order_sn+v_cnt WHERE timestr=v_timestr;
if row_count()=0 then
INSERT INTO order_seq(timestr,order_sn) VALUES(v_timestr,v_cnt);
END if;
SELECT concat(v_timestr,LPAD(order_sn,7,0)) as order_sn from order_seq WHERE timestr=v_timestr;
commit;



#只导出表结构
mysqldump -uroot -proot -d study >studydb_struct.sql
mysqldump -uroot -proot -d study person>studydb_persontbl_struct.sql

#导出表结构和数据（取消-d选项）
mysqldump -uroot -proot study >studydb_struct_data.sql
mysqldump -uroot -proot study person>studydb_persontbl_struct_data.sql

#导出数据是不包含列标题（加-N选项）
/usr/bin/mysql -uroot -phive -N -e