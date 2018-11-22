## Git笔记

[TOC]

### 基础

集中式版本控制工具:CVS、SVN、VSS等，分布式版本控制工具：git、merucrial、bazarr等，选择git的原因：

- 大部分操作在本地完成，不需要联网（待有网之后一次性提交）
- 完整性保证
- 分支操作非常快捷流畅
- 与Linux命令全面兼容

#### 配置

三层配置文件:

- `/etc/gitconfig` 文件：系统中对所有用户都普遍适用的配置。若使用 `git config` 时用 `--system` 选项，读写的就是这个文件。

- `~/.gitconfig` 文件：用户目录下的配置文件只适用于该用户。若使用 `git config` 时用 `--global` 选项，读写的就是这个文件。

- 当前项目的 Git 目录中的配置文件（也就是工作目录中的 `.git/config` 文件）：这里的配置仅仅针对当前项目有效。

  ​

  每一个级别的配置都会覆盖上层的相同配置，所以 `.git/config` 里的配置会覆盖 `/etc/gitconfig` 中的同名变量。

查看配置：

```shell
#查看所有配置
git config --list

# 查看某个变量的配置
git config user.name
```

> 有时候会看到重复的变量名，那就说明它们来自不同的配置文件（比如 `/etc/gitconfig` 和 `~/.gitconfig`），不过最终 Git 实际采用的是最后一个。

配置文件样例：

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

##### 授权配置

###### ssh密钥配置

```shell
ssh-keygen -t rsa -C "xxx@gmail.com"
# 生成私钥id_rsa和公钥id_rsa.pub两个文件,将id_rsa.pub拷贝到网站上
```

为不同的环境配置不同的ssh密钥？

###### https账号配置

以https协议方式提交的时候，需要输入用户名和密码，对应的如果是登录的网站，则就是登录的网站和密码，若是nginx的https设置的账号密码，则对应输入即可。

