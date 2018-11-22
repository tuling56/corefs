#!/bin/perl

# #main包
print '当前包名:',__PACKAGE__,"\n"; 

$data{'google'} = 'google.com';
$data{'runoob'} = 'runoob.com';
$data{'taobao'} = 'taobao.com';

print "\$data{'google'} = $data{'google'}\n";


require mpackage;
print "引用包的变量:",$test::a,"\n";
