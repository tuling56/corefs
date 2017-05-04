## Perl学习笔记

[TOC]

### 基础



### 应用

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



##  参考

[菜鸟网络Perl教程](http://www.runoob.com/perl/perl-process-management.html)