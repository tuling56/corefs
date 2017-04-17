#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

# 编译安装1
function compile_1()
{
    with_module="--without-http-cache --with-http_image_filter_module --with-http_ssl_module --with-http_stub_status_module"
    add_module="--add-module=$dir/modules/ngx_devel_kit --add-module=$dir/modules/echo-nginx-module --add-module=$dir/modules/lua-nginx-module"

    ./configure --prefix=/usr/local/nginx --with-ld-opt="-Wl,-rpath,$LUA_LIB" ${with_module} ${add_module}

    make -j2
    make install
}


# 编译安装2
function compile_2()
{
    with_module="--without-http-cache --with-http_image_filter_module --with-http_ssl_module --with-http_stub_status_module"
    add_module="--add-module=$dir/modules/ngx_devel_kit --add-module=$dir/modules/echo-nginx-module --add-module=$dir/modules/lua-nginx-module"

    ./configure --prefix=/usr/local/nginx \
        --with-ld-opt="-Wl,-rpath,$LUA_LIB" \
        --without-http-cache \
        --with-http_image_filter_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --add-module=$dir/modules/ngx_devel_kit \
        --add-module=$dir/modules/echo-nginx-module \
        --add-module=$dir/modules/lua-nginx-module

    make -j2
    make install
}


compile_2

exit 0
