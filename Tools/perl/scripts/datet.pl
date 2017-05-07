#!/usr/bin/perl

# --localtime()
@months = qw( 一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月 );
@days = qw(星期天 星期一 星期二 星期三 星期四 星期五 星期六);


=pod日期时间格式转换
    sec,     # 秒， 0 到 61
    min,     # 分钟， 0 到 59
    hour,    # 小时， 0 到 24
    mday,    # 天， 1 到 31
    mon,     # 月， 0 到 11
    year,    # 年，从 1900 开始
    wday,    # 星期几，0-6,0表示周日
    yday,    # 一年中的第几天,0-364,365
    isdst    # 如果夏令时有效，则为真
=cut

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year=$year+1900;
print "今天时间和日期:$year $mday $months[$mon] $days[$wday]\n";

# 直接调用localtime(),返回当前设置的时区的时间
$datestring = localtime();
print "时间日期为：$datestring\n";


# ---gmtime()
# 与localtime使用方法相同，返回的是格林威治时间
#

# --格式化日期和时间
printf("格式化时间：HH:MM:SS\t");
printf("%02d:%02d:%02d\n", $hour, $min, $sec);

use POSIX qw(strftime);
$datestring = strftime "%Y-%m-%d %H:%M:%S", localtime;
printf("strftime时间日期格式化 - $datestring\n");

# --time()
# 返回的新纪元时间，从1970年1月1日起累计的秒数
$epoc = time();
$epoc = $epoc - 24 * 60 * 60;   # 一天前的时间秒数
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($epoc);
print "昨天时间和日期：";
printf("%d-%d-%d %d:%d:%d\n",$year+1900,$mon+1,$mday,$hour,$min,$sec);
