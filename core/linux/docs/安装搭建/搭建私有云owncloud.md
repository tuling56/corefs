##搭建私有云owncloud
[TOC]

### 基础

#### 安装

##### 服务器端

[官网下载服务器端安装包](https://download.owncloud.org/community/owncloud-10.0.3.zip)

```
然后解压通过web进行安装
```

##### 客户端

- PC客户端操作

  [下载PC客户端软件](https://download.owncloud.com/desktop/stable/ownCloud-2.3.3.8250-setup.exe)

- 移动端操作

  应用市场下载对应的移动端app软件，需要到google- play上下

##### 网页端

访问对应的网站即可

### 高级

### 问题

#### 修改存储目录

先修改owncloud/config/config.php

```
'datadirectory' => '/var/www/owncloud/data',
修改为：
'datadirectory' => '/tmp/ocdata/',
```

然后`chmod 777 owncloud `,即可通过web访问的方式进行文件操作

 ##参考

- 基础

- 高级

- 问题

  [修改存储目录](https://www.duoluodeyu.com/1235.html)