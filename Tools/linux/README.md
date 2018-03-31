## Linux积累

[TOC]

### 基础知识

#### 账号权限

##### [用户](https://www.cnblogs.com/xd502djj/archive/2011/11/23/2260094.html)

修改root密码

```
登录root账号，sudo passwd root或者之间passwd，重复输入两次密码即可
```

添加用户

```shell
# 添加用户ftpuser，指定目录为/opt/ftp,所属组为ftpgroup
useradd -g ftpgroup -d /opt/ftp -M ftpuser 
# 修改ftpuser的密码passwd ftpuser   

# 添加组
groupadd test   

```



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

##### 开机启动

`chkconfig`和`systemctl enable`

以mysql为例:

```shell
# step1:将服务文件拷贝到init.d下，并重命名为mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql   

# step2:赋予可执行权限
chmod +x /etc/init.d/mysql    

# step3:添加服务
chkconfig --add mysql        

# step4:显示服务列表
chkconfig --list 
# 如果看到345都是on的话，则成功，否则执行
chkconfig --level 345 mysql on
```

#### 定时任务

##### crontab

在计算机正常的情况下，才执行，参数列表如下:

```shell
-u user：用来设定某个用户的crontab服务，例如，“-u ixdba”表示设定ixdba用户的crontab服务，此参数一般有root用户来运行。

file：file是命令文件的名字,表示将file做为crontab的任务列表文件并载入crontab。如果在命令行中没有指定这个文件，crontab命令将接受标准输入（键盘）上键入的命令，并将它们载入crontab。

-e：编辑某个用户的crontab文件内容。如果不指定用户，则表示编辑当前用户的crontab文件。

-l：显示某个用户的crontab文件内容，如果不指定用户，则表示显示当前用户的crontab文件内容。

-r：从/var/spool/cron目录中删除某个用户的crontab文件，如果不指定用户，则默认删除当前用户的crontab文件。

-i：在删除用户的crontab文件时给确认提示。
```

在crontab中使用命令和变量牵涉到%的时候要用“\”转义

```
00 01 * * * mysqldump -u root --password=passwd-d mustang > /tmp/mustang_$(date +\%Y\%m\%d_\%H\%M\%S).sql
```

##### anacron

处理服务器开关机问题,在该执行的时候因为故障没有执行，在服务器正常的时候，重新执行

```

```

#### 其它

##### 防火墙

###### iptables

命令

```shell
# 查看iptables状态
service iptables status

# 开启/关闭/重启
service iptables start/stop/restart
```

配置文件

```shell
vim /etc/sysconfig/iptables-config
vim /etc/sysconfig/iptables
```

##### 内核升级

