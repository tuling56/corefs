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

```shell
#!/usr/bin/awk -f
# 弹幕日志统计的awk实现
# 日期:2017年1月23日
# 作者：tuling56

#日志格式(标准的日志格式)：
#27.27.28.235 - - [21/Dec/2016:14:13:01 +0800] "GET /getID?type=local&key=A451D48686CBE4BB9A9575F51D2591E1E724C060&duration=148654&subkey=312235673&md5=84b14712129a5ba0eedf3e6b92263e3b HTTP/1.1" 200 81 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)"

BEGIN{FS="\""}

{  
 	print "-----------------------------------------------"
 	if($3~/200/)
	{
		num200++;
		# part1:请求时间（计算峰值访问量）
		split($1,iptime,"[");
		split(iptime[2],dtime," ");
		reqtime=substr(dtime[1],1,17)
		reqfreq[reqtime]++;
		print reqtime

		# part2:请求体解析
		split($2,url," ");
		split(url[2],urlparas,"?");

		## url请求类型统计（计算每个类别的访问量）
		urltype=urlparas[1];
		urltypenum[urltype]++;

		## GET参数解析
		paras_str=urlparas[2];
		paras_len=split(paras_str,paras,"&");
		print urltype,paras_str;
		for(i=1;i<paras_len;i++)
			print paras[i];
	}
	else if($2~/favicon\.ico/ && $3~/404/)
 	{
		error404++;
	}
 	else
 	{
		unerror++;
	}

}

END{  # 这个括号不能移到下一行
	print "===============信息汇总======================";
	# 总请求量
	tnum=num200+error404+unerror;
	print tnum,error404,unerror;

	#峰值请求量
	for(tmf in reqfreq)
	{
		print tmf,reqfreq[tmf]|"sort -r -n -k2";
	}

	#类别访问量
	for(cl in urltypenum)
	{
		print cl,urltypenum[cl]|"sort -r -n -k2";
	}
}

```

#### awk数组

[参考1](http://blog.csdn.net/beyondlpf/article/details/7024730)

```shell
awk 'BEGIN{a[0,0]=12;a[1,1]=13;}END{for(k in a) {print k,a[k];split(k,idx,SUBSEP);print idx[1],idx[2],a[idx[1],idx[2]]}}' </dev/null
```

多维数组统计

```shell
# 数据格式（按第一列汇总，求第二列和第三列的和）
anime	6645	3776
movie	40184	20706
teleplay	30341	15223
tv	6232	3746
anime	206	106
documentary	418	172
femalestars	342	146
joke	618	232
lovers	11	9
malestars	22	10
vmovie	745	299
mvzhibo	3879	2263
zhibo	2332	1447

# 统计程序
awk '{if (a in arr) {split(arr[a],puv,"\t");pv=puv[1]+$2;uv=puv[2]+$3;} else arr[$1]=$2"\t"$3;}END{ for(a in arr) print a,arr[a]|"sort -rn -k2"}' 
```

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