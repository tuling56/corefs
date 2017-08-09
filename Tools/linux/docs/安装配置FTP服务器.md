## FTP配置

[TOC]

### 安装

#### 服务器端

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

#### 客户端

注意安装完服务器端的ftp 之后，自带的有客户端的ftp命令，但是原生的lftp客户端比较弱，故采用功能比较强大的lftp客户端。

##### 安装

```
yum install lftp
```

##### 使用

基础

```shell
#lftp的 -f选项可以直接执行文件中的ftp命令，然后退出,如下：
lftp -f lftp_conf.ini
#其中lftp_conf.ini的文件内容如下:
open ip/hostname
user username  passwd
dir

###一键登录（ftp原生客户端不支持）
lftp username:passwd@hostname:port

###分步登录
[root@local122 ftp]# lftp bxu2713660548.my3w.com
lftp bxu2713660548.my3w.com:~> user bxu2713660548
Password: 
lftp bxu2713660548@bxu2713660548.my3w.com:~>  # 此处已经登录成功
```

下载文件

```shell
get remotefile1 remotefile2 ...
# 注意不支持下载到本地的指定目录，需要先用本地的shell命令切换到要下载的目录
```

上传文件

```shell
put localfile1 localfile2 ..
# 注意不支持上传到远程的指定目录，需要先用远程shell命令切换到要上传的目录中
```

下载文件夹

```shell
mirror remotedir localdir/
# 下载后的本地目录组织是 localdir/remotedir,即remotedir是localdir的子目录
# 注意：
- remotedir可以带/，也可以不带
- localdir必须带/,否则会把remotedir里的内容下载到localdir内，而不是remotedir这个目录
```

上传文件夹

```shell
mirror -R localdir remotedir　　// 将本地目录ldir上传到远程目录rdir
```



### 应用

利用Python实现基于ftp的文件(夹)上传和下载功能，以前已经实现了一个基于sftp的文件(夹)上传和下载服务



## 参考

[Centos6.5中安装和配置vsftp教程](http://www.jb51.net/article/47795.htm)

[Centos6.5下快速搭建ftp服务器](http://www.linuxidc.com/Linux/2015-10/123848.htm)

[Ubuntu下安装和配置FTP服务器](https://linux.cn/article-8312-1.html)

[Centos生产环境部属Samba](http://www.toutiao.com/i6350479559573373442/)

[FTP命令详解（含操作实例）](http://blog.csdn.net/indexman/article/details/46387561)

[Centos启用ftp功能](http://os.51cto.com/art/201408/448630.htm)

[lftp上传和下载文件夹(主要是mirror命令)](http://www.cnblogs.com/leonyoung/archive/2012/04/17/2453804.html)

