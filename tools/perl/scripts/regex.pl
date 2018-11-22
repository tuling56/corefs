#!/usr/bin/perl

$bar = "I am runoob site. za\tja welcome to runoob site\n.";

# 匹配部分
sub part_match{
    print "原始字符串:$bar\n";
    if ($bar =~ /zaja/im){
        print "第一次匹配\n";
        print "匹配前的字符串: $`\n";
        print "匹配的字符串: $&\n";
        print "匹配后的字符串: $'\n";
    }
    else{
        print "第一次不匹配\n";
    }

    $bar = "run";
    if ($bar =~ /run/){
        print "第二次匹配\n";
    }
    else{
        print "第二次不匹配\n";
    }
}

# 替换部分
sub part_replace{
    $bar =~ s/runoob/google/g;
    print "替换后字符串:$bar";
}

# 转化部分
sub part_tr{
    $string = 'welcome to runoob site.';
    $string =~ tr/a-z/A-z/;
    print "转化后字符串:$string\n";
}



# 测试入口
#part_match();
#part_replace();
part_tr();
