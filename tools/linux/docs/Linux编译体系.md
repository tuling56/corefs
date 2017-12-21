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

配置环境量`LDFLAGS`、`CFLAGS`、`CPPFLAGS`的方法:

```shell
export LDFLAGS="$LDFALGS　-L/path1/ -L/path2/"
export CFLAGS="$LDFALGS　-I/path1/ -I/path2/"
export CPPLAGS="$LDFALGS　-I/path1/ -I/path2/"
# 注意不同路径之间是有空格分割，不同于PATH路径的':'分割
```

此外，可以通过`LD_LIBRARY_PATH`环境变量来配置库的搜索路径

```shell
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/usr/local/opencv/lib:/usr/local/opencv3/lib
```

#### pkg-config

```shell
# 查看包含目录
[root@local122 pkgconfig]# pkg-config --cflags opencv2
-I/usr/local/opencv/include/opencv -I/usr/local/opencv/include 

# 查看库目录
[root@local122 pkgconfig]# pkg-config --libs opencv2
-L/usr/local/opencv/lib -lopencv_calib3d -lopencv_contrib -lopencv_core -lopencv_features2d -lopencv_flann -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lopencv_nonfree -lopencv_objdetect -lopencv_ocl -lopencv_photo -lopencv_stitching -lopencv_superres -lopencv_ts -lopencv_video -lopencv_videostab -lrt -lpthread -lm -ldl 

# 查看pkg-config格式的opencv2配置文件
[root@local122 pkgconfig]# cat opencv2.pc 
# Package Information for pkg-config

prefix=/usr/local/opencv
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir_old=${prefix}/include/opencv
includedir_new=${prefix}/include

Name: OpenCV
Description: Open Source Computer Vision Library
Version: 2.4.13
Libs: -L${exec_prefix}/lib -lopencv_calib3d -lopencv_contrib -lopencv_core -lopencv_features2d -lopencv_flann -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lopencv_nonfree -lopencv_objdetect -lopencv_ocl -lopencv_photo -lopencv_stitching -lopencv_superres -lopencv_ts -lopencv_video -lopencv_videostab -lrt -lpthread -lm -ldl
Cflags: -I${includedir_old} -I${includedir_new}
```

> 为了让pkg-config能找到opencv2.pc这个配置文件，需要先配置opencv2.pc文件所在的路径到PKG_CONFIG_PATH环境变量里，格式如下:
>
> ```shell
> export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig:/usr/local/opencv/lib/pkgconfig/:/usr/local/opencv3/lib/pkgconfig/
> ```

 ##参考

[关于configure和makefile](http://blog.csdn.net/mitesi/article/details/44759949)

[Configure，Makefile.am, Makefile.in, Makefile文件之间的关系](http://my.oschina.net/qihh/blog/66113)

[cmake手册详解系列- SirDigit - 博客园](http://www.cnblogs.com/coderfenghc/tag/cmake/)

[Linux中的configure,make,make install到底在做些什么](https://www.toutiao.com/i6465202322342412813/)

[gcc指定头文件路径及动态链接库路径 - 开源中国社区（推荐）](http://www.oschina.net/question/565065_115133)