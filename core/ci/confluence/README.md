## Confluene学习

软件地址：`群晖/software/Linux/tools/confluence`

启动和停止

```
/opt/atlassian/confluence/bin/start-confluence.sh
```

访问目录：

```
http://localhost:8090/
```

安装完后的两个重要目录

```shell
# 配置目录
/var/atlassian/application-data/confluence

# 安装目录 
/opt/atlassian/confluence
```

配置mysql库的部分

> 文件路径：/var/atlassian/application-data/confluence/confluence.cfg.xml
>
> 中文显示：注意jdbc连接串中的utf8字段

```xml
<property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>
<property name="hibernate.connection.url">jdbc:mysql://localhost:3306/confluence?useUnicode=true&amp;characterEncoding=utf8</property>
```

> 错误提示：MySQL isolation level 'REPEATABLE-READ' is no longer supported. Isolation level must be 'READ-COMMITTED'，在/etc/my.cnf增加如下
>
> ```
> [mysqld]
> transaction-isolation=READ-COMMITTED
> ```
>
> 

配置nginx

```json
/usr/local/nginx/conf/vhost/confluence.conf

upstream confluence {
	server 127.0.0.1:8090;
}

server {
    listen 80;
    server_name cf.ilanni.com;
    server_tokens off;
    client_max_body_size 0;
    access_log /var/log/confluence_access.log access;
    error_log /var/log/confluence_error.log;

    location / {
      proxy_read_timeout 300;
      proxy_connect_timeout 300;
      proxy_redirect off;
      proxy_http_version 1.1;
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto http;
      proxy_pass http://confluence;
    }
}
```





参考：[wiki系统confluence5.6.6安装、中文、破解及迁移](https://www.ilanni.com/?p=11989)