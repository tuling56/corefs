##CGI编程
[TOC]

### 基础

#### 概念

CGI是什么？

- CGI(公共网关接口)，定义了信息如何在Web服务器（如http服务器）和客户端脚本(外部网关程序)之间进行交互的

  对接的接口标准

- CGI程序可以用Python、PERL、Shell、C 或 C++ 等进行编写

- CGI目前的版本是CGI/1.1,CGI/1.2版本正在开发中

公共网关接口（CGI），是使得应用程序（称为 CGI 程序或 CGI 脚本）能够与 Web 服务器以及客户端进行交互的标准协议。这些 CGI 程序可以用 Python、PERL、Shell、C 或 C++ 等进行编写。

![cgi架构](http://www.runoob.com/wp-content/uploads/2015/05/cgiarch.gif)

#### 配置

##### Apache配置CGI

在你进行CGI编程前，确保您的Web服务器支持CGI及已经配置了CGI的处理程序。

[Apache 支持CGI 配置](http://blog.csdn.net/naturebe/article/details/7443662)：

```shell
# 编译的时候加入 
--enable-cgi

#编辑编辑httpd.conf,打开
LoadModule cgi_module /usr/lib/apache2/modules/mod_cgi.so //默认有则不需要加
```

设置好CGI目录：

``` shell
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

```shell
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

nginx支持fastcgi和spawn-fcgi

### 进阶

每次都要初始化cgi环境，启动新进程，这是软肋，需要使用fastcgi或者spawn-fcgi等进行cgi进程管理

#### 基础

##### http头信息

| 头信息                 | 描述                                       |
| ------------------- | ---------------------------------------- |
| Content-type:       | MIME 字符串，定义返回的文件格式。例如 Content-type:text/html。 |
| Expires: Date       | 信息变成无效的日期。浏览器使用它来判断一个页面何时需要刷新。一个有效的日期字符串的格式应为 01 Jan 1998 12:00:00 GMT。 |
| Location: URL       | 这个 URL 是指应该返回的 URL，而不是请求的 URL。你可以使用它来重定向一个请求到任意的文件。 |
| Last-modified: Date | 资源的最后修改日期。                               |
| Content-length: N   | 要返回的数据的长度，以字节为单位。浏览器使用这个值来表示一个文件的预计下载时间。 |
| Set-Cookie: String  | 通过 *string* 设置 cookie。                   |

##### CGI 环境变量

所有的 CGI 程序都可以访问下列的环境变量。这些变量在编写 CGI 程序时扮演了非常重要的角色。

| 变量名             | 描述                                       |
| --------------- | ---------------------------------------- |
| CONTENT_TYPE    | 内容的数据类型。当客户端向服务器发送附加内容时使用。例如，文件上传等功能。    |
| CONTENT_LENGTH  | 查询的信息长度。只对 POST 请求可用。                    |
| HTTP_COOKIE     | 以键 & 值对的形式返回设置的 cookies。                 |
| HTTP_USER_AGENT | 用户代理请求标头字段，递交用户发起请求的有关信息，包含了浏览器的名称、版本和其他平台性的附加信息。 |
| PATH_INFO       | CGI 脚本的路径。                               |
| QUERY_STRING    | 通过 GET 方法发送请求时的 URL 编码信息，包含 URL 中问号后面的参数。 |
| REMOTE_ADDR     | 发出请求的远程主机的 IP 地址。这在日志记录和认证时是非常有用的。       |
| REMOTE_HOST     | 发出请求的主机的完全限定名称。如果此信息不可用，则可以用 REMOTE_ADDR 来获取 IP 地址。 |
| REQUEST_METHOD  | 用于发出请求的方法。最常见的方法是 GET 和 POST。            |
| SCRIPT_FILENAME | CGI 脚本的完整路径。                             |
| SCRIPT_NAME     | CGI 脚本的名称。                               |
| SERVER_NAME     | 服务器的主机名或 IP 地址。                          |
| SERVER_SOFTWARE | 服务器上运行的软件的名称和版本。                         |

#### cgi-c++

一个例子:

```cpp
#include <iostream>
using namespace std;
 
int main ()
{   
   cout << "Content-type:text/html\r\n\r\n";
   cout << "<html>\n";
   cout << "<head>\n";
   cout << "<title>Hello World - 第一个CPP CGI 程序</title>\n";
   cout << "</head>\n";
   cout << "<body>\n";
   cout << "<h2>Hello World! 这是我的第一个CPP CGI 程序</h2>\n";
   cout << "</body>\n";
   cout << "</html>\n";
   
   return 0;
}
```

编译上面的代码，把可执行文件命名为 cpp.cgi，并把这个文件保存在 /var/www/cgi-bin 目录中。在运行 CGI 程序之前，请使用 `chmod 755 cpp.cgi` UNIX 命令来修改文件模式，确保文件可执行。

访问可执行文件，http://localhost:/cgi-bin/cpp.cgi您会看到下面的输出:Hello World! 这是我的第一个CPP CGI 程序

真实的实例中，需要通过cgi程序执行许多操作，专门为c++程序编写的[cgi库](ftp://ftp.gnu.org/gnu/cgicc/)

##### get/post表单数据

##### cookies使用

##### 文件上传

#### cgi-python

##### get/post表单数据

##### cookies使用

##### 文件上传

#### cgi-shell

脚本语言，更多复杂的功能等请使用cpp或者python实现

##### get/post表单数据

#### cgi-perl

脚本语言，更多复杂的功能等请使用cpp或者python实现

##### get/post表单数据

 ##参考

- 基础

  [PerlCGI头库](https://stackoverflow.com/questions/22307610/end-of-script-output-before-headers-error-in-apache)

  [教你用shell写cgi程序](http://www.xinghaixu.com/archives/117)

- 进阶

  [Perl CGI编程](http://www.runoob.com/perl/perl-cgi-programming.html)

  [C++ CGI编程](http://www.runoob.com/cplusplus/cpp-web-programming.html)

  [Python CGI编程](http://www.runoob.com/python/python-cgi.html)

  [Ruby CGI编程](http://www.runoob.com/ruby/ruby-cgi.html)