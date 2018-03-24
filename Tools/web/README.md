## Web笔记

[TOC]

### 基础

#### URL编解码

网址URL中特殊字符的转义编码

```she
字符 - URL编码值
空格 - %20
" - %22
# - %23
% - %25
& - %26
( - %28
) - %29
+ - %2B
, - %2C
/ - %2F
: - %3A
; - %3B
< - %3C
= - %3D
> - %3E
? - %3F
@ - %40
\ - %5C
| - %7C 
```

URL特殊字符转义 

```shell
URL中一些字符的特殊含义，基本编码规则如下：
1、空格换成加号(+)
2、正斜杠(/)分隔目录和子目录
3、问号(?)分隔URL和查询
4、百分号(%)制定特殊字符
5、#号指定书签
6、&号分隔参数
如果需要在URL中用到，需要将这些特殊字符换成相应的十六进制的值
+ %2B
/ %2F
? %3F
% %25
# %23
& %26
```



#### 知识补充

##### http和https

![http&https](https://mmbiz.qpic.cn/mmbiz_jpg/Pn4Sm0RsAuiaxTry6S0jiabbia7SwYOXDq2DxCAUOYKAjahDibpvibZpsibPpeS8HRzZKM3BrkvuSv2FhtzHBnFWjkEg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1)

##### 正向代理和反向代理

###### 正向代理

![](http://p3.pstatp.com/large/39a60000f56a68371985)

​	所谓`正向代理`，是用于代理客户端的。举个很简单的例子：你直接在大陆地区访问`google.com`肯定是访问不了的，原因大家都知道，现在假如你有一台在美国的主机A，并且能够正常访问，那么你可以将浏览器对`google.com`的请求先转发给服务器A，服务器A收到请求后，扮演客户端的角色，发起对`google.com`的请求，服务器A收到响应后，又扮演服务端，将此响应原封不动的返回给你，自此，一次正向代理顺利完成。

###### 反向代理

​	`反向代理`顾名思义是用来代理服务端的。我们也举个简单的例子来说明：我们知道`google.com`没秒钟要处理如洪水般的网络请求，这些请求如果仅仅让一台单一的服务器处理，肯定是处理不过来的，我们自然而然的想到让多台服务器来处理这些请求，减少每台服务器的压力。但是现在有一个问题，多个服务器那就产生了多个IP，一般的，`google.com`只能解析到某个固定的IP（为了方便描述，我们暂且这样认为。实际情况下，通过设置也是可以让同一个域名解析到多个IP的），因为现在存在多个Server，我的一个`google.com`就不能解析到这些服务器上，而且用多个二级域名比如`server1.google.com`，`server2.google.com`等等也给用户造成了使用上的不便（一万台服务器，你咋不上天呢?），那该怎么办呢？通过反向代理可以很好的解决这个问题。

详情参考:[nginx的正向和反向代理](http://natumsol.github.io/2016/03/16/nginx-basic/)

#### 工具列表

##### httpstat

单python文件的http统计工具,无任何依赖

![](http://img2.tuicool.com/fiymIri.png!web)

安装：

```shell
# 使用pip install httpstat来安装命令行版的，然后就可以直接在命令行中使用
httpstat url 

# 直接单独文件使用
python httpstat.py url
```

参考：

[httpstat - HTTP 响应的可视化命令行工具](http://www.tuicool.com/articles/BJFRBjj)

##### http-server

[http-server](https://github.com/indexzero/http-server)是一个简单的零配置的命令行http服务器，基于nodejs

安装和使用

```shell
# 安装
npm install http-server

# 使用
http-server -p 3001
在此server的根目录下新建文件index.html，输入’hello, nginx (server 2)’
```

### 进阶

#### OSI&TCP/IP

![OSI七层网络模型](http://www.2cto.com/uploadfile/2013/1026/20131026083024168.gif)

TCP/IP五层模型

- 应用层
- 传输层
- 网络层
- 数据链路层
- 物理层

#### TCP&UDP

##### TCP

三次握手和四次挥手

![](http://p3.pstatp.com/large/46f100023c44585f5481)

##### UDP

//待补充

## 参考

- 基础

  [利用Nginx进行反向代理个负责均衡](http://natumsol.github.io/2016/03/16/nginx-basic/)

  [nginx配置正向代理和反向代理（实战）](http://www.toutiao.com/i6462125121552253454/)

- 进阶

  [OSI七层与TCP/IP五层模型（推荐）](https://www.2cto.com/net/201310/252965.html)