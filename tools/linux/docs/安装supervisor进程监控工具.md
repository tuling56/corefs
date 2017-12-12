##supervisor笔记
[TOC]

### 基础

supervisor是一款进程监控工具

#### 安装

安装

```shell
yum install supervisor
```

配置

```shell
# 配置文件
/etc/logrotate.d/supervisor
/etc/supervisord.conf  # 默认配置文件
/etc/supervisord.d	   # 其它要监控的进程配置文件存放的目录

# 默认执行文件
/usr/bin/echo_supervisord_conf  # 显示默认配置文件(在此计算上进行修改)
/usr/bin/pidproxy
/usr/bin/supervisorctl
/usr/bin/supervisord
```

例子：

```shell
# supervisor_demo.conf
command=/opt/logstash/bin/logstash -f nginx_to_redis.conf
numprocs=1
autostart=true
autorestart=true
log_stdout=true
log_stderr=true
logfile=./nginx_to_redis.log
```

 ##参考

- 基础

  [官方参考(推荐)](http://www.supervisord.org/running.html)

  [进程监控工具supervisor](http://www.toutiao.com/i6461940746659299854/)