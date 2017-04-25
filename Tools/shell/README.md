## Shell学习笔记

[TOC]

### bash

#### 基础

目录和文件判断

```shell
-e #filename 如果 filename存在，则为真
-d #filename 如果 filename为目录，则为真 
-f #filename 如果 filename为常规文件，则为真
-L #filename 如果 filename为符号链接，则为真
-r #filename 如果 filename可读，则为真 
-w #filename 如果 filename可写，则为真 
-x #filename 如果 filename可执行，则为真
-s #filename 如果文件长度不为0，则为真
-h #filename 如果文件是软链接，则为真
filename1 -nt filename2 #如果 filename1比 filename2新，则为真。
filename1 -ot filename2 #如果 filename1比 filename2旧，则为真。
-eq #等于
-ne #不等于
-gt #大于
-ge #大于等于
-lt #小于
-le #小于等于
#至于！号那就是取非
```

##### 字符串

按分割符截取(4种)

```shell
var=http://www.aaa.com/123.htm
1. # 号截取，删除左边字符，保留右边字符。
echo ${var#*//}
# 其中 var 是变量名，# 号是运算符，*// 表示从左边开始删除第一个 // 号及左边的所有字符, 即删除 http://
# 结果是 ：www.aaa.com/123.htm

2. ## 号截取，删除左边字符，保留右边字符。
echo ${var##*/}
##*/ 表示从左边开始删除最后（最右边）一个 / 号及左边的所有字符
# 即删除 http://www.aaa.com/
# 结果是 123.htm

3. %号截取，删除右边字符，保留左边字符
echo ${var%/*}
# %/* 表示从右边开始，删除第一个 / 号及右边的字符
# 结果是：http://www.aaa.com

4. %% 号截取，删除右边字符，保留左边字符
echo ${var%%/*}
# %%/* 表示从右边开始，删除最后（最左边）一个 / 号及右边的字符
# 结果是：http:
```

按开始位置和数量截取(4种)

```shell
# 从左边第几个字符开始，及字符的个数
echo ${var:0:5}   #其中的 0 表示左边第一个字符开始，5 表示字符的总个数。

# 从左边第几个字符开始，一直到结束
echo ${var:7}

# 从右边第几个字符开始，及字符的个数
echo ${var:0-7:3}  #其中的 0-7 表示右边算起第七个字符开始，3 表示字符的个数。

# 从右边第几个字符开始，一直到结束
echo ${var:0-7}
```

**参考**

