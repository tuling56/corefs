# 自动化运维

[TOC]

> 随着云主机的发展，对运维人才的专项需求越来越少，而作为程序开发者掌握基本的运维工具，则是如虎添翼，本学习也是基于此而准备的。自动化运维的本质上减少重复的手工操作。

## Ansible部分

---

### ansible

​	提供配置管理、应用部署、服务自动化的工具。

- 配置管理

  配置管理的操作系统可以是RHEL,可以是centos，也可以是其他Linux。操作系统可以装在物理机上，可以装在虚拟机上，甚至可以装在云上。

  ```reStructuredText
  修改linux配置文件、打补丁、启动服务等都属于配置管理。大多数linux上的配置管理我们怎么做？SSH上去，敲命令行，或者实现写好一个脚本，上传到被配置的linux系统中，然后进行执行
  ```

- 原理是：让管理节点可以无密码ssh登录被管节点，被管理节点上只需安装Python即可


**安装**

Ansible是属于Extra Packages for Enterprise Linux (EPEL)库的一部分，因此要先安装EPEL

> 添加epel源：
>
> - 方式1：下载http://mirrors.aliyun.com/repo/epel-7.repo 放到/etc/yum.repos.d/目录下，然后执行yum makecache
> - 方式2：yum isntall epel-release
>
> 安装：
>
> > yum install ansible

### ansible-tower

**问题：**

> 如果OSI的数量太多，配置SSH的工作量也很大，其次，这种方式在企业级应用中，也存在安全风险

**解决：**

>  通过Ansible Tower来解决这个问题。Ansible Tower相当于Ansible的统一管理界面，类似虚拟化中的管理平台。它可以和AD，LDAP等认证方式做对接、通过统一图形化界面直观地看到被管系统的状态。

**安装**

> 下载：https://releases.ansible.com/ansible-tower/setup-bundle/ansible-tower-setup-bundle-3.0.2-1.el7.tar.gz
>
> - 修改inventory文件，增加密码
>
>
> - sudo ./setup.sh
>
> - >  这个过程可能需要手动安装避免超时：yum install postgresql94
>
> - > 手动创建目录： mkdir /var/log/tower

​	安装说明：

> 最后的安装目录如下：/var/lib/awx
>
> awx
> ├── beat.db
> ├── favicon.ico
> ├── job_status
> ├── projects
> ├── public
> │   └── static
> ├── venv
> │   ├── ansible       #ansible目录
> │   └── tower	  #ansilble tower目录
> └── wsgi.py

参考

