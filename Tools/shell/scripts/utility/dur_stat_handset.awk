#!/usr/bin/awk -f
# 区间统计（手工区间设置）
# 日期:2017年5月2日
# 作者：tuling56
# 测试数据：dur_stat.data


# 手工设置参数
BEGIN{FS="\t"}
{
	if( 1<=$1 && $1<2 )
		dur[1,2]++;
	else if (2<=$1 && $1<5 )
		dur[2,5]++;
	else if( 5<=$1 && $1<10 )
		dur[5,10]++;
	else if( 10<=$1 && $1<50 )
		dur[10,50]++;
	else if( 50<=$1 )
		dur[50,"+"]++;
	else
		print "nodur:",$1;
}
END{
	for(i in dur)
	{
		split(i,idx,SUBSEP);
		print "["idx[1]"~"idx[2]")\t"dur[i]"\t"dur[i]*100/NR"%"|"sort -t'~' -n -k1.2";
		#printf("["idx[1]"~"idx[2]")\t"dur[i]"\t""%2.2f\n\%")|"sort -t'~' -n -k1.2"; #暂时有问题
	}
}

