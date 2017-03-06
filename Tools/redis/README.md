## Redis学习笔记

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
```



##### 列表

简单的字符串列表，按照插入顺序排序

##### 集合

Set是string类型的无序集合，集合是通过hash表实现的，所以添加、删除、查找的复杂度都是O(1)

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

#### 发布和订阅

不知道有什么用，信息流推送？

#### 事务



### 备份

#### 自身备份

数据导入和导出：SAVE和BGSAVE命令

#### 和MySQL数据同步









## 参考

[Centos6.5下Redis的安装和配置](http://blog.csdn.net/ludonqin/article/details/47211109)

[菜鸟Redis学习](http://www.runoob.com/redis/redis-sorted-sets.html)

[Redis官方参考](http://www.redis.net.cn/order/3530.html) 

[Python操作Redis](http://www.cnblogs.com/clover-siyecao/p/5600078.html)

[MySQL快速数据同步到Redis](http://www.cnblogs.com/Buggo/p/5550358.html)(思路不错)