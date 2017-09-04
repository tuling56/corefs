## 日志分析系统

[TOC]

说明：

目的在于日志分析接口模块化，减少初期的重复数据加工，目前有以下几种方案

| 方案                                  | 技术点                                 | 备注          |
| ----------------------------------- | ----------------------------------- | ----------- |
| 手动解析                                | awk                                 |             |
| Rsyslog+LogAnayzer+MySQL            | Rsyslog+LogAnayzer+MySQL            |             |
| Logstash+Elasticsearch+Redis+Kinaba | Logstash+Elasticsearch+Redis+Kinaba |             |
| goaccess                            |                                     | 成熟解决方案，关注配置 |

### 手动解析

| 脚本                | 应用                 | 说明   |
| ----------------- | ------------------ | ---- |
| log_stat.awk      | awk实现基础版           |      |
| log_stat_impl.awk | awk实现增强版，增加了类别的汇总量 |      |
| log_stat.py       | python实现           |      |
| log_stat.data     | 测试数据               | 测试数据 |

### Rsyslog+LogAnayzer+MySQL

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

### Logstash+Elasticsearch+Redis+Kinaba

#### 基础

Logstash: logstash server端用来搜集日志；

Elasticsearch: 存储各类日志；

Kibana: web化接口用作查寻和可视化日志；

Logstash Forwarder: logstash client端用来通过lumberjack 网络协议发送日志到logstash server

### goaccess

goaccess包含解析和可视化

#### nginx

```nginx
# nginx的默认日志格式
log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    # 启用认证访问(这块接触的很少，待研究)
    auth_basic "nginx auth";
    auth_basic_user_file /etc/nginx/auth;
}
```

nginx参数说明：

```nginx
$remote_addr - # 访问来源ip 后面的"-" 是个普通字符
$remote_user # 用户，只有在启用 auth_basic 认证访问的时候才会出现，否则是一个 "-" 字符
[$time_local] # 日期，时间，时区
"$request" # 请求地址 注意，这里有双引号
$status # 状态码
$body_bytes_sent # 包发送大小(是服务器返回给客户端的大小)
"$http_referer" # 引用页 注意，这里有双引号
"$http_user_agent" # 客户端useragent信息（系统版本、浏览器等） 注意，这里有双引号
"$http_x_forwarded_for" # nginx做反向代理时的客户端地址 注意，这里有双引号
```

#### goaccess

goaccess日志格式说明：

```shell
time-format %H:%M:%S
date-format %d/%b/%Y
log-format %h %^ %^ [%d:%t %^] "%r" %s %b "%R" "%u" %^
```

> 不要忘记日志格式中的双引号，及其他字符，如[]，否则会解析失败,参数说明：
>
> ```shell
> %x 与时间格式和日期格式变量匹配的日期和时间字段。当使用时间戳而不是日期和时间在两个单独的变量中时使用这个。
>
> %t time字段匹配时间格式变量。
>
> %d date字段匹配日期格式变量。
>
> %v 根据规范名称设置（服务器块或虚拟主机）的服务器名称。
>
> %e 这是通过HTTP身份验证请求文档的用户ID。
>
> %h host（客户端IP地址，IPv4或IPv6）
>
> %r 客户端的请求行。这需要围绕请求的特定分隔符（单引号，双引号等）可解析。否则，请使用特殊格式说明符（如%m，%U，%q和%H）的组合来解析各个字段。
>
> 注意：使用%r获取完整请求或%m，%U，%q和%H以形成请求，两者不要同时使用。
>
> %m 请求方式。
>
> %U 请求的URL路径。
>
> 注意：如果查询字符串在%U中，则不需要使用%q。但是，如果URL路径不包含任何查询字符串，则可以使用%q，并将查询字符串追加到请求中。
>
> %q 查询字符串。
>
> %H 请求协议。
>
> %s 服务器发送回客户端的状态码。
>
> %b 返回给客户端的对象的大小。
>
> %R “Referer”HTTP请求标头。
>
> %u 用户代理HTTP请求标头。
>
> %D 服务请求所用的时间，以微秒为单位。
>
> %T 以毫秒级分辨率提供服务所需的时间（秒）。
>
> %L 服务请求所需的时间，以毫秒为单位，为十进制数。
>
> %^ 忽略此字段。
>
> %~ 向前移动日志字符串，直到找到一个非空格（！isspace）字符。
>
> ~h X-Forwarded-For（XFF）字段中的主机（客户端IP地址，IPv4或IPv6）
> ```

使用:

```shell
goaccess -f /var/log/nginx/access.log  -o ./access.html
# 在生成html时候加一个参数 --real-time-html，这时goaccess会在当前窗口一直运行，可以用nohup放到后台。
```

> 更多的使用可以参考`man goaccess`

##  参考

[Linux日志分析终极指南](http://blog.jobbole.com/110660/)

[Nginx日志分析及性能排查](http://mp.weixin.qq.com/s/A1ufVgi3VFuSGRh4Ju5puA)

[Logstash+Elasticsearch+Redis+Kinaba（ELK）日志可视化分析系统](http://467754239.blog.51cto.com/4878013/1700828)

[Centos6.5利用Rsyslog+LogAnayzer+MySQL部署日志服务器](http://www.mamicode.com/info-detail-1165648.html)(推荐)

[EFK Nginx日志的可视化分析](http://www.toutiao.com/i6352290798666514945/)

[goaccess日志分析详解](http://www.toutiao.com/i6460608551814431245/)

[如何挖掘Nginx日志中的金矿（推荐）](http://mp.weixin.qq.com/s/t-ktlzJsrpad1-YRuIakiw)