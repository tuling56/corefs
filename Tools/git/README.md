## Git学习笔记

[TOC]

### 基础

#### 配置

##### 授权配置

###### ssh密钥配置

```shell
ssh-keygen -t rsa -C "xxx@gmail.com"
# 生成私钥id_rsa和公钥id_rsa.pub两个文件,将id_rsa.pub拷贝到网站上
```

为不同的环境配置不同的ssh密钥？

###### https账号配置

//https访问如何自动添加账号和密码

##### 用户配置

配置文件

```git
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

> 注：以上配置文件放置在个人的~/.gitconfig，使用`git config --list`查看已有的配置

###### [别名配置](http://blog.csdn.net/zhang31jian/article/details/41011313)

```
# 待补充
```

###### 日志配置

```R
图形化：git log --pretty=format:'%h : %s(%an-%ai)' --graph
原始格式：git log --pretty=full
定制格式：git log --pretty=format:'%h %ai : %an , %s'
git log --stat #显示每次提交（commit）中哪些文件被修改了  
```

###### 账号配置

设置Git的全局user name和email：

```shell
git config --global user.name "tuling56"  
git config --global user.email "tuling56@gmail.com"  

# 注意:用户名必须是已注册的用户名，邮箱必须为该用户绑定的邮箱地址
```

为每个仓库单独设置user name和email:

```shell
# 先取消全局配置
git config --global --unset user.name  
git config --global --unset user.email

# 再为每个仓库单独设置
git config user.name "gitlab's Name"
git config user.email "gitlab@xx.com"
git config --list

```

> - git config --list查看当前配置, 在当前项目下面查看的配置是全局配置+当前项目的配置, 使用的时候会优先使用当前项目的配置
> - 在项目中如果不进行单独配置用户名和邮箱的话，则会使用全局的，正确的做法是针对公司的项目，在项目根目录下单独进行配置：

#### 使用

##### 创建版本库

```shell
mkdir git_pro1
cd git_pro1
git init
git config user.name "XX"
git config user.email "xxx@xx.com"
```

##### 添加远程仓库

```shell
git remote add [reponame] [repoaddress]
```

> 其中reponame自取，repoaddress是远程仓库的地址，例如`https://tuling56@bitbucket.org/tuling56/tutorial.git` 或者`git@github.com:tuling56/CPP.git`

可以添加多个远程仓库，在推送的时候选择要推送的仓库即可

##### 推送到远程仓库

```shell
git push [reponame] [repobranch]
```

> 其中reponame是远程仓库名，repobranch是远程仓库的分支（默认是是master）,若不指定reponame和repobranch则推送到origin仓库的master分支，即`git pust origin master`

#### 传输协议

- 本地协议
- git协议(不推荐)
- ssh协议
- http/s协议

##### ssh/https

在git中clone项目有两种方式：HTTPS和SSH，它们的区别如下：

- HTTPS

  不管是谁，拿到url随便clone，但是在push的时候需要验证用户名和密码；

- SSH

  clone的项目你必须是拥有者或者管理员，而且需要在clone前添加SSH Key。SSH 在push的时候，是不需要输入用户名的，如果配置SSH key的时候设置了密码，则需要输入密码的，否则直接是不需要输入密码的。

###### https协议

以https协议clone的项目在推送的时候还需要配置配置一个post-update挂钩，否则推送不成功

### 进阶

#### 概要

##### 3步骤

