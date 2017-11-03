## 安装配置LAMP环境

[TOC]

### 安装

#### yum安装

httpd、mysql、php

```shell
# httpd
yum install httpd

# mysql
yum install community-mysql-server community-mysql

# php
yum install php php-fpm
# 另外为了方便管理，可以安装和配置phpMyAdmin环境，yum install phpMyAdmin
```

启动

```shell
# apache配置
/etc/init.d/httpd start 或者service httpd start 或者systemctl start httpd.service
chkconfig httpd on  # 配置开机启动

# mysql配置
/etc/init.d/mysqld start
chkconfig mysqld on
# 设置MySQL root 密码:
# mysqladmin -uroot password 'abc123'

# php配置
vim /var/www/html/index.php
<?php    
	phpinfo();    
?>    
```

测试

```shell
# 输入：
http://localhost/index.php,看看是否出现相关的php和apache信息
```

#### 源码编译

##### 安装apache

```shell
wget http://mirror.bit.edu.cn/apache//httpd/httpd-2.4.29.tar.bz2
tar -jxvf httpd-2.4.29.tar.bz2
cd httpd-2.4.29
./configure --prefix=/usr/local/apache --enable-so  --enable-rewrite --enable-ssl --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-pcre=/usr/local/pcre  
```

> 编译安装的时候遇到问题，其中apr,apr-util和pcre需要单独安装或者利用系统中

```shell
# apr
wget http://archive.apache.org/dist/apr/apr-1.6.2.tar.bz2
./configure --prefix=/usr/local/apr  
make && make install 

# apr-util(注意版本不要太高)
wget http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz
 ./configure --prefix=/usr/local/apr-util -with-apr=/usr/local/apr/bin/apr-1-config  
make && make install 

# pcre
wget http://jaist.dl.sourceforge.net/project/pcre/pcre/8.38/pcre-8.38.zip
./configure --prefix=/usr/local/pcre  
make && make install 
```

##### 安装php

```shell
wget http://cn2.php.net/distributions/php-5.6.32.tar.bz2
tar -xvf php-5.6.32.tar.bz2
cd php-5.6.32
./configure --prefix=/usr/local/php -–enable-fpm --enable-mbstring --enable-zip --with-apxs2=/usr/local/apache/bin/apxs --with-mysql --with-curl --with-gd --with-zlib
```

> 中间过程可能需要安装libxml2,libxml2-devel,zlib-devel

```shell
# 查看编译安装了哪些模块
php -m
```

###### php-fpm

> nginx本身不能处理PHP，它只是个web服务器，当接收到请求后，如果是php请求，则发给php解释器处理，并把结果返回给客户端。
>
> nginx一般是把请求发fastcgi管理进程处理，fascgi管理进程选择cgi子进程处理结果并返回被nginx
>
> 本文以php-fpm为例介绍如何使nginx支持PHP
>
> 一、编译安装php-fpm
>
> **什么是PHP-FPM**
>
> PHP-FPM是一个PHP FastCGI管理器，是只用于PHP的,可以在 http://php-fpm.org/download下载得到.
>
> PHP-FPM其实是PHP源代码的一个补丁，旨在将FastCGI进程管理整合进PHP包中。必须将它patch到你的PHP源代码中，在编译安装PHP后才可以使用。

[php-fpm的安装](http://www.nginx.cn/231.html)

##### 安装mysql

```
待补充
```

> 高版本的mysql编译安装很麻烦

## 参考

[Ubuntu16.04.1搭建LAMP开发环境](http://www.toutiao.com/i6349408678034014722/)

[编译安装apache时候找不到apr问题](http://xtony.blog.51cto.com/3964396/836508/)

[LAMP整套系统编译安装](http://php.net/manual/zh/install.unix.apache2.php)

[编译apache2.4出现的问题](http://www.503e.net/archives/1212)

[编译安装](http://www.cnblogs.com/alexqdh/archive/2012/11/20/2776017.html)