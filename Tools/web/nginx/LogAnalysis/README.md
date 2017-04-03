## 日志分析系统

[TOC]

目的在于日志分析接口模块化，减少初期的重复数据加工

### 方案0：手动解析

| 脚本                | 应用                 | 说明   |
| ----------------- | ------------------ | ---- |
| log_stat.awk      | awk实现基础版           |      |
| log_stat_impl.awk | awk实现增强版，增加了类别的汇总量 |      |
| log_stat.py       | python实现           |      |
| log_stat.data     | 测试数据               | 测试数据 |

### 方案1：Rsyslog+LogAnayzer+MySQL

#### LogAnalyzer 

LogAnalyzer 是一款syslog日志和其他网络事件数据的Web前端。它提供了对日志的简单浏览、搜索、基本分析和一些图表报告的功能。数据可以从数据库或一般的 syslog文本文件中获取，所以LogAnalyzer不需要改变现有的记录架构。基于当前的日志数据，它可以处理syslog日志消 息，Windows事件日志记录，支持故障排除，使用户能够快速查找日志数据中看出问题的解决方案。

LogAnalyzer 获取客户端日志会有两种保存模式，一种是直接读取客户端/var/log/目录下的日志并保存到服务端该目录下，一种是读取后保存到日志服务器数据库中，推荐使用后者。

LogAnalyzer 采用php开发，所以日志服务器需要php的运行环境，本文采用LAMP(其配置参考git::/shared_common_libs/Tools/linux/docs)。

#### Rsyslog

Rsys是一个快速处理收集系统日志的程序，rsyslog是syslog的升级版，它将多种来源输入输出转换结果到目的地。

安装

```
yum install rsyslog rsyslog-mysql
# 其中后者是将日志传送到MySQL数据库的一个模块
```

配置服务器端

```shell
vim /etc/rsyslog.conf

part1:在 #### MODULES #### 下添加上面两行。
$ModLoad ommysql   
*.* :ommysql:localhost,Syslog,rsyslog,123

说明：localhost 表示本地主机，Syslog 为数据库名，rsyslog 为数据库的用户，123为该用户密码。

part2: 开启相关日志模块

$ModLoad immark      #immark是模块名，支持日志标记
$ModLoad imudp    	 #imupd是模块名，支持udp协议
$UDPServerRun 514    #允许514端口接收使用UDP和TCP协议转发过来的日志
```

配置客户端

```shell
//将日志输出到服务器端
```

MySQL配置

```shell
/usr/share/doc/rsyslog/mysql-createDB.sql  导入到mysql

# 创建mysql的rsyslog用户并授权
grant all on Syslog.* to rsyslog@localhost identified by '123';
flush privileges;
```

进度

> 2017年4月3日

卡在配置文件不可写这一步了

### 方案2：Logstash+Elasticsearch+Redis+Kinaba

#### 基础

Logstash: logstash server端用来搜集日志；

Elasticsearch: 存储各类日志；

Kibana: web化接口用作查寻和可视化日志；

Logstash Forwarder: logstash client端用来通过lumberjack 网络协议发送日志到logstash server；



##  参考

[Logstash+Elasticsearch+Redis+Kinaba（ELK）日志可视化分析系统](http://467754239.blog.51cto.com/4878013/1700828)

[Nginx日志分析及性能排查](http://mp.weixin.qq.com/s/A1ufVgi3VFuSGRh4Ju5puA)

[Centos6.5利用Rsyslog+LogAnayzer+MySQL部署日志服务器](http://www.mamicode.com/info-detail-1165648.html)(推荐)

[EFK Nginx日志的可视化分析](http://www.toutiao.com/i6352290798666514945/)

[Linux日志分析终极指南](http://blog.jobbole.com/110660/)