![img](http://mmbiz.qpic.cn/mmbiz_jpg/9aPYe0E1fb1el0zsnhYXiadWS9DtUkHnwzsRUe3nJiclZIHpg0Mc2EYjcdSxicXjJSJDs9bOYlNEHbwJZzibibQxKpg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1)

正常情况下，我们的工作流就是3个步骤，对应上图中的3个箭头线：

```shell
git add .
git commit -m "comment"
git push
```

1. git add .把所有文件放入暂存区；
2. git commit把所有文件从暂存区提交进本地仓库；
3. git push把所有文件从本地仓库推送进远程仓库。

##### 4个区

​	git之所以令人费解，主要是它相比于svn等等传统的版本管理工具，多引入了一个暂存区(Stage)的概念，就因为多了这一个概念，而使很多人疑惑。其实，在初学者来说，每个区具体怎么工作的，我们完全不需要关心，而只要知道有这么4个区就够了：

- 工作区(Working Area)
- 暂存区(Stage)
- 本地仓库(Local Repository)
- 远程仓库(Remote Repository)

##### 5状态

​	以上4个区，进入每一个区成功之后会产生一个状态，再加上最初始的一个状态，一共是5种状态。以下我们把这5种状态分别命名为：

- 未修改(Origin)
- 已修改(Modified)
- 已暂存(Staged)
- 已提交(Committed)
- 已推送(Pushed)

#### 撤销

git流程和状态图

![git流程图](http://mmbiz.qpic.cn/mmbiz_jpg/9aPYe0E1fb1el0zsnhYXiadWS9DtUkHnwibYnN1BRsxiaicWqEpscniaj5iaKOf1kOq3pF7XbicnrQcLObAx1u7VYCnzA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1)

| 状态            | 差异查看                          | 撤销                                       | 说明                             |
| ------------- | ----------------------------- | ---------------------------------------- | ------------------------------ |
| 已修改未add       | git diff                      | git checkout或者git reset --hard           |                                |
| 已add但没有commit | git diff --cached             | git reset 然后执行git checkout 或者直接执行git reset --hard |                                |
| 已commit但未push | git diff master origin/master | git reset --hard origin/master           | master是本地仓库，origin/master是远程仓库 |
| 已push         |                               | git reset --hard HEAD^ 然后执行git push -f   |                                |

### 高级

#### [分支](https://git-scm.com/book/zh/v1/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6)

本地有dev和master分支，远程也有dev和master分支，如何对应

##### 查看分支

查看远程分支

```shell
$git branch -a
* dev   # 标注出当前的分支所在
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/branch1
  remotes/origin/master
```

> 列出所有分支，不带remotes的是本地分支，标注*号的是当前所在的本地分支，其它的是远程分支.
>
> 备注：
>
> origin是git在clone之后自动将远程仓库命名为origin,其本身是一个别名，可以通过`git remote -v`查看，所以origin/master是远程仓库的master分支

查看本地分支

```shell
$git branch
* dev
  master
```

> 仅列出本地分支，标注*号的是当前所在的本地分支

##### 创建分支

```shell
# 创建本地test分支
git branch test

# 把test分支推送到远程test分支上（若没有则创建）
git push origin test
```

##### 切换分支

切换分支的时候要留心工作目录和暂存区，那些还没有提交的修复，将会和检出的分支产生冲突从而阻止git为你切换分支。

```shell
git checkout test
```

> 可以通过`git checkout -b test`新建test分支，并同时切换都test分支上

##### 合并分支

合并到master

```shell
#先切换到master分支，然后执行以下命令，将test分支合并到master分支上
git merge test
```

master合并到指定分支

```
# 如果主分支在子分支a之后进行了修改，想将修改后的内容合并到子分支a上，则先切换到子分a上
git merge master

# 待子分支a完成后再合并到master上
```

##### 删除分支

```shell
# 删除本地分支
git branch -d test

# 删除远程分支
git branch -r -d origin/branch-name  
```

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

####  tag

//待补充

### 问题

//待补充

## 参考

- 基础

  [看完这篇文章才算对Git有新认识](http://www.cnblogs.com/godok/p/6279177.html)

  [搭建Git服务器(廖雪峰)](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/00137583770360579bc4b458f044ce7afed3df579123eca000)

  [gitlab配置ssh-key](http://blog.csdn.net/breeze_life/article/details/45868045)

  [git查看远程仓库](http://blog.csdn.net/wanghuihui02/article/details/48155627)

- 进阶

  [git四个阶段的撤销更改](https://mp.weixin.qq.com/s/akvB2DO_1dpUrf-ol77MwQ)

- 高级

  [git post-receive钩子部署服务端代码立即重启生效](https://yq.aliyun.com/ziliao/25682)

  [http方式push失败的疑似解决方案](https://stackoverflow.com/questions/25312542/git-push-to-nginxgit-http-backend-error-cannot-access-url-http-return-code-2)

- 问题

  //待补充