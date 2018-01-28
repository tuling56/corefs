## Xtrabackup备份MySQL

[TOC]

### 基础

percona-xtrabackup是一款开源的MySQL热备份工具

> Xtrabackup是由percona开发的一个开源软件，它是innodb热备工具ibbackup（收费的商业软件）的一个开源替代品。Xtrabackup由个部分组成:xtrabackup和innobackupex，其中xtrabackup工具用于备份innodb和 xtraDB引擎的表；而innobackupex工具用于备份myisam和innodb引擎的表，本文将介绍如何用innobackupex工具做全量和增量备份。

#### 安装Xtrabackup

```shell
yum install percona-xtrabackup
```

#### 安装MySQL

1. 安装MySQL
2. 更改时间戳设置
3. 启动MySQL
4. 配置MySQL密码

a. 新版本MySQL安装完成后会生成临时的初始密码

修改MySQL密码

注意：MySQL 5.7默认安装了密码安全检查插件(validate_password)，默认密码检查策略要求密码必须包含:大小写字母、数字和特殊符号，并且长度不能少于8位。

MySQL官网MySQL 5.7[密码策略详细说明](http://dev.mysql.com/doc/refman/5.7/en/validate-password-options-variables.html#sysvar_validate_password_policy):

b.修改密码策略

c.官方数据库示例

#### 说明

##### innobackupex常用命令

--backup	     	默认选项

--defaults-file	 指定要备份的mysql实例的my.cnf文件，必须为第一个选项

--port	        	 端口

--socket	 		连接套字节的位置，默认为/var/lib/mysql/mysql.sock

--host	         	主机

--no-timestamp	 指定了这个选项备份会直接备份在BACKUP-DIR，不再创建时间戳文件夹

--target-dir	 	指定了这个选项备份会直接备份在BACKUP-DIR，不再创建时间戳文件夹

--use-memory     	指定备份所用内存大小，默认为100M，与--apply-log同用

--apply-log      	从备份恢复

--apply-log-only 	在恢复时，停止恢复进程不进行LSN，只使用log

--copy-back      	复制备份文件

--incremental    	==建立增量备份==

--incremental-basedir=DIRECTORY	指定一个全库备份的目录作为增量备份的基础数据库

--incremental-dir=DIRECTORY		指定增量备份与全库备份合并建立一个新的全备目录

--prepare        					从backup恢复

--compress       					压缩选项

##### xtrabackup备份后的主要文件

(1)xtrabackup_checkpoints

 —— 备份类型（如完全或增量）、备份状态（如是否已经为prepared状态）和LSN(日志序列号)范围信息；

每个InnoDB页(通常为16k大小)都会包含一个日志序列号，即LSN。LSN是整个数据库系统的系统版本号，每个页面相关的LSN能够表明此页面最近是如何发生改变的。

(2)xtrabackup_binlog_info 

—— mysql服务器当前正在使用的二进制日志文件及至备份这一刻为止二进制日志事件的位置。

(3)xtrabackup_binlog_pos_innodb

 —— 二进制日志文件及用于InnoDB或XtraDB表的二进制日志文件的当前position。

(4)xtrabackup_binary 

—— 备份中用到的xtrabackup的可执行文件。

(5)backup-my.cnf 

—— 备份命令用到的配置选项信息。

### Innobackupex

备份流程

![全备份流程](http://p1.pstatp.com/large/2a48000321a5c30c59d4)

#### 全备

##### 备份

1. 创建全备

```shell
# innobackupex --defaults-file=/etc/my.cnf  --user=root --password=12345678 backup/
......
completed OK!

# 备份后的结果文件如下：
cd backup/2018-01-20_17-29-43
-rw-r--r-- 1 root root  295 Jan 20 17:29 backup-my.cnf
-rw-r----- 1 root root  12M Jan 20 17:30 ibdata1
-rw-r--r-- 1 root root  48M Jan 20 17:30 ib_logfile0
-rw-r--r-- 1 root root  48M Jan 20 17:30 ib_logfile1
drwx------ 2 root root 4.0K Jan 20 17:29 mysql/
drwxr-xr-x 2 root root 4.0K Jan 20 17:29 performance_schema/
drwxr-xr-x 2 root root 4.0K Jan 20 17:29 typecho/
-rw-r----- 1 root root   89 Jan 20 17:30 xtrabackup_checkpoints
-rw-r--r-- 1 root root  509 Jan 20 17:29 xtrabackup_info
-rw-r----- 1 root root 2.0M Jan 20 17:30 xtrabackup_logfile
```

> 该操作会在`/backup/`目录下创建时间戳格式的文件夹，里面存储的是备份文件
>
> - xtrabackup_checkpoints  查看备份类型、备份专题等信息
> - xtrabackup_binlog_info 如果当前服务器开启了binlog,则有此文件
> - backup-my.cnf
>
> 局限:
>
> - 不能指定到数据库，也不能指定到表

2. 应用全备日志

```shell
# innobackupex --apply-log /backup/2017-04-03_12-45-44/
......
completed OK!
```

> 这一步对mysql的备份日志进行恢复，不然数据无法直接使用，主要原因如下:
>
> > 一般情况下，在备份完成后，数据尚且不能用于恢复操作，因为备份的数据中可能会包含尚<u>未提交的事务</u>或<u>已经提交但尚未同步至数据文件中的事务</u>。因此，此时数据文件仍处理不一致状态。“准备”的主要作用正是通过回滚未提交的事务及同步已经提交的事务至数据文件也使得数据文件处于一致性状态。

3. 查看备份状态

```shell
# cat /backup/2017-04-03_12-45-44/xtrabackup_checkpoints 
backup_type = full-prepared        ##全备
from_lsn = 0                       ##备份开始点
to_lsn = 9692219                   ##备份结束点
last_lsn = 9692228
compact = 0
recover_binlog_info = 0
```

4. 查看二进制日志事件信息

```shell
# cat /backup/2017-04-03_12-45-44/xtrabackup_info 
uuid = 694e5590-1828-11e7-81d2-000c291bd2a1
name = 
tool_name = innobackupex
tool_command = --defaults-file=/etc/my.cnf --user=root --password=... /backup/
tool_version = 2.4.6
ibbackup_version = 2.4.6
server_version = 5.7.17
start_time = 2017-04-03 21:34:09
end_time = 2017-04-03 21:34:13
lock_time = 0
binlog_pos = 
innodb_from_lsn = 0
innodb_to_lsn = 9692219
partial = N
incremental = N
format = file
compact = N
compressed = N
encrypted = N
```

##### 恢复

5.进行全备恢复

a.删除数据库、停止并破坏MySQL

```shell
# mysql -u root -p
mysql> show databases;
mysql> drop database sakila;
Query OK, 30 rows affected (0.59 sec)
# systemctl stop mysqld
# cp -R /var/lib/mysql /root
# rm -rf /var/lib/mysql
```

b.恢复全备

```shell
# innobackupex --copy-back /backup/2017-04-03_21-34-08/
......
completed OK!
# chown -R mysql.mysql /var/lib/mysql
# systemctl start mysqld
# mysql -u root -p
mysql> show databases;
```

> 关键命令：copy-back

注:如无法启动SQL，可能是SELINUX的问题

```shell
# vim /etc/selinux/config
SELINUX=disabled
```

#### 增量备份

1.创建数据库和表

2.基于全备进行增量备份

3.应用全备日志

4.应用第一次增量备份日志

5.基于全备进行第一次增量备份恢复

6.基于第一次增量备份进行备份

​	a.向表中添加数据

​	b.应用第二次增量备份日志

​	c.查看备份状态

​	d.基于全备份和第一次增量备份，恢复第二次增量备

b.应用第二次增量备份日志

c.查看备份状态

d.基于全备份和第一次增量备份，恢复第二次增量备份

##### 备份

首先进行全备，步骤同上

###### 二进制方式

```shell
cat mysqlback/xxxx/xtrabackup_binlog_info
mysql-bin.000002 2322
mysqlbinlog --start-position=2322 mysql-bin.000002 > xxx.sql

```



##### 恢复

//待添加

### Xtrabackup

#### 全备

1.创建全备

2.应用全备日志

3.查看备份状态

4.恢复备份

#### 增量备份

1.第一次增量备份

2.应用第一次增量备份日志

3.查看备份状态

4.第二次增量备份

5.应用第二次增量备份日志

6.查看备份状态

7.准备第一次增量备份

8.准备第二次增量备份

9.合并恢复备份



## 参考

[官方文档](https://www.percona.com/doc/percona-xtrabackup/LATEST/index.html)

[使用xtrabackup同步主从及数据备份](http://www.toutiao.com/i6436511518929453569/)

