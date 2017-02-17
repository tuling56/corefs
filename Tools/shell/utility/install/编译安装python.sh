#!/bin/bash
cd `dirname $0`

# 编译安装python(参考地址：http://www.th7.cn/Program/Python/201606/887497.shtml)
function install_python()
{
	wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
	tar -xvf Python-2.7.11.tgz

	cd Python-2.7.11
	./configure --enable-shared --prefix=/usr/local/python27
	make
	make install



}



cd -
exit 0