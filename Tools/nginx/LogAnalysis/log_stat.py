#!/usr/local/bin/python2.7
# -*- coding: utf-8 -*-
'''
	Fun:日志数据统计
	Ref:
	State：
	Date:2016/12/21
	Author:tuling56
'''
import os, sys
from datetime import date, datetime, timedelta
import json
#import MySQLdb

reload(sys)
sys.setdefaultencoding('utf-8')

file_path=os.getcwd()
stat_res=os.path.join(file_path,"data","barrage_stat.txt")

if len(sys.argv) == 1:
	calcday = date.today() - timedelta(days=1)
	calcday = calcday.strftime("%Y%m%d")
	proc_log= os.path.join(file_path,"data","barrage_proc_"+calcday)
elif len(sys.argv) == 2:
	calcday = sys.argv[1]
	proc_log= os.path.join(file_path,"data","barrage_proc_"+calcday)
elif len(sys.argv) == 3:
	calcday = sys.argv[1]
	proc_log= sys.argv[2]
else:
	print '\033[1;31merror params num wrong,please use date as the paras\033[0m'
	sys.exit()

log_path="/usr/local/nginx/logs/bak"
src_log=os.path.join(log_path,"barrage_acc_"+calcday)

print "\033[1;31m[ SrcLog]:%s\033[0m" % (src_log)	# 原始日志
print "\033[1;31m[ProcLog]:%s\033[0m" % (proc_log)	# 处理后的日志
print "\033[1;31m[StatRes]:%s\033[0m" % (stat_res)	# 粗略的日志分析统计结果


'''
	日志分割并构建pandas数据结构（含初步统计）【本机完成】
	# 日志格式：
	101.67.77.220 - - [28/Mar/2017:23:58:20 +0800] "GET /info?groupID=7A03E41D29B2160052A7F9D9F6A235786D9C797C_1560846460&type=local&key=7A03E41D29B2160052A7F9D9F6A235786D9C797C&subkey=15608464
60&md5=19f3312149afa309733eafee6d1fe239 HTTP/1.1" 200 20 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"
'''
def log_split(log,proc_log):
	category_num = {}
	fout_stat=open(proc_log,'w')
	print >>fout_stat,','.join(["category","groupID","type","key","subkey","peerid","userid","action","title"])  # 打印信息头
	with open(log,"r") as f:	
		for line in f:
			data_set={"category":"","groupID":"","type":"","key":"","subkey":"","peerid":"","userid":"","action":"","title":""}
			try:
				line=line.strip().split('\"')
				category,info=line[1].split('?')
				category = category.split()[1].replace('/', '')
				data_set["category"] = category
				
				# 类别汇总
				try:
					category_num[category] = category_num[category] + 1
				except:
					category_num[category] = 0
				
				if not info:continue
				infolist=info.split("&")
				for i in range(0,len(infolist)):
					if(len(infolist[i])>0) and infolist[i].find('=')!=-1:
						key,value=infolist[i].split("=")
						if key in data_set:
							data_set[key]=value
				
				list_res=[data_set["category"],data_set["groupID"],data_set["type"],data_set["key"],data_set["subkey"],data_set["peerid"],data_set["userid"],data_set["action"],data_set["title"]]
				print >> fout_stat, ','.join(list(map(lambda x : str(x),list_res)))
			except Exception,e:
				#t,value,traceback = sys.exc_info()
				#print "\033[1;31m%s\033[0m" %(line)
				if line[2].find('404')!=-1:
					try:
						category_num['Error404']=category_num['Error404']+1
					except:
						category_num['Error404']=0
			del data_set
	fout_stat.close()
	
	#统计结果写入文件
	fres=open(stat_res,'a+')
	if not os.path.getsize(stat_res):
		title="%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\r\n" %('date','getID','info','upload','remark','search','Error404')
		fres.write(title)
	result="%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\r\n" %(calcday,str(category_num.get('getID','0')),str(category_num.get('info','0')),str(category_num.get('upload','0')),str(category_num.get('remark','0')),str(category_num.get('search',0)),str(category_num.get('Error404','0')))
	
	fres.write(result)
	fres.close()


'''
	详细数据统计（利用mysql）【可选在其它机器上完成】
'''
def stat_by_mysql(proc_log):
	detail_stat=os.path.join(file_path,"data","barrage_stat_detail_"+calcday)
	f=open(detail_stat,'w')
	try:
		import MySQLdb
		conn=MySQLdb.connect(host='127.0.0.1',user='root',passwd='sd-9898w',db='test')
		cur=conn.cursor(cursorclass=MySQLdb.cursors.DictCursor)
		# 创建表和加载数据
		#csql="use test;create table if not exists barrage_stat(category varchar(10), groupID varchar(30), type varchar(10), \`key\` varchar(100), subkey varchar(30), peerid varchar(20), userid varchar(30), action varchar(10), title varchar(50))ENGINE=MyISAM DEFAULT CHARSET=utf8;;"
		#cur.execute(csql)
		#lsql="use test;delete from barrage_stat;load data local infile '%s' into table barrage_stat fields terminated by ',';" %(proc_log)
		#cur.execute(lsql)
		#conn.commit()
	except Exception,e:
		t,value,traceback = sys.exc_info()
		print str(e)
		sys.exit()
	
	#　利用mysql进行数据统计
	## 获取弹幕ID
	print "GetID:"
	qsql="select \"%s\" ,\"getID\",type,count(*) as '次数',count(DISTINCT groupID)+count(DISTINCT concat(`key`,subkey)) as '影片数' from test.barrage_stat where category=\"getID\";" % (calcday)
	print qsql
	cur.execute(qsql)
	data=cur.fetchall()
	json.dump(data,f)

	## 统计下载弹幕次数和影片数
	print "下载:"
	qsql="select \"%s\" ,\"download\",type,count(*) as '次数',count(DISTINCT groupID)+count(DISTINCT concat(`key`,subkey)) as '影片数'  from test.barrage_stat where category=\"info\";" % (calcday)
	print qsql
	cur.execute(qsql)
	data=cur.fetchall()
	json.dump(data,f)

	## 统计上报弹幕的次数，人数，影片数
	print "上报:"
	qsql="select \"%s\",\"upload\",type,count(*) as '次数',count(distinct peerid) as '人数',count(DISTINCT groupID)+count(DISTINCT concat(`key`,subkey)) as '影片数' from test.barrage_stat where category=\"upload\" GROUP by category,type;" % (calcday)
	print qsql
	cur.execute(qsql)
	data=cur.fetchall()
	json.dump(data,f)

	## 统计点评弹幕的次数，影片数,（细分点赞和举报）
	print "点评:"
	qsql="select \"%s\",\"remark\",action,count(*) as '次数',count(DISTINCT groupID)+count(DISTINCT concat(`key`,subkey)) as '影片数' from test.barrage_stat where category=\"remark\" GROUP by category,action;" % (calcday)
	print qsql
	cur.execute(qsql)
	data=cur.fetchall()
	json.dump(data,f)

	## 统计搜索的次数,搜索的影片数
	print "搜索:"
	qsql="select \"%s\",\"search\",count(*),count(DISTINCT title) from test.barrage_stat where category=\"search\" GROUP by category;" % (calcday)
	print qsql
	cur.execute(qsql)
	data=cur.fetchall()
	json.dump(data,f)

	conn.close()
	f.close()
	

'''
	测试入口
'''
if __name__ == "__main__":
	log_split(log,proc_log)
	#stat_by_mysql(proc_log)