#!/usr/bin/awk -f
# 弹幕日志统计的awk实现增强版
# 日期:2017年1月23日
# 作者：tuling56


#日志格式(标准的日志格式)：
#27.27.28.235 - - [21/Dec/2016:14:13:01 +0800] "GET /getID?type=local&key=A451D48686CBE4BB9A9575F51D2591E1E724C060&duration=148654&subkey=312235673&md5=84b14712129a5ba0eedf3e6b92263e3b HTTP/1.1" 200 81 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)"

BEGIN{	# 注意BEGIN后面的大括号不能换行
	FS="\"";
	error404=0;
	unerror=0;

	### 如何控制get的参数按这个序列进行输出(["category","groupID","type","key","subkey","peerid","userid","action","title"])
	### 如何先获取所有的序列
	stat_dict["category"]="";
	stat_dict["groupID"]="";
	stat_dict["type"]="";
	stat_dict["key"]="";
	stat_dict["subkey"]="";
	stat_dict["peerid"]="";
	stat_dict["userid"]="";
	stat_dict["action"]="";
	stat_dict["title"]="";

	slen=asorti(stat_dict,tA);
	for(i=1;i<=slen;i++)
	{
		if(i!=slen)
			printf("%s,",tA[i]);
		else
			printf("%s\n",tA[i]);
	}
}

{
 	#print "-----------------------------------------------"
 	if($3~/200/)
	{
		num200++;
		# part1:请求时间（计算峰值访问量）
		split($1,iptime,"[");
		split(iptime[2],dtime," ");
		reqtime=substr(dtime[1],1,17)
		reqfreq[reqtime]++;
		#print reqtime

		# part2:请求体解析
		split($2,url," ");
		split(url[2],urlparas,"?");

		## url请求类型统计（计算每个类别的访问量）
		urltype=urlparas[1];
		urltypenum[urltype]++;

		## GET参数解析
		paras_str=urlparas[2];
		paras_len=split(paras_str,paras,"&");
		#print urltype,paras_str;
		for(i=1;i<paras_len;i++)
		{
			#print paras[i];
			split(paras[i],para_kv,"=");
			paras_dict[para_kv[1]]=para_kv[2];
		}

		# 数据关联
		for(k in stat_dict)
		{
			if(k in paras_dict)
				stat_dict[k]=paras_dict[k];
			else
				stat_dict[k]="";
		}

		#for(k in stat_dict) #需要处理下，不是顺序输出
		#{
		#	print "[关联]:",k,"\t",stat_dict[k];
		#	printf("%s,",stat_dict[k]);
		#}

		# 按键进行排序(排序后的键值存在数组tA中)
		#for(i=1;i<=slen;i++)
		#{
		#	print i,tA[i],stat_dict[tA[i]];
		#	if(i!=slen)
		#		printf("%s,",stat_dict[tA[i]]);
		#	else
		#		printf("%s\n",stat_dict[tA[i]]);
		#}
		print stat_dict["category"]","stat_dict["groupID"]","stat_dict["type"]","stat_dict["key"]","stat_dict["subkey"]","stat_dict["peerid"]","stat_dict["userid"]","stat_dict["action"]","stat_dict["title"];

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

END{  # 注意END后面的大括号不能换行
	print "===============信息汇总======================";
	# 总请求量
	tnum=num200+error404+unerror;
	print "total:"tnum,"erro404:"error404,"unknown:"unerror;

	# 峰值请求量
	for(tmf in reqfreq)
	{
		print tmf,reqfreq[tmf]|"sort -r -n -k2";
	}

	# 类别访问量
	for(cl in urltypenum)
	{
		print cl,urltypenum[cl]|"sort -r -n -k2";
	}

}

