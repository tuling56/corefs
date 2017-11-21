## Git学习笔记

[TOC]

### 基本

#### 配置

用户配置文件

```
[user]
    name = XXX
           email = XXX@xunlei.com
      [alias]
           pushfull = push origin HEAD:refs/for/master
           logfull = log --pretty=full
           logformat = log --pretty=format:'%h %ai : %an , %s'
           loggraph = log --pretty=format:'%h : %s(%an-%ai)' --graph
     [color]
           ui = true
     [format]
           pretty = format:%h %ai %an, %s
```

注：以上配置文件放置每个人的~/.gitconfig

##### 全局配置

设置Git的全局user name和email：

```shell
git config --global user.name "tuling56"  
git config --global user.email "tuling56@gmail.com"  
```

> 注意:用户名必须是已注册的用户名，邮箱必须为该用户绑定的邮箱地址

生成ssh密钥过程

```shell
ssh-keygen -t rsa -C “xxx@gmail.com” 
# 生成私钥id_rsa和公钥id_rsa.pub两个文件,将id_rsa.pub拷贝到网站上
```

使用`git config --list`查看已有的配置

##### 单独配置

在项目中如果不进行单独配置用户名和邮箱的话，则会使用全局的，正确的做法是针对公司的项目，在项目根目录下单独进行配置：

```shell
git config user.name "gitlab's Name"
git config user.email "gitlab@xx.com"
git config --list
```

> 注： git config --list查看当前配置, 在当前项目下面查看的配置是全局配置+当前项目的配置, 使用的时候会优先使用当前项目的配置

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

#### 撤销

| 情况            | 语句   | 说明   |
| ------------- | ---- | ---- |
| 已add但没有commit |      |      |
| 已commit但未push |      |      |
| 已push         |      |      |

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