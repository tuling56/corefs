## shell学习笔记

[TOC]

### bash

#### 字符串操作

#### 数组操作

### awk

> 主要用于列式文本处理，进行列的分割，判断处理

shell中调用awk脚本传递参数问题,[参考](http://www.2cto.com/os/201507/412860.html):

```shell
#!/bin/bash

awk -f stat.awk	"para1=value1" "para2=value2" inputfile
#或者
./stat.awk "para1=value1" "para2=value2" inputfile

#其中stat.awk的脚本中引用变量可以采用如下的方式：
#!/usr/bin/awk -f 
BEGIN{
    a=0;
}

{
    a++;   
}

END{
    print para1"\t"a;
}
```

#### 纯awk脚本



### sed

#### 基本使用

#### 模式空间

> 流文本编辑器，处理行的时候十分方便。

暂存空间-->模式空间(hold sapce  --> patter space)

| 命令   | 意义                                      |
| ---- | --------------------------------------- |
| g    | hold sapce--> ~~patter space[delete]~~  |
| G    | hold sapce--> patter space[append]      |
| h    | pattern sapce--> ~~hold space[delete]~~ |
| H    | pattern sapce--> hold space[append]     |
| x    | hold sapce <--> patter space            |

模式空间和存储空间的参考例子：

![img](http://coolshell.cn//wp-content/uploads/2013/02/sed_demo_00.jpg)

### grep

grep查找指定类型文件的内容

```shell
find . -name *.py |xargs grep xxxx
find . -name *.py -exec grep xhh {}\;  # 这个有问题，总提示exec缺少参数
```



## 参考

- **bash部分**

[shell脚本8种字符串截取方法](http://www.jb51.net/article/56563.htm)

- **awk部分**

[awk手册](http://luy.li/data/awk.html)

[awk学习详细文档](http://www.cnblogs.com/gaoxufei/p/6058584.html)

[awk处理多维数组](http://blog.csdn.net/ithomer/article/details/8478716)

[awk常见数组处理技巧](http://www.cnblogs.com/lixiaohui-ambition/archive/2012/12/11/2813419.html)

- **sed部分**

[sed简明教程](http://coolshell.cn/articles/9104.html?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)