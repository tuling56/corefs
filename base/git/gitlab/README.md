##Gitlab笔记
[TOC]

### 基础

#### 安装

##### 安装

```shell
# 下载和安装
wget -c https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el6/gitlab-ce-10.0.0-ce.0.el6.x86_64.rpm
rpm -ivh gitlab-ce-10.0.0-ce.0.el6.x86_64.rpm

# 防火墙配置（不建议这一步操作）
sudo lokkit -s http -s ssh
```

[lokkit命令参考](http://www.jianshu.com/p/dd00ea2598b1)

##### 配置

默认配置文件是：`/etc/gitlab/gitlab.rb`

基础配置

```shell
# 配置和启动
sudo gitlab-ctl reconfigure
gitlab-ctl start
gitlab-ctl stop
gitlab-ctl status # 查看安装后的程序运行情况
gitlab-ctl tail

# 修改默认端口和配置,修改配置文件的这个部分
external_url 'http://mgitlab.com:8088'
```

> 最后通过浏览器访问:http://localhost:xxx或者http://ip:xxx访问gitlab，首次登陆需要修改密码，此处修改为（gitlab112233）,然后重新登录即可
>
> 问题和解决办法：
>
> - [taking too much time to respond](http://blog.csdn.net/snowglede/article/details/74911101)问题的解决方法

邮件配置



 ##参考

- 基础

  [官网安装教程](https://www.gitlab.cc/installation/#centos-6)

  [Centos服务器上搭建安装GitLab教程](http://www.21yunwei.com/archives/4351)

  [Centos6.5搭建gitlab服务器（推荐）](https://www.cnblogs.com/shenlanzhizun/p/5851942.html)