此处的升级方法仅限于centos派的yum/rpm,64bit。另外可参考自[编译内核](https://blog.janfou.com/technical-documents/10485.html)

安装

```shell
# 查看当前内核
uname -r

# step1:导入key
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

# step2:升级至当前最稳定内核
yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm  #添加源
yum --enablerepo=elrepo-kernel install -y kernel-ml  #安装当前最新内核，以后升级内核直接运行这句就可

# step3：升级指定内核
# 到这个网址选择内核版本http://elrepo.reloumirrors.net/kernel/el7/x86_64/RPMS/，然后使用
yum install -y  http://elrepo.reloumirrors.net/kernel/el7/x86_64/RPMS/kernel-lt-4.4.101-1.el7.elrepo.x86_64.rpm

# 补充：在centos6上使用以下的命令成功升级内核
yum install -y  http://elrepo.reloumirrors.net/kernel/el6/x86_64/RPMS/kernel-lt-4.4.101-1.el6.elrepo.x86_64.rpm
```

> 另一种方法是：
>
> ```shell
> yum -y install kernel
> 然后使用reboot重启系统
> ```

配置

```shell
vim /etc/grub.conf
# 修改Grub引导顺序,般新安装的内核在第一个位置，所以设置default=0，表示启动新内核

 grub2-mkconfig -o /boot/grub2/grub.cfg   # 重新编译内核启动文件，以后升级完内核也要执行一次
```

删除旧内核

```shell
rpm -qa | grep kernel
yum autoremove kernel-3.10.0-327.13.1.el7.x86_64
```

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

[curl指定用户名和密码](http://www.bubuko.com/infodetail-2309629.html)

```shell
curl -u yjm:123 http://localhost:8066/?search=%E5%BC%A0
```

##### wget

需要下载某个目录下面的所有文件，命令如下

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

###### 应用

检测网址是否有效

```shell
#!/bin/bash  
#no.1  
if [ "$#" -ne 1 ]  
  then  
      echo "/root/sh/ $0" 请您输入一个网址  
      exit 1  
fi  
#no.2  
wget --spider -q -o /dev/null --tries=1 -T 3 $1  
if [ "$?" -eq 0 ]  
  then  
    echo "$1 检测是成功的！"  
  else  
    echo "$1 检测是失败的！"  
    exit 1  
fi  
```



#####  axel

```

```

#### 文件传输

##### rsync

​	rsync（remote synchronize）是一个远程数据同步工具，可通过 LAN/WAN 快速同步多台主机之间的文件。也可以使用 rsync 同步本地硬盘中的不同目录。rsync 是用于替代 rcp 的一个工具，rsync 使用所谓的 rsync算法进行数据同步，这种算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快。

在使用 rsync 进行远程同步时，可以使用两种方式：

- 远程 Shell 方式（建议使用 ssh，用户验证由 ssh 负责）
- C/S 方式（即客户连接远程 rsync 服务器，用户验证由 rsync 服务器负责）

在C/S方式下Server端会开一个873端口，当有连接过来时，会进行口令检查

###### 传输方式

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

###### 应用情景

**包含和排除**

- include-from和exclude-from

```shell
#--include-from 指定目录下的部分目录的方法：
rsync  -avz -P --include-from=/home/include.txt --exclude=/*   /home/mnt /data/upload/f/ 

#--exclude-from 排除目录下的部分目录的方法
rsync  -aSz  --exclude-from=/home/exclude.txt 	/home/mnt/ 	 ser@server1:/mnt/data
```

- include和exclude

```shell
# --exclude/--include=PATTERN	指定排除/包含传输的文件匹配模式
```

- 附录(适用于[include-from和include之后pattern规则](https://stackoverflow.com/questions/19296190/rsync-include-from-vs-exclude-from-what-is-the-actual-difference))

> PATTERN 的书写规则如下：
>
> - 以 / 开头：匹配被传输的跟路径上的文件或目录
> - 以 / 结尾：匹配目录而非普通文件、链接文件或设备文件
> - 使用通配符
>   - *：匹配非空目录或文件（遇到 / 截止）
>   - **：匹配任何路径（包含 / ）
>   - ?：匹配除了 / 的任意单个字符
>   - [：匹配字符集中的任意一个字符，如 [a-z] 或 [[:alpha:]]
>   - 可以使用转义字符 \ 将上述通配符还原为字符本身含义

例子

```shell
#同步指定类型的文件(单文件夹下，不嵌套目录)
rsync.exe -u -avP --include="bash.bashrc" --include="vimrc" --exclude="*" "$local_conf" "$remote_conf"

#同步指定类型的文件(嵌套目录)
rsync.exe -u -avP --include="*/" --include="bash.bashrc" --include="vimrc" --exclude="*" "$local_conf" "$remote_conf"
```

**删除**

> --delete参数删除目标目录比源目录多余的文件

```shell
# 将dirA的所有文件同步到dirB内，并删除dirB内多余的文件
rsync -avz --delete  dirA/ dirB/
```

**访问设置**

```shell
# 在使用ssh的方式时候指定ssh的端口（https://segmentfault.com/q/1010000002405966）
rsync.exe -e 'ssh -p 122' -avP dst.txt yjm@localhost:/tmp

# 在使用ssh的是指定密钥（避免和原先用来登录用户密钥混合）（http://blog.csdn.net/fuguoq1984/article/details/32331941）
rsync.exe -e "ssh -i /usr/rsync_id_dsa" /tmp/testfile csdn@remotehost:/tmp/ 
```

问题：

> 问题1:It is required that your private key files are NOT accessible by others.
>
> > chmod  600  id_rsa

##### scp/sftp/ssh

Fabric、paramito和watchdog的组合方案

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

##### watchdog

//看门狗模块

#### 包管理

##### rpm

安装

```shell
rpm -ivh
rpm -qa
```

查看

```
rpm -ql 包名
```

卸载

```shell
# 卸载rpm包
首先通过  rpm -q <关键字> 可以查询到rpm包的名字
然后 调用 rpm -e <包的名字> 删除特定rpm包
如果遇到依赖，无法删除，使用 rpm -e --nodeps <包的名字> 不检查依赖，直接删除rpm包
如果恰好有多个包叫同样的名字，使用 rpm -e --allmatches --nodeps <包的名字> 删除所有相同名字的包， 并忽略依赖
```

##### yum

yum源的本质是什么？

查看所有已安装的yum源

```shell
yum repolist enabled
```

#### 邮件发送

##### sendEmail

sendEmail是一个轻量级，命令行的SMTP邮件客户端。其本身是一个perl脚本编写的可执行文件，如果你需要使用命令行发送邮件，那么sendEmail是非常完美的选择:使用简单并且功能强大

###### 安装

```shell
wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz
tar -zxvf sendEmail-v1.56.tar.gz
chmod u+x 
mv sendEmail /usr/local/bin
```

使用范例：

```shell
perl sendEmail 
	-s smtp.xxx.com 
	-f xxxx@hostname1 
	-xu uname@serverhost 
	-xp 111111 
	-t xxxx@hostname2 
	-o message-charset=utf8
	-u "email title" 
	-m "email body info"  
	-a "attachment files"

# 可以将文件内容作为邮件内容进行发送
LOG="/tmp/clean.log"
-o message-file="${LOG}"
```

说明：

1. perl脚本写的程序，各选项的意义如下

```shell
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

1. 多个收件人

```shell
MAIL_TO="zhangweibing@cc.sandai.net luochuan@cc.sandai.net 
-t ${MAIL_TO}
```

2. 在邮件中发送中文：

```shell
SENDMAIL="/usr/local/monitor-base/bin/sendEmail -s mail.cc.sandai.net -f monitor@cc.sandai.net -xu monitor@cc.sandai.net -xp 121212 -o message-charset=utf8 "

logw=$datapath/skewtrend_check_$date
logu="源数据量下降和不均衡报警 [$date from $(hostname)]"
logucn=$(echo $logu | iconv -f utf-8 -t GBK)
MAIL_TO="yuanjunmiao@cc.sandai.net luochuan@cc.sandai.net"
if [ -s $logw ];then
   logm="`cat $logw`"
   logm="$logm\n\n请前往哈勃数据中心源量统计查看:http://tongji.xunlei.com/auto_plain?reportId=104352&elmId=209527&productId=-111018"
   logmcn=$(echo "$logm"| iconv -f utf-8 -t GBK)
   ${SENDMAIL} -t ${MAIL_TO} -u "$logucn" -m "$logmcn" -a "$logw"
else
   cd $datapath && rm -f skewtrend_check_$date
fi
```

###### 详细参考

Synopsis:  sendEmail -f ADDRESS [options]

  Required:

```
-f ADDRESS                from (sender) email address
* At least one recipient required via -t, -cc, or -bcc
* Message body required via -m, STDIN, or -o message-file=FILE
```

  Common:

```
-t ADDRESS [ADDR ...]     to email address(es)
-u SUBJECT                message subject
-m MESSAGE                message body
-s SERVER[:PORT]          smtp mail relay, default is localhost:25
```

  Optional:

```shell
-a   FILE [FILE ...]      file attachment(s)
-cc  ADDRESS [ADDR ...]   cc  email address(es)
-bcc ADDRESS [ADDR ...]   bcc email address(es)
-xu  USERNAME             username for SMTP authentication
-xp  PASSWORD             password for SMTP authentication
```

  Paranormal:

```shell
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
```

  Help:

```shell
--help                    the helpful overview you're reading now
--help addressing         explain addressing and related options
--help message            explain message body input and related options
--help networking         explain -s, -b, etc
--help output             explain logging and other output options
--help misc               explain -o options, TLS, SMTP auth, and more
```

参考：

[不可或缺的sendEmail](http://blog.csdn.net/leshami/article/details/8314570)

[如何使用sendEmail发送邮件](http://www.ttlsa.com/linux/use-sendemail/)

### 环境配置

#### 环境变量

![设置Linux环境变量的三种方法](pics/设置Linux环境变量的三种方法.jpg)

#### JDK环境

要先删除open jdk，然后再安装sun jdk

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

### 软件使用

#### ffmpeg

##### 安装

```shell
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

#安装依赖项yasm:
yum install yasm

#编译安装：
./configure –enable-shared –prefix=/usr/local/ffmpeg
make&make install
```

##### 配置

使用


```shell
# 将ffmpeg工具添加到环境变量中去
sudo vim ~/.bashrc #末尾添加 export PATH=/usr/local/ffmpeg/bin
```

开发
```shell
# 添加库：
vim /etc/ld.so.conf，# 末尾添加/usr/local/ffmpeg/lib
ldconfig # 更新
```
测试

```shell
ffmpeg --help
```
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

#### ssh

ssh本身会附带一个scp命令，用来进行文件的传输

##### 安装

```shell
# 服务器端
sudo yum install openssh-server

# 客户端
sudo yum install openssh-client

# 启动服务
service ssh restart
```

##### 使用

参数指定

```shell
# 指定端口
ssh root@127.0.0.1 -p 122

# ssh指定要使用的密钥和端口
ssh -i /cygdrive/c/Users/xl/.ssh/id_rsa -p122

# ssh交互使用(需要输入密码等交互情况下，输入-t参数)
ssh -t xxx@xxx "sudo ls /tmp"
```

远程执行

```shell
# 远程执行命令
ssh -t xxx@xxx "sudo ls /tmp"

# 远程执行远程脚本
ssh xxx@xxxx "/home/xx/vv.sh"

# 远程执行本地脚本
ssh xxx@xxxx < test.sh
```

> 远程执行-远程脚本传参
>
> ```shell
> # 直接将参数写在后面即可
> ssh xxx@xxx  /home/nick/test.sh helloworld
> ```
>
> 远程执行-本地脚本传参
>
> ```shell
> # 需要使用bash -s
> ssh nick@xxx.xxx.xxx.xxx 'bash -s' < test.sh helloworld
> ```

远程执行获取结果

```shell

```

#### scp

​	scp是secure copy的简写，用于在Linux下进行远程拷贝文件的命令，获得远程服务器上的某个文件，远程服务器既没有配置ftp服务器，没有开启web服务器，也没有做共享，无法通过常规途径获得文件时，只需要通过scp命令便可轻松的达到目的；

##### 安装

```
在安装ssh的时候已经自带了
```

参数指定

```
-P 端口(若使用默认的ssh端口，则不需要修改)
-p 表示保持文件权限；
-r 表示递归复制；
-v 和大多数 linux 命令中的 -v 意思一样，用来显示进度，可以用来查看连接、认证或是配置错误；
-C 使能压缩选项；
```

##### 使用

上传文件

```shell
scp /home/liujia/file1.txt  liujia@172.16.252.32:/user/liujia
# 上传本地file1.txt到远程的/user/liujia目录，最终结果为/user/liujia/file1.txt
```

上传文件夹

```shell
scp -r /home/liujia/dir1  liujia@172.16.252.32:/user/liujia
# 上传本地的dir1目录到远程的/user/liujia目录，最终的结果为/user/liujia/dir1
```

下载文件

```shell
scp root@172.16.252.32:/user/liujia/tex.txt  .
# 下载远程的tex.txt 到当前目录为tex.txt
```

下载文件夹

```shell
scp -r liujia@172.16.252.32:/user/liujia/dir1  /home/projects
# 复制远程的dir1目录到本地的/home/projects目录下，最终的结果是/home/projects/dir1
```

#### jq

##### 安装

```shell
git clone https://github.com/stedolan/jq.git
cd jq
autoreconf -i
./configure --disable-maintainer-mode
make
sudo make install
```

## 参考

- 基础知识

  [Centos/Linux升级系统内核](http://www.linuxidc.com/Linux/2015-02/112961.htm)

  [Centos升级系统内核](http://blog.csdn.net/reyleon/article/details/52229293)

  [Linux性能工具集](https://www.toutiao.com/i6492996073429139982/)

  [Linux crontab定时任务管理](http://www.imooc.com/video/10979)

  [linux系统的7种运行级别](http://blog.chinaunix.net/uid-22746363-id-383989.html) 

- 技能积累

  [详解rsync好文（推荐）](http://blog.csdn.net/lianzg/article/details/24817087)

  [使用rsync 的 --delete参数删除目标目录比源目录多余的文件](http://www.linuxidc.com/Linux/2014-03/98835.htm)

  [Rsync与inotify 进行实时同步](http://www.toutiao.com/i6351627805494608385/)

  [rsync命令参数详解](http://www.jb51.net/article/34869.htm)

  [使用Fabric模块编写的批量同步文件的python脚本](http://www.toutiao.com/i6449256257931969037/)

  [Fabric官方参考](http://docs.fabfile.org/en/latest/index.html#usage-docs)

  [基于paramiko和watchdog的文件夹自动同步工具](http://www.cnblogs.com/MikeZhang/p/autoSync20170617.html)

  [基于inotify-tools和rsync的文件夹自动同步工具](https://www.toutiao.com/i6503742233206850061/)

- 环境配置

  [Linux下安装Sun JDK（删除Open JDK）](http://www.toutiao.com/i6416458864656384514/)

- 软件使用

  [linux下安装编译ffmpeg](http://www.toutiao.com/a6348252505277841666/)

  [SSH 远程执行任务](http://www.cnblogs.com/sparkdev/p/6842805.html)

  [获取ssh远程执行的结果](http://blog.csdn.net/liuxiao723846/article/details/55045988)

  [命令行下json处理工具:jq](http://blog.csdn.net/neven7/article/details/50626153)

  [scp上传和下载](http://blog.csdn.net/liuxiao723846/article/details/55045988)

  ​

  ​

