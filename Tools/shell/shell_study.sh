#!/bin/bash
echo "=======start shell======="

function mbase()
{
	# # 变量

	# 字符串
	var1="find . -type f -print" # 查找当前目录下的常规文件，并打印出来

	# 双(())的使用
	a=1;
	b=2;
	c=3;
	a=$((a+1,b++,c++));
	echo $a,$b,$c


	# 比较运算
	if [ "22" -lt  "33" ]; then
	echo "22 less than 33"
	else
	echo "no"
	fi

	# 变量引用
	# 间接变量引用
	a=letter_of_alphabet    # 变量"a"保存着另外一个变量的名字.
	letter_of_alphabet=z
	# 直接引用.
	echo "a = $a"          # a = letter_of_alphabet
	# 间接引用.
	eval a=\$$a
	echo "Now a = $a"      # 现在 a = z

	# ###数组，
	# 使用一个单一的阵列来存储
	arr[0]="v0"
	arr[1]="v1"
	# set -A arr1 "v3" "v4"    #只能在ksh shell中使用
	arr2=("v2.1","v2.2" "v3"}  # 中间用“空格”分割来对应不同的元素
	echo ${arr2[0]}		   # 访问数组的某一个元素
	echo ${#arr2[*]}           # 求数组的长度
	# 注意关联数组要声明
	declare -A unArray


	# 判断一个变量是否在数组中(可以进行包含的粗略匹配，精确匹配有问题)
	a=(zhang wenwen wenwnsw wew)
	if [[ ${a[@]} =~ ".*we*" ]];then echo "in" ;else echo "not in";fi

	# 数组分片
	# ${数组名[@或*]:起始位置:长度} 切片原先数组(其中起始位置0代表第一个元素)，返回是字符串，中间用“空格”分开，因此如果加上”()”，将得到切片数组
	echo ${a[@]:1:2}


	# 数组替换
	# ${数组名[@或*]/查找字符/替换字符} 该操作不会改变原先数组内容
	echo ${a[@]/zhang/li}
}

# 函数
function square()
{
	let "res=$1 * $1"
	echo 'your para is' $1
	#ma=12
	#mb=15
	#mab=(( $ma + $mb ))
	return $res
}

#===test the function
# declare -f square
# square 13
# result=$?
# echo $result

# 流程控制
function mconctr()
{
	# if 控制语句
	if [ -e "shet.txt" ];then
		echo "shet.txt exist"
	else
		vim shet.txt
	fi

	# case控制语句
	echo "Input1:"
	read num
	case "num" in
		"1"|"2")	passwd="123we";echo "your input is $passwd"	;;
		      *)	passwd="1root";echo "your input is $passwd"
	esac

	echo "Input2 : "
	read num
	echo "the input data is $num"
	case $num in
		1) echo "January";;    #双分号结束
		2) echo "Feburary";;
		5) echo "may"          #每个case可以有多条命令
		   echo "sdfd"
		   echo "sdf";;        #但最后一条命令一定是双分号结束

		*) echo "not correct input";;   #*）是其他值、default的意思
	esac
}

# 循环
function mloop()
{
	# for循环
	for i in $var1; do
		echo $i
	done

	for (( i = 0; i < 10; i++ )); do
		echo $i
	done

	# while 循环
	count=1
	while [[ $count -le  5 ]]; do
		echo $count
		count=$((count+1))  # count=$(($count-1)) 也可以
	done

	# until 循环
	count=1
	until [[ $count -gt 2000 ]]; do
		read line
		echo line>>subfile
		# echo 'until'+$count
		count=$((count+1))
	done <shet.txt
	# select 循环
}

# 退出控制
function mexit()
{
	echo 'test'
	ret=$?
	[ $ret -ne 0 ]&& exit $ret
	if [ "$ret" == "0" ];then
		echo 'success'
		exit 3
	fi
	exit 0

}


