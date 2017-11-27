##Gerrit
[TOC]

### 基础

Git服务器，它为在其服务器上托管的Git仓库提供一系列权限控制，以及一个用来做Code Review是Web前台页面。当然，其主要功能就是用来做Code Review。

#### 安装

安装

```shell
# 下载
wget https://www.gerritcodereview.com/download/gerrit-2.14.2.war
java -jar gerrit-2.14.2.war init --batch --dev -d /home/yjm/Documents/gerrit/

--dev 配置授权选项进行身份验证
# 注意安装的时候要安装download-commands，不然没有项目地址
```

添加用户

```shell
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



### 问题

#### 基础

怎样创建项目？

- 创建的项目找不到地址
- 怎样将现有的git项目加入到gerrit中去

权限管理

- 用户分组

配置https方式访问

- ​

 ##参考

- 基础

  [gerrit搭建官方教程(推荐)](https://gerrit-review.googlesource.com/Documentation/linux-quickstart.html)

  [gerrit环境搭建和使用（基于apache）](http://blog.csdn.net/ganshuyu/article/details/8978614)

  [gerrit的日常使用](http://www.jianshu.com/p/b77fd16894b6)

  [gerrit部分参考](http://blog.csdn.net/chenjh213/article/details/50493626)

  [gerrit官方参考](https://gerrit.googlesource.com/plugins/download-commands/+/v2.14.5)

- 问题