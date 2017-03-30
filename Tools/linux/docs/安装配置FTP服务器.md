## FTP配置

[TOC]

### 安装

安装

```shell
yum install ftp vsftpd
```

服务配置和启动

```shell
# 启动
service vsftpd start
# 开启启动
chkconfig vsftpd on
```

配置`/etc/vsftpd/vsftpd.conf`

```
待添加
```

用户控制

```
待添加
```

### 应用

利用Python实现基于ftp的文件(夹)上传和下载功能，以前已经实现了一个基于sftp的文件(夹)上传和下载服务



## 参考

[Centos6.5中安装和配置vsftp教程](http://www.jb51.net/article/47795.htm)

[Centos6.5下快速搭建ftp服务器](http://www.linuxidc.com/Linux/2015-10/123848.htm)

[Ubuntu下安装和配置FTP服务器](https://linux.cn/article-8312-1.html)

[Centos生产环境部属Samba](http://www.toutiao.com/i6350479559573373442/)

