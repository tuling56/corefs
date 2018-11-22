#!/usr/bin/perl

# 接收邮箱，这里我设置为我的 QQ 邮箱，你需要修改它为你自己的邮箱
$to = '429240967@qq.com';
#发送者邮箱
$from = 'test@runoob.com';
#标题
$subject = '菜鸟教程 Perl 发送邮件测试';
$message = '这是一封使用 Perl 发送的邮件。';

open(MAIL, "|/usr/sbin/sendmail -t");

# 邮件头部
print MAIL "To: $to\n";
print MAIL "From: $from\n";
print MAIL "Subject: $subject\n\n";
# 邮箱信息
print MAIL $message;

close(MAIL);
print "邮件发送成功\n";