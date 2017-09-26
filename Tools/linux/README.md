## Linux积累

[TOC]

### 基础知识

#### 文件目录

##### 文件

文件的时间

```shell
###各类时间说明
#1、访问时间，读一次这个文件的内容，这个时间就会更新。比如对这个文件使用more命令。ls、stat命令都不会修改文件的访问时间。
#2、修改时间，对文件内容修改一次，这个时间就会更新。比如：vi后保存文件。ls -l列出的时间就是这个时间。
#3、状态改变时间。通过chmod命令更改一次文件属性，这个时间就会更新。查看文件的详细的状态、准确的修改时间等，可以通过stat命令 文件名。
```

获取文件的（修改）时间，并比较文件的新旧

```shell
src=$1
dst=$2

src_mt=`stat $src |grep ^Modify | awk '{split($3,arr,".");print $2,arr[1]}'`
dst_mt=`stat $dst |grep ^Modify | awk '{split($3,arr,".");print $2,arr[1]}'`

src_mts=`date -d"$src_mt" +%s`
dst_mts=`date -d"$dst_mt" +%s`

if [ $src_mts -gt $dst_mts ];then
{
	echo "[$src][$src_mt] > [$dst][$dst_mt]"
	rsync.exe  -avP $src $dst
}
elif [ $src_mts -lt $dst_mts ];then
{
	echo "[$dst][$dst_mt] > [$src][$src_mt]"
	rsync.exe  -avP $dst $src
}
else
{
	echo "[$dst][$dst_mt] = [$src][$src_mt]"
}
fi
```

##### 目录

一次性创建多级目录

```shell
mkdir -p ./application/{controllers,models,static,static/css,static/js,templates}
```

##### 解压缩

zip 命令（zip格式）

```shell
压缩：
    压缩文件：zip 压缩文件名 源文件
    压缩目录： zip -r 压缩文件名 源目录

解压缩
	unzip 压缩文件名（不区分文件和目录）
```

gzip命令（gz格式）

```shell
压缩
    压缩文件：
        gzip 源文件 # 压缩为.gz格式的压缩文件，源文件会消失
        gzip -c 源文件>压缩文件.gz #可以保留源文件
    压缩目录： 不支持，但可以用gzip -r 来递归压缩文件夹内的每个文件（这个指的是每个文件都会被压缩）

解压缩
    解压文件：gzip -d 压缩文件或者gunzip 压缩文件，压缩包会消失
    解压目录：gzip -d -r 压缩文件或者gunzip -r 压缩文件 压缩包会消失
```

bzip2命令（bz2格式）

```shell
压缩
    压缩文件：
        bz2 源文件 	 # 压缩为bz2格式的文件，不保留源文件
        bzip2 -k 源文件 # 压缩之后保留源文件
    压缩目录： 根本不支持
解压缩
    bzip2 -d 压缩文件 # 压缩文件会消失，-k保留压缩文件
    bunzip2 压缩文件  # -k保留压缩文件
```

tar命令和格式.tar.gz和.tar.bz2

```shell
压缩	
    压缩文件和目录（不作区分） 
        1）打包：tar -cvf 打包文件名 源文件  # tar -cvf jaw.tar  jaw
        2）压缩：zip jaw.tar.zip jaw.tar
    其便捷方式是：
    tar -zcvf 压缩文件名.tar.gz  源文件1 源文件2  #-z 压缩格式为.tar.gz格式
    tar -jcvf 压缩文件名.tar.bz2 源文件1 源文件2  #-j 压缩格式为.tar.bz2格式
    注意压缩文件名用绝对路劲指定压缩文件存放的目录

解压缩
    解压文件和目录（不作区分）
        1）解压缩 gzip -d
        2）解包： tar -xvf 打包文件名
    其便捷方式是：
    tar -zxvf 压缩文件名.tar.gz  
    tar -jxvf 压缩文件名.tar.bz2 -C "destdir"  
    注意用"-C"选择指定解压到的目录

    补充：
    只查看 tar -ztvf xx.tar.gz 只查看
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

### 技能积累

#### 日期时间

##### date

```shell
# 获得当前时间戳
date +%s 可以得到UNIX的时间戳;

