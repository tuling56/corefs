##Jenkins发布系统
[TOC]

### 基础

#### 安装

##### 安装

```shell
# 首先安装jdk环境（>1.6）
# 在网址https://pkg.jenkins.io/redhat-stable/下载jenkins版本
wget https://prodjenkinsreleases.blob.core.windows.net/redhat-stable/jenkins-2.7.4-1.1.noarch.rpm
rpm -ivh jenkins-2.7.4-1.1.noarch.rpm

# 
```

##### 配置

基础配置和启动

```shell
# 修改配置文件
vim /etc/sysconfig/jenkins
# 默认端口是8080,此处修改为8086

[root@local122 software]# /usr/sbin/rcjenkins --help
Usage: /usr/sbin/rcjenkins {start|stop|status|try-restart|restart|force-reload|reload|probe}

# 启动
rcjenkins start

# 更多的开机启动配置可以参考chkconfig --help
```

>  然后访问http://localhost:8086，要求输入密码，查看`cat /var/lib/jenkins/secrets/initialAdminPassword`,将其内容粘贴到输入框。

选择安装插件

```
选择需要安装的插件即可
```

> 安装插件完毕后，创建第一个用户并继续

##### 任务



### 高级

//待补充

 ##参考

- 基础

  [jenkins安装教程](https://www.toutiao.com/a6383796960260800769/)

  [自动安装插件卡住的解决办法](http://ask.csdn.net/questions/351157)