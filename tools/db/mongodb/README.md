## mongodb学习笔记

[TOC]

### 基本

#### 安装

wget -c http://61.180.11.29/mongodb-linux-x86_64-rhel70-3.2.10.tgz

然后解压并重命名复制到/usr/local/mongodb目录下

在/usr/local/mongodb目录下新建data和log目录，用以存储数据和日志文件.

执行启动

```shell
/usr/local/mongodb/bin/mongod --dbpath=/usr/local/mongodb/data/ --logpath=/usr/local/mongodb/log/mongodb.log --logappend&
```

### 积累

### 应用

### 查询

### 调优

### 备份

#### 导入和导出

//待补充

#### mongodb导入到mysql

//待补充

## 参考 

- 基础

  [Linux系统下MongoDB的简单安装与基本操作](http://www.jb51.net/article/63552.htm)(强烈推荐)

  [Linux下Mongodb安装和启动配置](http://blog.csdn.net/yuwenruli/article/details/8529192)（参数配置）