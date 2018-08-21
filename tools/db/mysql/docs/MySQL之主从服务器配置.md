## MySQL主从服务器

重点要解决主从延迟问题

### 基础

#### 同步方案

##### 简单主从

![简单主从](http://p3.pstatp.com/large/pgc-image/1526723373823f38072ac35)



##### 带中间件的主从

![中间件的主从](http://p9.pstatp.com/large/pgc-image/152672362782479aef71df4)

##### 多主带中间件

![多主带中间件](http://p3.pstatp.com/large/pgc-image/1526724981986b3cdbc59ab)

### 实现

#### 简单主从

简单主从的配置和实现

##### 配置master

###### 开启二进制格式

找到/etc/my.cnf文件，修改如下，重启：

```mysql
server-id=1             # 给数据库服务的唯一标识，一般为大家设置服务器Ip的末尾号
log-bin=master-bin
log-bin-index=master-bin.index

binlog-do-db = slaveDB  # 需要同步的数据库，如果需要同步多个数据库,则继续添加此项。
# binlog-do-db = slaveDB1
# binlog-do-db = slaveDB2
binlog-ignore-db = mysql # 不需要同步的数据库；
```

然后检查主服务器的状态

```mysql
mysql> show master status;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 | 10568216 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)

```

###### 创建同步使用的用户

```mysql
create user syncopy;
GRANT REPLICATION SLAVE ON *.* TO 'syncopy'@'%' IDENTIFIED BY 'syncopy_pwd';
```

##### 配置slave

修改/etc/my.cnf文件

```mysql
[mysqld]
server-id=2
relay-log=slave-relay-bin 
relay-log-index=slave-relay-bin.index
replicate-do-db=study        # 需要同步的数据库
replicate-ignore-db=mysql    # 不同步系统数据库
read_only                    # 设只读权限

```

mysql命令行执行

```mysql
slave stop;
change master to master_host='47.95.195.31',
master_port=3306,
master_user='syncopy',
master_password='syncopy_pwd',
master_log_file='mysql-bin.000003',
master_log_pos=831;
slave start;
```

错误：

> Error 'Table 'study.test_copy' doesn't exist' on query

### 进阶

//待补充

## 参考

- 基础

  [数据库部署方案](https://www.toutiao.com/i6557238786713993741/)

  [Mysql主从服务器配置](https://blog.csdn.net/rdisme/article/details/78910841)

- 实现

- 进阶