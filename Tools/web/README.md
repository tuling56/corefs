## Web笔记

[TOC]

### 知识补充

#### 正向代理和反向代理

所谓`正向代理`，是用于代理客户端的。举个很简单的例子：你直接在大陆地区访问`google.com`肯定是访问不了的，原因大家都知道，现在假如你有一台在美国的主机A，并且能够正常访问，那么你可以将浏览器对`google.com`的请求先转发给服务器A，服务器A收到请求后，扮演客户端的角色，发起对`google.com`的请求，服务器A收到响应后，又扮演服务端，将此响应原封不动的返回给你，自此，一次正向代理顺利完成。

`反向代理`顾名思义是用来代理服务端的。我们也举个简单的例子来说明：我们知道`google.com`没秒钟要处理如洪水般的网络请求，这些请求如果仅仅让一台单一的服务器处理，肯定是处理不过来的，我们自然而然的想到让多台服务器来处理这些请求，减少每台服务器的压力。但是现在有一个问题，多个服务器那就产生了多个IP，一般的，`google.com`只能解析到某个固定的IP（为了方便描述，我们暂且这样认为。实际情况下，通过设置也是可以让同一个域名解析到多个IP的），因为现在存在多个Server，我的一个`google.com`就不能解析到这些服务器上，而且用多个二级域名比如`server1.google.com`，`server2.google.com`等等也给用户造成了使用上的不便（一万台服务器，你咋不上天呢?），那该怎么办呢？通过反向代理可以很好的解决这个问题。

详情参考:[nginx的正向和反向代理](http://natumsol.github.io/2016/03/16/nginx-basic/)

### 工具列表

#### httpstat

单python文件的http统计工具,无任何依赖

![](http://img2.tuicool.com/fiymIri.png!web)

安装：

```
# 使用pip install httpstat来安装命令行版的，然后就可以直接在命令行中使用
httpstat url 

# 直接单独文件使用
 python httpstat.py url
```

参考：

[httpstat - HTTP 响应的可视化命令行工具](http://www.tuicool.com/articles/BJFRBjj)

#### http-server

[http-server](https://github.com/indexzero/http-server)是一个简单的零配置的命令行http服务器，基于nodejs

安装和使用

```shell
# 安装
npm install http-server

# 使用
http-server -p 3001
在此server的根目录下新建文件index.html，输入’hello, nginx (server 2)’
```

## 参考

[利用Nginx进行反向代理个负责均衡](http://natumsol.github.io/2016/03/16/nginx-basic/)