## Shell笔记

[TOC]

### bash

shell的分类，zsh和bash的区别

#### 基础

##### 变量

###### 变量命名

- var='harer'   #注意=号两边不能有空格shell变量区分大小写，引用的使用采\$var或者${var}
- 变量的名称可以包含只有字母（a到z或A到Z），数字（0〜9）或下划线（_）,且必须以字母或者下划线开头，不能以数字开头

###### 变量替换

![变量替换](http://tuling56.site/imgbed/2018-08-02_125729.png)

变量替换的应用

```shell
# 若没有替换变量，则使用指定的字符
KK_WORKSPACE=${KK_WORKSPACE:-"/usr/local/sandai/server"}
```

##### 字符串

###### 字符串截取

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

>  参考:[shell脚本8种字符串截取方法](http://www.jb51.net/article/56563.htm)

###### 字符串替换

```shell
b=${a/123/321}  # 将${a}里的第一个123替换为321
b=${a//123/321} # 将${a}里的所有123替换为321
```

###### 字符串匹配

```shell
# 方式0（利用第三方匹配）
export LANG=zh_CN.UTF-8
A="米饭 + 爆炒牛肉 + 豉汁肉片 + 蒜蓉芥蓝"
B="牛肉"
echo $A | grep "$B" &>/dev/null  # 该等同于echo $A | grep -q "$B" 抑制grep的输出
test $? -eq 0 && echo "[Match]:$A include $B" ||echo "[NotMatch]:$A  not include $B"
if [[ $? == 0 ]]; then
   echo "[Match]:$A include $B"
else
   echo "[NotMatch]:$A  not include $B"
fi

# 方式1（利用bash的匹配）
A="米饭 + 爆炒牛肉 + 豉汁肉片 + 蒜蓉芥蓝"
F="牛肉"
if [[ $A =~ $F ]] ; then echo "$A include $F" ;else echo "$A not include $F";fi

# 方式2(注意不要加[],此处不利用返回值)
if  echo "aha"|grep "x" &>/dev/null ;then echo "find";else echo "no find";fi
```

> 参考：[linux shell中做匹配](https://segmentfault.com/q/1010000000504746)，可进一步参考awk中的字段匹配

###### 字符串分割

如何在一次处理中得到各个分割后的各个字段，shell的默认的数组分割符号是空白字符

方法1:替换空白字符为其它字符

```shell
str1="hello,ni,nihao"
# 方法1
array=(${str1//,/ })
for s in ${array[@]};do
	echo "m1:"$s
done
```

方法2:替换其它字符为分割符

```shell
str1="hello,ni,nihao"
OLD_IFS="$IFS"
IFS=","
array=($str1)
IFS="${OLD_IFS}"
for s in ${array[@]};do
	echo "m2:"$s
done
```

##### 数组

###### [普通数组](http://www.cnblogs.com/chengmo/archive/2010/09/30/1839632.html)

读取

```shell
a=(1 2 3 4 5)

# 取单个
echo ${a[0]}

# 取所有
echo ${a[@]} # 或者echo ${a[*]}

# 取长度
lentmp=${#a[@]}
len=$((lentmp-1))
```

遍历

```shell
# 遍历
for i in `seq 0 $((${#a[@]}-1))`;do
	if [ $i -eq '0'];then
		echo -n ${line:0:4}"/"${line:4:2}"/"${line:6:2}
	else
		echo -en "\t"$i
	fi
	echo 
done

#并行遍历(要求两个数组一样长)
a=(1 2 3 4 5)
b=('a' 'b' 'c' 'd' 'e')
for i in `seq 0 $((${#a[@]}-1))`;do
    echo  "${a[$i]}:${b[$i]}"
done

# 笛卡尔积
a=(1 2 3 4 5)
b=('a' 'b' 'c' 'd' 'e')
for i in `seq 0 $((${#a[@]}-1))`;do
	for j in `seq 0 $((${#b[@]}-1))`;do
    	echo  "${a[$i]}:${b[$j]}"
    done
done
```

删除

```shell
unset a
echo ${a[*]}  # 结果为空

unset a[1]
echo ${a[*]}  # 结果为1 3 4 5
echo ${#a[*]} # 结果为4
```

赋值

```shell
a=(1 2 3 4 5)
a[1]=100
echo ${a[*]} # 结果为1 100 2 3 4 5
```

分片

```shell
echo ${a[@]:0:3}  # 结果为 1 2 3
# 直接通过 ${数组名[@或*]:起始位置:长度} 切片原先数组，返回是字符串，中间用“空格”分开，因此如果加上”()”，将得到切片数组，上面例子：c 就是一个新数据
```

替换

```shell
# ${数组名[@或*]/查找字符/替换字符} 该操作不会改变原先数组内容，如果需要修改，可以看上面例子，重新定义数据。
a=(${a[@]/3/100})

a=(1 2 323 4 5)
a=(${a[@]/3/100})
a=(${a[@]//3/100})  # 此处的替换逻辑遵循字符串的替换逻辑
```

###### 关联数组

读取

```shell
echo ${!garray[*]}   	#取关联数组所有键  
echo ${!garray[@]}  	#取关联数组所有键  
echo ${garray[*]}       #取关联数组所有值  
echo ${garray[@]}      	#取关联数组所有值  
echo ${#garray[*]}  	#取关联数组长度  
echo ${#garray[@]} 		#取关联数组长度  
```

创建

```shell
# 方法1：(先声明)
declare -A garray
garray["jim"]=158  
garray["amy"]=168
# 方法2：(直接使用内嵌“索引-值”列表法：)
array=(["jim"]=158 ["amy"]=168)  
```

遍历

```shell
# 以key的方式遍历
for key in ${!garray[*]};do  
    echo "key:"$key
    echo "value:"${garray[$key]}
done

# 以value的方式遍历
for value in ${garray[*]};do  
    echo "value:"${value}
done
```

删除

```shell
# 清空数组元素
# 但是这样清空后，garray中仍有“fe”这个key，只是其对应的值被清空了 
unset garray["fe"]

# 清空数组
# 但是这样清空后，array的key是没有了，但是整个garray也不能再用了，不再是关联数组，需要重新声明使用：
unset garray
```

累加

```shell
# 关联数组累加
function arr_dict_sum(){
    declare -A anum
    for item in a a b c d e f g k a c b d;do
        anum[$item]=$((${anum[$item]}+1));
    done

    for k in ${!anum[*]};do
        echo "$k:${anum[$k]}"
    done
}

#例子：单词计数
function words_conut()
{
    declare -A cn
    while read line;do
        for w in $line;do
            cn[$w]=$((${cn[$w]}+1))
        done
    done < words.txt
    
    res=""
    for wc in ${!cn[*]};do
        if [ -z $res ];then
            ct="$wc\t${cn[$wc]}"
        else
            ct="\n$wc\t${cn[$wc]}"
        fi
        res="$res$ct"
    done

    echo -e "$res"|sort -k2 -rn
}
```

判断key是否在关联数组中

```shell
function isinkey(){  
    for key in ${!count_result[*]};do  
      if [ "$1" = "$key" ];then  
        return 1  
      fi  
    done  
    return 0  
} 
```

数组参数

```shell
function f1(){  
  declare -a array  
  array[0]="h1"  
  array[1]="h2"  
  arr=`echo "${array[*]}"`  
  local val="h1"  
  f2 $val $arr  
}  
function f2(){  
  local arr2=`echo "$2"`  
  for value in ${arr2[*]};do  
     echo "value: $value"  
  done  
} 
```

> 尚存在问题没有解决，只能传递数组的第一个值

##### 输入输出

###### 输入

标准输入

```shell
#!/bin/bash
# substr(fu1,2,5),fu2,fu5,fu7,fip,finsert_time
# 2A5F8   [3,0,8] ["5486","0","0"]        0,1,0   124.91.9.111    1517673596
while read line;do
    infos=($line)
    echo -e -n "hahh:${infos[0]}\t${infos[1]}\t${infos[2]}\t${infos[3]}\t${infos[4]}"
    ds=`date -d @${infos[5]} "+%Y-%m-%d"`
    echo -e -n "${ds}\n"
done
```

输入重定向

```shell
#!/bin/bash
# substr(fu1,2,5),fu2,fu5,fu7,fip,finsert_time
# 2A5F8   [3,0,8] ["5486","0","0"]        0,1,0   124.91.9.111    1517673596
while read line;do
    infos=($line)
    echo -e -n "hahh:${infos[0]}\t${infos[1]}\t${infos[2]}\t${infos[3]}\t${infos[4]}"
    ds=`date -d @${infos[5]} "+%Y-%m-%d"`
    echo -e -n "${ds}\n"
done < test.data
```

###### 输出

标准输出

```shell
# echo
echo "xxxx"

# printf
printf "%s %s %s\n" a b c d e f g h i j
printf "%-6s %-6s %-6s\n" a b c d e f g h i j  # 等宽输出
printf "%s\t\t%s\t%s\n" a b c d e f g h i j
```

输出重定向

```shell
sh xxx.sh > xxx.log 2>&1 
```

颜色修饰：[参考shell颜色输出](https://misc.flogisoft.com/bash/tip_colors_and_formatting%E3%80%82)

##### [运算符](http://c.biancheng.net/cpp/view/2736.html)

###### 算术运算符

| 运算符  | 说明                        | 举例                        |
| ---- | ------------------------- | ------------------------- |
| +    | 加法                        | `expr $a + $b` 结果为 30。    |
| -    | 减法                        | `expr $a - $b` 结果为 10。    |
| *    | 乘法                        | `expr $a \* $b` 结果为  200。 |
| /    | 除法                        | `expr $b / $a` 结果为 2。     |
| %    | 取余                        | `expr $b % $a` 结果为 0。     |
| =    | 赋值                        | a=$b 将把变量 b 的值赋给 a。       |
| ==   | 相等。用于比较两个数字，相同则返回 true。   | [ $a == $b ] 返回 false。    |
| !=   | 不相等。用于比较两个数字，不相同则返回 true。 | [ $a != $b ] 返回 true。     |

例子：

```shell
# expr 是一款表达式计算工具
a=10
b=20
val=`expr $a + $b`  # 表达式和运算符之间要有空格
echo "a + b : $val"

if [ $a != $b ];then  # 注意条件表达式要放在方括号之间，并且要有空格
   echo "a is not equal to b"
fi
```

算术表达式嵌套

```shell
echo $(($((5**2)) * 3))
```

###### 关系运算符

关系运算符只支持数字，不支持字符串，除非字符串的值是数字

| 运算符  | 说明                            | 举例                      |
| ---- | ----------------------------- | ----------------------- |
| -eq  | 检测两个数是否相等，相等返回 true。          | [ $a -eq $b ] 返回 true。  |
| -ne  | 检测两个数是否相等，不相等返回 true。         | [ $a -ne $b ] 返回 true。  |
| -gt  | 检测左边的数是否大于右边的，如果是，则返回 true。   | [ $a -gt $b ] 返回 false。 |
| -lt  | 检测左边的数是否小于右边的，如果是，则返回 true。   | [ $a -lt $b ] 返回 true。  |
| -ge  | 检测左边的数是否大等于右边的，如果是，则返回 true。  | [ $a -ge $b ] 返回 false。 |
| -le  | 检测左边的数是否小于等于右边的，如果是，则返回 true。 | [ $a -le $b ] 返回 true。  |

例子：

```shell
if [ $a -le $b ]
then
   echo "$a -le $b: a is less or  equal to b"
else
   echo "$a -le $b: a is not less or equal to b"
fi
```

###### 布尔运算符

| 运算符  | 说明                                | 举例                                   |
| ---- | --------------------------------- | ------------------------------------ |
| !    | 非运算，表达式为 true 则返回 false，否则返回 true | [ ! false ] 返回 true。                 |
| -o   | 或运算，有一个表达式为 true 则返回 true。        | [ $a -lt 20 -o \$b -gt 100 ] 返回 true |
| -a   | 与运算，两个表达式都为 true 才返回 true         | [ $a -lt 20 -a \$b -gt 100 ] 返回      |

例子：

```shell

```

###### 字符串运算符

| 运算符  | 说明                      | 举例                    |
| ---- | ----------------------- | --------------------- |
| =    | 检测两个字符串是否相等，相等返回 true。  | [ $a = $b ] 返回 false。 |
| !=   | 检测两个字符串是否相等，不相等返回 true。 | [ $a != $b ] 返回 true。 |
| -z   | 检测字符串长度是否为0，为0返回 true。  | [ -z $a ] 返回 false。   |
| -n   | 检测字符串长度是否为0，不为0返回 true。 | [ -z $a ] 返回 true。    |
| str  | 检测字符串是否为空，不为空返回 true。   | [ $a ] 返回 true。       |

 注意字符串运算符的等判断和数字的等判断的区别

例子：

```powershell
if [ $a != $b ]
then
   echo "$a != $b : a is not equal to b"
else
   echo "$a != $b: a is equal to b"
fi
```

###### 文件测试运算符

| 操作符     | 说明                                       | 举例                     |
| ------- | ---------------------------------------- | ---------------------- |
| -b file | 检测文件是否是块设备文件，如果是，则返回 true。               | [ -b $file ] 返回 false。 |
| -c file | 检测文件是否是字符设备文件，如果是，则返回 true。              | [ -b $file ] 返回 false。 |
| -d file | 检测文件是否是目录，如果是，则返回 true。                  | [ -d $file ] 返回 false。 |
| -f file | 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 | [ -f $file ] 返回 true。  |
| -g file | 检测文件是否设置了 SGID 位，如果是，则返回 true。           | [ -g $file ] 返回 false。 |
| -k file | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。   | [ -k $file ] 返回 false。 |
| -p file | 检测文件是否是具名管道，如果是，则返回 true。                | [ -p $file ] 返回 false。 |
| -u file | 检测文件是否设置了 SUID 位，如果是，则返回 true。           | [ -u $file ] 返回 false。 |
| -r file | 检测文件是否可读，如果是，则返回 true。                   | [ -r $file ] 返回 true。  |
| -w file | 检测文件是否可写，如果是，则返回 true。                   | [ -w $file ] 返回 true。  |
| -x file | 检测文件是否可执行，如果是，则返回 true。                  | [ -x $file ] 返回 true。  |
| -s file | 检测文件是否为空（文件大小是否大于0），不为空返回 true。          | [ -s $file ] 返回 true。  |
| -e file | 检测文件（包括目录）是否存在，如果是，则返回 true。             | [ -e $file ] 返回 true。  |

 例子：

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

##### 其它

###### 注释

多行注释

![多行注释](http://tuling56.site/imgbed/2018-09-28_103911.png)

```shell

```

参考:[shell单行和多行注释](http://blog.csdn.net/lansesl2008/article/details/20558369/)

#### 控制结构

##### 条件语句

###### if then fi

```shell
# 两重
if [ $a == $b ];then
   echo "a is equal to b"
else
   echo "a is not equal to b"
fi

# 多重嵌套
if [ expression 1 ];then
   Statement(s) to be executed if expression 1 is true
elif [ expression 2 ];then
   Statement(s) to be executed if expression 2 is true
elif [ expression 3 ];then
   Statement(s) to be executed if expression 3 is true
else
   Statement(s) to be executed if no expression is true
fi
```

###### [case when](http://blog.csdn.net/qq_39591494/article/details/79285173)

```shell
case 变量名 in  
    值1)  
      指令1
      指令11
    ;;  
    值2)  
      指令2 
      指令21
    ;;  
    值3)  
      指令3  
    ;;  
esac  
```

###### select

  制作一个选择表，在列表中选择一个选项执行命令行。如果选择的变量不在列表序列中，则返回一个空值。需要用break退出循环。 

```shell
select 变量 in 列表;do
	命令行（通常用到循环变量）
done
```

```shell
echo "a is 5 ,b is 3. Please select your method: "

a=5
b=3

select var in "a+b" "a-b" "a*b" "a/b";do
        break
done

case $var in
    "a+b")
            echo 'a+b= '`expr $a + $b`;;
    "a-b")
            echo 'a-b= '`expr $a - $b`;;
    "a*b")
            echo 'a*b= '`expr $a \* $b`;;
    "a/b")
            echo 'a/b= '`expr $a / $b`;;
    *)
            echo "input error"
esac
```

###### &&||

三目运算符

```shell
[ -z "$res" ]&& echo "true exec" || echo "false exec"
```

##### [循环语句](https://blog.csdn.net/fansongy/article/details/6724228)

###### while

```shell

```

###### until

```shell
sum=0
num=10

until test $num -eq 0;do
        sum=`expr $sum + $num`
        num=`expr $num - 1`
    done
echo "sum = $sum"
```

###### for

```shell
for((i=0;i<10;i++));do xx done

for i in {0..10};do xx done

for i in `seq 10`;do xx done

for i in $(seq 10);do
	echo "$i"
	j=$(echo "$i*12.6-1.5"|bc)
	echo $j
done
```

#### 函数

​	函数的返回值通过`$?`获得只能是整数，不接受其它类型的返回值，可以通过修改变量的方式实现返回其它类型的值。另外函数可以不显示的使用return,此时函数的返回值是函数的退出状态，0代表成功退出，非0代表函数执行过程中有异常。

函数的三种定义方式：

```shell
function 函数名 () {  
        指令...  
        return -n  
}  
  
function 函数名 {  
        指令...  
        return -n  
}  
  
函数名 () {  
    指令...  
    return -n  
}  
```

##### 分离函数体

![分离函数体](http://tuling56.site/imgbed/2018-02-08_133315.png)

##### 返回值

```shell
#!/bin/sh
# Define your function here
Hello(){
   echo "Hello World $1 $2"
   return 10
}
# Invoke your function
Hello Zara Al
i# Capture value returnd by last command
ret=$?
echo "Return value is $ret",
如果有多个返回值的情况，则$?是shell的数组数据类型
```

##### 函数妙用

复杂逻辑封装函数，调用时展开

###### sql语句封装

```shell
# 定义函数
function tag_shoulei_active() 
{
	# 注意此处map里的映射顺序对结果有直接影响
	sql="xl_map_tag($1,
            map(
                'push_pop','1',
                'app_on_desk','1',
                '(?!auto).*(login|register).*success','2'  # map支持正则
            ))"
	echo "$sql"
}

function tag_shoulei_action_type() # 语句封装
{
	# 注意此处when的顺序对结果有直接的影响
	sql="case 
	   		when $1 rlike '(android|ios)_advertise' then 'advertise'
        	when $1 rlike '(android|ios)_.*(homehannel).*' and $1!='andrideo' then 'video'
        	when $1 rlike '(android|ios)_(download|dl_center_action)' then 'download'
        	when $1 rlike '(android|ios)_(launch|forground)' then 'launch'
        	when $1 rlike '(android|ios)_play.*' then 'play'
		else 'other' end"
	
	echo "$sql"
}


# hql中调用（字段名作为参数传递进去的，并不是字段的内容，内部的判断还是字段名）
hql="select 
		`tag_shoulei_active extdata[\'attribute1\']` as is_active
	    ,`tag_shoulei_action_type eventid` as type
	    ,`tag_shoulei_action_type uridecode\(fu1\) id` as type  # 参考:kkclick_flag.sh
		,`tag_trans para1` as test1
	from 
		tblxxx
	where xxx;
	"
echo "$hql"  # 在展开过程中会进行展开
${HIVE} -e "$hql"
```

> 注意函数的格式，此外还要考虑输入的参数带空格的话如何完整的传递进去呢

###### shell处理封装

示例1：数据加工

```mysql
function tag_trans()  #函数处理
{
	proc="$1 这是附加的内容"
	echo "$proc"
}

# hql中调用
hql="select 
		`tag_trans para1` as test1
	    ,`tag_trans `
	from 
		tblxx
	where xxx;
	"
echo "$hql"  # 在展开过程中会进行展开
${HIVE} -e "$hql"
```

示例2：参数替换

```shell
function chql()
{
    local start_date=$1
    local end_date=$2

    sql="select ds,pv,uv from xxx 
    	where ds>='${start_date}' and ds<='${end_date}'"
    echo $sql
}

function main()
{
    hql=$(chql 20180712 20180716)
    echo "$hql"
}

# 执行main函数的输出结果是
select ds,pv,uv from xxx where ds>='20180712' and ds<='20180716'
```

示例3：字符映射

```mysql
#字典替换
declare -A mdict
mdict['pos']='ni hao'
mdict['click']='ni huai'

function thql()
{
    local k=$1
    res="${mdict[$k]}"
    if [ -z "$res" ];then
        echo "空"
    else
        echo "$res"
    fi

    # 三目运算符
    [ -z "${mdict[$k]}" ]&&echo "空"||echo "${mdict[$k]}"
}

function main()
{
    # thql测试
    thql 'zhang'
    thql 'pos'
}
```

> 备注：
>
> - 在hive中使用，必须要结合streaming实现，不然没法获取到这个字段每行的内容
> - 在shell中用这个映射的话，直接将行内容作为
>

#### 应用

##### 字符串

###### 循环复制

循环拼接的方式

```shell
# 字符串重复n次
a="hah"
res=""
for i in `seq 10`;do 
	tmp="$(printf '%s- ' $a)"
	res="$tmp $res"
done
echo $res
```

###### URL

[解码](https://blog.csdn.net/carlostyq/article/details/7928585)

```shell
awk 'BEGIN{for(i=0;i<10;i++)hex[i]=i;hex["A"]=hex["a"]=10;hex["B"]=hex["b"]=11;hex["C"]=hex["c"]=12;hex["D"]=hex["d"]=13;hex["E"]=hex["e"]=14;hex["F"]=hex["f"]=15;}{gsub(/\+/," ");i=$0;while(match(i,/%../)){;if(RSTART>1);printf"%s",substr(i,1,RSTART-1);printf"%c",hex[substr(i,RSTART+1,1)]*16+hex[substr(i,RSTART+2,1)];i=substr(i,RSTART+RLENGTH);}print i;}' xxx.data
```

> 建议处理成awk的脚本，到时候直接使用此脚本即可

##### 生成序列

###### 日期序列

```shell
# 生成连续的日期序列
start_date=`date -d"-7 day" +%Y%m%d`
end_date=`date -d"-1 day" +%Y%m%d`
while [[ $start_date -le $end_date ]];do
    echo -e "\e[1;31mstep:\e[0m"$start_date
    process ${start_date}
    start_date=`date -d${start_date}"+1 day" +%Y%m%d`
done

a=($(seq -s" " -f"201809%02g" 1 10))
echo $a
echo ${a[@]}


# 生成不连续的日期序列
while read sdate;do
	echo -e "\e[1;31mstep:\e[0m"$sdate
	process ${sdate}
done<sdate_list
```

###### 整数序列

[seq](https://www.cnblogs.com/ginvip/p/6351720.html)

```shell
seq 1 2 10  # 1 3 5 7 9
seq -s, -w 1 10  # 01,02,03,04,05,06,07,08,09,10
seq -s, -f"s%03g" 1 10  # s001,s002,s003,s004,s005,s006,s007,s008,s009,s010
```

> 注：-w和-f不能同时使用

循环

```shell
# 方法1：for
for i in {1..10};do echo $i;done  # 生成序列1,2,3,4,....10

# 方法2：while
start=1;end=12
while [[ $start -le $end ]];do
	echo "$start"
	start=$((start+1))
done
```

###### 随机数

```shell
function getRandom()
{
	begin=$1;
	end=$2;
	numrange=${end}-${begin}
	randomnum=`date +"%s%N"`
	((retnum=randomnum%numrange+min))
	echo $retnum; ##通过echo打印出结果，可以用做返回值。
}

num=`getRandom 1 100` ##生成1-100之间的随机数
echo $num
```

参考：[shell生成随机数的七种方法](https://blog.csdn.net/taiyang1987912/article/details/39997303),[shell生成随机数](https://blog.csdn.net/taiyang1987912/article/details/39997303)

##### 文件目录

###### 文件操作

文件重命名

``` sh
# 第一种实现 find+awk+sh
find . -maxdepth 1 -type f | awk '!/png$/{print "mv" $1,$1".png" }' |sh

# 第二种实现 for+sed实现
for sql in `find /root -name “*.sql”`;do  mv $sql `echo $sql|sed  ‘s/sql/txt/'` ;done

# 第三种实现 rename
rename  .sql  .txt *.sql  //好像不能递归目录,其中最后一个是要修改文件类型的列表

# find+xargs+sed
```

###### 目录操作

```shell
 mkdir -p parent/child/grandson
 mkdir -p ./sub/{1,2,3,4}
 mkdir -p ./sub/{1/{11,12,13},2/{21,22,23},3/{31,32,33}}  # 也即意味着支持多级嵌套
```

##### 数学计算

###### 混合运算

浮点运算

```shell
 #百分比显示
 
 # 方法1：使用bc
 r_o_ratio="`echo "scale=2;${remain_i}*100/${odl_i}"|bc`%"
 # 方法2：使用awk（注意此语句中的BEGIN不能省略）
 r_o_ratio=$(awk -v a=12 -v b=260 'BEGIN{printf("%4.2f%%",a*100/b);}')
 # 方法2.1(注意通过管道传递过来的数据不能在begin中使用，可以在前面加上END)
 echo "12 260" | awk '{printf("%4.2f%%",$1*100/$2);}'
```

[加减乘除(整数)](https://blog.csdn.net/hu_wen/article/details/52930806)

```shell
a=4;b=8

# 方法1:let
let a=a+1  # 或者let a=$a+1
let a=b+2

# 方法2：expr
expr 30/3/2 
expr $num/2 
c=`expr $a + $b` # ！不能是c=`expr a + b`

# 方法3：$(())
c=$((a+b)) # 或者 c=$(($a+$b)) 
```

###### 数组运算

一维数组

```shell
array=(111 222 333 444 555 999 888 777 666)

# 求最大值、最小值

# 求和、均值
```

[多维数组求最大值最小值](https://yq.aliyun.com/ziliao/98637)

```shell

```

###### 集合运算

交差并补

```shell
#交集
sort A.txt B.txt |uniq -d 

#并集
sort A.txt B.txt |uniq

# 差集（A-B）
sort A.txt B.txt  B.txt|uniq -u
```

> 目前只处理了单列的情况，多列的情况要再完善

文件差异

```shell
diff A.txt B.txt
cdiff A.txt B.txt
```

###### 连接运算

**comm**

```shell
comm  -f1 -f2 -f3 A_sort.txt B_sort.txt
#第一列为只出现在文件A中的，第二列为只出现在文件B中的，第三列为AB中共同出现的
```

**[join](http://www.cnblogs.com/mfryf/p/3402200.html)**

参数选项

```shell
-a FILENUM：除了显示匹配好的行另外将指定序号（1或2）文件里部匹配的行显示出来
-e EMPTY：将须要显示可是文件里不存在的域用此选项指定的字符取代
-i :忽略大写和小写
-j FIELD ：等同于 -1 FIELD -2 FIELD,-j指定一个域作为匹配字段
-o FORMAT：以指定格式输出
-t CHAR ：以指定字符作为输入输出的分隔符
```

```
[root@yjmaliecs join]# cat aa.txt 
aa 1 2
bb 2 3
cc 4 6
dd 3 3

[root@yjmaliecs join]# cat bb.txt 
aa 2 1
bb 8 2
ff 2 4
cc 4 4
dd 5 
```

选择匹配列

```shell
# 默认以两个文件的第一行作匹配字段，默认以空格（不限个数）作分隔符
join aa.txt bb.txt

# 用-j选项指定选择哪列字段作为匹配，也可以单独指定，-j 1等同于-1 1 -2 1，
join -j 1 aa.txt bb.txt
join -1 2 -2 3 aa.txt bb.txt #以第一个文件的第二列和第二个文件的第三列做匹配字段
```

选择输出列

```shell
# -o指定将file1的1,2,3列，file2的1,2,3列都输出。
# -a指定将file1中不匹配的行也输出，可是file2中沒有与file1后两行相应的字段，因此使用empty补齐。
join -o 1.1 -o 1.2 -o 1.3 -o 2.1 -o 2.2 -o 2.3 -e 'empty' -a 1 aa.txt bb.txt 
```

非匹配行

```shell
# -v 1 将file1中不匹配的行输出
join -v 1 aa.txt aa.txt 
```

多输入

```shell
# 有时我们须要将多个格式同样的文件join到一起，而join接受的是两个文件的指令，此时我们能够使用管道和字符“-"来实现
join file1 file2 | join - file3 | join - file4 
```

> join命令和数据库中的join命令很相似。尽管file1和file2都已经排序，可是因为在第三行时開始不匹配因此仅仅匹配上了前两行，后面的行尽管字段也能够相应可是以不能匹配。join命令对文件格式的要求很强，假设想要更灵活的使用，可用AWK命令，參加AWK实例

##### 多进程

###### 后台进程

```shell
tables=(xmpcloud2 xmpconv xmpconv2 xmptipsex2)
dbs=(pgv3_split_t1 pgv3_split_t2 pgv3_split_c1 pgv3_split_c2)

declare -A Apdb
for table in ${tables[@]}; do
	pids=""
	for db in ${dbs[@]}; do
		cmd="do something"
		$cmd &
		pids="$pids $!"
		Apdb[$!]=$db
	done

	#  wait $pids
	for p in $pids;do
		wait $p
		if [[ "$?" -ne "0" ]];then
			# do something
		fi
	done
done
```

> 此处的多进程是处理每个表的多个数据来源的时候采用并发的多进程来处理，没有锁的高级使用

shell的多进程之间没有锁，只有靠wait变相实现

###### 进程切换

利用fg和bg命令实现的前台[进程切换](https://www.cnblogs.com/itech/archive/2012/04/19/2457499.html)

```shell

```

##### 进制转换

shell 脚本默认数值是由10 进制数处理,除非这个数字某种特殊的标记法或前缀开头. 才可以表示其它进制类型数值。如：以 0 开头就是 8 进制.以0x 开头就是16 进制数.使用 BASE#NUMBER 这种形式可以表示其它进制.BASE值：2-64.

[printf格式说明](https://blog.csdn.net/sinat_34009734/article/details/51646469)

###### [其它进制转十进](http://www.jb51.net/article/57943.htm)制

```shell
# 二进制转十进制
((num=2#111));echo $num  --7


# 八进制转十进制
((num=8#12));echo $num   --10
((num=012));echo $num    --10
let num=012;echo $num  	 --10

# 十六进制转十进制
((num=16#12));echo $num  --18
((num=0x12)); echo $num  --18
let num=0x12;echo $num   --18


# base32转十进制
((num=32#ffff));echo $num

# base64转十进制
((num=64#abc_));echo $num 

```

###### 十进制转其它进制

printf方法

```shell 
# 十进制转16进制
printf "%X" 255  --FF
printf "%x" 255  --ff

# 十进制转8进制
printf "%o" 10  --12

# 十进制转二进制

```

bc方法

```shell
# 十进制转二进制(5)
echo "obase=2;5"|bc  -- 101

# 十进制转八进制(64)
echo "obase=8;64"|bc  -- 100

# 十进制转十六进制(64)
echo "obase=16;256"|bc --100

# 十进制转base32
echo "obase=32;507375"|bc 

# 十进制转base32
echo "obase=32;2667327"|bc 
```

##### 日期时间

###### 显示

```shell
date "+%Y-%m-%d %H:%M:%S"  # 2018-08-07 21:25:58
date "+%F %T"   # 2018-08-07 21:25:58
```

###### 时间戳和日期

日期转时间戳

```shell
date -d "2015-08-04 00:00:00" +%s     #输出：1438617600
```

时间戳转日期

```shell
date +%s   # 可以得到UNIX的时间戳
date -d @1438617600  "+%Y-%m-%d" 
```

###### 日期运算

[自加减](https://www.douban.com/note/582106990/)

```shell
#其中的day可以更换为week、month、year
date -d "2012-04-10 -1 day " +%Y-%m-%d
date -d "20120410 -1 day " +%Y-%m-%d
```

相差

```shell
# 相差秒
diff_second=$(($(date +%s -d '2010-01-01') - $(date +%s -d '2009-01-01 11:11:11')));
```

#### 规范

##### 公共抽取

抽取公共变量或者公共方法到global_tool.sh、global_var.sh、gloab_fun.sh文件中，然后在.bashrc，.bash_profile等文件中使用source引入，这样就可以在shell的任何地方使用公共变量或者公共方法。

###### 变量和别名

global_var.sh

```shell
$ cat global_var.sh
#########################################################################
# File Name: global_var.sh
# Description:shell全局变量配置
# Author:tuling56
# State:全局变量
# Created_Time: 2017-05-26 14:07
# Last modified: 2017-10-26 03:01:39 PM
#########################################################################
#!/bin/bash

# 文件和目录
sl='grep -i --exclude-dir=\.svn --exclude-dir=".git" -Rl --color'
sn='grep -i --exclude-dir=\.svn --exclude-dir=".git"  -Rn --color'
ld='find . -maxdepth 1 -type d|grep -v "^.$"'
lf='find . -maxdepth 1 -type f'

MYSQL="/usr/bin/mysql -uroot -proot -N"

# 工具
SENDMAIL="/usr/sbin/sendemail -s mail.cc.sandai.net -f monitor@cc.sandai.net -xu monitor@cc.sandai.net -xp 121212 -o message-charset=utf8 "
```

> 变量和别名的配置最好放在`~/.bashrc`文件里，也可以在这个文件中引用

###### 公共方法

global_fun.sh

```shell
$ cat global_fun.sh
#########################################################################
# File Name: global_fun.sh
# Description:shell全局函数
# Author:tuling56
# State:
# Created_Time: 2017-05-09 17:12
# Last modified: 2018-03-26 09:05:16 PM
#########################################################################
#!/bin/bash

# 计算百分比
function calcratio()
{
    local num=$1
    local total=$2

    # 方法1
    #r_o_ratio="`echo "scale=2;${num}*100/${total}"|bc`%"
    # 方法2：使用awk（注意此语句中的BEGIN不能省略）
    #r_o_ratio=$(awk -v a=$num -v b=$total 'BEGIN{printf("%4.2f%%",a*100/b);}')
    # 方法2.1(注意通过管道传递过来的数据不能在begin中使用，可以在前面加上END)
    r_o_ratio=$(echo "$num $total" | awk '{printf("%4.2f%%",$1*100/$2);}')

    echo ${r_o_ratio}
}


# 计算日期差，注意输入的是hive字段
function calcdate_diff()
{
    local first_d=$1
    local last_d=$2

    diff_d=datediff(concat_ws('-',substring(${last_d},1,4),substring(${last_d},5,2),substring(${last_d},7,2)),
                            concat_ws('-',substring(${first_d},1,4),substring(${first_d},5,2),substring(${first_d},7,2)))

    echo ${diff_d}
}

```

注意事项：

- 在牵涉到目录处理的情况下慎用，因为提升到公共.sh中的方法获取的是公共.sh所在的目录，并不能获取到运运行公共方法的目录，这个问题可以通过传递真实的操作目录来解决。

#### 积累

##### 参数

###### 调试参数

set -e 命令

```shell
set -e命令用法总结如下:

1.当命令的返回值为非零状态时，则立即退出脚本的执行
2.作用范围只限于脚本执行的当前进行，不作用于其创建的子进程
3.当想根据命令执行的返回值输出对应的log时，最好不要采用set -e选项，而是通过配合exit命令来达到输出log并退出执行的目的
```

例子：

```shell
#!/bin/bash
set -e

echo "xxxx"
ret=$?
# 方式1
[ $ret -ne 0 ]&& echo "fail" || echo "succ"

# 方式2
if [ $ret -ne 0 ];then 
	echo "fail" 
else
	echo "succ"
fi
```

> 对比下这两种方式之间的区别，验证-e选项

###### 传递参数

传递带空格的参数，需要将参数用[双引号括起来](https://blog.csdn.net/victor0127/article/details/47314619)，而且要养成好习惯，变量的引用都用双引号括起来

```shell
get_browser "$line"
```

参考：[linux参数太长的换行问题](http://blog.csdn.net/feng27156/article/details/39057773)

##### 命令

###### shift

```shell
for i in `seq 1 6`;do
	echo "$1 $2 $3 $4 $5 $6"
	shift
done
```

###### paste/cat/zcat

paste

```shell
# paste命令不接受流输入，只能处理文件
```

###### tr/xargs/exec

```shell

```

[exec/xargs](exec/xargs)

```shell
-exec与xargs不同的是：
-exec是将结果逐条传递给后面的命令，后面的命令逐条执行。
xargs是将结果作为一个列表全部传递给后面的命令，后面的命令一次性执行参数串，可以通过xargs -p ls -l来查看即将要执行的完整的命令

# .txt文件不存在时有差异
find ./ -name "*.txt*" | xargs ls -l | awk -F " " '{ans+=$5}END{print ans}'
find ./ -name "*.txt*" -exec ls -l {} ;| awk -F " " '{ans+=$5}END{print ans}'

# 文件排序
find ./ -name "*log*" -exec ls -lrt {} ; --rt无效
find ./ -name "*log*" | xargs ls -lrt --rt有效
```

> 参考：[linux命令详解之xargs](https://www.toutiao.com/i6606263998138548749/)

###### printf/echo

printf

```

printf命令
printf '输出类型输出格式' 输出内容
printf 不支持数据流
输出类型
%ns     输出字符串，输出n个字符
%ni      输出整数，n指代输出几个数字
%m.nf  输出浮点数。总共m位，其中n位是小数。
输出格式
\n 
\t
\b
\f 清除屏幕
printf '%s\t%s\t%\t%\n' $(cat student.txt)
```

echo

![颜色输出高亮](http://tuling56.site/imgbed/2018-09-14_171950.png)

### awk

awk由模式和操作组成，主要用于列式文本处理，进行列的分割，判断处理。

```shell
awk 'BEGIN{ print "start" } pattern{ commands } END{ print "end" }' file
```

其中模式pattern可以是以下任意一个：

- /正则表达式/：使用通配符的扩展集。
- 关系表达式：使用运算符进行操作，可以是字符串或数字的比较测试。
- 模式匹配表达式：用运算符\~（匹配）和\~!（不匹配）。 
- BEGIN语句块、pattern语句块、END语句块：参见awk的工作原理

#### 基础

##### 变量

###### 内置变量

```
NR：表示awk开始执行程序后所读取的数据行数。
FNR：awk当前读取的记录数，其变量值小于等于NR（比如当读取第二个文件时，FNR是从0开始重新计数，而NR不会）。
```
###### 变量传递

```shell
# 向awk命令行程序传递变量
1.  awk '{print a, b}' a=111 b=222 yourfile
注意, 变量位置要在 file 名之前, 否则就不能调用，还有, 于 BEGIN{}中是不能调用这些的variable. 要用之后所讲的第二种方法才可解决.

2.  awk –v a=111 –v b=222 '{print a,b}' yourfile
注意, 对每一个变量加一个 –v 作传递.

3.  awk '{print "'"$LOGNAME"'"}' yourfile
如果想调用environment variable, 要用以上的方式调用, 方法是:"'"$LOGNAME"'"
```

注释

```shell
awks='BEGIN{
            #print "begin:"frow;
      }
      {
              # 列名获取
              if(NR==1){
                for(i=1;i<=NF;++i)
                    headers[i]=$i;
                next;
              }
              
              # 行头部
              rowf=$1;
              for(j=2;j<=frow;j++)
                 rowf=rowf"\t"$j;
              #print "rowf:"rowf;
              
              for(i=frow+1;i<=NF;++i){
                printf("%s\t%s\t%s\n",rowf,headers[i],$i);
              }
      }
      END{
            #print "done"
      }'
```

> awk中的注释用`#`号

##### [数组](http://blog.csdn.net/beyondlpf/article/details/7024730)

###### 基本数组

```shell
# 数组的长度
length(a)

# 数组遍历
awk 'BEGIN{a[1]="c";a[2]="d";a[3]="e";n=length(a);for(i=1;i<=n;i++) print a[i]}' # 按长度遍历
awk 'BEGIN{a[1]="c";a[2]="d";a[3]="e";for(k in a) print k,a[k]}'  # 按key遍历
```

###### 多维数组

```shell
awk 'BEGIN{a[0,0]=12;a[1,1]=13;}
	 END{
	 	for(k in a) {
	 	   	print k,a[k];
	 	    split(k,idx,SUBSEP);
	 	    print idx[1],idx[2],a[idx[1],idx[2]]
	 	}
	 }' </dev/null
```

> 建议：对于复杂的awk程序，直接写在awk脚本里更方便
>
> ```shell
> [root@yjmaliecs shell]# cat t.awk 
> #!/usr/bin/awk -f
> BEGIN{a[0,0]=12;a[1,1]=13;}
> END{
>     for(k in a) {
>         print k,a[k];  # 原始输出，把多维数组当成一个
>         split(k,idx,SUBSEP);
>         print idx[1],idx[2],a[idx[1],idx[2]]  # 对维度进行分解
>     }
> }
> [root@yjmaliecs shell]# ./t.awk /dev/null
> 00 12
> 0 0 12
> 11 13
> 1 1 13
> ```

多维数组构建

```shell

```

> 判断key是否在数组中：
>
> ```shell
> #普通数组
> if(k in arra) # 注意，此处否定的使用不能是if(k not in arra)
> print (k in a)
>
> # 关联数组
> awk -F"," 'BEGIN{s="1,2,15,22";split(s,a,",");print (3 in a)}'
> ```
>

###### 数组排序

```shell
$ cat sortd.txt
aaa 125
ddd 123
bbb 128
ccc 120
```

**asort**

对key进行文本排序，不能保存key-value的映射关系(这大部分还存在问题)

```  
$ awk '{a[$2]=$0}END{for(i=1;i<=asort(a);i++)print a[i]}' sortd.txt
aaa 125
bbb 128
ccc 120
ddd 123
```

**asorti**

对value进行数字排序，可以保存key-value的映射关系

```shell
$ awk '{a[$2]=$0}END{for(i=1;i<=asorti(a,b);i++)print a[b[i]]}' sortd.txt
ccc 120
ddd 123
aaa 125
bbb 128
```


##### 正则模式

###### 基础

awk本身支持扩展正则，不需要加额外的参数, 模式是用来对行进行筛选的，操作的基本单位是行。

常见的模式筛选规则举例：

```shell
# 正则表达式(输出以字符T开头的行)  
result=`awk '/^T/ { print }' scores.txt` 

# 混合模式（输出以K开头的行，同时第2列分数大于80分的行）
result=`awk '/^K/ && $2 > 80 { print }' scores.txt`
result=`awk '$2~/^K/ && $2 > 80 { print }' scores.txt`

# 区间模式（以Nancy开头的行为起始，第2列等于92分的行为终止，输出之间的连续的行。
		   #注意：当满足patter1或者pattern2的行不只一行的时候，会自动选择第一个符合要求的行。）
result=`awk '/^Nancy/, $2==92 { print }' scores.txt` 
```

正则否定

```shell
awk '{if($3!~/total/) print $0}' xxx.data 
```

跳过执行

```shell
BEGIN{
    FS=",";
    if(jtype !~ /^(inner|left|right|full)$/) {print "error join type,exit .....";exit_flag=1;}
}
{}
END{
    if(exit_flag==1) break;
}
```

###### 高级

多行处理

```shell
$ cat mutiline.data
张三
男
30岁
韩国
邮编:xwew
电话:xhwew

李四
女
32岁
日本
邮编:aaad
电话:bbb
```

```shell
awk 'BEGIN{FS="\n";RS="";OFS=",";ORS=";"}{print $1,$2,$3,$5,$NF}' mutiline.data
```

跨行匹配

```shell

```

多匹配

```shell

```

##### 运算符

运算符的位置很灵活

| 运算符                     | 描述               |
| ----------------------- | ---------------- |
| **赋值运算符**               |                  |
| = += -= *= /= %= ^= **= | 赋值语句             |
| **逻辑运算符**               |                  |
| \|\|                    | 逻辑或              |
| &&                      | 逻辑与              |
| **正则运算符**               |                  |
| ~ ~!                    | 匹配正则表达式和不匹配正则表达式 |
| **关系运算符**               |                  |
| < <= > >= != ==         | 关系运算符            |
| **算术运算符**               |                  |
| + -                     | 加，减              |
| * / &                   | 乘，除与求余           |
| + - !                   | 一元加，减和逻辑非        |
| ^ ***                   | 求幂               |
| ++ --                   | 增加或减少，作为前缀或后缀    |
| **其它运算符**               |                  |
| $                       | 字段引用             |
| 空格                      | 字符串连接符           |
| ?:                      | C条件表达式           |
| in                      | 数组中是否存在某键值       |

###### 逻辑运算符

`||`和`&&`

```shell
# 内部
awk 'BEGIN{a=1;b=2;print (a>5 && b<=2),(a>5 || b<=2);}'

# 外部
awk '$1>5 && $2<=2{print $0;}'
```

###### 赋值运算符

`= += -= *= /= %= ^= **=`

```

```

###### 算术运算符

`+  -  *  \  &  ++  -- ^`

```

```

###### 正则运算符

```shell
~ 	匹配正则表达式
~!  不匹配正则表达式
```

##### 控制语句

###### 条件控制

```shell
awk条件控制语句如何实现
```

###### [循环和退出](http://blog.sina.com.cn/s/blog_551d7bff0100umkv.html)

循环语句

```shell
# while,for循环语句
awk '{ i = 1; while ( i <= NF ) { print NF,$i; i++}}' test
awk '{for (i = 1; i<NF; i++) print NF,$i}' test
```

退出语句

```shell
# break语句
用于在满足条件的情况下跳出循环；

# continue语句
用于在满足条件的情况下忽略后面的语句，直接返回循环的顶端。

# next语句
next语句从输入文件中读取一行，然后从头开始执行awk脚本

# exit语句
exit语句用于结束awk程序，但不会略过END块。退出状态为0代表成功，非零值表示出错。

# getline 语句
getline实现两个文件的同步读取，当然另一种方法是利用字典实现
```

> 如何在BEGIN模块里实现直接退出呢?
>
> ```shell
> BEING{
>     if(xxx) {exit_flag=1;}
> }
> {}
> END{
>     if(exit_flag==1) exit;
> }
> ```

##### 程序

###### 脚本

awk脚本示例如下：

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

###### [脚本传参](https://www.cnblogs.com/chengmo/archive/2010/10/03/1841753.html)

- shell中运行awk脚本,如何在shell程序中向awk脚本传参：[shell中调用awk脚本传递参数问题](http://www.2cto.com/os/201507/412860.html)

```shell
#!/bin/bash

# 方法1：在awk脚本后面（此处方法BEGIN模块里获取不到）
awk -f stat.awk	"para1=value1" "para2=value2" inputfile # 或者
./stat.awk "para1=value1" "para2=value2" inputfile

# 方法2：
awk -v "para1=value1"  -v "para2=value2" -f stat.awk inputfile
```

> stat.awk脚本的内容如下：
>
> ```shell
> #其中stat.awk的脚本中引用变量可以采用如下的方式：
> #!/usr/bin/awk -f 
> BEGIN{
>     a=0;
> }
> {
>     a++;   
> }
> END{
>     print para1"\t"a;
> }
> ```

- awk命令行传参

```shell
name="76868&5676&435&43526&334&12312312&12321"

# 方法1：（awk规定引用系统变量必须使用单引号加双引号，即'"$sysvar"'这样的格式，但是split函数也需要双引号来定界，但这个双引号又不能让sh解释，而应留给awk来解释，所以使用了\"和\"组成的双引号）
awk 'BEGIN {print split('"\"$name\""', filearray, "&")；for}'

# 方法2：(注意：这种方式BEGIN的action不能获得变量)
awk  '{print test}' test="$name"

# 方法3：
awk -v test="name" 'BEGIN{print test}{print test}'     

# 方法4：(通过设置环境变量的方式获取)
export test=xxxx
#awk 'BEGIN{for (i in ENVIRON) {print i"="ENVIRON[i];}}'  # 遍历环境变量
awk 'BEGIN{print ENVIRON["test"];}{print ENVIRON["test"];}END{print ENVIRON["test"];}'
```



#### 进阶

##### [字符串](https://www.cnblogs.com/anny-1980/articles/3616086.html)

| 函数                               | 说明                                       | 备注   |
| -------------------------------- | ---------------------------------------- | ---- |
| gsub(r,s)                        | 在整个$0中用s替代r                              |      |
| gsub(r,s,t)                      | 在整个t中用s替代r                               |      |
| index(s,t)                       | 返回s中字符串t的第一位置                            |      |
| length(s)                        | 返回s长度                                    |      |
| match(s,r)                       | 测试s是否包含匹配r的字符串                           |      |
| split(s,a,fs)                    | 在fs上将s分成序列a                              |      |
| sprint(fmt,exp)                  | 返回经fmt格式化后的exp                           |      |
| sub(r,s)                         | 用$0中最左边最长的子串代替s                          |      |
| substr(s,p)                      | 返回字符串s中从p开始的后缀部分                         |      |
| substr(s,p,n)                    | 返回字符串s中从p开始长度为n的后缀部分                     |      |
| gensub(/123/,"x",1,$1)           | 替换\$1中 第一次匹配到的123为字符x，返回值为\$1替换后的内容，且$1的内容并没有改变 |      |
| gensub(/a(.*)b/,"\\1",1)         | 返回值为匹配正则第1对()内的内容                        |      |
| gensub(/a(.\*)b(.\*)c/,"\\\2",1) | 返回值为匹配正则第2对()内的内容                        |      |
| gensub(a,b,c[,d])                | 全局替换，匹配正则a， 用b替换，c为指定替换目标是第几次匹配，d为指定替换目标是哪个域如\$1,\$2，若无d指$0，返回值为target替换后内容(未替换还是返回 target原内容)，与sub、gsub不同的是，target内容替换后不改变。 |      |

###### 字符串分割

split( String, A, [Ere] ) 

> split(字符串，数组，字段分隔符) ,返回的是分割之后的 数组长度

```shell
# 例子1：
echo '[7,10]d  4724 ["10","14","1926"]'|awk '{split($2,c,"[");for (i in dict) print }'

# 例子2
name="76868&5676&435&43526&334&12312312&12321"
awk 'BEGIN {print split('"\"$name\""', filearray, "&")；for}'
```

###### [字符串拼接](https://blog.csdn.net/hipop/article/details/1089998)

```shell
echo |awk '{a="abc";var=1 2 a 3 4;print var}'  #equivlent to: "1" "2" "abc" "3" "4"
echo "1 2"|awk '{print $1 $2;print $1,$2}'
echo | awk '{jfc1="1,3";print split(jfc1,fc1,","); for(c in fc1) c1=c1"$"c","; print substr(c1,1,length(c1)-1);}'
```

###### 字符串截取

```shell

```



##### 内容抽取

抽取指定位置的内容

```shell

```

##### 输出修饰

###### 单行修饰

输入：

```data
# ttt.txt
a
b
c
```

输出

```
# 输出1
("a","b","c")

# 输出2
('a','b','c')
```

实现

```shell
# 输出1
awk '{printf("\"%s\",",$1);}' ttt.txt

#输出２
awk '{printf("'\''%s'\'',",$1);}' ttt.txt
awk 'BEGIN{printf("%s", "(");}{printf("'\''%s'\'',",$1);}END{printf("%s",")");}' ttt.txt
```

参考：[awk中输出单引号和双引号](https://www.cnblogs.com/emanlee/p/3620785.html)

#### 应用

##### 区间统计

问题描述，给出一堆数据，然后将该堆数据进行分组（分组区间自己指定），然后统计每个分组内的个数

固定区间间隔

```shell
# 统计落在每个区间段内的数量
awk '{intfloat=$1/500;split(intfloat,intn,".");v=intn[1];dict[v]++;}END{for(i in dict) print i*500"\t"i*500"~"(i+1)*500"\t"dict[i]|"sort -n -k1"}'  view_num

#改进版（利用awk提供的int函数，获取除法的整数部分）
awk '{v=int($1/500);dur[v]++;}END{for(i in dur) print i*500"\t"i*500"~"(i+1)*500"\t"dur[i]|"sort -n -k1"}'  view_num
```

指定区间间隔

```shell
awk '{if(1<=$1&& $1<2) dur[1,2]++;else if (2<=$1 && $1<5) dur[2,5]++;else if( 5<=$1 && $1<10) dur[5,10]++; else if(10<=$1 && $1<50) dur[10,50]++;else if(50<=$1) dur[50,"+"]++; else print "nodur"}END{split(i,idx,SUBSEP);	print "["idx[1]"~"idx[2]")\t"dur[i]"\t"dur[i]*100/NR"%"|"sort -t'~' -n -k1.2";}'  view_num
```

awk实现行转列

```shell
# 利用awk的数组来实现(待完成)
```

##### 多维数组统计

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

##### 文件重合度

```shell
# 同时会给出两个文件各自的行数
awk '{if(NR==FNR){a[$1]=$1;overlap_num=0;f1num=f1num+1;}else{if($1 in a) overlap_num++;}}END{print ARGV[1]"\t"f1num"\n"ARGV[2]"\t"FNR"\noverlap\t"overlap_num}' file1 file2  
```

##### 计算时间差

``` shell
awk -v s="20110510" -v t="20110605" 'BEGIN{"date +%s -d "s|getline a;"date +%s -d "t|getline b;print (b/3600-a/3600)/24}'
```

参考：

[awk计算时间差](http://bbs.chinaunix.net/forum.php?mod=viewthread&tid=2316841&page=1#pid15618823)

##### 重定向

###### 输出重定向

```shell
awk '$1=100{print $1 > "output_file"}' file

# 根据变量进行重定向
head imei_filters.log |awk '{g=substr($2,15,1);print $2,g >g"_file";}'
head imei_filters.log |awk '{l1=substr($2,15,1);l2=substr($2,14,1);print $2,l1,l2 >"data/"l1"_"l2".file";}'
```

###### 输入重定向

输入重定向需用到getline函数。getline从标准输入、管道或者当前正在处理的文件之外的其他输入文件获得输入。它负责从输入获得下一行的内容，并给NF,NR和FNR等内建变量赋值。如果得到一条记录，getline函数返回1，如果到达文件的末尾就返回0，如果出现错误，例如打开文件失败，就返回-1。如：

可以在awk中直接执行shell命令

```shell
awk 'BEGIN{"date"|getline d;split(d,a);print a[2]}'
# 执行linux的date命令，并通过管道输出给getline，然后再把输出赋值给自定义变量d，并以默认空格为分割符把它拆分开以数字1开始递增方式为下标存入数组a中，并打印数组a下标为2的值。下面我们再看看一些复杂的运用。
```

| 文件a:                 | 文件b: |
| -------------------- | ---- |
| 220 34 50 70         | 10   |
| 553 556 32 21        | 8    |
| 1 1 14 98 33         | 2    |
| 2 2 3 3 4  5 5  6 34 | 7    |

要求文件a的每行数据与文件b的相对应的行的值相减，得到其绝对值

```shell
awk '{getline j<"b";for(i=1;i<=NF;i++){$i>j?$i=$i-j:$i=j-$i}}1' a|column -t
# columnt -t的作用是让结果列对齐，该程序还有些问题
```

##### 选取某列不同的n个

选取第一列不同的n个，其它列可以重复

```shell
# cat test.data
a 1
a 2
a 3
b 1
c 2
d 2
f 6

awk '{a[$1]=$1;n=length(a);print NR,n; if(n<=3) print $0}END{print n}'  test.data

# 注意此处不要用asort或asorti求数组的长度
```

##### 实现join

```shell
#!/usr/bin/awk -f 
# awk实现join,不断扩展其功能

BEGIN{
    FS=",";
    OFS=FS;
    if(jtype !~ /^(inner|left|right|full)$/) {print "error join type:"jtype",exit.";exit_flag=1;}
#   jfc1="1,3";split(jfc1,fc1,","); for(c in fc1) c1=c1"$"c",";c1=substr(c1,1,length(c1)-1);
#   jfc2="1,2";split(jfc2,fc2,","); for(c in fc2) c2=c2"$"c",";c2=substr(c2,1,length(c2)-1);
#   print c1c2
}
{
   # 根据join的条件，构建多维初始数组
    if(NR==FNR){
        arra[$1,$2]=$0;
        nfa=NF;
        }
    else{
        arrb[$1,$2]=$0;
        nfb=NF;
    }
    #print $0;
}
END{ 
    if(exit_flag==1) exit;

        # 根据join的类型和输出字段选择输出
        if(jtype=="inner"){
        for(ka in arra){
            if(ka in arrb)
                print arra[ka],arrb[ka];   
        }
    }
    else if(jtype=="left")
    {
        print "left join";
        for(ka in arra){
            if(ka in arrb)
                print arra[ka],arrb[ka];
            else{
                blank="";
                for(i=0;i<nfb;i++)
                    blank=blank""OFS;
                printf("%s%s\n",arra[ka],blank);
            }
        }
    }
    else if(jtype=="right")
    {
        print "right join";
        for(kb in arrb){
            if(kb in arra)
                print arrb[kb],arra[kb];
            else{
                blank="";
                for(i=0;i<nfa;i++)
                    blank=blank""OFS;
                printf("%s%s\n",arrb[kb],blank);
            }
        }
    }
    else if(jtype=="full")
    { 
        print "full join"; 
        # 左全
        for(ka in arra){
            if(ka in arrb)
                print arra[ka],arrb[ka];
            else{
                blank="";
                for(i=0;i<nfb;i++)
                    blank=blank""OFS;
                printf("%s%s\n",arra[ka],blank);
            }
        }
        # 右部分(剔除公共)
        for(kb in arrb){
            if(kb in arra)
                continue;
            else{
                blank="";
                for(i=0;i<nfa;i++)
                    blank=blank""OFS;
                printf("%s%s\n",blank,arrb[kb]);
            }
        }
    }
    else
    {
        print "error jtype";
        exit;
    }
}
```

### sed

[sed](http://man.linuxde.net/sed)是一种流编辑器（Streaming Editor），它是文本处理中非常中的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出。Sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。

sed的处理流程如下：

```
sed维护着两个数据缓冲区：一个活动的模版空间(pattern space)，另一个辅助的保留空间(hold space)，初始都是空的，没有数据。
1、sed从输入中读取一行文本，去掉行尾可能的换行符(\n)后放到模版空间里；
2、用指定的执行脚本中的命令依次来处理模版空间里数据，直到脚本结束；
3、向模版空间中的数据尾添加上换行符(没有进行去换行符操作就不添加)，显示输出(选项-n将阻止输出) 模版空间中的数据后清空模版空间；
4、sed再读取下一行文本重复上面处理过程。
5、上面的4步处理过程称为一个sed处理循环。而sed就是重复这循环直到遇到退出命令或文件处理完毕。
注意：保留空间中的数据是保持不变的，除非有命令改变它。
```

#### 基础

##### 地址

| 地址        | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| n           | 行号，n 是一个正整数。                                       |
| $           | 最后一行。                                                   |
| /regexp/    | 所有匹配一个 POSIX 基本正则表达式的文本行。注意正则表达式通过 斜杠字符界定。选择性地，这个正则表达式可能由一个备用字符界定，通过\cregexpc 来 指定表达式，这里 c 就是一个备用的字符。 |
| addr1,addr2 | 从 addr1 到 addr2 范围内的文本行，包含地址 addr2 在内。地址可能是上述任意 单独的地址形式。若两个地址都是正则表达式，则[地址范围的确定方法](https://segmentfault.com/a/1190000004696613) |
| first~step  | 匹配由数字 first 代表的文本行，然后随后的每个在 step 间隔处的文本行。例如 1~2 是指每个位于偶数行号的文本行，5~5 则指第五行和之后每五行位置的文本行。 |
| addr1,+n    | 匹配地址 addr1 和随后的 n 个文本行。                         |
| addr!       | 匹配所有的文本行，除了 addr 之外，addr 可能是上述任意的地址形式。 |

###### 举例

sed多条指令执行

```shell
sed '/test/d;/boy/d' test.txt > test_new.txt      # 删除含字符串"test"或“boy"的行
# 等效于
sed -e '/test/d' -e'/boy/d' test.txt > test_new.txt 
```

显示从第n行到结尾

```shell
sed -n '2,$p' xxxx
```

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

删除匹配行的下一行

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

##### 正则

sed添加-r才支持扩展正则，此时扩展符合才不需要转义

```shell
sed -nr '/^xxx(.*)a$/s/vvv/xxx/gp' 

# 将日期格式替换成当前日期
cat bugbuffer.hql|sed -r 's/201[678]{1}[0-9]{2}[0-9]{2}/99999999/g'
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

#### 进阶

##### 变量传递

向sed命令行传递变量

```shell
ststr=`date +%d\\\/%b\\\/%Y:%H`	# 这个日期的转换，在脚本内要使用三个\才能代表一个\，脚本外可使用两个

sed -n "/${ststr}/p" ${log_path}/${log} > ${log_path_bak}/${log}_${datehour}
# 注意使用双引号，而不是单引号，这样变量才能传递过去
```

##### sed脚本

###### 从文件读入命令

```shell
sed -f sedscript.sh
```

sedscript.sh的内容如下：

> ```shell
> !/bin/sed -f
> s/root/yerik/p  
> s/bash/csh/p
> ```

sed对于脚本中输入的命令非常挑剔，在命令的末尾不能有任何空白或文本，如果在一行中有多个命令，要用分号分隔。以#开头的行为注释行，且不能跨行

###### 直接运行脚本

```shell
chmod u+x
./sedscript.sh xxxxfile
```

sed命令如何接收外部参数

#### 实践

##### 整行处理

```shell
# a命令插入行
sed '1,5a 这是追加的第五行' test.txt

# i命令插入行
sed '1,5i 这是插入的第五行' test.txt

# c命令替换行(注意是将1~5整体替换成替换后的，不是每一行替换成替换后的)
sed '1,5c 这是替换后的' test.txt

# d命令删除行
sed '1,5d 删除1~5行' test.txt
```

##### 行内处理

###### 替换

```shell
# s命令替换（其中原来的部分支持正则\w）
sed 's/原来的/现在的/g' test.txt

echo -e "inet addr:172.17.54.137  Bcast:172.17.63.255 \n  Mask:255.255.240.0" |
sed -n '/inet / s/inet.*:$?//'

# &命令替换固定字符串
sed -n 's/dog/&&xa/p' pets.txt
```

###### 插入

在行内指定位置插入,其本质是通过替换实现的

```shell
# 行数行尾插入' 
echo -e 'a\nb\nc' |sed -e "s/^/'&/" -e "s/$/'&/" -e "s/\r/,/"

# 指定位置插入(在c后面插入xx)
echo -e 'a\ncoy\nc' |sed -e "s/c/&xx/"
```

###### 转换

利用&命令进行大小写转换

```shell
#\u\U\l\L
echo -e "inet addr:172.17.54.137  Bcast:1 \n  Mask:40.0" |sed -n 's/inet/\u&/p'
```

> 扩展成关键字的大小写转换，目前还有问题

##### 其它

```shell
# {}代表命令组合
echo -e "inet addr:172.17.54.137  Bcast:1 \n  Mask:40.0" | sed -n '/inet / {p;s/inet/xxx/p}'

# r命令读取特定的文件内容到文件(读取pets.txt的内容追加到test.txt的第一行后)
sed '1r pets.txt' test.txt  


# w命令匹配特定的文件内容写入到文件
sed '1w pets.txt' test.txt
```

#### 应用

##### 特定行

输出特定行

```shell
#输出偶数行
sed -n '{n;p}' test.txt
sed -n '2~1p' test.txt

#输出奇数行
sed -n '{p;n}' test.txt
sed -n '1~1p' test.txt
```

> 备注：{}代表命令组合

替换特定行

```shell
 sed -i '/g_tool_hive=/c g_tool_hive="/usr/local/complat/cdh5.10.0/hive/bin/hive"' `sl 'g_tool_hive'`
```

##### 特定内容

输出满足条件部分的行的部分内容

```shell
# 比如：/usr/local/complat/cdh5.10.0/hive/bin/hive，要抽取complat那个位置的内容
```

### grep

全局正则表达式匹配

####  基础

语法格式：`grep [options] regex [file...]`

options的选项如下：

| 选项 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| -i   | 忽略大小写。不会区分大小写字符。也可用--ignore-case 来指定。 |
| -v   | 不匹配。通常，grep 程序会打印包含匹配项的文本行。这个选项导致 grep 程序只会打印不包含匹配项的文本行。也可用--invert-match 来指定。 |
| -c   | 打印匹配的数量（或者是不匹配的数目，若指定了-v 选项），而不是文本行本身。 也可用--count 选项来指定。 |
| -l   | 打印包含匹配项的文件名，而不是文本行本身，也可用--files-with-matches 选项来指定。 |
| -L   | 相似于-l 选项，但是只是打印不包含匹配项的文件名。也可用--files-without-match 来指定。 |
| -n   | 在每个匹配行之前打印出其位于文件中的相应行号。也可用--line-number 选项来指定。 |
| -h   | 应用于多文件搜索，不输出文件名。也可用--no-filename 选项来指定。 |

##### 基本

排除指定文件夹

```shell
grep -i --exclude-dir=\.svn --exclude-dir=".git" -Rl --color
#或者
grep -i --exclude-dir={.svn,.git} -Rl --color
```

grep查找指定类型文件的内容

```shell
find . -name *.py |xargs grep xxxx
find . -name *.py -exec grep xhh {} \;  # 问题修正，注意{}和 \;之间的空格，不然提示exec缺少参数
```

grep和sed结合使用

```shell
# 批量替换多个文件中的字符串
sed -i 's/oldstr/newstr/g' `grep oldstr -rl odlstr $datadir`
```

#### 进阶

##### 正则

grep支持BRE、ERE、PRE，默认支持BRE

grep -F快速正则，相当于fgrep,不使用任何正则匹配的时候使用，不会解析任何正则元字符，均当成默认字符.

###### **基本正则BRE**

基本正则支持`^ $ . * [] `五个元字符，其它字符都被当成文本字符，比如`? + | () {}`这些符号在基本正则表达式中，需要前加上转义字符`\`才能代表正则的意义，否则只代表该字符的默认意义。

```shell
# 基础正则
grep -i --color  -C2  "trial_over\|xl_tbc_navigation" xlx
# 扩展正则
grep -i -E --color  -C2  "trial_over|xl_tbc_navigation" xlx
```

###### **扩展正则ERE**

grep加-E支持扩展正则`？+ |（）{}`,相当于egrep

```shell
# 搜索匹配zhang或者wang的行
grep -E 'zhang|wang' xxx.data

# 搜索以zhang或者wang开头的行
grep -E '^(zhang|wang)' xxx.data
```

###### **Perl正则PRE**

grep加-P选项支持Perl格式的正则，注意此处不能缩写为pgrep,断言等高级使用是Perl正则才有的

```shell
# 断言的实验
echo "zhangshaohan:16" |grep -oP '(?<=zhangshaohan:).*$'
```

#### 应用

##### 抽取

精确匹配多个的一个

```shell
# 精确匹配push_pop、push_click、push_error
grep -E -w 'push_pop|push_click|push_error' new.data
```

抽取指定条件范围里的内容

```shell
 # 抽取同一行内from和where之间的内容(注意懒惰匹配)，并剔除空格
 grep -P -o '(?<=from)(.*?)(?=where)' a.txt |sed -n 's/ //gp' 
```

匹配指定条件后的第一个单词

```shell
grep -P -o '(?<=from)\s+\b[.\w]+\b' a.txt |sed -n 's/ //gp'
```

指定位置后的内容

```shell
# 例如抽取16
echo "zhangshaohan:16" |grep -oP '(?<=zhangshaohan:).*$'
```

> 此处使用了到[正则的断言](http://deerchao.net/tutorials/regex/regex.htm)和grep的Perl风格正则(参考全栈数据之路部分)

##### 过滤

按文件后缀过滤

```shell
egrep '\.mp4$|\.rmvb$|\.avi$' test.txt
# 当匹配的规则较多的时候使用-f
egrep -f pattern.file text.txt
```

### find

#### 基础

find \[指定目录]\[指定条件][指定动作]

【指定目录】

- find默认递归指定目录，目录若有多个，目录之间用空格分开

【指定条件】

- -prune 不在当前指定的目录中查找
- -depth 在查找当前文件时候，首先查找当前目录中的文件，然后再在子目录中进行查找
- -a -o -not的使用： -a 条件同时满足； -o 条件满足一个即可； -not对条件进行取反等同于'!'

【指定动作】

- -print 默认动作，打印文件名到标准输出，同理还有-ls
- -ok [commond] #查找后执行命令的时候询问是否要执行
- -exec [commond] #查找后执行命令的时候不询问用户，直接执行

##### 查找

######  按文件名

````shell
# 该命令查询文件名为’tmp’或是匹配’mina*’的所有文件
find –name "tmp" –o –name "mina*"

# 若只搜索当前目录内的文件（深度为1）,则用-maxdepth指定：
find . -maxdepth 1 -type f
````

正则

```shell
#find是默认没有开启正则的，比如要查找txt和pdf格式的文件,不使用正则情况下：
find .\(-name "*.txt" -o -name "*.pdf") -print
#若使用正则：
find . -regex ".*\(\.txt | \.pdf\)$"   #使用圆括号
find . -regex ".*[(\.txt)(\.pdf)]$"    #使用方括号
```

###### 按文件类型

-type 查找某一类型的文件 

 文件类型：  f-普通文件  d-目录  l-符号链接文件  c-字符设备文件  p-管道文件  b-块设备文件  s-socket文件

```shell

```

###### 按文件大小

-size 按文件大小

```shell
# 小于10M的文件 
find ~ -size +1M -size -10M 

# 找出条件范围的文件，并列出其大小
find . -type f  -size +10M  -print0 |xargs -0 ls -lh {} \;
```

###### 按文件日期

-atime   最近一次访问时间      单位：天
-mtime 最近一次内容修改时间  单位：天
-ctime  最近一次属性修改时间  单位：天
-amin   最近一次访问时间      单位：分钟
-mmin  最近一次内容修改时间  单位：分钟
-cmin   最近一次属性修改时间  单位：分钟
-newer file1 ! file2 查找更改时间比文件file1新但比文件file2旧的文件 

```shell
find /tmp -atime +5  #表示查找在五天内没有访问过的文件
```

###### 按文件权限

找出具有执行权限的文件

```shell

```

找出属于某个用户或组的文件

```shell

```

##### 排除   

###### 排除文件

```shell
#  搜索但跳出指定目录
#（注意-prune后面的-o不能缺少），另外需要说明的是跳出的是目录内部的内容，但目录本身还是会被包含进去的
find . -path "./sk" -prune -o -name "*.txt" -print


# 搜索指定类型文件的内容
alias sllua='grep -i -a  -Rl --color `find . -type f -name "*.lua"`'
alias slpy='grep -i -a   -Rl --color `find . -type f -name "*.py"`'
alias slsh='grep -i -a   -Rl --color `find . -type f -name "*.sh"`'

# 搜索py类型文件中包含xhsn的
find . -type f -name "*.py" -print0|xargs grep 'xhsn'
grep 'xhsn' $(find . -type f -name "*.py")
grep 'xhsn' `find . -type f -name "*.py"`



#搜索文件夹下指定类型的文件并打包
zip calc_bak.zip $(find xmp_odl -path "*dev*" -prune -o -type f  \( -name "*.py" -o -name "*.sh" -o -name "*.hql" -o -name "*.json" -o -name "*.conf" -o  -name "*.ini" \))
```

###### 排除目录

```shell

```

#### 进阶

##### 动作

###### 命令替换

先搜索出找出指定类型文件

```shell
find xmp_odl -path "*dev*" -prune -o -type f  \( -name "*.py" -o -name "*.sh" -o -name "*.hql" -o -name "*.json" -o -name "*.conf" -o  -name "*.ini" \)

```

>  其中`-path "*dev*" -prune -o`是排除指定目录下的文件

压缩打包

```shell
# 找出指定类型的文件并压缩打包
zip calc_bak.zip.$date $(find xmp_odl -path "*dev*" -prune -o -type f  \( -name "*.py" -o -name "*.sh" -o -name "*.hql" -o -name "*.json" -o -name "*.conf" -o  -name "*.ini" \))
```

###### 管道参数

删除

```shell
# 方法1
find xmp_odl -path "*dev*" -prune -o -type f  \( -name "*.py" -o -name "*.sh" -o -name "*.hql" -o -name "*.json" -o -name "*.conf" -o  -name "*.ini" \) | xargs -0 rm -f {} \;

# 方法2：
find . -type f -name "*.log" -exec rm {} \; 

find . -type f -name "*.swp" -delete
find . -type f -name "*.swp" | xargs rm -rf
find . -type f -name "*.swp"  -exec rm {} \;
```

重命名

```shell
find xxx |xargs -0 
```

修改权限

```shell
find /tmp -name "*.old" | xargs chmod 700 
```

#### 积累

##### 转换

###### 输出修饰

```shell
# 为输出的文件名加上双引号
find . -type f -exec echo "{}" \;  

# 查看目录中的最新文件
find . -type f -printf "%T@\t%p\n"|sort -n|cut -f2|xargs ls -lrt
```

###### 文件名空格

文件名中存在空格的时候无法处理，解决方式如下：

```shell
# 方法1:无法处理名字中包含空格的问题
function method1()
{
        find . -type f -mtime -7 -name *.py
        sed -i 's/\t/    /g'  $(find . -type f -name "*.py")
}


# 方法2：解决了文件名中包含空格的问题(使用了read的方法)
function method2()
{
        find . -type f -mtime -7 -name "*.py"|while read f;do
                sed -i 's/\t/    /g'  "$f"    # 注意$f两边的引号不可缺少
                echo "$f"
        done
}

method2

exit 0
```

##### 其它

和find命令类似的是locate、[mlocate](https://www.toutiao.com/a6609762838850306573/)命令，使用这两个命令的时候需要先更新下索引updatedb

### 实践

#### 文件转换

##### 行列转置

行转列，实现方法如下：

###### shell实现

```shell
headrow=($(head -1 $inputf))
colnum=${#headrow[*]}
for c in $(seq 1 $colnum);do
    if [ "$inseq" = "\t" ];then
        #cut -f$c $inputf |paste -d"$outseq" -s
        cut -f$c $inputf |tr '\n' ' '
    else
        #cut -d"$inseq" -f$c $inputf |paste -d"$outseq" -s
        cut -d"$inseq" -f$c $inputf |tr '\n' ' '
  	fi
done
```

> 存在的问题是内存超出限制（处理超长列的时候）

###### awk实现

```shell
awk '{i=1;
	  while(i<=NF){
          col="col"i;
          a[col]=a[col]" "$i;
          i=i+1;
		}
	 }
	 END{
		for(v in a){
			print substr(a[v],2);
		}
	}' $inputf
```

##### 格式转换

###### tab&space

tab转space

```shell
expand -t4 xxx.txt > yyy.txt
# 或者
alias t2s="sed -i 's/\t/    /g' "  # tab替换为4个空格

```

space转tab

```shell
unexpand -t4 xxx.txt >yyy.txt
# 或者
alias s2t="sed -i 's/    /\t/g' "  # 4个空格替换为tab
```

###### linux&dos

格式说明：

- Unix系统里，每行结尾只有“<换行>”，即“\n”
- Windows系统里面，每行结尾是“<换行><回 车>”，即“\n\r”

一个直接后果是:

- Unix系统下的文件在Windows里打开的话，所有文字会变成一行；
- Windows里的文件在Unix下打开的话，在每行的结尾可能会多出一个^M符号。

```shell
# dos转linux
yum install dos2unix
dos2unix xx.txt  # 或者sed -i 's/\r$//g' ttt.txt

# linux转dos
yum install unix2dos
unix2dos xx.txt
```

#### 输出修饰

##### 加引号

输入：

```shell
# ttt.txt
a
b
c
```

输出

```
('a','b','c')
```

实现：

```shell
# 方法1
awk '{printf("\"%s\",",$1)}' ttt.txt |sed -n "s/\"/'/gp"

# 方法2
awk '{printf("'\''%s'\'',",$1);}' ttt.txt

# 方法3
while read line;do echo -n "'$line',";done < ttt.txt
```

##### 显示进度

主要利用的还是printf函数

```shell
function process_show()
{
        b=''
        i=0
        while [ $i -le 100 ];do
                printf "[%-50s] %d%% \n" "$b" "$i";
                sleep 0.2
                ((i=i+2))
                b+='#'
                done
        echo
}
```

#### 行列转换

##### 列转行

```shell
echo "1,2,3 "|tr ',' '\n'
echo "1,2,3" |sed -n 's/,/\n/gp'
```

##### 行转列

```shell
echo -e "1\n2\n3" |xargs
echo -e "1\n2\n3" |sed -n 's/\n/ /gp'
```

## 参考

- **bash部分**

  [shell脚本检查工具shellcheck](https://github.com/koalaman/shellcheck)

  [shell教程(c语言中文网)](http://c.biancheng.net/cpp/view/2740.html)(推荐)

  [shell关联数组](http://blog.csdn.net/mm_bit/article/details/48417157)

  [<Shell 编程范例>面向操作对象学Shell(推荐)](https://tinylab.gitbooks.io/shellbook/)

  [数据工程师常用shell命令](https://www.jianshu.com/p/1ea90c81b659)

  [bash中set命令的使用（阮一峰推荐）](http://www.ruanyifeng.com/blog/2017/11/bash-set.html)

  [Shell脚本批量重命名文件后缀的3种实现](http://www.jb51.net/article/55255.htm)

  [Shell重命名（智慧大碰撞）](http://www.oschina.net/question/75009_111550)

  [shell脚本自动化测试框架shUnit2](https://blog.csdn.net/robertsong2004/article/details/37927287)

  [Shell速查手册(强烈推荐)](https://segmentfault.com/u/vvpale/articles?page=1)

  [Shell join命令详解](http://www.cnblogs.com/mfryf/p/3402200.html)

  [Shell常用的文档编辑命令(建议收藏)](https://www.toutiao.com/i6600636341069808132/)

  [写好shell脚本的13个建议](https://www.toutiao.com/i6570585538628157959/)

  [编写shell脚本的最佳实践(强烈推荐)](https://kb.cnblogs.com/page/574767/)

  [DataScienceAttheCommandLine](https://github.com/jeroenjanssens/data-science-at-the-command-line)

- **awk部分**

  [awk手册](http://luy.li/data/awk.html)

  [awk快速指南](http://man.linuxde.net/awk)(推荐)

  [awk学习详细文档](http://www.cnblogs.com/gaoxufei/p/6058584.html)

  [awk处理多维数组](http://blog.csdn.net/ithomer/article/details/8478716)

  [awk常见数组处理技巧(强烈推荐)](http://www.cnblogs.com/lixiaohui-ambition/archive/2012/12/11/2813419.html)

  [awk 内置变量使用介绍](http://blog.jobbole.com/92494/)

  [awk 内置函数详细介绍（实例）](http://blog.jobbole.com/92497/)

  [awk运算符介绍](http://blog.csdn.net/gaoming655/article/details/7390207)

  [[使用awk进行数字计算](http://www.mamicode.com/info-detail-1187091.html)](http://www.mamicode.com/info-detail-1187091.html)

  [awk中的输入和输出重定向](http://blog.chinaunix.net/uid-10540984-id-356795.html)（推荐）

  [awk的模式匹配(推荐)](http://blog.csdn.net/puqutogether/article/details/45865631)

  [awk数组操作详细介绍（推荐）](http://www.cnblogs.com/chengmo/archive/2010/10/08/1846190.html)

  [awk排序](https://blog.csdn.net/newmarui/article/details/49849197)

- **sed部分**

  [sed简明教程](http://coolshell.cn/articles/9104.html?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)

  [sed命令](http://man.linuxde.net/sed)

  [sed处理流程概述（推荐）](http://blog.csdn.net/yiqingnian28/article/details/23133043)

  [强大的sed(强烈强烈推荐)](http://sed.sourceforge.net/sed1line.txt)

- **grep部分**

  [grep用法详解与正则表达式](http://blog.csdn.net/deyili/article/details/5548603)

- **find部分**

  [find命令使用详解](https://blog.csdn.net/caomiao2006/article/details/12572965)

  [find递归搜索文件名(强烈推荐)](https://blog.csdn.net/gexiaobaohelloworld/article/details/8206889)

- **实践部分**

  //待补充



