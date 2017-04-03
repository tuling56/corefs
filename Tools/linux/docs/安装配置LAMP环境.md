## 安装配置LAMP环境

[TOC]

### 安装

httpd、mysql、php

```shell
# httpd:
yum install httpd

# mysql
yum install community-mysql-server community-mysql

# php
yum install php
# 另外为了方便管理，可以安装和配置phpMyAdmin环境，yum install phpMyAdmin
```

启动

```shell
# apache配置
/etc/init.d/httpd start 或者service httpd start 或者systemctl start  httpd.service
chkconfig httpd on  # 配置开机启动

# mysql配置
/etc/init.d/mysqld start
chkconfig mysqld on
# 设置MySQL root 密码:
# mysqladmin -uroot password 'abc123'

# php配置
vim /var/www/html/index.php
> <?php    
> phpinfo();    
> ?>    
```

测试

```shell
# 输入：
http://localhost/index.php,看看是否出现相关的php和apache信息
```



## 参考

[Ubuntu16.04.1搭建LAMP开发环境](http://www.toutiao.com/i6349408678034014722/)