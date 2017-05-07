## Perl学习笔记

[TOC]

### 基础

#### 运行方式

交互式编程

```
perl -e 'print "Hello World\n"'
```

脚本编程

```perl
#!/usr/bin/perl

# 输出 "Hello, World"   # 这是perl单行注释方法
print "Hello, world\n";

=pod注释名称
这是一个多行注释
\=pod、 \=cut只能在行首。
以=开头，以=cut结尾。
\=后面要紧接一个字符，=cut后面可以不用。
=cut
```

然后执行`chmod 0755 hello.pl && ./hello.pl`,或者`perl hello.pl` 

#### 数据类型

perl是弱类型的语言， 所以变量不需要指定类型，perl解释器会根据上下文自动选择匹配的类型。

perl有三个基本的数据类型：变量、数组和哈希

**标量**

```perl
# 在变量名前加一个$代表标量，数据类型可以是字符串，数字和浮点数
$myfirst=123;　    #数字123　
$mysecond="123";   #字符串123　
$mysecond=233.23;   #浮点数　
```

**数组**

```perl
# 数组变量以字符"@"开头，索引从0开始，如：@arr=(1,2,3)
@arr=(1,2,3)
```

详细的数组操作参考菜鸟教程

**哈希**

```perl
# 哈希是一个无序的 key/value 对集合。可以使用键作为下标获取值。哈希变量以字符"%"开头。
%h=('a'=>1,'b'=>2); 
```

#### 控制语句

##### 条件控制

