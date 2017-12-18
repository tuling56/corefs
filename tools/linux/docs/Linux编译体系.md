##Linux编译体系
[TOC]

### configure体系

```mermaid
graph LR
A[configure]-->B[make]
B-->C[make install]
```



#### 环境变量设置

```
For compilers to find this software you may need to set:

    LDFLAGS:  -L/usr/local/opt/openssl/lib

    CPPFLAGS: -I/usr/local/opt/openssl/include

For pkg-config to find this software you may need to set:

    PKG_CONFIG_PATH: /usr/local/opt/openssl/lib/pkgconfig
```



 ##参考

[关于configure和makefile](http://blog.csdn.net/mitesi/article/details/44759949)

[Configure，Makefile.am, Makefile.in, Makefile文件之间的关系](http://my.oschina.net/qihh/blog/66113)

[cmake手册详解系列- SirDigit - 博客园](http://www.cnblogs.com/coderfenghc/tag/cmake/)

[Linux中的configure,make,make install到底在做些什么](https://www.toutiao.com/i6465202322342412813/)