#shell将时间字符串与时间戳互转：
date -d "2010-10-18 00:00:00" +%s 输出形如：1287331200

#时间戳转换为字符串可以这样做：
date -d @1287331200 "+%Y-%m-%d" 输出形如：2010-10-18
```

#### 网络

##### curl

```shell
curl -XPOST 'http://localhost:9200/indexdb/fulltext/_mapping' -d '
{                                                                 
    "fulltext": {                                                 
       "_all": {                                                  
      "analyzer": "ik"                                            
     },                                                           
     "properties": {                                              
      "content": {                                                
	"type" : "string",                                            
	"boost" : 8.0,                                                
	"term_vector" : "with_positions_offsets",                     
	"analyzer" : "ik",                                            
	"include_in_all" : true                                       
      }                                                           
    }                                                             
  }                                                               
}'                                                                

```

##### wget

需要下载某个目录下面的所有文件。命令如下

```shell
wget -c -r -np -k -L -p www.mhcf.net/test/
在下载时。有用到外部域名的图片或连接。如果需要同时下载就要用-H参数。
wget -np -nH -r –span-hosts www.mhcf.net/test/

-c 断点续传
-r 递归下载，下载指定网页某一目录下（包括子目录）的所有文件
-nd 递归下载时不创建一层一层的目录，把所有的文件下载到当前目录
-np 递归下载时不搜索上层目录，如wget -c -r www.mhcf.net/test/
没有加参数-np，就会同时下载path的上一级目录pub下的其它文件
-k 将绝对链接转为相对链接，下载整个站点后脱机浏览网页，最好加上这个参数
-L 递归时不进入其它主机，如wget -c -r www.mhcf.net/test/
```

#### 文件传输

##### rsync

rsync（remote synchronize）是一个远程数据同步工具，可通过 LAN/WAN 快速同步多台主机之间的文件。也可以使用 rsync 同步本地硬盘中的不同目录。rsync 是用于替代 rcp 的一个工具，rsync 使用所谓的 rsync算法 进行数据同步，这种算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快。

在使用 rsync 进行远程同步时，可以使用两种方式：远程 Shell 方式（建议使用 ssh，用户验证由 ssh 负责）和 C/S 方式（即客户连接远程 rsync 服务器，用户验证由 rsync 服务器负责）。

| 源地址（分为目录的方式和数据库的方式）                    | 目的地址                                     | 备注                                      |
| -------------------------------------- | ---------------------------------------- | :-------------------------------------- |
| rsync  -av -P    root1@xxx:/data/xxx*  | /data/pgv_stat/                          | shell 方式，主机名与资源之间使用单个冒号“:”作为分隔符         |
| rsync  -av -P    tw07012:data/xmp*     | data/pgv_stat/                           | shell 方式， 若本地登录用户与远程主机上的用户一致，可以省略 USER@ |
| rsync  -av -P    xmp@tw07562::pgv_stat | /data/pgv_stat/   --password-file=/etc/rsync.pass.xmp | rsync服务器的方式                             |

> 注释：如执行命令的用户名和ssh远程连接到服务器的用户名相同，则可以省略用户名

###### 命令格式

```
Rsync的命令格式可以为以下六种：
　　rsync [OPTION]... SRC DEST				（本地文件复制方式）
　　rsync [OPTION]... SRC [USER@]HOST:DEST    （ssh方式远程上传模式）
　　rsync [OPTION]... [USER@]HOST:SRC DEST    （ssh方式远程拉取模式）【远程机器到本地】
　　
　　rsync [OPTION]... [USER@]HOST::SRC DEST   （rsync服务器的方式，拷贝文件到本地）
　　rsync [OPTION]... SRC [USER@]HOST::DEST   （rysnc服务的方式，将本地文件拷贝到远程服务器）
　　rsync [OPTION]... rsync://[USER@]HOST[:PORT]/SRC [DEST]   （rysnc列远程机的文件列表，不常见）