# 文件操作
function mfile()
{
	 # #迭代文件中的行，单词和字符
	 # while循环迭代行
	 while read line;do
	 	echo $line
	 	for word in line; do  # 迭代每一个单词
	 		echo $word
	 		for chara in word; do  # 迭代每一个字符（method1）
	 			echo $chara
	 		done
	 		for (( i = 0; i < ${#word}; i++ )); do # method2
	 			echo ${word:i:1}    #
	 		done
	 	done
	 done<shet.txt

	# 读取文件的前2000行内容到新文件
	count=1
	while [[ $count -lt 2000 ]]; do
		read line
		echo $line>>subfile.txt
		#echo 'until'+$count
		count=$(($count+1))
	done <'test.txt'

    # 逐行读取文件的内容并添加下划线显示
	while read line; do
		echo $line
		echo '--------'
	done<shet.txt

	# awk法迭代每一行
 	cat shet.txt | awk 'BEGIN{print "--start---"}{print}END{print "------"}'

 	# cut 按列切分文本

}

# 操作数据库
function testdb()
{
	mysql="C:\\Program Files\\MySQL\\MySQL Server 5.5\\bin\\mysql.exe"
	echo $mysql
	sql='use school;select stuname from student where sutno=2;'
	result=`\""${mysql}"\" -uroot -proot -e "${sql}"`
	echo $result
	return result
}


# shell交互操作
function mexpect()
{
	#!/usr/bin/expect			# 指定shebang
	set timeout 3				# 设定超时时间为3秒
	spawn ssh root@127.0.0.1 122            # fork一个子进程执行ssh命令
	expect "*password*"		        # 期待匹配到 'user_name@ip_string's password:'
	send "123\r"				# 向命令行输入密码并回车
	send "cd \r"	                        # 帮我切换到常用的工作目录
	interact                                # 允许用户与命令行交互

	#sshpass -p $passwd ssh root@$ip -o> >$temp_file
	#if [[ $?!=0 ]]; then
	#grep -q "Remote Host I" $temp_file
	#	if [[ $?=0 ]]; then
	#		#statements
	#	fi
	#fi
}


# 统计n多个文件，保证每一行的中单词A和单词B出现的个数相等
function checkpair_base()
{
    fileName=$0
    lineContent=$1
    lineNum=$2
	wordA=$3
	wordB=$4
	numA=`echo $lineContent|sed 's/\(${wordA}\)/\1\n/g'| grep -i -w ${wordA} | wc -l`
	numB=`echo $lineContent|sed 's/\(${wordB}\)/\1\n/g'| grep -i -w ${wordB} | wc -l`
	if [[ $numA == $numB ]]; then
		...
	else
		echo -e "Error:[$fileName]:[\t$lineNum:\t$lineContent]"
	fi
}

# 配对情况检查
function checkpair_pro()
{
	# 统计文件
	allfiles=`find -type f -name shet.txt -print`
	[ -z $allfiles ]&& echo "no file find" && exit -1

	wordA="setSize"
	wordB="resetSize"

	for file in allfiles; do
		cat $file | awk "BEGIN{print '--start--'}{pro $file $0 NR  $wordA $wordB}END{print '---end---'}"
	done
}



# 统计某个日期间隔内的每天（存在的问题是不能跨月,会按100进行计数）
function stalen_v1()
{
	start_date=20151006
	end_date=20151014
	while [[ $start_date -lt $end_date ]];do
	sql="select ds,count(fu1) from kankan_odl.xmp_click where ds='${start_date}' and fu3 like 'focus_list_0_UL%'";
	echo ${sql}>>result.txt
	# hive -e "${sql}">>result.txt
	start_date=$(($start_date+1))
	done
}

# 修复了跨月统计的问题
function stalen_v2()
{
	start_date=`date -d"-4 month" +%Y%m%d`
	end_date=`date -d"-1 day" +%Y%m%d`
	while [[ $start_date -le $end_date ]];do
		echo $start_date
		#python task3.5 $start_date
		start_date=`date -d$start_date"+1 day" +%Y%m%d`  #若-d参数后面不跟字符串，则表示将当期时间
	done
}

# 生成序列日期段
function gen_dateseq()
{
	ret="("
	for i in {1..7}
	do
	     date=`date -d"-${i} day" +%Y%m%d`
	     ret="${ret}'${date}',"
	done
	ret="${ret}'${dt}')"
}


# 区间段中所有日期
function statlen_v4（）
{
	start_date=20151221
	end_date=20160111
	while [[ "${start_date}" -le "${end_date}" ]];do
		durdate=${durdate}" "${start_date}
		start_date=`date -d${start_date}"+1 day" +%Y%m%d`
	done
	durdates=($durdate)
}

# 生成日期序列
function date_range()
{
	# 区间段中所有日期
	start_date=20151221
	end_date=20160111
	while [[ "${start_date}" -le "${end_date}" ]];do
		durdate=${durdate}" "${start_date}
		start_date=`date -d${start_date}"+1 day" +%Y%m%d`
	done
	durdates=($durdate)

	# 日期序列
	mon=201611
	for i in `seq 26 28`;do
		day=`printf "%02d" $i`
		fdate=${mon}${day}
		fdates=$fdates" "$fdate
	done
	fdates=(${fdates})    # 使用的时候:	dates=(${fdates[@]})

}

# 求一个月的第一天和最后一天
function statlen_v3（）
{
	start_mon=201512
	end_mon=201602
	while [[ $start_mon -le $end_mon ]];do
		start_date=${start_mon}01
		tmp=`date -d "${start_date} next month" +%Y%m%d`
		end_date=`date -d "${tmp} -1 day" +%Y%m%d`
		#do something ${start_date}
		start_mon=${tmp:0:6}
	done
}


# 判读日期
function judge_date()
{
	if [ `date -d"${date}" +%w` -eq 0 ]; # %w day of week (0..6); 0或7 is Sunday
	then
		sh  xl7_and_xmp.sh ${date}
	fi

	if [[ `date -d"${cal_day} +1 day" +%e` -eq 1 ]];# %e day of month, space padded; same as %_d 一月的第几天
	then
		# pass
	fi
	# 另外一种判读月的第一天的方法
	${day_num}=${cal_day:6:2}
	if [ ${day_num} -eq "01" ];
}



# 文件关联去重复（注意文件要都是unix格式）
function rowdereplication(predatefile,todayfile)
{
	# awk '{if(NR<FNR) a[$2+$3]=$0;else{b[$1]++;if(b[$1]==1&&$2+$3 in a) print a[$1]}}' $predatefile  $todayfile>result.txt
	awk '{if(NR==FNR) a[$2$3]=$0;else{if($2$3 not in a) print $0}}' $predatefile  $todayfile>result.txt
	awk 'NR==FNR{a[$2$3]=0;next}{if($2$3 not in a) print $0}' '20151102.txt' '20151103.txt'

	# 另外的方式求文件的交集
	cat file1 file2 | sort |uniq -c | awk '{if($1>1) print $1}' | wc -l
}


# awk函数使用
function mawk()
{
	# awk中使用split函数
	awk 'BEGIN{info="this is a test";split(info,tA," ");print length(tA);for(k in tA){print k,tA[k];}}'
	weburl="76868&5676&435&43526&334&12312312&12321"
	awk 'BEGIN{print split('"\"$weburl\""',farray,"&");print length(farray);for(k in farray){print farray[k];}} END{print "-----over------";}'
}


# rsync的使用
function mrsync()
{
	# 只复制inputlist_from_pgv_stat.txt里的文件到目的地址，其他的不复制
	rsync  -avz -P  --include-from=/usr/local/sandai/server/bin/xmp_habor/inputlist_from_pgv_stat.txt  --exclude=/*  ${pgv_stat_dir}  $destdir
	# 其中inputlist_from_pgv_stat.txt的格式如下：(一行一个，注意对.进行转义，这里面使用了正则)
	# xmpconv_group\.*
	# xmp_tips\.*
}

# 小技巧
function tricks()
{
	# 添加双引号
	echo "install,peerid,installtype,newinstall"|awk -F',' '{for(i=1;i<=NF;i++) printf("\"%s\",",$i)}'

	# 分组求和(注意多条件匹配)
	awk '{if($3==00 && $1~/8$/) a[$13"\t"$5"\t"$3"\t"$1]+=1}END{ for(i in a) print i"\t"a[i]}'

	# awk多维数组统计
	awk '{if (a in arr) {split(arr[a],puv,"\t");pv=puv[1]+$2;uv=puv[2]+$3;} else arr[$1]=$2"\t"$3;}END{ for(a in arr) print a,arr[a]|"sort -rn -k2"}' 

}


# 获取文件基本信息
function getstat()
{
	# 获取文件的修改日期
	stat main |grep Modify|grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}'

	# 获取文件的创建日期

	# 获取文件的访问日期

	# 获取文件的大小

	# 获取文件所属组
}


