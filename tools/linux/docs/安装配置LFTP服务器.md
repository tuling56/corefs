## FTP配置

[TOC]

### 安装

 	FTP有两种使用模式：主动(Port Mode)和被动(Passive Mode)。主动模式要求[客户端](http://baike.baidu.com/view/930.htm)和[服务器](http://baike.baidu.com/view/899.htm)端同时打开并且监听一个端口以建立连接。在这种情况下，客户端由于安装了[防火墙](http://baike.baidu.com/view/3067.htm)会产生一些问题。所以，创立了被动模式。被动模式只要求服务器端产生一个监听相应端口的进程，这样就可以绕过客户端安装了防火墙的问题。

主动模式：

> 客户端高速服务端客户端打开了一个端口等服务端进行数据连接，当服务端收到这个Port命令后，就会向那个端口进行连接

被动模式：

> 服务端会发信息给客户端服务器端打开了一个端口，让客户端去连接，客户端收到命令后就向服务端的那个端口进行连接

主动和被动模式详解：

```
主动和被动模式
     FTP有两种使用模式：主动和被动。主动模式要求客户端和服务器端同时打开并且监听一个端口以建立连接。在这种情况下，客户端由于安装了防火墙会产生一些问题。所以，创立了被动模式。被动模式只要求服务器端产生一个监听相应端口的进程，这样就可以绕过客户端安装了防火墙的问题。

一个主动模式的FTP连接建立要遵循以下步骤：
    1.客户端打开一个随机的端口（端口号大于1024，在这里，我们称它为x），同时一个FTP进程连接至服务器的21号命令端口。此时，源端口为随机端口x，在客户端，远程端口为21，在服务器。
    2.客户端开始监听端口（x+1），同时向服务器发送一个端口命令（通过服务器的21号命令端口），此命令告诉服务器客户端正在监听的端口号并且已准备好从此端口接收数据。这个端口就是我们所知的数据端口。
    3.服务器打开20号源端口并且建立和客户端数据端口的连接。此时，源端口为20，远程数据端口为（x+1）。
    4.客户端通过本地的数据端口建立一个和服务器20号端口的连接，然后向服务器发送一个应答，告诉服务器它已经建立好了一个连接。

被动模式FTP:
    为了解决服务器发起到客户的连接的问题，人们开发了一种不同的FTP连接方式。这就是所谓的被动方式，或者叫做PASV，当客户端通知服务器它处于被动模式时才启用。

    在被动方式FTP中，命令连接和数据连接都由客户端发起，这样就可以解决从服务器到客户端的数据端口的入方向连接被防火墙过滤掉的问题。

    当开启一个 FTP连接时，客户端打开两个任意的非特权本地端口（N>1024和N+1）。第一个端口连接服务器的21端口，但与主动方式的FTP不同，客户端不会提交PORT命令并允许服务器来回连它的数据端口，而是提交 PASV命令。这样做的结果是服务器会开启一个任意的非特权端口（P>1024），并发送PORT P命令给客户端。然后客户端发起从本地端口N+1到服务器的端口P的连接用来传送数据。

对于服务器端的防火墙来说，必须允许下面的通讯才能支持被动方式的FTP：
1. 从任何大于1024的端口到服务器的21端口 （客户端的初始化连接）
2. 服务器的21端口到任何大于1024的端口 （服务器响应到客户端的控制端口的连接）
3. 从任何大于1024端口到服务器的大于1024端口 （客户端初始化数据连接到服务器指定的任意端口）
4. 服务器的大于1024端口到远程的大于1024的端口（服务器发送ACK响应和数据到客户端的数据端口）
```



#### 服务器端

```shell
yum install vsftpd
```

服务

```shell
# 启动
service vsftpd start
systemctl start vsftpd.service

# 开启启动
chkconfig vsftpd on
systemctl enable vsftpd.service
```

配置

```shell
vim /etc/vsftpd/vsftpd.conf

dirmessage_enable=YES

```

[被动模式和 主动模式](http://blog.csdn.net/binsoft/article/details/44595677)配置

```shell
1.  开启被动模式的配置：
   connect_from_port_20=NO(默认为YES) #设置是否允许主动模式
   pasv_enable=YES(默认为YES) #设置是否允许被动模式
   pasv_min_port=50000(default:0(use any port))
   pasv_max_port=60000(default:0(use any port))
2.  开启主动模式的配置：
   connect_from_port_20=YES
   pasv_enable=NO
```



```shell
#启动chroot列表
chroot_list_enable=YES

#指定列表位置(所有用户将被锁定在定义的目录)
chroot_list_file=/etc/vsftpd/chroot_list

#禁止文件/etc/vsftpd/user_list文件中的用户登陆FTP
userlist_enable=yes

#添加读取用户配置目录(注:本行配置默认没有需要手动输入)
user_config_dir=/etc/vsftpd/userconf
```

用户控制

```shell
# 匿名账号访问
# #无需输入用户名和口令！ 用户名：anonymous 密码：回车或者邮箱账号)
anonymous_enable=YES #YES允许匿名访问，NO禁止匿名访问
anon_umask=073
anon_root=/var/www/html/ 
anon_mkdir_write_enable=YES   匿名用户创建文件夹 
anon_other_write_enable=YES  增加此行！  //文件夹可以重命名，可以删除文件，上传

# 本地账号
local_enable=YES
local_root=/media/ftp/pub  # 本地用户登录后的根目录 
chroot_local_user=YES  
```

权限

```shell
# 网络权限
write_enable=YES # 网络权限可写（如果本地权限也可写，则访问时可写）
```

端口

```shell
# new added by netseek
listen_port=5021                         ;命令通道端口，默认为21
listen_data_port=5020                     ;数据通道端口，默认为20

pasv_enable=YES                         ;允许被动模式
pasv_min_port=10000                     ；被动模式使用端口范围
pasv_max_port=10010

local_max_rate=200000                    ；用户宽带限制
chroot_local_user=YES                    ；禁用户离开主目录

listen_address=192.168.0.21                ；让他监听ip:192.168.0.21
```



#### 客户端

注意安装完服务器端的ftp 之后，自带的有客户端的ftp命令，但是原生的ftp客户端比较弱，故采用功能比较强大的lftp客户端。

##### ftp原生客户端

###### 安装

```shell
# 有些系统发行版自带，有的需要专门安装
yum install ftp
```

###### 使用

```shell
# 登录
$ ftp 127.0.0.1
连接到 127.0.0.1。
220 Welcome to Everything ETP/FTP
530 Not logged on.
用户(127.0.0.1:(none)): yjm
331 Password required for yjm
密码:
230 Logged on.
```

##### lftp增强客户端

###### 安装

```
yum install lftp
```

###### 使用

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

上传文件夹（尤其要注意-R选项）

```shell
mirror -R localdir remotedir　　// 将本地目录localdir上传到远程目录remotedir
# 注意
- localdir可以带/，也可以不带
- remotedir必须带/,否则会把localdir里的内容上传到remotedir目录内，而不是remotedir/localdir这个目录
```

### 应用

利用Python实现基于ftp的文件(夹)上传和下载功能，以前已经实现了一个基于sftp的文件(夹)上传和下载服务,后面全部实现



## 参考

[阿里云ecs官方配置ftp教程](https://help.aliyun.com/document_detail/51998.html)

[Centos6.5中安装和配置vsftp教程](http://www.jb51.net/article/47795.htm)

[Centos6.5下快速搭建ftp服务器](http://www.linuxidc.com/Linux/2015-10/123848.htm)

[Centos7中搭建vsftp服务器](http://www.toutiao.com/i6458983660245746190/)

[Ubuntu下安装和配置FTP服务器](https://linux.cn/article-8312-1.html)

[Centos生产环境部属Samba](http://www.toutiao.com/i6350479559573373442/)

[FTP命令详解（含操作实例）](http://blog.csdn.net/indexman/article/details/46387561)

[FTP命令大全](https://www.toutiao.com/a6482879662451065357/)

[Centos启用ftp功能](http://os.51cto.com/art/201408/448630.htm)

[lftp上传和下载文件夹(主要是mirror命令)](http://www.cnblogs.com/leonyoung/archive/2012/04/17/2453804.html)

[lftp命令大全和中文乱码问题解决（推荐）](http://blog.chinaunix.net/uid-24993824-id-470961.html)

[ftp账号和权限设置（推荐）](http://blog.51cto.com/guojiping/1007517)

