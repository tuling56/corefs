# 服务器web开发

> 主要牵涉到nginx结合uwsgi+php+django+web.py+lua等 的配置和使用，及相互之间的集成

[TOC]

## nginx的配置

nginx本身是一个http服务器，同时又是一个高性能的反向代理服务器，也是一个IMAP/POP3/SMTP代理服务器。

### 安装

> 安装依赖项：
>
> > > 基本依赖模块
> >
> > ```
> > pcre
> > yum install pcre pcre-devel
> >
> > openssl
> > yum install openssl openssl-devel
> >
> > zlib
> > yum install zlib
> >
> > gd
> > yum install gd gd-devel
> >
> >
> > # 若在安装的时候找不到上述模块，可以用指定源码包的方式，例如：
> > --with-openssl=<openssl_dir>、--with-pcre=<pcre_dir>、--with-zlib=<zlib_dir> 指定依赖的模块目录。如已安装过，此处的路径为安装目录；若未安装，则此路径为编译安装包路径，Nginx 将执行模块的默认编译安装。
> > ```
> >
> > > lua支持需要的模块
> >
> > ```
> > ngx_devel_kit      https://github.com/simpl/ngx_devel_kit  
> > echo-nginx-module  https://github.com/agentzh/echo-nginx-module  
> > lua-nginx-module   https://github.com/chaoslawful/lua-nginx-module 
> > ```
> >
>
> 源码编译安装
>
> ```shell
> ./configure --prefix=/usr/local/nginx 
> --add-module=./modules/ngx_devel_kit 
> --add-module=./modules/echo-nginx-module  
> --add-module=./modules/lua-nginx-module
> ```
>
> 参考：[nginx编译安装选项说明](http://blog.csdn.net/pang040328/article/details/29180913)
>
> 产看当前的安装参数：
>
> ```
> nginx -V
> ```

### 启动关闭和重启

启动

> `cd /usr/local/nginx/sbin`
>
> ./nginx

重启

> ./nginx -s reload 
>
> （在配置文件发生改变的时候，使用这个命令，重新加载配置文件，而不需要重启服务,编译的新模块开启的时候也沿用此套方法）

判断配置文件是否正确

> ./nginx -t

关闭

> pkill  -9 nginx 或者 ./nginx -s stop
>
> > 使用参考：./nginx  -h

检查是否正确启动

> 在浏览器地址栏中输入：http://localhost，看看是否出现欢迎页

tips:如何将一个应用程序做成一个[^服务]：

[^服务]: 是注释程序

> [如何将一个应用程序做成一个服务](http://www.cnblogs.com/niocai/archive/2012/07/12/2587736.html)（还存在问题，这个是老版本的，新版本的还没解决）

### nginx开启启动

[ nginx开机自动启动脚本](http://blog.csdn.net/gebitan505/article/details/17606735)

> 注意直接用下载好的脚本`docs/nginx.service`，开头配置如下：
>
> ```
> # chkconfig: - 85 15
> # description: nginx is a World Wide Web server. It is used to serve
>
> # Default-Start:     2 3 4 5
> # Default-Stop:      0 1 6
> # Short-Description: starts the nginx web server
> ```
>
> 前两行解决了`**service nginx does not support chkconfig**`[问题](http://blog.csdn.net/gebitan505/article/details/17606799)
>
> 然后直接使用：`chkconfig --add nginx` 即可，其它的不需要任何操作
>
> > 简便方式：将该目录下的准备好的nginx文件直接拷贝到`/etc/init.d/`目录下，然后执行`chmod u+x nginx && chkconfig --add nginx`
>
> 附:完整版的nginx.service配置
>
> ```shell
> #!/bin/sh
> # chkconfig: - 85 15
> # description: nginx is a World Wide Web server. It is used to serve
>
> # Default-Start:     2 3 4 5
> # Default-Stop:      0 1 6
> # Short-Description: starts the nginx web server
>
> PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
> DESC="nginx daemon"
> NAME=nginx
> DAEMON=/usr/local/nginx/sbin/$NAME
> CONFIGFILE=/usr/local/nginx/conf/$NAME.conf
> PIDFILE=/usr/local/nginx/logs/$NAME.pid
> SCRIPTNAME=/etc/init.d/$NAME
>
> set -e
> [ -x "$DAEMON" ] || exit 0
>
> do_start() {
>  $DAEMON -c $CONFIGFILE || echo -n "nginx already running"
> }
>
> do_stop() {
>  kill -INT `cat $PIDFILE` || echo -n "nginx not running"
> }
>
> do_reload() {
>  kill -HUP `cat $PIDFILE` || echo -n "nginx can't reload"
> }
>
> case "$1" in
>  start)
>  echo -n "Starting $DESC: $NAME"
>  do_start
>  echo "."
>  ;;
>  stop)
>  echo -n "Stopping $DESC: $NAME"
>  do_stop
>  echo "."
>  ;;
>  reload|graceful)
>  echo -n "Reloading $DESC configuration..."
>  do_reload
>  echo "."
>  ;;
>  restart)
>  echo -n "Restarting $DESC: $NAME"
>  do_stop
>  do_start
>  echo "."
>  ;;
>  *)
>  echo "Usage: $SCRIPTNAME {start|stop|reload|restart}" >&2
>  exit 3
>  ;;
> esac
>
> exit 0
> ```

### nginx配置文件

#### **nginx.conf主配置文件**

```nginx
worker_process      # 表示工作进程的数量，一般设置为cpu的核数

worker_connections  # 表示每个工作进程的最大连接数

server{}            # 块定义了虚拟主机

    listen          # 监听端口

    server_name     # 监听域名

    location {}     # 是用来为匹配的 URI 进行配置，URI 即语法中的“/uri/”

    location /{}    # 匹配任何查询，因为所有请求都以 / 开头

        root        # 指定对应uri的资源查找路径，这里html为相对路径，完整路径为
                    # /opt/nginx-1.7.7/html/

        index       # 指定首页index文件的名称，可以配置多个，以空格分开。如有多个，按配置顺序查找。
```

>  nginx的配置和参数优化比较复杂，需要不断的根据实际使用进行调整。

##### 自动列出目录

```nginx
autoindex on;
autoindex_exact_size off;
autoindex_localtime on;
charset utf-8,gbk;
```

> 在Nginx下默认是不允许列出整个目录的。如需此功能，
>
> 先打开nginx.conf文件，在location server 或 http段中加入autoindex on;
>
> 另外两个参数最好也加上去:
>
> autoindex_exact_size off;
> 默认为on，显示出文件的确切大小，单位是bytes。改为off后，显示出文件的大概大小，单位是kB或者MB或者GB
>
> autoindex_localtime on;
> 默认为off，显示的文件时间为GMT时间。注意:改为on后，显示的文件时间为文件的服务器时间
>
> 但是如果有中文目录的话会出现乱码问题，所以还需要在下面添加这一句：
>
> charset utf-8,gbk;

#### location的匹配规则

| 模式                  | 含义                                       |
| ------------------- | ---------------------------------------- |
| location = /uri     | = 表示精确匹配，只有完全匹配上才能生效                     |
| location ^~ /uri    | ^~ 开头对URL路径进行前缀匹配，并且在正则之前。               |
| location ~ pattern  | 开头表示区分大小写的正则匹配                           |
| location ~* pattern | 开头表示不区分大小写的正则匹配                          |
| location /uri       | 不带任何修饰符，也表示前缀匹配，但是在正则匹配之后                |
| location /          | 通用匹配，任何未匹配到其它location的请求都会匹配到，相当于switch中的default |

匹配顺序

```
首先精确匹配 =
其次前缀匹配 ^~
其次是按文件中顺序的正则匹配
然后匹配不带任何修饰的前缀匹配。
最后是交给 / 通用匹配
当有匹配成功时候，停止匹配，按当前匹配规则处理请求
```



//待补充，比较多

**root和alias的区别**

> ```nginx
> location /request_path/image/ {
>     root /local_path/image/;
> }
> ```
>
> 这样配置的结果就是当客户端请求 /request_path/image/cat.png 的时候， 
> Nginx把请求映射为**/local_path/image/request_path/image/cat.png**
>
> 再看alias的用法
>
> ```nginx
> location /request_path/image/ {
>     alias /local_path/image/; # 目录名后面一定要加"/"。
> }
> ```
>
> 这时候，当客户端请求 /request_path/image/cat.png 的时候， 
> Nginx把请求映射为**/local_path/image/cat.png** 

参考:[nginx的location匹配规则](http://wiki.jikexueyuan.com/project/openresty/ngx/nginx_local_pcre.html)

#### 内置变量

| 字段                                 | 作用                                       |
| ---------------------------------- | ---------------------------------------- |
| $remote_addr与$http_x_forwarded_for | 记录客户端IP地址                                |
| $remote_user                       | 记录客户端用户名称                                |
| $request                           | 记录请求的URI和HTTP协议                          |
| $status                            | 记录请求状态                                   |
| $body_bytes_sent                   | 发送给客户端的字节数，不包括响应头的大小                     |
| $bytes_sent                        | 发送给客户端的总字节数                              |
| $connection                        | 连接的序列号                                   |
| $connection_requests               | 当前通过一个连接获得的请求数量                          |
| $msec                              | 日志写入时间。单位为秒，精度是毫秒                        |
| $pipe                              | 如果请求是通过HTTP流水线(pipelined)发送，pipe值为“p”，否则为“.” |
| $http_referer                      | 记录从哪个页面链接访问过来的                           |
| $http_user_agent                   | 记录客户端浏览器相关信息                             |
| $request_length                    | 请求的长度（包括请求行，请求头和请求正文）                    |
| $request_time                      | 请求处理时间，单位为秒，精度毫秒                         |
| $time_iso8601                      | ISO8601标准格式下的本地时间                        |
| $time_local                        | 记录访问时间与时区                                |

#### 日志配置

错误日志

error_log不能改变，日志文件可以指定任意存放日志的目录，错误日志级别常见的有`debug|info|notice|warn|error|crit|alert|emerg`，级别越高，记录的信息越少，生产场景一般是`warn|error|crit`这三个级别之一，注意不要配置info等较低级别，会带来巨大磁盘I/O消耗。

可放置的标签段为:(这这个暂时找不到放置的位置)

context: main， http， server， location

> 注意错误日志不支持自定义格式，只能使用以上的格式，而access支持自定义格式

### nginx开启https支持

SSL使用证书来创建安全连接，有两种验证模式：

1. 仅客户端验证服务器的证书，客户端自己不提供证书；
2. 客户端和服务器都互相验证对方的证书。

#### 创建自签名SSL证书

创建自签名证书需要安装openssl，使用以下步骤：[参考](http://www.liaoxuefeng.com/article/0014189023237367e8d42829de24b6eaf893ca47df4fb5e000)

1. 创建Key(密钥口令可选)；
2. 创建签名请求；
3. 将Key的口令移除；
4. 用Key签名证书。

```
# 这个还是存在问题的，不同的机器访问不了，只能本机访问
```

#### https配置方法

**https配置方法1：**

> 证书有服务器端证书和客户端证书

服务器端证书

> step1:创建服务器私钥（==.key文件==，带密钥口令）
>
> ```shell
> openssl genrsa -des3 -out https-server.key 1024
>
> # 会提示输入密钥口令：
> #Enter pass phrase for https-server.key:
> #Verifying - Enter pass phrase for https-server.key:
> ```
>
> step2:创建签名证书请求(==.csr文件==)
>
> ```shell
> openssl req -new -key https-server.key -out https-server.csr
>
> # 会提示输入上一步输入的密钥口令
> ```
>
>  ```shell
> # 在加载ssl支持的nginx，并使用上述私钥时除去必须的口令
> cp https-server.key  https-server.key.org
> openssl rsa -in https-server.key.org -out https-server.key
>  ```
>
> step3:自签署证书（创建CA证书==.crt文件==)
>
>  ```shell
> openssl x509 -req -days 365 -in https-server.csr -signkey https-server.key -out https-server.crt
>  ```
>
> > 另一种方式：
> >
> > ```shell
> > openssl req -new -x509 -days365 -key https-server.key -out https-server.crt
> > ```
>
> step4:将证书导出成浏览器支持的.p12格式
>
>  ```shell
>  openssl pkcs12 -export -clcerts -in https-server.key -inkey https-server.key -out https-server.p12
>  ```
>
> 总结：
>
> 共三个文件:server.key, server.csr, sever.crt,最后将这三个文件放到默认的nginx/conf/ssl目录下

客户端证书

> 客户端证书如何配置？

**配置https方法2：**

``` shell
# 自建CA
(1) 生成私钥文件
	mkdir -p /etc/pki/CA/private
	openssl genrsa -out /etc/pki/CA/private/cakey.pem 4096
(2) 生成自签证书
	openssl req -new -x509 -key /etc/pki/CA/private/cakey.pem -out /etc/pki/CA/cacert.pem -days 7300
(3) 为CA提供所需的目录和文件
  touch /etc/pki/CA/index.txt # 创建数据库文件
  echo 01 > /etc/pki/CA/serial # 创建序列号文件并给明第一个证书的序列号码
----
# 证书申请
进入到nginx的conf目录，创建ssl目录，以下在ssl目录中操作：
（1）在证书申请的主机上生成私钥
	openssl genrsa -out server.key 2048
（2）生成证书签署请求
	openssl req -new -key server.key -out server.csr -days 365
 (3) 把请求发给CA，这里是本机不再发送 
 (4) CA签发证书
	 openssl ca -in server.csr -out server.crt -days 365
	 
> 注意：自建CA的第二步和证书申请的第二步的输入信息要一致，不然签发失败 
```

**生成自签证书的过程：**

> [root@local122 CA]# openssl req -new -x509 -key /etc/pki/CA/private/cakey.pem -out /etc/pki/CA/cacert.pem -days 7300
> You are about to be asked to enter information that will be incorporated
> into your certificate request.
> What you are about to enter is what is called a Distinguished Name or a DN.
> There are quite a few fields but you can leave some blank
> For some fields there will be a default value,
>
> If you enter '.', the field will be left blank.
>
> Country Name (2 letter code) [XX]:cn
> State or Province Name (full name) []:guangdong
> Locality Name (eg, city) [Default City]:shenzhen
> Organization Name (eg, company) [Default Company Ltd]:xnot
> Organizational Unit Name (eg, section) []:xmpx
> Common Name (eg, your name or your server's hostname) []:yjm
> Email Address []:126@126.com

**签发成功后，会显示签发信息,如下：**

    Using configuration from /etc/pki/tls/openssl.cnf
    Check that the request matches the signature
    Signature ok
    Certificate Details:
       Serial Number: 1 (0x1)
        Validity
            Not Before: Jan 19 08:46:14 2017 GMT
            Not After : Jan 19 08:46:14 2018 GMT
        Subject:
            countryName               = cn
            stateOrProvinceName       = guangdong
            organizationName          = Default Company Ltd
            organizationalUnitName    = xmpx
            commonName                = yjm
            emailAddress              = 126@126.com
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Comment: 
                OpenSSL Generated Certificate
            X509v3 Subject Key Identifier: 
                34:C0:37:31:1D:7B:D7:75:C2:A5:07:9B:52:19:F7:69:F1:F6:89:0C
            X509v3 Authority Key Identifier: 
                keyid:5C:AD:BE:75:C4:27:F7:E2:68:9F:EC:69:76:8F:79:C1:A9:86:87:5D
                
    Certificate is to be certified until Jan 19 08:46:14 2018 GMT (365 days)
    Sign the certificate? [y/n]:y
    1 out of 1 certificate requests certified, commit? [y/n]y
    Write out database with 1 new entries
    Data Base Updated

**配置nginx**

![nginx开启https](http://p1.pstatp.com/large/159f00042b57b14e3efa)

### nginx运行状态监控

需要使用到的模块是http_stub_status_module

#### 安装

编译nginx的时候加上:**--with-http_stub_status_module**

#### 配置

在nginx.conf的server里配置

```和
location /nginx_status {
    # Turn on nginx stats
    stub_status on;
    # I do not need logs for stats
    access_log   off;
    # Security: Only allow access from 192.168.1.100 IP #
    #allow 192.168.1.100;
    # Send rest of the world to /dev/null #
    #deny all;
}
```

#### 结果和说明

```
Active connections: 1 
server accepts handled requests
 1 1 1 
Reading: 0 Writing: 1 Waiting: 0 
```

- **Active connections** – Number of all open connections. This doesn’t mean number of users. A single user, for a single pageview can open many concurrent connections to your server.
- **Server accepts handled requests** – This shows three values.First is total *accepted* connections.Second is total *handled* connections. Usually first 2 values are same.Third value is number of and handles *requests. *This is usually greater than second value.Dividing third-value by second-one will give you number of requests per connection handled by Nginx. In above example, 10993/7368, **1.49 requests per connections**.
- **Reading** – nginx reads request header
- **Writing** – nginx reads request body, processes request, or writes response to a client
- **Waiting** – keep-alive connections, actually it is `active – (reading + writing).`This value depends on [keepalive-timeout](http://wiki.nginx.org/HttpCoreModule#keepalive_timeout). Do not confuse non-zero waiting value for poor performance. It can be ignored. Although, you can force zero waiting by setting `keepalive_timeout 0;`

### nginx开启访问认证

ngx_http_auth_basic_module模块实现访问认证，只有输入正确的用户密码才允许访问web内容。web上的一些内容不想被其他人知道，但是又想让部分人看到。[nginx](http://www.ttlsa.com/nginx/)的http auth模块以及Apache http auth都是很好的解决方案。

```nginx
server{
       server_name  www.ttlsa.com ttlsa.com;
 
        index index.html index.php;
        root /data/site/www.ttlsa.com;       
 
        location /
        {
                auth_basic "nginx basic http test for ttlsa.com";
                auth_basic_user_file /usr/local/nginx/conf/htpasswd; # 此处最好使用绝对路径 
                autoindex on;
        }
}
```

htppaswd文件的生成：

可以使用htpasswd，或者使用openssl:

```shell
# 方式1：
htpasswd -c -d /usr/local/nginx/conf/htpasswd username
> 输入以上命令，回车输入密码，再次回车，输入确认密码 

# 方式2：
printf "yjm:$(openssl passwd -crypt 123)\n" >>conf/htpasswd
cat conf/htpasswd 
#yjm:xyJkVhXGAZ8tM  # 这样就配置了用户名为yjm,密码为123（还要加密）的访问认证
```

>使用cookie机制，首次访问的时候需要验证

参考：

[nginx实现访问网站或目录密码认证保护](http://blog.csdn.net/babydavic/article/details/8880868)

[nginx用户认证配置（ Basic HTTP authentication）](http://www.ttlsa.com/nginx/nginx-basic-http-authentication/)

### 参考

[Nginx安装](http://blog.csdn.net/carlos1992/article/details/48194321)

[nginx安全加固](http://www.toutiao.com/i6410241153689453057/)

[nginx_lua_module 模块 以及 echo-nginx-module 模块](http://blog.csdn.net/vboy1010/article/details/7868645)

[Fedroa18/19以上关闭防火墙](http://www.linuxidc.com/Linux/2013-08/89215.htm)

[logrotate日志归档](http://www.tuicool.com/articles/AB3euy)

[极客学院:nginx，lua,openresty的联合配置和使用](http://wiki.jikexueyuan.com/project/openresty/openresty/inline_var.html)

[如何配置nginx反向代理和负载均衡](http://natumsol.github.io/2016/03/16/nginx-basic/)

[nginx使用ssl模块配置https支持](http://www.cnblogs.com/yanghuahui/archive/2012/06/25/2561568.html)

[nginx配置https,自建CA证书服务器](http://www.toutiao.com/a6376456802976661762/)

[ centos lnmp环境配置ssl证书支持https访问](http://blog.csdn.net/nuli888/article/details/51865084?locationNum=7)

[nginx配置文件详解](https://www.zybuluo.com/phper/note/89391)

[nginx日志分析及性能排查](http://mp.weixin.qq.com/s/A1ufVgi3VFuSGRh4Ju5puA)

[http_stub_status_module监控其运行状态](http://www.cnblogs.com/94cool/p/3872492.html)

[开启nginx的状态监控模块](https://easyengine.io/tutorials/nginx/status-page/)

## uwsgi的配置

---

[uwsgi是什么？](http://www.nowamagic.net/academy/detail/1330328)

> WSGI是web服务网关接口，它是一个web服务器（如nginx）与应用服务器（如uWSGI服务器）通信的一种规范
>
> - uWSGI是什么？
>
> > 是一个==web服务器==，实现了<u>WSGI协议、uwsgi协议、http</u>等协议。Nginx中HttpUwsgiModule的作用是与uWSGI服务器进行交换。（注意概念辨析）

### 安装

> ~~sudo yum install uwsgi (这一步非必须，Linux系统一般都自带的安装在/usr/sbin目录下)~~
>
> ~~安装两个插件：~~
>
> > - ~~yum install  uwsgi-plugin-python  	# 可有可无~~
> > - ~~pip intsall uwsgi                                   #等效于sudo yum install uwsgi~~
>
> ~~[该部分的参考](http://blog.csdn.net/hshl1214/article/details/46764861)~~	
>
> 其实只需要用一句话：
>
> ```shell
> sudo apt-get install uwsgi uwsgi-plugin-python
> ```

### 启动和关闭

启动:

> /usr/sbin/uwsgi  -i  /home/celte/lovenote/uwsgi.ini --plugin python

关闭：

>  killall -9 uwsgi

### 配置

> uwsgi --help, #一个启动配置文件的参考：

| [uwsgi]                                | 说明                                      |
| -------------------------------------- | --------------------------------------- |
| socket = 127.0.0.1:9000                | 通信                                      |
| master = true                          | 是否是主机                                   |
| processes = 1                          | 开启的进程数量                                 |
| daemonize = /usr/local/vod/log/vod.log |                                         |
| chdir = /usr/local/vod/                | 指定运行目录                                  |
| pidfile = /usr/local/vod/.pid          | 指定pid文件的位置，记录主进程的pid号                   |
| module = interface                     | 同级目录下有个interface.py的问文件，注意和wsgi-file的区别 |
| plugins = python                       | ***这个配置在python应用的时候必须开启***              |
| web.config.debug = False               | 是否开启debug模式                             |
| socket-timeout = 120                   | 超时设置                                    |
| harakiri = 1200                        |                                         |
| py-autoreload = 1                      |                                         |
| wsgi-file                              | 载入wsgi-file                             |
| stats                                  | 在指定的地址上，开启状态服务                          |
| thred                                  | 运行线程数量                                  |
| log-maxsize                            | 以固定的文件大小（kb），切割日志文件                     |
| vacuum                                 | 当服务器退出的时候自动清理环境，删除uinx socket和pid文件     |
| disable-logging                        | 不记录请求信息的日志，只记录错误及uwsgi内部消息到日志中。         |
| uid=root                               | 配置运行uwsgi用户的uid                         |
| gid=root                               | 配置运行uwsgi用户的gid                         |

### 测试

#### uwsig的安装是否成功

> 什么情况下代表uwsgi配置成功？如何确认,测试uwsgi是否安装成功
>
> 在你的django项目根目录下建一个test.py文件：
>
> ```python
> # test.py
> def application(env, start_response):
>     start_response('200 OK', [('Content-Type','text/html')])
>     return "Hello World"
> ```
>
> 然后执行以下命令：
>
> > ~~uwsgi --http :8001 --wsgi-file    ${projectroot}/test.py~~
> >
> > 更正为：
> >
> > uwsgi --socket 127.0.0.1:9000 --protocol=http --wait-interface test:application
>
> 访问网页 http://115.28.0.89:9000/，OK，显示 Hello World，说明 [uwsgi](http://www.nowamagic.net/academy/tag/uwsgi) 安装成功。

#### 通过web页面执行服务器端脚本

```python
import os
 
def application(env, start_response):
    os.chdir('/usr/local/src/python-test')
    retcode = os.system('sh dir.sh')
    if retcode == 0:
        ret = 'success!'
    else:
        ret = 'failure!'
        start_response('200 OK', [('Content-Type','text/html')])
    return [ret]
```

### 开启nginx+uwsgi

uwsgi和nginx的关系:nginx的服务由uwsgi进行接管，然后处理程序都是uwsgi进行的，所以需要现在nginx的配置文件中，做类似以下的配置：

```nginx
server{
  listen 80;
  server_name localhost 127.0.0.1;
  
  location /{
    uwsgi_pass 127.0.0.1:9000   #注意此处的8800端口要和uwsgi里配置的端口一样
    include uwsgi_params;
    acess_log off;
    root  # 表示当匹配这个请求的路径时，将会在这个文件夹内寻找相应的文件
    	  # （对于django来说，此处指向包含settings.py的那个目录）
    index # 当没有指定主页时，默认会选择这个指定的文件，按顺序查找
  }
}
```

### 开启django+uwsgi

#### 先测试django自带web服务器

python $projectroot/manage.py runserver 127.0.0.1:8801  # 此处8801是django自带的web服务器的端口

然后访问http://127.0.0.1:8801,成功显示，则代表Django自带服务正确

#### 开启uwsgi与Django的连接

> - 在与manage.py同目录下新建django_wsgi.py文件：
>
> ```python
> #django_wsgi.py
> #!/usr/bin/env python
> # coding: utf-8
>
> import os
> import sys
>
> # 将系统的编码设置为UTF8
> reload(sys)
> sys.setdefaultencoding('utf8')
>
> os.environ.setdefault("DJANGO_SETTINGS_MODULE", "projectname.settings")
>
> from django.core.handlers.wsgi import WSGIHandler
> application = WSGIHandler()     # 使用此获取应用
> ```
>
> - 执行
>
>
> ```shell
> uwsgi --http :9000 --chdir $projectroot --module django_wsgi
> 更新为：uwsgi --socket 127.0.0.1:9000 --protocol=http --chdir $projectroot --module django_wsgi
> ```
>
> > 其实在django项目的配置文件目录内有wsgi.py文件，可以直接作为uwsgi的入口文件
>
> ```python
> """
> WSGI config for django_project project.
>
> It exposes the WSGI callable as a module-level variable named ``application``.
>
> For more information on this file, see
> https://docs.djangoproject.com/en/1.8/howto/deployment/wsgi/
> """
>
> import os
>
> from django.core.wsgi import get_wsgi_application
>
> os.environ.setdefault("DJANGO_SETTINGS_MODULE", "django_project.settings")
>
> application = get_wsgi_application()  #使用此获取应用
> ```

### uwsgi的处理过程

> 如何将nginx的请求进行处理和返回的？

### 参考

[uWSGI搭配Nginx](http://www.nowamagic.net/academy/tag/uwsgi)(现代魔法学院)

[uWSGI+Nginx安装配置（成功）](http://www.cnblogs.com/configure/p/6401695.html)

[uWSGI的安装与配置（官网摘录）](http://blog.csdn.net/chenggong2dm/article/details/43937433)（参考链接很有价值）

[uWSGI Invalid Blocksize](http://stackoverflow.com/questions/15878176/uwsgi-invalid-request-block-size)(注意协议，遇到问题多搜，不要空想)

[cgi,fastcgi,php-cgi,php_fpm的关系](http://www.toutiao.com/a6374973598017192194/)（介绍的比较清楚）

(![CGI、FastCGI、PHP-CGI、PHP-FPM流程](http://p1.pstatp.com/large/1534000214d226572cc9)

## nginx+fastcgi的配置

这个部分还需要很大的完善，有很多的工作没有做



## nginx+php的配置

### 安装依赖项

> yum install libxml2  libxml2-devel curl-devel libmcrypt-devel mhash-devel libxslt-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel

### 下载和安装php

> wget http://cn2.php.net/distributions/php-5.6.27.tar.bz2
>
> tar -jxvf  php-5.6.27.tar.bz2
>
> mkdir /usr/local/php
>
> 配置php如下:(注意配置项是可以重新配置的)
>
> ```shell
> ./configure --prefix=/usr/local/php  --enable-fpm --with-mcrypt --enable-mbstring --disable-pdo --with-curl --disable-debug  --disable-rpath \
> --enable-inline-optimization --with-bz2  --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex \
> --with-mhash --enable-zip --with-pcre-regex --with-mysql --with-mysqli --with-gd --with-jpeg-dir
> ```
>
> make（ 然后使用make test 进行测试）
>
> make install

### 启动和配置php

配置

> 将源码包中的php.ini-production拷贝到/usr/local/php/lib/php.ini
>
> cp /usr/local/php/etc/php-fpm.conf.default      /usr/local/php/etc/php-fpm.conf
>
> >  注意
>
> 测试配置
>
> >/usr/local/php/sbin/php-fpm   -t

启动

> /usr/local/php/sbin/php-fpm
>
> > 带参启动：
> >
> > /usr/local/php/sbin/php-fpm -c /usr/local/php/lib/php.ini -y /usr/local/php/etc/php-fpm.conf
>
> :grey_question:如何配置开机启动php?

关闭和重启

>关闭：
>
>kill -INT `cat /usr/local/php/var/run/php-fpm.pid`
>
>重启
>
>kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
>
>*说明*：若上面的pid文件没有生成，则可以查看`/usr/local/php/var/log/php-fpm.log`,找到对应的pid，然后进行杀死



### 开启nginx支持php

- 编辑nginx的配置文件:`/usr/local/nginx/conf/nginx.conf`,修改如下:

```nginx
location ~ \.php$ {
            root          html; 
            fastcgi_pass  127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
 
            include        fastcgi_params;
 }
```

- ~~配置fastcgi:编辑文件 `/usr/local/nginx/conf/fastcgi_params`,添加如下行:~~

  > ~~fastcgi_param SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;~~


- 测试

  ==启动php,然后重启nginx服务器==

  编辑`/usr/local/nginx/html/index.php`,添加如下内容：

  ```php
  <?php phpinfo();?>
  ```

  在浏览器中打开http://127.0.0.1/index.php,看看是否出现php的相关信息

### 参考

[搭建Nginx+PHP环境](http://www.linuxidc.com/Linux/2013-03/80423p3.htm)（这里有详细的nginx的安装配置）

[php配置php-fpm启动参数及配置详解](http://www.jb51.net/article/42716.htm)

[Linux下配置安装PHP环境](http://www.cnblogs.com/lufangtao/archive/2012/12/30/2839679.html)（里面有配置mysql的支持）

## nginx+web.py的配置

### 安装

```shell
pip install web.py 
```

###  web.py+uwsqi的配置

接口配置

```python
import os
import sys
import web

#web.config.debug = False

# 以下承接各个app
sys.path.append("./common")
sys.path.append("./app_welcome")  
sys.path.append("./app_add_num")

# url路由列表
urls = (
        '/','welcome.Handler',
		'/add_num','add_num.Handler',
)

# 启动应用接口
app = web.application(urls, globals(), autoreload=True)
#app.config['debug'] = False

if __name__ == '__main__':
        app.run()
else:
        application = app.wsgifunc()
```

nginx配置

```nginx
location / {
                include uwsgi_params;
                uwsgi_read_timeout 3600;
                uwsgi_pass 127.0.0.1:9090;
   }
# 注意此处的路径必须是‘/’
```

uwsgi配置

```uwsgi
[uwsgi]
socket = 127.0.0.1:9090
wsgi-file = /usr/local/src/python-test/python-test.py
plugins = python   				#这个必不可少
chdir = /usr/local/src/python-test
processes = 2
threads = 2
post-buffering = 8192
buffer-size = 65535
socket-timeout = 10
stats = 127.0.0.1:9191
# callable = python-test
uid = uwsgi
gid = uwsgi
master = true
protocol = uwsgi
buffer-size = 8192
pidfile = /var/run/uwsgi9090.pid
# daemonize = /var/log/uwsgi9090.log
```



### 参考

[web.py官方参考手册](http://webpy.org/cookbook/ctx)

## nginx+django的配置

### django模块

> 安装：
>
> - pip install django
>
> 使用：
>
> - 创建项目：django-admin.py startproject django_pjname
> - 创建app  :  django-admin.py startapp appname
> - 更新模型：python manage.py syncdb
> - 启动项目：python manage.py runserver 127.0.0.1:8000

### django+uwsgi的配置

Django is very probably the most used Python web framework around. Deploying it is pretty easy (we continue our configuration with 4 processes with 2 threads each).

We suppose the Django project is in `/home/foobar/myproject`:

```
uwsgi --socket 127.0.0.1:3031 --chdir /home/foobar/myproject/ --wsgi-file myproject/wsgi.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191

```

(with `--chdir` we move to a specific directory). In Django this is required to correctly load modules.

Argh! What the hell is this?! Yes, you’re right, you’re right... dealing with such long command lines is unpractical, foolish and error-prone. Never fear! uWSGI supports various configuration styles. In this quickstart we will use .ini files.

```
[uwsgi]
socket = 127.0.0.1:8100
chdir = /home/foobar/myproject/
wsgi-file = myproject/wsgi.py
processes = 4
threads = 2
stats = 127.0.0.1:9191
```

A lot better!

Just run it:

```
uwsgi yourfile.ini

```

If the file `/home/foobar/myproject/myproject/wsgi.py` (or whatever you have called your project) does not exist, you are very probably using an old (< 1.4) version of Django. In such a case you need a little bit more configuration:

```
uwsgi --socket 127.0.0.1:3031 --chdir /home/foobar/myproject/ --pythonpath .. --env DJANGO_SETTINGS_MODULE=myproject.settings --module "django.core.handlers.wsgi:WSGIHandler()" --processes 4 --threads 2 --stats 127.0.0.1:9191

```

Or, using the .ini file:

```
[uwsgi]
socket = 127.0.0.1:3031
chdir = /home/foobar/myproject/
pythonpath = ..
env = DJANGO_SETTINGS_MODULE=myproject.settings
module = django.core.handlers.wsgi:WSGIHandler()
processes = 4
threads = 2
stats = 127.0.0.1:9191

```

Older (< 1.4) Django releases need to set `env`, `module` and the `pythonpath` (`..` allow us to reach the `myproject.settings` module).

## nginx+flask的配置

nginx是一个提供静态文件访问服务的web服务器，然后它不能直接执行托管Python应用程序，而uwsgi解决了这个问题，稍后配置nginx和uwsgi之间的交互。flask内置有web托管服务，开发和调试是个不错的工具，但生产中还是使用nginx。

//始终得不到解决，也是烦死了

## nginx+lua的配置

### 安装

> 安装依赖项：
>
> > yum install readline-devel
>
> 安装lua
>
> > wget http://www.lua.org/ftp/lua-5.1.5.tar.gz
> >
> > tar -zxvf  lua-5.1.5.tar.gz
> >
> > ./configure 
> >
> > make linux test
> >
> > make install
> >
> > :grey_question:lua安装后的文件所在并不清楚？！被打散分配到各个对应的目录
>
> 安装模块管理器luasocks，类似于yum，可以使用luarocks来安装相关模块
>
> > wget http://luarocks.github.io/luarocks/releases/luarocks-2.4.1.tar.gz
> >
> > tar -zxvf  luarocks-2.4.1.tar.gz
> >
> > ./configure --with-lua=/usr/local --with-lua-include=/usr/local/include
> >
> > make bootstrap
> >
> > sudo luarocks install luasocket
>
> > 在解决访问数据库的时候还需要安装
> >
> > yum install mysql-devel             	    # 安装mysql.h
> >
> > yum install community-mysql-libs  # 安装mysql客户端
> >
> > yum install community-mysql-devel  # 安装开发环境
> >
> > luarocks install luasql-mysql MYSQL_INCDIR=/usr/include/mysql MYSQL_LIBDIR=/usr/lib64/mysql/
> >
> > > [注意修改](http://stackoverflow.com/questions/10854971/luasql-nil-value)
> > >
> > > luasql = require "luasql.mysql"
> > >
> > > env = assert (luasql.mysql())

### nginx+lua的配置

> lua支持

```shell
ngx_devel_kit      https://github.com/simpl/ngx_devel_kit  
echo-nginx-module  https://github.com/agentzh/echo-nginx-module  
lua-nginx-module   https://github.com/chaoslawful/lua-nginx-module 
```

> 重新编译Nginx源码并安装

```shell
./configure --prefix=/usr/local/nginx 
--add-module=./modules/ngx_devel_kit 
--add-module=./modules/echo-nginx-module  
--add-module=./modules/lua-nginx-module
make 
make install
```

### 参考

[lua数据库访问](http://www.runoob.com/lua/lua-database-access.html)

[linux下lua开发环境安装](http://www.runoob.com/lua/lua-database-access.html)（牵涉到nginx的配置）

[CentOS系统下，如何安装 nginx_lua_module 模块 以及 echo-nginx-module 模块](http://blog.csdn.net/vboy1010/article/details/7868645)



## 参考

//大参考体系