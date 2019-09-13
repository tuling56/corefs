#!/usr/bin/awk -f
# 区间统计（自动参数设置）
# 日期:2017年5月2日
# 作者：tuling56
# 测试数据：dur_stat.data


# 自动设置参数(此处步长是20)
BEGIN{FS="\t";durseq=20}
{
    v=int($1/durseq);dur[v]++;
}
END{
    for(i in dur)
    {
        print "["i*durseq"~"(i+1)*durseq")\t"dur[i]"\t",substr(dur[i]*100/NR,1,5)"%"|"sort -t'~' -n -k1.2";
    }
}