1. [CentOS7 安装Ansible](https://my.oschina.net/wangchongya/blog/752027)
2. [官方参考手册](http://docs.ansible.com/ansible-tower/3.0.3/html/installandreference/requirements_refguide.html#ansible-software-requirements)
3. [在 CentOS 7 中安装并使用自动化工具 Ansible](http://www.linuxidc.com/Linux/2015-10/123801.htm)
4. [IT武林的小无相功：Ansible](http://www.toutiao.com/a6353964130168602882/)
5. [Ansible-tower学习配置博客园](http://www.cnblogs.com/luojie89757/)（官方软件参考安装教程）
6. [Ansible-tower官网申请](https://www.ansible.com/tower-trial)

对比相似的技术：saltstack

## SaltStack部分

---

> 基于python开发，采用c/s架构（服务端和客户端）配置语法用的是YMAL,使用脚本配置非常简单





## Prometheus部分

---

> ​       Prometheus监控、时间序列数据库，提供一种功能性表达式语言，能够让用户实时的选择和聚合时间序列数据的数据，表达式返回的结果可以被显示为曲线图，也可以在prometheus浏览器中显示为表格，或者通过HTTP API经由外部系统处理。
>
> ​	Prometheus 是一个开源的服务监控系统，它通过==HTTP协议从远程的机器收集数据并存储在本地的时序数据库上==。它提供了一个简单的网页界面、一个功能强大的查询语言以及HTTP接口等等。
>
> 现在的进展是理解已有的各个统计指标的含义，继而是增加新的统计指标，这个看官方文档和在网上找例子进行看。
>
> 

**原理**

> **特性**
>
> - 高维度数据模型
> - 自定义查询语言
> - 可视化数据展示
> - 高效的存储策略
> - 易于运维
> - 提供各种客户端开发库
> - 警告和报警
> - 数据导出
>
> **原理如下：**
>
> ![img](http://static.oschina.net/uploads/space/2015/0205/082749_47Dp_5189.png)
>
> ```
> 客户端库的理解：
> client library是什么？
> ```
>
> 组件结构如下：
>
> ![组件结构](http://img.blog.csdn.net/20160306230146357)
>
> 架构图：
>
> ![架构图](http://img0.tuicool.com/ZB7zyeF.png!web)
>
> 竞品对比：
>
> Comparison to alternatives
>
> - [Prometheus vs. Graphite](https://prometheus.io/docs/introduction/comparison/#prometheus-vs.-graphite)
> - - [Scope](https://prometheus.io/docs/introduction/comparison/#scope)
>   - [Data model](https://prometheus.io/docs/introduction/comparison/#data-model)
>   - [Storage](https://prometheus.io/docs/introduction/comparison/#storage)
> - [Prometheus vs. InfluxDB](https://prometheus.io/docs/introduction/comparison/#prometheus-vs.-influxdb)
> - - [Scope](https://prometheus.io/docs/introduction/comparison/#scope)
>   - [Data model / storage](https://prometheus.io/docs/introduction/comparison/#data-model-/-storage)
>   - [Architecture](https://prometheus.io/docs/introduction/comparison/#architecture)
> - [Prometheus vs. OpenTSDB](https://prometheus.io/docs/introduction/comparison/#prometheus-vs.-opentsdb)
> - - [Scope](https://prometheus.io/docs/introduction/comparison/#scope)
>   - [Data model](https://prometheus.io/docs/introduction/comparison/#data-model)
>   - [Storage](https://prometheus.io/docs/introduction/comparison/#storage)

### 安装配置

> 在https://github.com/prometheus/prometheus/releases找到对应的系统版本，一般选择[**prometheus-1.3.1.linux-386.tar.gz**](https://github.com/prometheus/prometheus/releases/download/v1.3.1/prometheus-1.3.1.linux-386.tar.gz)
>
> 解压执行：./prometheus --config.file=prometheus.yml
>
> -    在http://localhost:9090 查看prometheus自身的监控服务器的状
>
> - 在http://localhost:9090/metrics,查看所有的监控数据信息，其中`prometheus_target_interval_length_seconds` 表示真实的数据获取间隔，在在prometheus首页输入它并回车，就可以看到一系列的数据，它们有不同quantile，从0.01至0.99不等。quantitle表示有多少比例的数据在这个值以内。如果只关注0.99的数据，可以输入`prometheus_target_interval_length_seconds{quantile="0.99"}`查询
>
> - 可以自定义rules，在prometheus.yml中配置包含的rules文件(如下格式)：
>
>          ​```
>          ------
>          配置文件prometheus.yml的规则配置如下：
>          # Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
>          rule_files:
> - "rules/first.rules"
>      - "second.rules"
>
>        first.rules格式如下：
>        [root@local122 prometheus-1.3.1.linux-386]# pwd
>        /home/yjm/Downloads/software/prometheus-1.3.1.linux-386
>        [root@local122 prometheus-1.3.1.linux-386]# cat rules/first.rules 
>         test:prometheus_target_interval_length_seconds:count = count(prometheus_target_interval_length_seconds)
>         ```
>
>         ```
>   ----
>   最终在界面显示的规则是：
>   test:prometheus_target_interval_length_seconds

**==总结==**

> 1. 数据收集
>    - 通过中介网关支持短时间序列数据采集
> 2. 数据存储
> 3. 数据查询
>    - 灵活的查询语言来利用上述维度的数据模型
> 4. 数据展示
>    - 丰富的展示面板：自带的expression browser(无需配置)，Grafana等
>
> ---
>
> 缺点：
>
> 1. 单机
>    - 单个服务节点为工作基础，因此每个节点的都要存储监控数据，每个节点的监控数据量就受限于存储空间
> 2. 内存占用量大
>    - 继承了leveldb(高效插入数据的数据库)，在ssd盘下io占用高
>
> 结论：
>
> 1. 适用于监控所有时间序列的项目
>
>

### Exporter

> 目前主要是node_exporter和mysql_exporter两个组件

#### node_exporter

> 机器系统数据的收集

**安装及配置**

> 在地址：https://github.com/prometheus/node_exporter/releases 找到对应的版本下载，解压执行` ./node_exporter `
>
> 配置:
>
> > 待添加

#### mysql_exporter

> 用于收集mysql服务器数据

**安装及配置**

> 在地址：https://github.com/prometheus/mysqld_exporter/releases 找到对应的版本下载，解压
>
> 配置mysql访问权限
>
> ```mysql
> CREATE USER 'mysqlexporter'@'localhost' IDENTIFIED BY 'myaqlexporter';
> GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'mysqlexporter'@'localhost'
> WITH MAX_USER_CONNECTIONS 3;
> ```
>
> 启动mysql_exporter
>
> ```shell
> 在mysql_exporter所在目录新建文件my.cnf,内如如下：
> [client]
> user=mysqlexporter
> password=mysqlexporter
>
> 然后执行：
>  ./mysqld_exporter --config.my-cnf="my.cnf"  
> ```

#### blackbox_exporter

>  blackbox_exporter 是 Prometheus 官方提供的 exporter之一，可以提供 http、dns、tcp、icmp（ping）的监控数据采集。[官方链接](https://github.com/prometheus/blackbox_exporter)
>
>  > 这个不太好整，配置比较麻烦

#### nginx_lua_prometheus

> 该模块用来监视nginx的状态，定制metrics,模块[地址](https://github.com/knyar/nginx-lua-prometheus)

在nginx.conf中添加以下配置

```
lua_shared_dict prometheus_metrics 10M;
lua_package_path "/path/to/nginx-lua-prometheus/?.lua";   #注意此处下载的prometheus.lua文件的放置
init_by_lua '
  prometheus = require("prometheus").init("prometheus_metrics")
  metric_requests = prometheus:counter(
    "nginx_http_requests_total", "Number of HTTP requests", {"host", "status"})
  metric_latency = prometheus:histogram(
    "nginx_http_request_duration_seconds", "HTTP request latency", {"host"})
';
log_by_lua '
  local host = ngx.var.host:gsub("^www.", "")
  metric_requests:inc(1, {host, ngx.var.status})
  metric_latency:observe(ngx.now() - ngx.req.start_time(), {host})
';
```

配置server如下

```
server {
         listen  9145;     
         server_name   test_prometheus.com;
         access_log    logs/lua_prometheus.log;
         error_log     logs/lua_prometheus_error.log;

		 location /metrics {
    			 content_by_lua 'prometheus:collect()';
  		 }        

         location /say_hello {  
                 default_type 'text/plain';  
                 content_by_lua 'ngx.say("[say] hello, lua")';  
         }
}
```

然后在prometheus.yml按如下配置

```
 - job_name: 'nginx'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9145']
        labels:
          instance: nginx
```

最后，在prometheus的监控界面可以看到新增加的nginx_xxx系列的配置，直接使用即可。

#### 自定义exporter

> 除[prometheus提供的exporters列表](https://github.com/prometheus/docs/blob/master/content/docs/instrumenting/exporters.md)，还可以使用client_library将自定义的服务数据转换为prometheus的时间序列数据，例子[参考](https://github.com/darkheaven1983/service_exporter)

```python
from prometheus_client import Gauge
from prometheus_client import start_http_server

'''
	数据收集和转换
'''
def gather_data():
    pass


# 程序入口
if __name__ == "__main__":

    run_event = threading.Event()
    run_event.set()

    thread = threading.Thread(target=gather_data, args=('darkheaven', run_event))
    thread.start()

    try:
        start_http_server(9104)
        while True:
            time.sleep(10)

    except KeyboardInterrupt:
        run_event.clear()
        thread.join()
        sys.exit(0)
    except:
        sys.exit(1)

```

> 官方文档：[写自定义Exporter需要注意的事项](https://prometheus.io/docs/instrumenting/writing_exporters/)

- [Maintainability and purity](https://prometheus.io/docs/instrumenting/writing_exporters/#maintainability-and-purity)
- [Configuration](https://prometheus.io/docs/instrumenting/writing_exporters/#configuration)
- [Metrics](https://prometheus.io/docs/instrumenting/writing_exporters/#metrics)
- - [Naming](https://prometheus.io/docs/instrumenting/writing_exporters/#naming)
  - [Labels](https://prometheus.io/docs/instrumenting/writing_exporters/#labels)
  - [Target labels, not static scraped labels](https://prometheus.io/docs/instrumenting/writing_exporters/#target-labels,-not-static-scraped-labels)
  - [Types](https://prometheus.io/docs/instrumenting/writing_exporters/#types)
  - [Help strings](https://prometheus.io/docs/instrumenting/writing_exporters/#help-strings)
  - [Drop less useful statistics](https://prometheus.io/docs/instrumenting/writing_exporters/#drop-less-useful-statistics)
  - [Dotted strings](https://prometheus.io/docs/instrumenting/writing_exporters/#dotted-strings)
- [Collectors](https://prometheus.io/docs/instrumenting/writing_exporters/#collectors)
- - [Metrics about the scrape itself](https://prometheus.io/docs/instrumenting/writing_exporters/#metrics-about-the-scrape-itself)
  - [Machine and process metrics](https://prometheus.io/docs/instrumenting/writing_exporters/#machine-and-process-metrics)
- [Deployment](https://prometheus.io/docs/instrumenting/writing_exporters/#deployment)
- - [Scheduling](https://prometheus.io/docs/instrumenting/writing_exporters/#scheduling)
  - [Pushes](https://prometheus.io/docs/instrumenting/writing_exporters/#pushes)
  - [Failed scrapes](https://prometheus.io/docs/instrumenting/writing_exporters/#failed-scrapes)
  - [Landing page](https://prometheus.io/docs/instrumenting/writing_exporters/#landing-page)
  - [Port numbers](https://prometheus.io/docs/instrumenting/writing_exporters/#port-numbers)
- [Announcing](https://prometheus.io/docs/instrumenting/writing_exporters/#announcing)

自定义Exporter的[python-client库使用例子](https://github.com/prometheus/client_python)

> exporter的实质是将metrics规则通过http的方式 暴露给prometheus,然后prometheus获取这些规则的数据，进行展示。

四种Meitric

- ==Counter==

  go up and reset,不能go down

- ==Gauge==

  go up and down and set to some value

- ==Summay==

  track zthe size and number of event

- Historgram

  track the size and number of events in buckets

- 下面介绍metric的属性设置

  - labels

    allowing grouping of realated time series

  - ProcessCollector

    auto export metrics about process cpu,ram,file descriptors and start time

- 下面介绍Exporting给Prometheus的方法

  - Http

    start_http_server(port_xx_)_,如何将现存的http服务器信息暴露给prometheus,查看MetricHandler类

  - Twisted

    MetricsResource类处理

  - WSGI

    make_wsgi_app来创建WSGI应用，也可以直接用start_wsgi_server来实现

  - Node exporter textfile collector

  - Exporting to a Pushgateway

- 下面介绍Exporting给其它应用的方法Bridges

  - Graphite

- 待。。

### GraphViz

**简介**

> 使用第三方可视化工具对监控数据进行可视化，[Grafana](http://grafana.org/) 是一个开源的功能丰富的数据可视化平台，通常用于时序数据的可视化。它内置了以下数据源的支持：
>
> ![img](http://img0.tuicool.com/AJVra27.png!web)
>
> 并可以通过插件扩展支持的数据源。

**安装**

> **安装grafana**
>
> 下载：https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.1-1470047149.linux-x64.tar.gz
>
> 修改配置文件：${grafana_home}/conf/default.ini
>
> ```
> [dashboards.json]
> enabled = true
> path = /var/lib/grafana/dashboards   #仪表盘目录
> ```
>
> **安装仪表盘grafana-dashboards**
>
> ```shell
> git clone https://github.com/percona/grafana-dashboards.git
> mv  grafana-dashboards /var/lib/grafana/dashboards
> ```
>
> 修改grafana使仪表盘显示正常
>
> ```shell
> $ sed -i 's/expr=\(.\)\.replace(\(.\)\.expr,\(.\)\.scopedVars\(.*\)var \(.\)=\(.\)\.interval/expr=\1.replace(\2.expr,\3.scopedVars\4var \5=\1.replace(\6.interval, \3.scopedVars)/' /usr/local/services/grafana/public/app/plugins/datasource/prometheus/datasource.js
> $ sed -i 's/,range_input/.replace(\/"{\/g,"\\"").replace(\/}"\/g,"\\""),range_input/; s/step_input:""/step_input:this.target.step/' /usr/local/services/grafana/public/app/plugins/datasource/prometheus/query_ctrl.js
>
> # 注意替换/usr/local/services/grafana为自己的grafana目录${grafana_home}
> ```

**配置**

> ```shell
> # 运行
> ${grafana_home}/bin/grafana-server
> # 网页访问
> http://localhost:3000访问Grafana页面，缺省账号为admin/admin
> # 添加DataSource
> //待添加
> ```

## Ganglia部分 

易于扩展的监控系统，使用它可以实时查看Linux服务器和集群（图形化展示）中的各项性能指标

### 安装配置

在主节点服务器安装监控工具

```shell
yum update && yum install epel-release
yum install ganglia rrdtool ganglia-gmetad ganglia-gmond ganglia-web
#其中rrdtool、ganglia-gmetad、ganglia-gmond都是基于ganglia的一些应用，ganglia-web提供ganglia的web服务

```

## nmon

通过nmon可以获取的信息有：处理器利用率、内存利用率、运行队列信息、磁盘I/O统计和网络I/O统计、进程指标等

nmon可定时采集数据然后生成报告，在本地使用nmon_analyser工具进行查看和分析

# 参考

## Ansible部分

- [Python自动化运维之ansible的介绍以及运行原理](http://www.toutiao.com/a6363987359403344130/)

## SaltStack部分

- 待定

## Prometheus部分

- [官方文档参考](https://prometheus.io/docs/querying/basics/)
- [Prometheus监控 - 简介、架构及基本环境配置](http://blog.csdn.net/y_xiao_/article/details/50816248)
- [使用Prometheus和Grafana监控Mysql服务器性能](http://www.tuicool.com/articles/fiYZriE)
- [采用prometheus 监控mysql](http://www.cnblogs.com/hf-cherish/p/6016374.html)
- [Prometheus监控 - 查询表达式篇](http://blog.csdn.net/y_xiao_/article/details/50820225)
- [Fedroa安装Docker](https://docs.docker.com/engine/installation/linux/fedora/)


## Ganglia部分

- [使用 Ganglia 对 Linux 网格和集群服务器进行实时监控](http://www.toutiao.com/i6381744290002895362/)


- [Prometheus 和 Grafana 监控系统指南](https://blog.eood.cn/prometheus-grafana-monitoring?utm_source=tuicool&utm_medium=referral)（这个讲到mysql的配置）


## nmon

[监控Linux系统性能的工具--nmon(一)](http://toutiao.com/user/3163731884/pin/)