| 语句                                       | 描述                                       |
| ---------------------------------------- | ---------------------------------------- |
| [if 语句](http://www.runoob.com/perl/perl-if-statement.html) | 一个 **if 语句** 由一个布尔表达式后跟一个或多个语句组成。        |
| [if...else 语句](http://www.runoob.com/perl/perl-if-else-statement.html) | 一个 **if 语句** 后可跟一个可选的 **else 语句**，else 语句在布尔表达式为假时执行。 |
| [if...elsif...else 语句](http://www.runoob.com/perl/perl-if-elsif-statement.html) | 您可以在一个 **if** 语句后可跟一个可选的 **elsif 语句**，然后再跟另一个 **else 语句**。 |
| [unless 语句](http://www.runoob.com/perl/perl-unless-statement.html) | 一个 **unless 语句** 由一个布尔表达式后跟一个或多个语句组成。    |
| [unless...else 语句。](http://www.runoob.com/perl/perl-unless-else-statement.html) | 一个 **unless 语句** 后可跟一个可选的 **else 语句**。   |
| [unless...elsif..else statement](http://www.runoob.com/perl/perl-unless-elsif-statement.html) | 一个 **unless 语句** 后可跟一个可选的 **elsif 语句**，然后再跟另一个 **else 语句**。 |
| [switch 语句](http://www.runoob.com/perl/perl-switch-statement.html) | 在最新版本的 Perl 中，我们可以使用 **switch** 语句。它根据不同的值执行对应的代码块。 |

##### 循环控制

循环类型

| 循环类型                                     | 描述                                       |
| ---------------------------------------- | ---------------------------------------- |
| [while 循环](http://www.runoob.com/perl/perl-while-loop.html) | 当给定条件为 true 时，重复执行语句或语句组。循环主体执行之前会先测试条件。 |
| [until 循环](http://www.runoob.com/perl/perl-until-loop.html) | 重复执行语句或语句组，直到给定的条件为 true。 循环主体执行之前会先测试条件。 |
| [for 循环](http://www.runoob.com/perl/perl-for-loop.html) | 多次执行一个语句序列，简化管理循环变量的代码。                  |
| [foreach 循环](http://www.runoob.com/perl/perl-foreach-loop.html) | foreach 循环用于迭代一个列表或集合变量的值。               |
| [do...while 循环](http://www.runoob.com/perl/perl-do-while-loop.html) | 除了它是在循环主体结尾测试条件外，其他与 while 语句类似。         |
| [嵌套循环](http://www.runoob.com/perl/perl-nested-loops.html) | 您可以在 while、for 或 do..while 循环内使用一个或多个循环。 |

循环控制语句

> 循环控制语句改变了代码的执行顺序，通过它你可以实现代码的跳转。

| 控制语句                                     | 描述                                       |
| ---------------------------------------- | ---------------------------------------- |
| [next 语句](http://www.runoob.com/perl/perl-next-statement.html) | 停止执行从next语句的下一语句开始到循环体结束标识符之间的语句，转去执行continue语句块，然后再返回到循环体的起始处开始执行下一次循环。 |
| [last 语句](http://www.runoob.com/perl/perl-last-statement.html) | 退出循环语句块，从而结束循环                           |
| [continue 语句](http://www.runoob.com/perl/perl-continue-statement.html) | continue 语句块通常在条件语句再次判断前执行。              |
| [redo 语句](http://www.runoob.com/perl/perl-redo-statement.html) | redo 语句直接转到循环体的第一行开始重复执行本次循环，redo语句之后的语句不再执行，continue语句块也不再执行； |
| [goto 语句](http://www.runoob.com/perl/perl-goto-statement.html) | Perl 有三种 goto 形式：got LABLE，goto EXPR，和 goto &NAME。 |

#### 运算符

- [算术运算符](http://www.runoob.com/perl/perl-operators.html#Arithmetic)
- [比较运算符](http://www.runoob.com/perl/perl-operators.html#Equality)
- [逻辑运算符](http://www.runoob.com/perl/perl-operators.html#Logical)
- [赋值运算符](http://www.runoob.com/perl/perl-operators.html#Assignment)
- [位运算符](http://www.runoob.com/perl/perl-operators.html#Bitwise)
- [引号运算符](http://www.runoob.com/perl/perl-operators.html#Quote)
- [其他运算符](http://www.runoob.com/perl/perl-operators.html#Miscellaneous)
- [运算符优先级](http://www.runoob.com/perl/perl-operators.html#Precedence)

#### 子程序（函数）

变量的传递（标量，数组和哈希）

变量的作用域

函数的返回值

#### 引用

引用就是指针，perl引用是一个标量类型可以窒息变量，数组和哈希（关联数据组）甚至子程序

#### 格式化输出

perl是一个非常强大的文本数据处理语言，perl中可以使用format来定义一个模板，然后使用write按指定模板输出数据

> 这部分比较繁琐啊

#### 错误处理

待完善

#### 包和模块

包又称为符号表，

```perl
package mypack;
```

此语句定义一个名为 **mypack** 的包，在此后定义的所有变量和子程序的名字都存贮在该包关联的符号表中，直到遇到另一个 **package** 语句为止。

每个符号表有其自己的一组变量、子程序名，各组名字是不相关的，因此可以在不同的包中使用相同的变量名，而代表的是不同的变量。

从一个包中访问另外一个包的变量，可通过" 包名 + 双冒号( :: ) + 变量名 " 的方式指定。

存贮变量和子程序的名字的默认符号表是与名为 main的包相关联的。如果在程序里定义了其它的包，当你想切换回去使用默认的符号表，可以重新指定main包.

##### begin和end模块

用于在程序体运行前或者运行后执行

```perl
#!/usr/bin/perl

package Foo;
print "Begin 和 Block 实例\n";

BEGIN { 
    print "这是 BEGIN 语句块\n" 
}

END { 
    print "这是 END 语句块\n" 
}
```

##### 模块的引入

require和use

##### 模块的制作

待完成

#### 进程管理

变量环境的传递，子进程的退出和进入

### 应用

#### 日期时间操作

时间的获取：localtime,time()和gmtime()

日期时间的格式化：strftime()

#### socket编程

套接字，向网络发出请求或者应答请求，使主机间或者一台计算机上的进程间可以通讯 。

#### 发送邮件

```shell
## step3: 邮件报警 ###########
logf=$datapath/mcheck_${hostn}_${date}.txt
logm="$date from ${hostn} hadoop check and calc log"
MAIL_TO="zhangxiaoer@cc.sandai.net"
if [ -f $logf ];then
	/usr/local/monitor-base/bin/sendEmail -s mail.xx.sandai.net -f monitor@xx.sandai.net -xu monitor@xx.sandai.net -xp 121212 -o message-charset=utf8 -t ${MAIL_TO} -u "$logm" -m "$logm" -a "$logf"
fi
```

#### ==正则表达式==

perl正则描述了一种字符串匹配的模式，可以用来检测一个串是否含有某种子串，讲匹配的子串做替换或者从个串中去除符合某个条件的子串等。

perl的正则表达是最强大的，主要有以下匹配、替换和转化三种：

- 匹配：m//（还可以简写为//，略去m）
- 替换：s///
- 转化：tr///

这三种形式一般都和 **=~** 或 **!~** 搭配使用（=~ 表示相匹配，!~ 表示不匹配）。

缺乏分组和前向匹配和后向匹配是说明

#### 数据库操作

基本的查询完成，但数据库的事务等还没涉及

#### CGI操作

文件的上传下载等操作也需要完善

##  参考

[菜鸟网络Perl教程](http://www.runoob.com/perl/perl-process-management.html)