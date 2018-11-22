#!/usr/bin/perl

# perl文件操作
sub foper{
    rename ("./test.data_2", "./test.data_3" );
    unlink("./test.data_2");
}

sub foper_seek{
    open(DATA, "+<test.data") or die "test.data 文件无法打开, $!";
    # 读取文件内容并将每一行的数据存放到@lines数组中
    @lines = <DATA>;
    print @lines;       # 输出数组内容

    # 再次读取文件的内容
    seek DATA, 0, 0;    # 重新定位文件位置
    $pos=tell DATA;
    print "curpos:$pos\n";    
    while(<DATA>){
        $pos=tell DATA;
        print "curpos:$pos\t";
        print "$_";
    }

    close(DATA) || die "无法关闭文件";
}

sub foper_open{
    # 以读写的方式打开
    open(DATA, "+<test.data") or die "test.data 文件无法打开, $!";
    while(<DATA>){
        print "$_";
    }
    close(DATA) || die "无法关闭文件";
}

sub foper_sysopen{
    # 以读写的的方式打开
    sysopen(DATA,"test.data",O_RDWR);
    open(DATA2,">>test.data_2");
    while(<DATA>){
        print "$_";
        print DATA2 "$_";
    }
    close(DATA) || die "无法关闭文件";
    close(DATA2) || die "无法关闭文件";
}


# 测试入口
#foper();
foper_seek();
#foper_open();
#foper_sysopen();