[shell脚本8种字符串截取方法](http://www.jb51.net/article/56563.htm)

##### 数组

读取

```shell

```

删除

```shell

```

赋值

```shell

```

分片

```shell

```

替换

```shell
# ${数组名[@或*]/查找字符/替换字符} 该操作不会改变原先数组内容，如果需要修改，可以看上面例子，重新定义数据。
```

#### 应用

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

> 主要用于列式文本处理，进行列的分割，判断处理。

```shell
awk 'BEGIN{ print "start" } pattern{ commands } END{ print "end" }' file
```



#### 基础

##### 基本

```
# getline 语句
实现两个文件的同步读取，当然另一种方法是利用字典实现
```

##### 循环

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

##### 向awk脚本传参

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

参考：

[shell中调用awk脚本传递参数问题](http://www.2cto.com/os/201507/412860.html)

##### awk脚本

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

##### awk数组

```shell
awk 'BEGIN{a[0,0]=12;a[1,1]=13;}END{for(k in a) {print k,a[k];split(k,idx,SUBSEP);print idx[1],idx[2],a[idx[1],idx[2]]}}' </dev/null
```

参考:

[awk数组的使用](http://blog.csdn.net/beyondlpf/article/details/7024730)

#### 应用

##### awk区间统计

问题描述，给出一堆数据，然后将该堆数据进行分组（分组区间自己指定），然后统计每个分组内的个数

```shell
# 统计落在每个区间段内的数量
awk '{intfloat=$1/500;split(intfloat,intn,".");v=intn[1];dict[v]++;}END{for(i in dict) print i*500"\t"i*500"~"(i+1)*500"\t"dict[i]|"sort -n -k1"}'  view_num

#改进版（利用awk提供的int函数，获取除法的整数部分）
awk '{v=int($1/500);dur[v]++;}END{for(i in dur) print i*500"\t"i*500"~"(i+1)*500"\t"dur[i]|"sort -n -k1"}'  view_num
```

##### awk多维数组统计

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

##### awk计算文件重合度

```shell
# 同时会给出两个文件各自的行数
awk '{if(NR==FNR){a[$1]=$1;overlap_num=0;f1num=f1num+1;}else{if($1 in a) overlap_num++;}}END{print ARGV[1]"\t"f1num"\n"ARGV[2]"\t"FNR"\noverlap\t"overlap_num}' file1 file2  
```

##### awk计算时间差

``` shell
awk -v s="20110510" -v t="20110605" 'BEGIN{"date +%s -d "s|getline a;"date +%s -d "t|getline b;print (b/3600-a/3600)/24}'
```

参考：

[awk计算时间差](http://bbs.chinaunix.net/forum.php?mod=viewthread&tid=2316841&page=1#pid15618823)

##### awk输入输出重定向

> 输出重定向：

```shell
awk '$1=100{print $1 > "output_file"}' file
```

> 输入重定向：

输入重定向需用到getline函数。getline从标准输入、管道或者当前正在处理的文件之外的其他输入文件获得输入。它负责从输入获得下一行的内容，并给NF,NR和FNR等内建变量赋值。如果得到一条记录，getline函数返回1，如果到达文件的末尾就返回0，如果出现错误，例如打开文件失败，就返回-1。如：

可以在awk中直接执行shell命令

```shell
awk 'BEGIN{"date"|getline d;split(d,a);print a[2]}'

# 执行linux的date命令，并通过管道输出给getline，然后再把输出赋值给自定义变量d，并以默认空格为分割符把它拆分开以数字1开始递增方式为下标存入数组a中，并打印数组a下标为2的值。下面我们再看看一些复杂的运用。
```

在awk中

```

```



### sed

[sed](http://man.linuxde.net/sed)是一种流编辑器，它是文本处理中非常中的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出。Sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。

#### 基础

打印匹配行和行号

```shell
#方法1
sed -n '/6645/{=;p; }' awk.data

# 方法2
sed -n -e '/6645/=' -e '/6645/p' awk.data

# 方法3
sed -n '/6645/=;/6645/p' awk.data

#结果如下(注意结果是换行了，如何在一行上显示呢，需要使用到模式空间的互换了)
1
anime   6645    3776

#### 显示匹配行和行号
sed -n '/6645/{=;p}' awk.data |sed 'N;s/\n/\t/' 
```

删除匹配行的下一行、

```shell
sed -n '/root/{n;d}'  /etc/passwd 		#将匹配root行的下一行删除 
```

删除匹配行和下一行

```shell
sed -n '/root/{N;d}' /etc/passwd 		# 将匹配root行和下一行都删除  
```

合并相邻行

```shell
sed 'N;s/\n/:/' /etc/passwd 		# 合并相邻行，并用：分割（注意不要添加-n选项，不然无输出）
# awk实现是
awk '{if(NR%2==0){printf $0 "\n"}else{printf "%s\t",$0}}' /etc/passwd
```

退出命令

```shell
sed '/hrwang/{s/hrwang/HRWANG/;q;}' datafile  #匹配到hrwang的行处理后就退出sed程序
```



##### 模式空间

> 流文本编辑器，处理行的时候十分方便。

暂存空间(hold sapce )-->模式空间(patter space)

| 命令   | 意义                                      |
| ---- | --------------------------------------- |
| g    | hold sapce--> ~~patter space[delete]~~  |
| G    | hold sapce--> patter space[append]      |
| h    | pattern sapce--> ~~hold space[delete]~~ |
| H    | pattern sapce--> hold space[append]     |
| x    | hold sapce <--> patter space            |

模式空间和存储空间的参考例子：

![img](http://coolshell.cn//wp-content/uploads/2013/02/sed_demo_00.jpg)

##### 向sed命令中传递变量

```shell
ststr=`date +%d\\\/%b\\\/%Y:%H`	# 这个日期的转换，在脚本内要使用三个\才能代表一个\，脚本外可使用两个
sed -n "/${ststr}/p" ${log_path}/${log} > ${log_path_bak}/${log}_${datehour}
# 注意使用双引号，而不是单引号，这样变量才能传递过去
```

##### sed脚本

**从文件读入命令**

```shell
sed -f sedscript.sh
```

> sedscript.sh的内容如下：
>
> ```shell
> !/bib/sed -f
> s/root/yerik/p  
> s/bash/csh/p
> ```

Sed对于脚本中输入的命令非常挑剔，在命令的末尾不能有任何空白或文本，如果在一行中有多个命令，要用分号分隔。以#开头的行为注释行，且不能跨行

**直接运行脚本**

```shell
chmod u+x
./sedscript.sh xxxxfile
```

#### 应用



### grep

grep查找指定类型文件的内容

```shell
find . -name *.py |xargs grep xxxx
find . -name *.py -exec grep xhh {}\;  # 这个有问题，总提示exec缺少参数
```



### 参考

- **bash部分**

[linux参数太长的换行问题](http://blog.csdn.net/feng27156/article/details/39057773)

- **awk部分**

[awk手册](http://luy.li/data/awk.html)

[awk快速指南](http://man.linuxde.net/awk)(推荐)

[awk学习详细文档](http://www.cnblogs.com/gaoxufei/p/6058584.html)

[awk处理多维数组](http://blog.csdn.net/ithomer/article/details/8478716)

[awk常见数组处理技巧](http://www.cnblogs.com/lixiaohui-ambition/archive/2012/12/11/2813419.html)

[awk 内置变量使用介绍](http://blog.jobbole.com/92494/)

[awk 内置函数详细介绍（实例）](http://blog.jobbole.com/92497/)

[awk运算符介绍](http://blog.csdn.net/gaoming655/article/details/7390207)

[awk中的输入和输出重定向](http://blog.chinaunix.net/uid-10540984-id-356795.html)（推荐）

- **sed部分**

[sed简明教程](http://coolshell.cn/articles/9104.html?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)

[Linuxsed命令](http://man.linuxde.net/sed)

- grep部分



## 效率工具

文件自动备份

### 参考

[Rsync与inotify 进行实时同步](http://www.toutiao.com/i6351627805494608385/)