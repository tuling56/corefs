## shell学习笔记

[TOC]

### bash

#### 字符串操作

参考

[shell脚本8种字符串截取方法](http://www.jb51.net/article/56563.htm)

#### 数组操作

#### 积累

##### 文件重命名

``` sh
# 第一种实现 find+awk+sh
find . -maxdepth 1 -type f | awk '!/png$/{print "mv" $1,$1".png" }' |sh

# 第二种实现 for+sed实现
for sql in `find /root -name “*.sql”`;do  mv $sql `echo $sql|sed  ‘s/sql/txt/'` ;done

# 第三种实现 rename
rename  .sql  .txt *.sql  //好像不能递归目录,其中最后一个是要修改文件类型的列表

# find+xargs+sed
```

参考：

[Shell脚本批量重命名文件后缀的3种实现](http://www.jb51.net/article/55255.htm)

[Shell重命名（智慧大碰撞）](http://www.oschina.net/question/75009_111550)

### awk

> 主要用于列式文本处理，进行列的分割，判断处理

#### 基础

基本

```
# getline 语句
实现两个文件的同步读取，当然另一种方法是利用字典实现
```



循环

```shell
# while,for循环语句
awk '{ i = 1; while ( i <= NF ) { print NF,$i; i++}}' test
awk '{for (i = 1; i<NF; i++) print NF,$i}' test

# break语句
用于在满足条件的情况下跳出循环；

# continue语句
用于在满足条件的情况下忽略后面的语句，直接返回循环的顶端。

# next语句
next语句从输入文件中读取一行，然后从头开始执行awk脚本

# exit语句
exit语句用于结束awk程序，但不会略过END块。退出状态为0代表成功，非零值表示出错。
```

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

awk脚本

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

awk数组[(参考)](http://blog.csdn.net/beyondlpf/article/details/7024730)

```shell
awk 'BEGIN{a[0,0]=12;a[1,1]=13;}END{for(k in a) {print k,a[k];split(k,idx,SUBSEP);print idx[1],idx[2],a[idx[1],idx[2]]}}' </dev/null
```

#### 应用

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

awk计算文件重合度

```shell
# 同时会给出两个文件各自的行数
awk '{if(NR==FNR){a[$1]=$1;overlap_num=0;f1num=f1num+1;}else{if($1 in a) overlap_num++;}}END{print ARGV[1]"\t"f1num"\n"ARGV[2]"\t"FNR"\noverlap\t"overlap_num}' file1 file2  
```

awk计算时间差（[参考](http://bbs.chinaunix.net/forum.php?mod=viewthread&tid=2316841&page=1#pid15618823)）

``` shell
awk -v s="20110510" -v t="20110605" 'BEGIN{"date +%s -d "s|getline a;"date +%s -d "t|getline b;print (b/3600-a/3600)/24}'
```



### sed

#### 基础

##### 模式空间

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



### 参考

- **awk部分**

[awk手册](http://luy.li/data/awk.html)

[awk学习详细文档](http://www.cnblogs.com/gaoxufei/p/6058584.html)

[awk处理多维数组](http://blog.csdn.net/ithomer/article/details/8478716)

[awk常见数组处理技巧](http://www.cnblogs.com/lixiaohui-ambition/archive/2012/12/11/2813419.html)

[awk 内置变量使用介绍](http://blog.jobbole.com/92494/)

[awk 内置函数详细介绍（实例）](http://blog.jobbole.com/92497/)

[awk运算符介绍](http://blog.csdn.net/gaoming655/article/details/7390207)

[awk中的输入和输出重定向](http://blog.chinaunix.net/uid-10540984-id-356795.html)

- **sed部分**

[sed简明教程](http://coolshell.cn/articles/9104.html?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)

- grep部分



## 效率工具

文件自动备份

### 参考

[Rsync与inotify 进行实时同步](http://www.toutiao.com/i6351627805494608385/)