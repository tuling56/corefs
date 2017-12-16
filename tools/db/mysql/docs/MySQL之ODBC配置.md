##MySQL之ODBC配置
[TOC]

### 基础

#### Windows



#### Linux

##### 安装

###### 安装依赖项unixODBC

```shell
yum install unixODBC
# 或者

tar zxvf unixODBC-2.3.0.tar.gz   
cd unixODBC-2.3.0  
./configure --prefix=/usr/local/lib --includedir=/usr/include --libdir=/usr/local/lib -bindir=/usr/bin --sysconfdir=/etc  
make  
make install  
```

查看配置

```shell
[root@local122 base]# rpm -ql unixODBC |grep ini
/etc/odbcinst.ini

# 查看配置文件路径
[root@local122 base]# odbcinst -j  
unixODBC 2.3.4
DRIVERS............: /etc/odbcinst.ini
SYSTEM DATA SOURCES: /etc/odbc.ini
FILE DATA SOURCES..: /etc/ODBCDataSources
USER DATA SOURCES..: /root/.odbc.ini
SQLULEN Size.......: 8
SQLLEN Size........: 8
SQLSETPOSIROW Size.: 8


### 查看配置详情
[root@local122 base]# cat /etc/odbcinst.ini
# Example driver definitions

# Driver from the postgresql-odbc package
# Setup from the unixODBC package
[PostgreSQL]
Description     = ODBC for PostgreSQL
Driver          = /usr/lib/psqlodbcw.so
Setup           = /usr/lib/libodbcpsqlS.so
Driver64        = /usr/lib64/psqlodbcw.so
Setup64         = /usr/lib64/libodbcpsqlS.so
FileUsage       = 1


# Driver from the mysql-connector-odbc package
# Setup from the unixODBC package
[MySQL]
Description     = ODBC for MySQL
Driver          = /usr/lib/libmyodbc5.so
Setup           = /usr/lib/libodbcmyS.so
Driver64        = /usr/lib64/libmyodbc5.so
Setup64         = /usr/lib64/libodbcmyS.so
FileUsage       = 1
```

###### 安装mysql odbc

```shell
yum install mysql-connector-odbc
# 或者
# --下载源码编译安装
```

##### 配置

配置环境变量

```shell
vim /etc/profile
export ODBCSYSINI=/etc  
export ODBCINI=/etc/odbc.ini  
```

配置数据源

```shell
[root@local122 mysql]# cat ~/.odbc.ini
[mysql_labs]   # 名字可以随意起  
Description = The Database for mysql  
Trace = On  
TraceFile = stderr  
Driver = MYSQL  
SERVER = localhost  
USER = root  
PASSWORD = root  
PORT = 3306  
DATABASE = labs
CHARSET= UTF8  
OPTION = 3
```

##### 测试

isql是unixODBC带的一个ODBC客户端访问工具,使用isql +数据源名来访问目标数据库.

```shell
isql -v mysql_labs  #mysql_labs是上午的配置的数据源,如果配置正确，则出现：

[root@local122 mysql]# isql -v mysql_labs
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL>

```







 ##参考

- 基础

  [linux下mysql odbc配置](http://blog.csdn.net/u010587433/article/details/46799037)

  [linux操作配置ODBC数据源](http://blog.51cto.com/webseven/1545877)