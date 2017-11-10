## Git学习笔记

[TOC]

### 基本

#### 配置

- 设置Git的user name和email：

> git config --global user.name "xxx"  
>
> git config --global user.email "xxx@gmail.com"  
>
> Note:用户名必须是已注册的用户名，邮箱必须为该用户绑定的邮箱地址

- 生成ssh密钥过程

```
ssh-keygen -t rsa -C “xxx@gmail.com” 
生成id_rsa和id_rsa.pub两个文件
将id_rsa.pub拷贝到网站上
```

#### 基础

##### 传输协议

- 本地协议
- ssh协议
- git协议

  不推荐

- http/s协议

需要配置一个post-update挂钩

###### Clone项目的两种方式

在git中clone项目有两种方式：HTTPS和SSH，它们的区别如下：

- HTTPS：不管是谁，拿到url随便clone，但是在push的时候需要验证用户名和密码；
- SSH：clone的项目你必须是拥有者或者管理员，而且需要在clone前添加SSH Key。SSH 在push的时候，是不需要输入用户名的，如果配置SSH key的时候设置了密码，则需要输入密码的，否则直接是不需要输入密码的。

### 高级

#### 钩子

钩子在运行的时候会调用GIT_DIR这个环境变量，而不是PWD这个

##### post-receive

需求描述：

```
 git push ssh://git@ownlinux.org:/opt/foo.git  之后在另外一个版本/opt/foo2.git库执行git pull的操作
```

解决：

```
#!/bin/sh
unset $(git rev-parse --local-env-vars)
cd /var/git/web3/etc/puppet
/usr/bin/git pull
```

### 积累



## 参考

- 基础

  [搭建Git服务器(廖雪峰)](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/00137583770360579bc4b458f044ce7afed3df579123eca000)

  [gitlab配置ssh-key](http://blog.csdn.net/breeze_life/article/details/45868045)

  [git查看远程仓库](http://blog.csdn.net/wanghuihui02/article/details/48155627)

- 高级

  [git post-receive钩子部署服务端代码立即重启生效](https://yq.aliyun.com/ziliao/25682)

  [http方式push失败的疑似解决方案](https://stackoverflow.com/questions/25312542/git-push-to-nginxgit-http-backend-error-cannot-access-url-http-return-code-2)