对应于以上六种命令格式，rsync有六种不同的工作模式：
　　1)拷贝本地文件。当SRC和DES路径信息都不包含有单个冒号":"分隔符时就启动这种工作模式。
　　如：rsync -a /data /backup
　　
　　2)使用一个远程shell程序(如rsh、ssh)来实现将本地机器的内容拷贝到远程机器。当DST路径地址包含单个冒号":"分隔符时启动该模式。
　　如：rsync -avz *.c foo:src
　　
　　3)使用一个远程shell程序(如rsh、ssh)来实现将远程机器的内容拷贝到本地机器。当SRC地址路径包含单个冒号":"分隔符时启动该模式。
　　如：rsync -avz foo:src/bar /data
　　
　　4)从远程rsync服务器中拷贝文件到本地机。当SRC路径信息包含"::"分隔符时启动该模式。
　　如：rsync -av root@172.16.78.192::www /databack
　　
　　5)从本地机器拷贝文件到远程rsync服务器中。当DST路径信息包含"::"分隔符时启动该模式。
　　如：rsync -av /databack root@172.16.78.192::www
　　
　　6)列远程机的文件列表。这类似于rsync传输，不过只要在命令中省略掉本地机信息即可。
　　如：rsync -v rsync://172.16.78.192/www
```

###### 参数设置

包含和排除

```shell
## include-from和exclude-from可
#--include-from 指定目录下的部分目录的方法：
rsync  -avz -P --include-from=/home/include.txt --exclude=/* /home/mnt/data/upload/f/ 
#--exclude-from 排除目录下的部分目录的方法
rsync  -aSz  --exclude-from=/home/exclude.txt /home/mnt/ user@server1:/mnt/data

## include和exclude
```

删除

> --delete参数删除目标目录比源目录多余的文件

```shell
# 将dirA的所有文件同步到dirB内，并删除dirB内多余的文件
rsync -avz --delete  dirA/ dirB/
```

访问设置

```shell
# 在使用ssh的方式时候指定ssh的端口（https://segmentfault.com/q/1010000002405966）
rsync.exe -e 'ssh -p 122' -avP dst.txt yjm@localhost:/tmp

# 在使用ssh的是指定密钥（避免和原先用来登录用户密钥混合）（http://blog.csdn.net/fuguoq1984/article/details/32331941）
rsync -e "ssh -i /usr/rsync_id_dsa" /tmp/testfile csdn@remotehost:/tmp/ 
```

问题：

> 问题1:It is required that your private key files are NOT accessible by others.
>
> > chmod  600  id_rsa

##### Fabric、paramito、watchdog

Fabric

> Fabric是基于Python实现的ssh命令行工具，简化了ssh的应用程序部署及系统管理任务，它为系统提供了基础的操作组件，可以实现本地或远程Shell命令，包括文件上传、下载、脚本执行及完整执行日志输出等功能。

paramiko

> ssh操作库

watchdog

> 用于监控本地文件状态

基于Fabric的文件自动同步工具

![](http://p1.pstatp.com/large/31d30002e98f69b6957f)

#### 文件监控

##### inotify-tools

```shell
yum install inotify-tools
```

inotify-tools安装完成后，会生成inotifywait和inotifywatch两个指令，

- inotifywait用于等待文件或文件集上的一个特定事件，它可以监控任何文件和目录设置，并可以递归监控整个目录树。
- inotifywatch用于收集被监控的文件系统统计数据，包括每个inotify事件发生多少次等信息

#### 包管理

##### rpm

```shell
rpm -ivh
rpm -qa
# 卸载rpm包
首先通过  rpm -q <关键字> 可以查询到rpm包的名字
然后 调用 rpm -e <包的名字> 删除特定rpm包
如果遇到依赖，无法删除，使用 rpm -e --nodeps <包的名字> 不检查依赖，直接删除rpm包
如果恰好有多个包叫同样的名字，使用 rpm -e --allmatches --nodeps <包的名字> 删除所有相同名字的包， 并忽略依赖
```

### 环境配置

#### JDK环境

删除openjdk安装sun jdk

##### 查询是否安装默认jdk

```shell
java -version
```

#####  删除默认安装的openjdk

```
rpm -qa |grep jdk
```

> java-1.6.0-openjdk-javadoc-1.6.0.0-1.41.1.10.4.el6.x86_64
>
> java-1.6.0-openjdk-1.6.0.0-1.41.1.10.4.el6.x86_64
>
> java-1.6.0-openjdk-devel-1.6.0.0-1.41.1.10.4.el6.x86_64

```
rpm -e --nodeps 以上查询到的几个
```

##### 安装sun jdk

```shell
#解压: tar -xvf jdk-8u121-linux-x64.tar.gz -C /usr/local/java
# 配置环境变量: vi /etc/profile，在文件末尾加上如下配置:
export JAVA_HOME=/usr/local/java/jdk1.8.0_121
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib.tools.jar
export PATH=$JAVA_HOME/bin:$PATH
#生效配置: source /etc/profile
#验证安装是否成功: java -version
```

参考：

[Linux下安装Sun JDK（删除Open JDK）](http://www.toutiao.com/i6416458864656384514/)

### 软件使用

#### sendEmail

sendEmail是一个轻量级，命令行的SMTP邮件客户端。如果你需要使用命令行发送邮件，那么sendEmail是非常完美的选择:使用简单并且功能强大

##### 安装

```shell
wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz
tar -zxvf sendEmail-v1.56.tar.gz
chmod u+x 
mv sendEmail /usr/local/bin
```

使用

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

##### 详细参考

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

参考：

[不可或缺的sendEmail](http://blog.csdn.net/leshami/article/details/8314570)

[如何使用sendEmail发送邮件](http://www.ttlsa.com/linux/use-sendemail/)

#### ffmpeg

##### 安装

> git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

> 安装依赖项yasm:`yum install yasm`
>
> 编译安装：
>
> - ./configure –enable-shared –prefix=/usr/local/ffmpeg
>
>
> - make&make install

##### 配置

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

#### percona-xtrabackup

开源的MySQL热备份工具

> Xtrabackup是由percona开发的一个开源软件，它是innodb热备工具ibbackup（收费的商业软件）的一个开源替代品。Xtrabackup由个部分组成:xtrabackup和innobackupex，其中xtrabackup工具用于备份innodb和 xtraDB引擎的表；而innobackupex工具用于备份myisam和innodb引擎的表，本文将介绍如何用innobackupex工具做全量和增量备份。

##### 安装

```shell
yum install percona-xtrabackup
```

##### 使用

全量备份

```

```

增量备份

```shell

```

##### 参考

[innobackupex的安装和使用](http://blog.csdn.net/dbanote/article/details/13295727)



## 参考

### 基础知识

### 技能积累

#### 文件传输

[详解rsync好文（推荐）](http://blog.csdn.net/lianzg/article/details/24817087)

[使用rsync 的 --delete参数删除目标目录比源目录多余的文件](http://www.linuxidc.com/Linux/2014-03/98835.htm)

[rsync命令参数详解](http://www.jb51.net/article/34869.htm)

[使用Fabric模块编写的批量同步文件的python脚本](http://www.toutiao.com/i6449256257931969037/)

[Fabric官方参考](http://docs.fabfile.org/en/latest/index.html#usage-docs)

[基于paramiko和watchdog的文件夹自动同步工具](http://www.cnblogs.com/MikeZhang/p/autoSync20170617.html)

### 环境配置

### 软件使用

