##supervisor进程监控工具
[TOC]

### 安装

yum install supervisor

```shell
# 配置文件
/etc/logrotate.d/supervisor
/etc/supervisord.conf  # 默认配置文件
/etc/supervisord.d	   # 其它要监控的进程配置文件存放的目录

# 默认执行文件
/usr/bin/echo_supervisord_conf
/usr/bin/pidproxy
/usr/bin/supervisorctl
/usr/bin/supervisord
```



 ##参考

[官方参考(推荐)](http://www.supervisord.org/running.html)

[进程监控工具supervisor](http://www.toutiao.com/i6461940746659299854/)