## 日志分析系统

目的在于日志分析接口模块化

### 基础

#### LogAnalyzer 

LogAnalyzer 是一款syslog日志和其他网络事件数据的Web前端。它提供了对日志的简单浏览、搜索、基本分析和一些图表报告的功能。数据可以从数据库或一般的 syslog文本文件中获取，所以LogAnalyzer不需要改变现有的记录架构。基于当前的日志数据，它可以处理syslog日志消 息，Windows事件日志记录，支持故障排除，使用户能够快速查找日志数据中看出问题的解决方案。

LogAnalyzer 获取客户端日志会有两种保存模式，一种是直接读取客户端/var/log/目录下的日志并保存到服务端该目录下，一种是读取后保存到日志服务器数据库中，推荐使用后者。

LogAnalyzer 采用php开发，所以日志服务器需要php的运行环境，本文采用LAMP(其配置参考git::/shared_common_libs/Tools/linux/docs)。

#### Rsyslog

安装

```
yum install rsyslog rsyslog-mysql
# 其中后者是将日志传送到MySQL数据库的一个模块
```

配置

```shell
/usr/share/doc/rsyslog/mysql-createDB.sql  导入到mysql

# 创建mysql的rsyslog用户并授权
grant all on Syslog.* to rsyslog@localhost identified by '123';
flush privileges;

```







##  参考

[ELK日志分析系统](http://467754239.blog.51cto.com/4878013/1700828)

[Nginx日志分析及性能排查](http://mp.weixin.qq.com/s/A1ufVgi3VFuSGRh4Ju5puA)

[Centos6.5利用Rsyslog+LogAnayzer+MySQL部署日志服务器](http://www.mamicode.com/info-detail-1165648.html)(推荐)