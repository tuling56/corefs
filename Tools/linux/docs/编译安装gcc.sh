#!/bin/bash
cd `dirname $0`


# 在redhat系列上安装gcc(参考地址：http://blog.csdn.net/cathy0322/article/details/48546197)
function install_gcc_redhat()
{
	# gmp安装
	wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/infrastructure/gmp-6.1.0.tar.gz
	tar -zxvf gmp-6.1.0.tar.gz
	cd gmp-6.1.0
	mkdir /usr/local/gmp-6.1.0
	./configure --prefix=/usr/local/gmp-6.1.0
	make
	make install


	# mpfr安装
	wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2
	tar -xvf mpfr-3.1.4.tar.bz2
	cd mpfr-3.1.4
	mkdir /usr/local/mpfr-3.1.4
	./configure --prefix=/usr/local/mpfr-3.1.4 --with-gmp=/usr/local/gmp-6.1.0
	make
	make install



	# mpc安装
	wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz
	tar -xzvf mpc-1.0.3.tar.gz
	cd  mpc-1.0.3
	mkdir /usr/local/mpc-1.0.3
	./configure --prefix=/usr/local/mpc-1.0.3 --with-gmp=/usr/local/gmp-6.1.0 --with-mpfr=/usr/local/mpfr-3.1.4
	make
	make install



	# gcc安装
	wget http://mirrors.concertpass.com/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.gz
	tar -zxvf gcc-5.3.0.tar.gz
	cd gcc-5.3.0
	mkdir /usr/local/gcc-5.3.0
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/gmp-6.1.0/lib/:/usr/local/mpfr-3.1.4/lib/:/usr/local/mpc-1.0.3/lib/
	./configure --prefix=/usr/local/gcc-5.3.0 --enable-threads=posix --disable-checking --disable-multilib --enable-languages=c,c++ --with-gmp=/usr/local/gmp-6.1.0 --with-mpfr=/usr/local/mpfr-3.1.4 --with-mpc=/usr/local/mpc-1.0.3
	make
	make install


	# 软连接设置
	ln -s /usr/local/gcc-4.8.4/bin/gcc   /usr/bin/gcc
	ln -s /usr/local/gcc-4.8.4/bin/g++   /usr/bin/g++
}


# 在ubuntu上安装gcc(参考地址：http://www.cnblogs.com/zero1665/archive/2009/11/03/1595510.html)
function install_gcc_debian()
{
	sudo apt-get  build-depgcc  # 或者sudo apt-get  install  build-essential
}



cd -
exit 0