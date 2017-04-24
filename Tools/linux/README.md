## Linux积累

[TOC]

### 基础知识

----

#### 文件目录

一次性创建多级目录

```shell
mkdir -p ./application/{controllers,models,static,static/css,static/js,templates}
```



#### 系统启动

#### 定时任务

##### crontab配置

在计算机正常的情况下，才执行

```

```

在crontab中使用命令和变量牵涉到%的时候要用“\”转义

```
00 01 * * * mysqldump -u root --password=passwd-d mustang > /tmp/mustang_$(date +\%Y\%m\%d_\%H\%M\%S).sql
```

##### anacron配置

处理服务器开关机问题,在该执行的时候因为故障没有执行，在服务器正常的时候，重新执行

```

```

参考

[Linux crontab定时任务管理](http://www.imooc.com/video/10979)

#### 参考

-  [linux系统的7种运行级别](http://blog.chinaunix.net/uid-22746363-id-383989.html) 

### 系统监控

----

#### glances

glances支持web访问，数据格式的导出是csv和==html==，方便和其它的应用做交互

> glances依赖psutil,bottle,jinja

#### nmon

独特的数据格式，只能在excel里自动绘图和查看

####   参考

- [系统监控glances以及其中用到的python](http://www.toutiao.com/a6358639873155219714/)
- [glances官方手册](https://github.com/nicolargo/glances)
- [监控Linux系统性能的工具--nmon](http://www.toutiao.com/a6357668867875668226/)


### 软件使用

---

#### rsync	   								

| 源地址（分为目录的方式和数据库的方式）                      | 目的地址                                     | 备注     |
| ---------------------------------------- | ---------------------------------------- | ------ |
| rsync  -av -P    root1@tw07012.sandai.net:/data/mysql/data/pgv_stat/* | /usr/local/mysql/data/pgv_stat/          | 目录的方式  |
| rsync  -av -P    tw07012.sandai.net:/data/mysql/data/pgv_stat/xmp* | /usr/local/mysql5/data/pgv_stat/         |        |
| rsync  -av -P    xmp@tw07562.sandai.net::pgv_stat_yingyin | /usr/local/mysql5_new/data/pgv_stat_yingyin/   --password-file=/etc/rsync.pass.xmp | 数据库的方式 |

> 注释：如执行命令的用户名和ssh远程连接到服务器的用户名相同，则可以省略用户名

用例详解

```
Rsync的命令格式可以为以下六种：
　　rsync [OPTION]... SRC DEST
　　rsync [OPTION]... SRC [USER@]HOST:DEST    （ssh方式远程上传模式）
　　rsync [OPTION]... [USER@]HOST:SRC DEST    （ssh方式远程拉取模式）【远程机器到本地】
　　rsync [OPTION]... [USER@]HOST::SRC DEST   （rsync服务器的方式，拷贝文件到本地）
　　rsync [OPTION]... SRC [USER@]HOST::DEST   （rysnc服务的方式，将本地文件拷贝到远程服务器）
　　rsync [OPTION]... rsync://[USER@]HOST[:PORT]/SRC [DEST]   （rysnc列远程机的文件列表，不常见）

对应于以上六种命令格式，rsync有六种不同的工作模式：
　　1)拷贝本地文件。当SRC和DES路径信息都不包含有单个冒号":"分隔符时就启动这种工作模式。如：rsync -a /data /backup
　　2)使用一个远程shell程序(如rsh、ssh)来实现将本地机器的内容拷贝到远程机器。当DST路径地址包含单个冒号":"分隔符时启动该模式。如：rsync -avz *.c foo:src
　　3)使用一个远程shell程序(如rsh、ssh)来实现将远程机器的内容拷贝到本地机器。当SRC地址路径包含单个冒号":"分隔符时启动该模式。如：rsync -avz foo:src/bar /data
　　4)从远程rsync服务器中拷贝文件到本地机。当SRC路径信息包含"::"分隔符时启动该模式。如：rsync -av root@172.16.78.192::www /databack
　　5)从本地机器拷贝文件到远程rsync服务器中。当DST路径信息包含"::"分隔符时启动该模式。如：rsync -av /databack root@172.16.78.192::www
　　6)列远程机的文件列表。这类似于rsync传输，不过只要在命令中省略掉本地机信息即可。如：rsync -v rsync://172.16.78.192/www
```

参考：

[使用rsync 的 --delete参数删除目标目录比源目录多余的文件](http://www.linuxidc.com/Linux/2014-03/98835.htm)

[rsync命令参数详解](http://www.jb51.net/article/34869.htm)

#### sendEmail

```shell
perl sendEmail -s mail.cc.sandai.net -f monitor@cc.sandai.net -xu monitor@cc.sandai.net -xp 121212 -t yuanjunmiao@cc.sandai.net -u "email title" -m "email body info"  -a "attachment files"

LOG="/tmp/clean.log"
-o message-file="${LOG}"
```

说明：

1. perl脚本写的程序，各选项的意义如下

   ```
   -f  发送者
   -s  发送者smtp服务器地址
   -xu 发送服务器的用户名
   -xp 发送服务器的用户密码
   -t  接收用户
   -u  邮件标题
   -m  邮件内容
   -o
       message-file=FILE    将文件内容作为邮件内容进行发送
   	message-charset=utf8 设置邮件编码
   -a  附件
   ```

2. 多个收件人

```
MAIL_TO="zhangweibing@cc.sandai.net luochuan@cc.sandai.net 
-t ${MAIL_TO}
```

一个实验例子：

```shell
perl sendEmail -s smtp.xxx.com -f xxxx@hostname1 -xu uname@serverhost -xp 111111 -t xxxx@hostname2 -u "email title" -o message-charset=utf8  -m "email body info"  -a "attachment files"
```

**详细参考手册**

Synopsis:  sendEmail -f ADDRESS [options]

  Required:
    -f ADDRESS                from (sender) email address
    * At least one recipient required via -t, -cc, or -bcc
    * Message body required via -m, STDIN, or -o message-file=FILE

  Common:
    -t ADDRESS [ADDR ...]     to email address(es)
    -u SUBJECT                message subject
    -m MESSAGE                message body
    -s SERVER[:PORT]          smtp mail relay, default is localhost:25

  Optional:
    -a   FILE [FILE ...]      file attachment(s)
    -cc  ADDRESS [ADDR ...]   cc  email address(es)
    -bcc ADDRESS [ADDR ...]   bcc email address(es)
    -xu  USERNAME             username for SMTP authentication
    -xp  PASSWORD             password for SMTP authentication

  Paranormal:
    -b BINDADDR[:PORT]        local host bind address
    -l LOGFILE                log to the specified file
    -v                        verbosity, use multiple times for greater effect
    -q                        be quiet (i.e. no STDOUT output)
    -o NAME=VALUE             advanced options, for details try: --help misc
        -o message-content-type=<auto|text|html>
        -o message-file=FILE         -o message-format=raw
        -o message-header=HEADER     -o message-charset=CHARSET
        -o reply-to=ADDRESS          -o timeout=SECONDS
        -o username=USERNAME         -o password=PASSWORD
        -o tls=<auto|yes|no>         -o fqdn=FQDN


  Help:
    --help                    the helpful overview you're reading now
    --help addressing         explain addressing and related options
    --help message            explain message body input and related options
    --help networking         explain -s, -b, etc
    --help output             explain logging and other output options
    --help misc               explain -o options, TLS, SMTP auth, and more

### 软件安装

----

#### rpm

```shell
rpm -ivh
rpm -qa
# 卸载rpm包
首先通过  rpm -q <关键字> 可以查询到rpm包的名字
然后 调用 rpm -e <包的名字> 删除特定rpm包
如果遇到依赖，无法删除，使用 rpm -e --nodeps <包的名字> 不检查依赖，直接删除rpm包
如果恰好有多个包叫同样的名字，使用 rpm -e --allmatches --nodeps <包的名字> 删除所有相同名字的包， 并忽略依赖
```

#### ffmpeg

**下载**

> git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

**安装**

> 安装依赖项yasm:`yum install yasm`
>
> 编译安装：
>
> - ./configure –enable-shared –prefix=/usr/local/ffmpeg
>
>
> - make&make install

**配置**

> 使用：
>
> > 将ffmpeg工具添加到环境变量中去
> >
> > sudo vim ~/.bashrc,末尾添加：export PATH=/usr/local/ffmpeg/bin
>
> 开发
>
> > 添加库：
> >
> > vim /etc/ld.so.conf，末尾添加/usr/local/ffmpeg/lib
> >
> > ldconfig 更新

**测试**

> ffmpeg --help
>
> ffmpeg -version查看版本信息，如下：
>
> [root@local122 ld.so.conf.d]# ffmpeg -version
> ffmpeg version N-82301-g1bbb18f Copyright (c) 2000-2016 the FFmpeg developers
> built with gcc 5.3.1 (GCC) 20160406 (Red Hat 5.3.1-6)
> configuration: --enable-shared --prefix=/usr/local/ffmpeg
> libavutil      55. 35.100 / 55. 35.100
> libavcodec     57. 66.101 / 57. 66.101
> libavformat    57. 57.100 / 57. 57.100
> libavdevice    57.  2.100 / 57.  2.100
> libavfilter     6. 66.100 /  6. 66.100
> libswscale      4.  3.100 /  4.  3.100
> libswresample   2.  4.100 /  2.  4.100

**参考**

[linux下安装编译ffmpeg](http://www.toutiao.com/a6348252505277841666/)

#### PostgreSQL

##### 安装

```shell
yum install postgresql-contrib  postgresql postgresql-server
# 该命令会安装以下的包
postgresql        	# PostgreSQL client programs 
postgresql-contrib  # Extension modules distributed with PostgreSQL
postgresql-libs     # The shared libraries required for any PostgreSQL clients 
postgresql-server   # The programs needed to create and run a PostgreSQL server
uuid             	# 用途未知  

```

初始化

```shell
# step1:初始化数据库
/usr/bin/initdb -D /home/yjm/xxx  # 该命令会创建数据库，并完成一系列的配置

# step2:启动数据库
# Success. You can now start the database server using:
    postgres -D /home/yjm/xxx
#or
	pg_ctl -D /home/yjm/xxx -l logfile start
```

##### 参考

[Centos上安装和配置PostgreSQL](http://www.linuxidc.com/Linux/2016-09/135538.htm)