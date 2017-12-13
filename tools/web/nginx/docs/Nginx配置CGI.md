##Nginx配置CGI
[TOC]

### 基础

nginx和os一般都自带了spawn-cgi支持，不需要再安装什么其它的库

#### 例子

step1:编写c/c++的cgi程序

```c
//myfastcgi.c
#include <iostream> 
#include <unistd.h>  //getid()函数声明
#include <fcgi_stdio.h> 
#include <stdlib.h> 

int main() 
{
    int count = 0;
    while(FCGI_Accept() >= 0){
        printf("Content-type: text/html\r\n"
        "\r\n"
        ""
        "FastCGI Hello!"
        "Request number %d running on host%s "
        "Process ID: %d\n", ++count, getenv("SERVER_NAME"), getpid()
        );
    }
    return 0;
}
```

> 然后编译执行`g++ myfastcgi.c -o myfastcgi -lfcgi ` 

step2:运行spawn-cgi

```shell
spawn-cgi -a 127.0.0.1 -p 9003 -F 3 -f myfastcgi
# 其中myfastcgi是前一步生成的可执行文件
```

step3:配置nginx

```nginx
#本地cgi-server，监听9003端口
upstream cgi-server{
    server 127.0.0.1:9003 weight=1;
}

# NGINX 虚拟主机，监听80端口
server {
    listen 80;
    server_name cgi_proxy.com;
    
    access_log logs/cgi_proxy_acc.log mylog;
    error_log logs/cgi_proxy_err.log;

    # Gzip Compression
    gzip on;
    gzip_comp_level 6;
    gzip_vary on;
    gzip_min_length  1000;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_buffers 16 8k;

    location / {
        root   cgi;
        index  index.html index.htm;
     }

    location ~ \.cgi$ {
        fastcgi_pass cgi-server; # 前面定义的cgi服务器
        fastcgi_index index.cgi;
        fastcgi_param SCRIPT_FILENAME fcgi$fastcgi_script_name;
        include fastcgi_params;
    }
}
```



 ##参考

- 基础

[nginx配置spawn-fastcgi执行自己编写的CGI程序(c/c++)  ](http://liuzhigong.blog.163.com/blog/static/178272375201351811194428/)