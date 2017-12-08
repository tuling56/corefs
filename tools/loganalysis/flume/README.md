##flume笔记
[TOC]

### 基础

#### 安装

前提:安装jdk环境,自行查阅参考资料

```shell
wget -c http://www.apache.org/dist/flume/stable/apache-flume-1.8.0-bin.tar.gz
tar -zxvf apache-flume-1.8.0-bin.tar.gz
mv apache-flume-1.8.0-bin flume

# 添加环境变量：
export FLUME_HOME=
export PATH=$FLUME_HOME/bin

# 测试
flume-ng version
```

### 高级

//待补充

 ##参考

- 基础

  [centos6.5安装flume](https://www.cnblogs.com/fujinzhou/p/5732983.html)