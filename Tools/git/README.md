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

#### Clone项目的两种方式

在git中clone项目有两种方式：HTTPS和SSH，它们的区别如下：

- HTTPS：不管是谁，拿到url随便clone，但是在push的时候需要验证用户名和密码；
- SSH：clone的项目你必须是拥有者或者管理员，而且需要在clone前添加SSH Key。SSH 在push的时候，是不需要输入用户名的，如果配置SSH key的时候设置了密码，则需要输入密码的，否则直接是不需要输入密码的。

## 参考

[gitlab配置ssh-key](http://blog.csdn.net/breeze_life/article/details/45868045)

[git查看远程仓库](http://blog.csdn.net/wanghuihui02/article/details/48155627)