![https访问配置](http://tuling56.site/imgbed/2018-02-12_172432.png)



//https访问如何自动添加账号和密码,待补充

##### 用户配置

查看配置

```shell
[root@yjmaliecs python]# git config --list
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
remote.origin.url=git@github.com:tuling56/Python.git
branch.master.remote=origin
branch.master.merge=refs/heads/master
```

###### 账号配置

设置Git的全局user name和email：

```shell
git config --global user.name "tuling56"  
git config --global user.email "tuling56@gmail.com"  

# 注意:用户名必须是已注册的用户名，邮箱必须为该用户绑定的邮箱地址.这个配置很重要，每次git提交时候都会引用这两条信息，说明是谁提交了更新，所以会随更新内容一起呗永久纳入历史记录。
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

###### [别名配置](http://blog.csdn.net/zhang31jian/article/details/41011313)

```
# 待补充
```

###### 其它配置

日志配置

```shell
图形化：git log --pretty=format:'%h : %s(%an-%ai)' --graph
原始格式：git log --pretty=full
定制格式：git log --pretty=format:'%h %ai : %an , %s'
git log --stat #显示每次提交（commit）中哪些文件被修改了  
```

文本编辑器

```shell
git config --global core.editor emacs
# Git 需要你输入一些额外消息的时候，会自动调用一个外部文本编辑器给你用
```

差异分析工具

```shell
git config --global merge.tool vimdiff
# 还有一个比较常用的是，在解决合并冲突时使用哪种差异分析工具。比如要改用 vimdiff 的话
```

##### 帮助

```shell
git help xxx
git xxx --help
man git-xxx
# 其中xxx是具体的命令，例如config命令
```

#### 使用

##### 基础流程

```mermaid
graph LR
A[创建本地仓库]--> B[添加远程仓库]
B-->C[推送到远程仓库]

D(克隆远程仓库)-->C
C-->D
```



###### 创建版本库

创建版本库之后会在当前目录下生成`.git`文件夹

```shell
# 说明git_pro1可以是已有的目录（空目录或者非空目录均可）
mkdir git_pro1
cd git_pro1

# 初始化仓库
git init
```

设置签名：创建之后可选择修改仓库的配置(仓库级别):

> ```shell
> git config user.name "xx"
> git config user.email "xxx@xx.com"
> ```

###### 添加远程仓库

```shell
# 查看当前所有远程仓库
get remote -v

# 添加远程仓库
git remote add [reponame] [repoaddress]

# 删除远程仓库
git remote remove reponame
```

> 其中reponame是远程仓库的别名(自取)，repoaddress是远程仓库的地址，支持http[s]/git等协议格式，例:
>
> `https://tuling56@bitbucket.org/tuling56/tutorial.git` 或者`git@github.com:tuling56/CPP.git`

可以添加多个远程仓库，在推送的时候选择要推送的仓库即可.利用此功能可以实现从一个主仓库中拉取东西，然后同步到另一个仓库中去

###### 推送到远程仓库

```shell
git push [reponame] [repobranch]

#例如推送到origin仓库的dev分支上
git push origin dev
```

> - 其中reponame是远程仓库名，repobranch是远程仓库的分支（默认是master）,若不指定reponame和repobranch则推送到origin仓库的master分支，即`git push origin master`

若推送的远程仓库是https协议的，在推送的时候可能会弹出登录框，输入账号和密码，即可。

##### 命令解释

######  clone

克隆仓库，可以在clone时候指定分支，若不指定，默认克隆master分支

```shell
git clone -b 仓库地址  [本地仓库名]
```

###### commit

```powershell
git commit -m "xxxx"
```

###### fetch

```shell
fetch的操作本质是更新repo所指定的远程
```

###### merge

```shell

```

###### pull

pull=fetch+merge

pull指定远程仓库

```shell
# 默认仓库是origin
git pull 远程仓库名 远程分支:本地分支
```

> 如遇到问题，可以添加`--rebase`参数

###### checkout

将远程git仓库的指定分支拉取到本地

```shell
git checkout -b 本地分支名 origin/远程分支名
#例如：
git checkout -b branch1 origin/branch1
#Branch branch1 set up to track remote branch branch1 from origin.
#Switched to a new branch 'branch1'
```

> - 这个自动会创建新的本地分支branch1,并与指定的远程分支关联起来，本地并自动切换到branch1分支上，若报错，则先执行`git fetch`，然后再执行。
>
> - 经过关联之后的分支，再次执行`git push`的时候会自动推送到远程的对应分支上
>
>   ![本地分支关联远程分支](http://tuling56.site/imgbed/2018-02-12_172745.png)

###### push

```shell
git push 远程仓库名 远程仓库分支
```

##### 参数解释

//待补充

#### 传输协议

协议一览：

- 本地协议(不常用)
- git协议(不推荐)
- ssh协议
- http[s]协议

综述：在git中clone项目有两种方式：HTTPS和SSH，它们的区别如下：

- HTTPS

  不管是谁，拿到url随便clone，但是在push的时候需要验证用户名和密码；

- SSH

  clone的项目你必须是拥有者或者管理员，而且需要在clone前添加SSH Key。SSH 在push的时候，是不需要输入用户名的，如果配置SSH key的时候设置了密码，则需要输入密码的，否则直接是不需要输入密码的。

##### https协议

以https协议clone的项目在推送的时候还需要配置配置一个post-update挂钩，否则推送不成功

##### ssh协议

ssh协议

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

1. git add .       把所有文件放入暂存区；
2. git commit  把所有文件从暂存区提交进本地仓库；
3. git push       把所有文件从本地仓库推送进远程仓库。

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

查看状态

```shell
git status
# 查看的是工作区和暂存区的状态，另外一个相似的命令是查看提交的历史
git log --pretty=online
git reflog
```



#### 贮藏

贮藏可以获取工作目录中的中间状态，

#### 回退

git流程和状态图

![git流程图](http://mmbiz.qpic.cn/mmbiz_jpg/9aPYe0E1fb1el0zsnhYXiadWS9DtUkHnwibYnN1BRsxiaicWqEpscniaj5iaKOf1kOq3pF7XbicnrQcLObAx1u7VYCnzA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1)

| 状态            | 差异查看                          | 撤销                                       | 说明                             |
| ------------- | ----------------------------- | ---------------------------------------- | ------------------------------ |
| 已修改未add       | git diff                      | git checkout或者git reset --hard           |                                |
| 已add但没有commit | git diff --cached             | git reset 然后执行git checkout 或者直接执行git reset --hard |                                |
| 已commit但未push | git diff master origin/master | git reset --hard origin/master           | master是本地仓库，origin/master是远程仓库 |
| 已push         |                               | git reset --hard HEAD^ 然后执行git push -f   |                                |

##### 修改commit

//待补充

#### 忽略

.gitignore文件的配置

参考`mdotfiles/git/gitignore`仓库，把该文件放在仓库的根目录里，内容格式如下：

```shell
cat .gitignore
.gitignore   # 注意一定要在.gitignore文件中把自身包含进去
/bin/common/global_var.sh
/data
*.log
*.data
*.sht
```

#### 对比

对比本地工作区和远程仓库的差异

```shell
git fetch origin
#然后可以比对
git diff 本地分支 origin/xxxx
```

#### 冲突

##### 冲突情景

1. 在A分支上修改了文件f1的内容，并提交到了本地的A分支上；
2. 在B分支上也修改了文件f1的内容，并提交到本地的B分支桑；
3. 要把B分支合并到A分支上，冲突在文件f1上产生

[冲突解决](https://www.imooc.com/article/35753)：

1. 提示冲突后，手动编辑冲突文件，保存退出，然后git add 冲突文件
2. git commit -m "解决冲突"(注意commit的实验一定不要带具体的文件名)



### 高级

#### 工作区

##### 基本

```shell
# 查看工作区
git status
```

#### [分支](https://git-scm.com/book/zh/v1/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6)

![分支原理](https://img2.mukewang.com/5b2883210001ae8405540207.jpg)

分支可以同时推进多个功能开发，提高效率，分支之间不会影响，失败的分组删除重新开始即可。

##### 查看分支

查看分支

```shell
# 查看本地分支
git branch -v

# 查看所有分支
git branch -a
* dev   # 星号标注出当前的分支所在
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
$git branch -v
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

切换分支前要留心工作区和暂存区，那些还没有提交的修复，将会和检出的分支产生冲突从而阻止git为你切换分支。

```shell
git checkout test
```

> 可以通过`git checkout -b test`新建test分支，并同时切换都test分支上

##### 合并分支

分支的合并的主要步骤如下：

```shell
# 1. 先切换到准备合并到的分支上
git checkout [准备合并到的分支]
# 2. 合并要合并的分支到本分支上
git merge [待合并的分支]
```

合并到master

```shell
#先切换到master分支，然后执行以下命令，将test分支合并到master分支上
git checkout master
git merge test  # 合并分支的时候总是加上--no-ff，即git merge --no-ff test
```

master合并到指定分支

```shell
# 如果主分支在子分支a之后进行了修改，想将修改后的内容合并到子分支a上，则先切换到子分a上
git merge master

# 待子分支a完成后再合并到master上
```

> 在合并分支的时候总是先切换到要合并到的分支上，然后将需要合并的分支合并过来

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

####  Tag

给历史中的某一个提交打上标签，比如用来标记发布节点

##### 列出标签

```shell
#列出所有标签
git tag

#列表指定系列的标签
git tag -l 'v1.85*'
```

##### 创建标签

两种标签类型：轻量标签和附注标签

###### 附注标签

```shell
git tag -a v1.4 -m "my version1.4"
```

> `-m` 选项指定了一条将会存储在标签中的信息。 如果没有为附注标签指定一条信息，Git 会运行编辑器要求你输入信息。通过使用 `git show` 命令可以看到<u>标签信息</u>与对应的<u>提交信息</u>
>
> ```shell
> git show v1.4
> ```

###### 轻量标签

轻量标签只是将提交检验和存储到一个文件中，没有保存任何其它信息

```shell
git tag v1.4
```

> `git show`不会看到额外的标签信息，只会显示出提交信息
>
> ```shell
> git show v1.4
> ```

###### 后期打标签

对过去的提交打标签

```shell
#　查看过去的提交
git log --pretty=oneline

# 为过去的某个提交打标签
git tag -a v1.4 xxxxx(校验和)
```

> `git show`查看打的标签
>
> ```shell
> git show v1.4
> ```

### 积累

#### 仓库

//待补充

### 应用

#### 协同开发

协同开发需要远程仓库上进行设置（以github为例），添加协同人员的github账号地址，待协同人员接受邀请后，就可以进行协同开发了。

![协同开发](https://img2.mukewang.com/5b2882f80001b18708620425.jpg)

#### 托管中心

github，码云，gitlab等

### 问题

#### 仓库

##### 裸仓库和非裸仓库

###### 裸仓库

可以之间作为服务器仓库供开发push和pull,实现数据文件共享和同步，不保存文件，至保存历史提交的版本信息

###### 非裸仓库

向非裸仓库push会报错，需要在.git文件夹的config文件后加

```shell
[receive]
denyCurrentBranch = ignore
```

才能提交数据，非裸仓库使用git reset --hard命令可以看到提交文件，否则推送到裸仓库的问题

```shell
remote: error: refusing to update checked out branch: refs/heads/master
remote: error: By default, updating the current branch in a non-bare repository
remote: error: is denied, because it will make the index and work tree inconsistent
remote: error: with what you pushed, and will require 'git reset --hard' to match
remote: error: the work tree to HEAD.
remote: error:
remote: error: You can set 'receive.denyCurrentBranch' configuration variable to
remote: error: 'ignore' or 'warn' in the remote repository to allow pushing into
remote: error: its current branch; however, this is not recommended unless you
remote: error: arranged to update its work tree to match what you pushed in some
remote: error: other way.
remote: error:
remote: error: To squelch this message and still keep the default behaviour, set
remote: error: 'receive.denyCurrentBranch' configuration variable to 'refuse'.
```

#### 其它

Rebase和Merge的区别

```shell
#待补充
```

## 参考

- **基础**

  [Git入门参考手册(推荐)](https://git-scm.com/book/zh/v1/%E8%B5%B7%E6%AD%A5-%E5%88%9D%E6%AC%A1%E8%BF%90%E8%A1%8C-Git-%E5%89%8D%E7%9A%84%E9%85%8D%E7%BD%AE)

  [Git使用规范流程（阮一峰）](http://www.ruanyifeng.com/blog/2015/08/git-use-process.html)

  [看完这篇文章才算对Git有新认识](http://www.cnblogs.com/godok/p/6279177.html)

  [搭建Git服务器(廖雪峰)](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/00137583770360579bc4b458f044ce7afed3df579123eca000)

  [gitlab配置ssh-key](http://blog.csdn.net/breeze_life/article/details/45868045)

  [git查看远程仓库](http://blog.csdn.net/wanghuihui02/article/details/48155627)

  [13条git命令，满足你的工作需求（推荐）](https://www.imooc.com/article/12473)

- **进阶**

  [git四个阶段的撤销更改](https://mp.weixin.qq.com/s/akvB2DO_1dpUrf-ol77MwQ)

  [修改已提交的内容](https://blog.csdn.net/sodaslay/article/details/72948722)

  [修改commit的内容](https://blog.csdn.net/dong19900415/article/details/70495716)

  [修改git commit信息中的author](https://blog.csdn.net/liang890806/article/details/46813039)

- **高级**

  [git post-receive钩子部署服务端代码立即重启生效](https://yq.aliyun.com/ziliao/25682)

  [http方式push失败的疑似解决方案](https://stackoverflow.com/questions/25312542/git-push-to-nginxgit-http-backend-error-cannot-access-url-http-return-code-2)

  [在sourcetree中使用gitflow](https://www.jianshu.com/p/8a3988057d0f)

- **问题**

  //待补充

