## Git指南

### 基本使用

1. 入门

``` shell
git init --bare
```



### 高级使用

#### git纯版本库

实现的效果是在推送到版本库的时候，其指定的工作区的内容会被更新，待验证的两件事：

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

