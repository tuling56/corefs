##CGI编程
[TOC]

### 基础

#### 概念

CGI是什么？

- CGI(公共网关接口)，定义了信息如何在Web服务器（如http服务器）和客户端脚本(外部网关程序)之间进行交互的

  对接的接口标准

- CGI程序可以用Python、PERL、Shell、C 或 C++ 等进行编写

- CGI目前的版本是CGI/1.1,CGI/1.2版本正在开发中

#### 配置

##### Apache配置CGI

在你进行CGI编程前，确保您的Web服务器支持CGI及已经配置了CGI的处理程序。

[Apache 支持CGI 配置](http://blog.csdn.net/naturebe/article/details/7443662)：

```shell
编译的时候加入 --enable-cgi

#编辑编辑httpd.conf,打开
LoadModule cgi_module /usr/lib/apache2/modules/mod_cgi.so //默认有则不需要加
```

设置好CGI目录：

```
ScriptAlias /cgi-bin/ /var/www/cgi-bin/
```

所有的HTTP服务器执行CGI程序都保存在一个预先配置的目录。这个目录被称为CGI目录，并按照惯例，它被命名为/var/www/cgi-bin目录。

CGI文件的扩展名为.cgi，python也可以使用.py扩展名。默认情况下，Linux服务器配置运行的cgi-bin目录中为/var/www。如果你想指定其他运行 CGI 脚本的目录，可以修改 httpd.conf 配置文件，如下所示：

```
<Directory "/var/www/cgi-bin">
   AllowOverride None
   Options +ExecCGI
   Order allow,deny
   Allow from all
</Directory>
```

在 AddHandler 中添加 .py 后缀，这样我们就可以访问 .py 结尾的 python 脚本文件：

```
AddHandler cgi-script .cgi .pl .py .sh
#并修改权限为755

# 注意文件的开头必须输出是html的类型头，否则报错
```

访问：

```
http://localhost/cgi-bin/xxx.pl
```

###### 测试

目录：

```
apache服务器默认的cgi目录是`D:\wamp\bin\apache\apache2.4.9\cgi-bin`
在apache的httpd.conf中配置了如下的alias：
<IfModule alias_module>
    ScriptAlias /cgi-bin/ "D:/wamp/bin/apache/apache2.4.9/cgi-bin/"
</IfModule>
```

测试：

```shell
http://localhost:8081/cgi-bin/perl_cgi.pl 
http://localhost:8081/cgi-bin/python_cgi.py?name_get=zhang&url_get=hah
```

> xl@DESKTOP-U21439C MINGW64 /d/wamp/bin/apache/apache2.4.9/cgi-bin
> $ ls -lh
> -rwxr-xr-x 1 xl 197121  879 11月 24  2016 perl_cgi.pl
> -rwxr-xr-x 1 xl 197121 1.2K 5月   7  2017 perl_resql.pl
> -rwxr-xr-x 1 xl 197121  348 5月   7  2017 perl_site.pl
> -rwxr-xr-x 1 xl 197121 1.1K 5月   7  2017 perl_sql.pl*
> -rwxr-xr-x 1 xl 197121  879 11月 24  2016 perlntenv.pl
> -rwxr-xr-x 1 xl 197121  297 12月 15  2016 php_cgi.php
> -rwxr-xr-x 1 xl 197121 2.1K 6月   7  2017 python_cgi.py

##### Nginx配置CGI

### 进阶

 ##参考

- 基础

  [PerlCGI头库](https://stackoverflow.com/questions/22307610/end-of-script-output-before-headers-error-in-apache)

  [教你用shell写cgi程序](http://www.xinghaixu.com/archives/117)

- 进阶

  [Perl CGI编程](http://www.runoob.com/perl/perl-cgi-programming.html)

  [C++ CGI编程](http://www.runoob.com/cplusplus/cpp-web-programming.html)

  [Python CGI编程](http://www.runoob.com/python/python-cgi.html)

  [Ruby CGI编程](http://www.runoob.com/ruby/ruby-cgi.html)