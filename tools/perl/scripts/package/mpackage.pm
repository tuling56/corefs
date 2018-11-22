#!/bin/perl

package test;
print '当前包名:',__PACKAGE__,"\n";

# 变量类型
$a=123;                 #这是标量
@{arraya}=(1,2,3);      #这是数组
%hasha=('a'=>1,'b'=>2); #这是哈希(方法0)


# 数组的访创建和访问问
print "数组的访问\n";
@{arrayb}=qw(zhang weng lizhoi);
print "\$arrya[0]=$arraya[1]\n";
print "\$arryb[0]=$arrayb[1]\n";


# 创建哈希元素的其它方法
# # 方法1：为么个key实则value的方式
print "哈希表的创建和访问\n";
$hashb{'google'} = 'google.com';
$hashb{'runoob'} = 'runoob.com';
$hashb{'taobao'} = 'taobao.com';

# # 方法2：通过列表设置，第一个为key，第二个为value
%hashc = ('google', 'google.com', 'runoob', 'runoob.com', 'taobao', 'taobao.com');
%hashd = ('google'=>'google.com', 'runoob'=>'runoob.com', 'taobao'=>'taobao.com');
%hashe = (-google=>'google.com', -runoob=>'runoob.com', -taobao=>'taobao.com');

print "       \$hashb{'google'} = $hashb{'google'}
       \$hashc{'google'} = $hashc{'google'}
       \$hashd{'google'} = $hashd{'google'}
       \$hashe{-google} = $hashe{-google}\n";
