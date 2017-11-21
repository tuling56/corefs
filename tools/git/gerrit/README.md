##Gerrit
[TOC]

### 基础

Git服务器，它为在其服务器上托管的Git仓库提供一系列权限控制，以及一个用来做Code Review是Web前台页面。当然，其主要功能就是用来做Code Review。

#### 安装

安装

```
# 下载
java -jar gerrit*.war init --batch --dev -d /home/yjm/Documents/gerrit/
```



添加用户

```
touch /home/yjm/Documents/gerrit/passwd
htpasswd /home/yjm/Documents/gerrit/passwd  [new-user-name]
```



启动、关闭和重启

```shell
/home/yjm/Documents/gerrit/bin/gerrit.sh start
/home/yjm/Documents/gerrit/bin/gerrit.sh stop
/home/yjm/Documents/gerrit/bin/gerrit.sh restart
```



#### 配置





 ##参考

[gerrit环境搭建和使用（基于apache）](http://blog.csdn.net/ganshuyu/article/details/8978614)

[gerrit搭建官方教程(推荐)](https://gerrit-review.googlesource.com/Documentation/linux-quickstart.html)

[gerrit的日常使用](http://www.jianshu.com/p/b77fd16894b6)

