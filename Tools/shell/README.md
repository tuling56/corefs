## shell学习笔记

[TOC]

### bash

### awk

### sed

> 流文本编辑器，处理行的时候十分方便。

暂存空间-->模式空间(hold sapce--> patter space)

| 命令   | 意义                                      |
| ---- | --------------------------------------- |
| g    | hold sapce--> ~~patter space[delete]~~  |
| G    | hold sapce--> patter space[append]      |
| h    | pattern sapce--> ~~hold space[delete]~~ |
| H    | pattern sapce--> hold space[append]     |
| x    | hold sapce <--> patter space            |

模式空和存储空间的参考例子：

![img](http://coolshell.cn//wp-content/uploads/2013/02/sed_demo_00.jpg)

### grep

grep查找指定类型文件的内容

```shell
find . -name *.py |xargs grep xxxx
find . -name *.py -exec grep xhh {}\;  # 这个有问题，总提示exec缺少参数
```



## 参考

- bash部分

[shell脚本8种字符串截取方法](http://www.jb51.net/article/56563.htm)

- awk部分

[awk处理多维数组](http://blog.csdn.net/ithomer/article/details/8478716)

[awk常见数组处理技巧](http://www.cnblogs.com/lixiaohui-ambition/archive/2012/12/11/2813419.html)

- sed部分

[sed简明教程](http://coolshell.cn/articles/9104.html?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)