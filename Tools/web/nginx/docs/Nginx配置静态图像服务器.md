## Nginx配置静态图像服务器

### 基础

#### 安装

依赖gd库，`yum install gd-devel`

编译nginx支持

```
./configure --prefix=/usr/local/nginx     \  
  --with-debug                            \  
  --with-http_stub_status_module          \  
  --with-http_ssl_module                  \  
  --with-http_realip_module               \  
  --with-http_image_filter_module         \  
  --with-pcre=../pcre-8.21                \  
  --add-module=../ngx_devel_kit-0.2.19    \  
  --add-module=../lua-nginx-module-0.9.8  \  
  --add-module=../echo-nginx-module       \  
  --add-module=../redis2-nginx-module     \  
  --add-module=../set-misc-nginx-module  
```

#### 配置

```nginx
#匹配全站所有的结尾图片  
---------------------------------------------------------  
        location ~* \.(jpg|gif|png)$ {  
            image_filter resize 500 500;  
        }  
---------------------------------------------------------  
  
#匹配某个目录所有图片  
---------------------------------------------------------  
        location ~* /image/.*\.(jpg|gif|png)$ {  
            image_filter resize 500 500;  
        }  
---------------------------------------------------------  
  
#再比如用url来指定  
---------------------------------------------------------  
        location ~* (.*\.(jpg|gif|png))!(.*)!(.*)$ {  
            set $width      $3;  
            set $height     $4;  
            rewrite "(.*\.(jpg|gif|png))(.*)$" $1;  
        }  
          
        location ~* /image/.*\.(jpg|gif|png)$ {  
            image_filter resize $width $height;  
        }  
---------------------------------------------------------  
http://172.16.18.114/image/girl.jpg!300!200  
自动将原图缩放为300*200的尺寸 
```



## 参考

[nginx之http-image-filter-module模块使用](http://blog.csdn.net/jiao_fuyou/article/details/37598441)