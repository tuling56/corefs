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

## 参考

[gitlab配置ssh-key](http://blog.csdn.net/breeze_life/article/details/45868045)

[git查看远程仓库](http://blog.csdn.net/wanghuihui02/article/details/48155627)