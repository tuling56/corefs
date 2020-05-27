## Git问题解答

[TOC]

### 基本使用

#### 本地搭建git服务器

在服务器上搭建：

```shell
cd /home/yjm/Documents/gitrepo
mkdir project.git
git init --bare
```

远程访问：

```shell
git clone root@127.0.0.1:/home/yjm/Documents/gitrepo/project.git
# 注意这里的用户是root用户，因为在机器上并没有建立git用户，详细的可以参考参考
```

参考：

[廖雪峰：搭建Git服务器](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/00137583770360579bc4b458f044ce7afed3df579123eca000)

### 高级使用

#### git纯版本库

```
git init --bare
```



实现的效果是在推送到版本库的时候，其指定的工作目录的内容会被更新，待验证的两件事：

1. 正常版本库的clone-->add-->push的文件在哪看



**==这种方法的坏处：==**

在生产服务器上也建立了版本管理，这样会消耗生产服务器资源，还可能带来源码泄露的问题（如在开发版本中将密码写了进去）。改进方案是是采用Git+Rsync的方式。只在开发服务器上架设gitlab进行源代码管理，同时搭建rsync客户端同步代码到生产服务器。生产服务器只使用rsync服务端监听端口结束同步请求。

**参考**

[git 纯版本库和它的工作区设置](http://www.cnblogs.com/trying/archive/2013/09/04/3301883.html)

[使用Cygwin编译Windows版本的Rsync](http://blog.csdn.net/tmt123421/article/details/52399616)

#### 版本差异对比

> 可选参数：
>
> - git diff --name-only只显示差异的文件
> - git diff --color    彩色化显示
>
> 基础版：
>
> - 查看工作树和暂存区的差别:git diff, 也就是查看工作树版本与未add的版本区别。
> - 查看暂存区与最新提交版本的差别: git diff --cached或git diff --staged。
> - 查看工作树与最近commit的版本的区别：git diff HEAD ,也就是查看工作树版本与最新提交的版本的区别。
>
> 更详细的：
>
> - git diff filename 查看尚未暂存的某个文件更新了哪些
> - git diff –cached filename 查看已经暂存起来的某个文件和上次提交的版本之间的差异
> - git diff ffd98b291e0caa6c33575c1ef465eae661ce40c9 b8e7b00c02b95b320f14b625663fdecf2d63e74c 查看某两个版本之间的差异
> - git diff ffd98b291e0caa6c33575c1ef465eae661ce40c9:filename b8e7b00c02b95b320f14b625663fdecf2d63e74c:filename 查看某两个版本的某个文件之间的差异

:last_quarter_moon:将git diff的结果在网页端展示，可以做一个在线的版本差异对比。

> 如何解析git diff的结果转换成html的结果进行展示

**参考**

[git diff命令详解](http://www.cnblogs.com/wish123/p/3963224.html)

#### 钩子

可以指定git在不同事件、不同动作下执行特定的脚本

githooks是基于事件的，当执行特定的git指令时，该软件会总从git仓库下的hooks目录下简称是否有对应的脚本，如果有，则执行至。

分为客户端的hook和服务器端的hook。

hooks列表如下：

| Hook名称             | 触发指令                             | 描述                                       | 参数的个数与描述                                 |
| ------------------ | -------------------------------- | ---------------------------------------- | ---------------------------------------- |
| applypatch-msg     | `git am`                         | 可以编辑commit时提交的message。通常用于验证或纠正补丁提交的信息以符合项目标准。 | (1) 包含预备commit信息的文件名                     |
| pre-applypatch     | `git am`                         | 虽然这个hook的名称是“打补丁前”，不过实际上的调用时机是打补丁之后、变更commit之前。如果以非0的状态退出，会导致变更成为uncommitted状态。可用于在实际进行commit之前检查代码树的状态。 | 无                                        |
| post-applypatch    | `git am`                         | 本hook的调用时机是打补丁后、commit完成提交后。因此，本hook无法用于取消进程，而主要用于通知。 | 无                                        |
| pre-commit         | `git commit`                     | 本hook的调用时机是在获取commit message之前。如果以非0的状态退出则会取消本次commit。主要用于检查commit本身（而不是message） | 无                                        |
| prepare-commit-msg | `git commit`                     | 本hook的调用时机是在接收默认commit message之后、启动commit message编辑器之前。非0的返回结果会取消本次commit。本hook可用于强制应用指定的commit message。 | 1. 包含commit message的文件名。2. commit message的源（message、template、merge、squash或commit）。3. commit的SHA-1（在现有commit上操作的情况）。 |
| commit-msg         | `git commit`                     | 可用于在message提交之后修改message的内容或打回message不合格的commit。非0的返回结果会取消本次commit。 | (1) 包含message内容的文件名。                     |
| post-commit        | `git commit`                     | 本hook在commit完成之后调用，因此无法用于打回commit。主要用于通知。 | 无                                        |
| pre-rebase         | `git rebase`                     | 在执行rebase的时候调用，可用于中断不想要的rebase。          | 1. 本次fork的上游。2. 被rebase的分支（如果rebase的是当前分支则没有此参数） |
| post-checkout      | `git checkout` 和 `git clone`     | 更新工作树后调用checkout时调用，或者执行 git clone后调用。主要用于验证环境、显示变更、配置环境。 | 1. 之前的HEAD的ref。 2. 新HEAD的ref。 3. 一个标签，表示其是一次branch checkout还是file checkout。 |
| post-merge         | `git merge` 或 `git pull`         | 合并后调用，无法用于取消合并。可用于进行权限操作等git无法执行的动作。     | (1) 一个标签，表示是否是一次标注为squash的merge。         |
| pre-push           | `git push`                       | 在往远程push之前调用。本hook除了携带参数之外，还同时给stdin输入了如下信息：” ”（每项之间有空格）。这些信息可以用来做一些检查，比如说，如果本地（local）sha1为40个零，则本次push是一个删除操作；如果远程（remote）sha1是40个零，则是一个新的分支。非0的返回结果会取消本次push。 | 1. 远程目标的名称。 2. 远程目标的位置。                  |
| pre-receive        | 远程repo进行`git-receive-pack`       | 本hook在远程repo更新刚被push的ref之前调用。非0的返回结果会中断本次进程。本hook虽然不携带参数，但是会给stdin输入如下信息：” ”。 | 无                                        |
| update             | 远程repo进行`git-receive-pack`       | 本hook在远程repo每一次ref被push的时候调用（而不是每一次push）。可以用于满足“所有的commit只能快进”这样的需求。 | 1. 被更新的ref名称。2. 老的对象名称。3. 新的对象名称。        |
| post-receive       | 远程repo进行`git-receive-pack`       | 本hook在远程repo上所有ref被更新后，push操作的时候调用。本hook不携带参数，但可以从stdin接收信息，接收格式为” ”。因为hook的调用在更新之后进行，因此无法用于终止进程。 | 无                                        |
| post-update        | 远程repo进行`git-receive-pack`       | 本hook仅在所有的ref被push之后执行一次。它与post-receive很像，但是不接收旧值与新值。主要用于通知。 | 每个被push的repo都会生成一个参数，参数内容是ref的名称         |
| pre-auto-gc        | `git gc –auto`                   | 用于在自动清理repo之前做一些检查。                      | 无                                        |
| post-rewrite       | `git commit –amend`,`git-rebase` | 本hook在git命令重写（rewrite）已经被commit的数据时调用。除了其携带的参数之外，本hook还从stdin接收信息，信息格式为” ”。 | 触发本hook的命令名称（amend或者rebase）              |

参考：

[githooks的使用](http://www.2cto.com/kf/201611/565992.html)