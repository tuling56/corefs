## Redis学习笔记

[TOC]

### 安装

#### 安装

```shell
#1.下载
wget http://download.redis.io/redis-stable.tar.gz
#2.解压
tar –zxvf redis-stable.tar.gz
#3.编译
cd redis-stable&&make
#4.安装
make install
```

#### 配置

redis.conf配置文件：[redis.conf配置文件详细说明](http://www.runoob.com/redis/redis-conf.html)

```shell
#配置文件(将压缩包目录的下的redis.conf拷贝到这个地方)
/etc/redis/redis.conf
# dumpfile 目录，进程pid目录，log目录
/var/redis/data
/var/redis/run
/var/redis/log
```

> 运行：redis-server  /path/to/redis.conf

命令行获取相关配置

```shell
# 获取某个变量的配置
redis 127.0.0.1:6379> CONFIG GET CONFIG_SETTING_NAME
# 获取所有配置项
redis 127.0.0.1:6379> CONFIG GET *       
# 使用CONFIG SET来设置变量
redis 127.0.0.1:6379> CONFIG SET CONFIG_SETTING_NAME NEW_CONFIG_VALUE
```

#### 开启启动

创建过程

```shell
# 1.创建启动脚本
# 拷贝解压包下utils下redis启动脚本至/etc/init.d/
cp redis_init_script /etc/init.d/redis-server

# 2.开机启动
# 添加以下内容到/etc/init.d/redis-server脚本头部
> # Start Redis-server at the launch. It is used to serve
> # chkconfig: 2345 90 10
# 然后执行chkconfig redis-server on
```

样例：

```shell
[root@local122 init.d]# cat redis-server 
#!/bin/sh
#

# Start Redis-server at the launch. It is used to serve
# chkconfig: 2345 90 10

# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

REDISPORT=6379
EXEC=/usr/local/redis/bin/redis-server
CLIEXEC=/usr/local/redis/bin/redis-cli

PIDFILE=/usr/local/redis/run/redis_${REDISPORT}.pid
CONF="/usr/local/redis/conf/redis.conf"

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
# 然后使用service redis-server start/stop进行服务的启动和关闭
[root@local122 init.d]# service redis-server start
/usr/local/redis/run/redis_6379.pid exists, process is already running or crashed
```



### 基础

Redis中没有关系数据库中库表的概念，只有key:value的概念

#### 数据类型

Redis支持五种数据类型：string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。

##### String

```shell
redis 127.0.0.1:6379> SET name "runoob"
OK
redis 127.0.0.1:6379> GET name
"runoob"
```

##### Hash

hash特别适合用于存储对象,和上面的String的区别在于其value是可以自动检索的。

```shell
127.0.0.1:6379> HMSET user:1 username runoob password runoob points 200
OK
127.0.0.1:6379> HGETALL user:1
1) "username"
2) "runoob"
3) "password"
4) "runoob"
5) "points"
6) "200"

127.0.0.1:6379> HGET user:1 username
runoob
```

> 哈希的主要功能：删除某个字段，为哈希表key中的指定字段的整数值加上增量，重新设置某个字段的值

##### 列表

简单的字符串列表，按照插入顺序排序

##### 集合

Set是string类型的无序集合，集合是通过hash表实现的，所以添加、删除、查找的复杂度都是O(1)。

```shell
redis 127.0.0.1:6379> sadd runoob redis
(integer) 1
redis 127.0.0.1:6379> sadd runoob mongodb
(integer) 1
redis 127.0.0.1:6379> sadd runoob rabitmq
(integer) 1
redis 127.0.0.1:6379> sadd runoob rabitmq
(integer) 0
redis 127.0.0.1:6379> smembers runoob

1) "rabitmq"
2) "mongodb"
3) "redis"
```

> 集合的作用主要用来计算集合的交集，并集，补集，差集等运算

##### 有序集合

zset和set一样，是string类型元素的集合，切不允许重复成员。不同的是每个元素都会关联一个double类型的分数，redis正是通过分数来为集合中的成员进行按从小到大的排序。

```shell
redis 127.0.0.1:6379> zadd runoob 0 redis
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 mongodb
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 rabitmq
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 rabitmq
(integer) 0
redis 127.0.0.1:6379> ZRANGEBYSCORE runoob 0 1000

1) "redis"
2) "mongodb"
3) "rabitmq"
```

有序集合按分数（值）筛选，按排名筛选，按域筛选等多种筛选方式的使用；指定成员分数的加减等

#### 发布和订阅

不知道有什么用，信息流推送？

#### 事务

//待补充

### 备份

#### 自身备份

数据导入和导出：SAVE和BGSAVE命令

#### 同步数据到MySQL

将redis数据导出成文件，然后一次性加载进mysql,关键是如何组织redis中的数据结构到mysql中数据结构的转换

### 接口

#### Python操作Redis

//已基本掌握

#### Lua操作Redis



## 参考

[Centos6.5下Redis的安装和配置](http://blog.csdn.net/ludonqin/article/details/47211109)

[菜鸟Redis学习](http://www.runoob.com/redis/redis-sorted-sets.html)

[Redis官方参考](http://www.redis.net.cn/order/3530.html) 

[Python操作Redis](http://www.cnblogs.com/clover-siyecao/p/5600078.html)

[MySQL快速数据同步到Redis](http://www.cnblogs.com/Buggo/p/5550358.html)(思路不错)