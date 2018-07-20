-- 该数据集来自:https://www.jianshu.com/p/6f9dec217055


-- 创建学生信息表
create table mdjs_Student(
	Sid varchar(10),
	Sname varchar(10),
	Sage datetime,
	Ssex varchar(10)
);

insert into mdjs_Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into mdjs_Student values('02' , '钱电' , '1990-12-21' , '男');
insert into mdjs_Student values('03' , '孙风' , '1990-05-20' , '男');
insert into mdjs_Student values('04' , '李云' , '1990-08-06' , '男');
insert into mdjs_Student values('05' , '周梅' , '1991-12-01' , '女');
insert into mdjs_Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into mdjs_Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into mdjs_Student values('08' , '王菊' , '1990-01-20' , '女');
insert into mdjs_Student values('09' , '孙吴昊' , '1990-01-20' , '女');
insert into mdjs_Student values('10' , '赵雷' , '1990-01-20' , '女');

-- 创建课程表
create table mdjs_Course(
	Cid varchar(10),
	Cname varchar(10),
	Tid varchar(10)
);


insert into mdjs_Course values('01' , '语文' , '02');
insert into mdjs_Course values('02' , '数学' , '01');
insert into mdjs_Course values('03' , '英语' , '03');
insert into mdjs_Course values('04' , '英语' , '01');

-- 创建教师表
create table mdjs_Teacher(
	Tid varchar(10),
	Tname varchar(10)
);

insert into mdjs_Teacher values('01' , N'张三');
insert into mdjs_Teacher values('02' , N'李四');
insert into mdjs_Teacher values('03' , N'王五');
insert into mdjs_Teacher values('04' , N'汪二蛋');

-- 创建综合表
create table mdjs_Score(
	Sid varchar(10),
	Cid varchar(10),
	score decimal(18,1)
);

insert into mdjs_Score values('01' , '01' , 80);
insert into mdjs_Score values('01' , '02' , 90);
insert into mdjs_Score values('01' , '03' , 99);
insert into mdjs_Score values('02' , '01' , 70);
insert into mdjs_Score values('02' , '02' , 60);
insert into mdjs_Score values('02' , '03' , 80);
insert into mdjs_Score values('03' , '01' , 80);
insert into mdjs_Score values('03' , '02' , 80);
insert into mdjs_Score values('03' , '03' , 80);
insert into mdjs_Score values('04' , '01' , 50);
insert into mdjs_Score values('04' , '02' , 30);
insert into mdjs_Score values('04' , '03' , 20);
insert into mdjs_Score values('05' , '01' , 76);
insert into mdjs_Score values('05' , '02' , 87);
insert into mdjs_Score values('06' , '01' , 31);
insert into mdjs_Score values('06' , '03' , 34);
insert into mdjs_Score values('07' , '02' , 89);
insert into mdjs_Score values('07' , '03' , 98);
insert into mdjs_Score values('08' , '03' , 98);
insert into mdjs_Score values('09' , '03' , 98);
insert into mdjs_Score values('10' , '04' , 59);
