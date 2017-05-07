#!/use/bin/perl

# 输出 "Hello, World"   # 这是perl单行注释方法
print "Hello, world\n";

print "这是perl的多行注释\n";
=pod注释名称
这是一个多行注释
\=pod、 \=cut只能在行首。
以=开头，以=cut结尾。
\=后面要紧接一个字符，=cut后面可以不用。
=cut

print "Hello, world
    #=注释名称
    #这是一个多行注释
    #\=pod、 \=cut只能在行首。
    #以=开头，以=cut结尾。
    #\=后面要紧接一个字符，=cut后面可以不用。
    #=cut
    \n";

=end  #代表程序在这里退出

print "晨曦已经退出，不再执行后面的"
