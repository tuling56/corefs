#!/usr/bin/awk -f

# awk多参数演示

BEGIN{FS=","  #最初确认是,
    print ">>>程序开始";
}
{
    if(NR==FNR){
        if($1 ~ 20170303){
            print "文件1的20170303匹配行",$1;
        }
        else{
            print "非20170303匹配行",$1;
        }
    }
    else{
        print "开始文件2的读取";   # 文件2的第一行存在着分隔符设置不及时响应的问题
        FS="\t";
        print $1;
        # 在文件2种使用外部的shell命令
        "grep \-c "$1" a.txt"|getline d;
        print d;
    }
}
END{
    print ">>>程序结束";
}

