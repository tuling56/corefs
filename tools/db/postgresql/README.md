##PostgreSQL笔记
[TOC]

### 基础

#### 安装

安装

```shell
yum install postgresql-contrib  postgresql postgresql-server
# 该命令会安装以下的包
postgresql        	# PostgreSQL client programs 
postgresql-contrib  # Extension modules distributed with PostgreSQL
postgresql-libs     # The shared libraries required for any PostgreSQL clients 
postgresql-server   # The programs needed to create and run a PostgreSQL server
uuid             	# 用途未知  
```

初始化

```shell
# step1:初始化数据库
/usr/bin/initdb -D /home/yjm/xxx  # 该命令会创建数据库，并完成一系列的配置

# step2:启动数据库
# Success. You can now start the database server using:
postgres -D /home/yjm/xxx
#or
pg_ctl -D /home/yjm/xxx -l logfile start
```

### 进阶

//待添加

### 备份

//带添加

 ##参考

- 基础

  [Centos上安装和配置PostgreSQL](http://www.linuxidc.com/Linux/2016-09/135538.htm)