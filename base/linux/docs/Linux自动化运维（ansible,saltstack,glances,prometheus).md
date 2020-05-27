# 自动化运维笔记

[TOC]

随着云主机的发展，对运维人才的专项需求越来越少，而作为程序开发者掌握基本的运维工具，则是如虎添翼，本学习也是基于此而准备的。自动化运维的本质上减少重复的手工操作。

## Ansible

---

### ansible

​	提供配置管理、应用部署、服务自动化的工具。

- 配置管理

  配置管理的操作系统可以是RHEL,可以是centos，也可以是其他Linux。操作系统可以装在物理机上，可以装在虚拟机上，甚至可以装在云上。

  ```reStructuredText
  修改linux配置文件、打补丁、启动服务等都属于配置管理。大多数linux上的配置管理我们怎么做？SSH上去，敲命令行，或者实现写好一个脚本，上传到被配置的linux系统中，然后进行执行
  ```

- 原理是：让管理节点可以无密码ssh登录被管节点，被管理节点上只需安装Python即可


#### 安装

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

如果OSI的数量太多，配置SSH的工作量也很大，其次，这种方式在企业级应用中，也存在安全风险

**解决：**

通过Ansible Tower来解决这个问题。Ansible Tower相当于Ansible的统一管理界面，类似虚拟化中的管理平台。它可以和AD，LDAP等认证方式做对接、通过统一图形化界面直观地看到被管系统的状态。

**安装**

下载：https://releases.ansible.com/ansible-tower/setup-bundle/ansible-tower-setup-bundle-3.0.2-1.el7.tar.gz

> - 修改inventory文件，增加密码
>
>
> - sudo ./setup.sh
>
> - >  这个过程可能需要手动安装避免超时：yum install postgresql94
>
> - > 手动创建目录： mkdir /var/log/tower

安装说明：

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

对比相似的技术：saltstack

## SaltStack

---

基于python开发，采用c/s架构（服务端和客户端）配置语法用的是YMAL,使用脚本配置非常简单

//待补充



## Prometheus

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

### 基础

#### 安装

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
> ----
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

#### 配置

配置参考

```
[root@local122 prometheus-1.3.1.linux-386]# cat prometheus.yml 
# my global config
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s # By default, scrape targets every 15 seconds.
  # scrape_timeout is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'codelab-monitor'

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
   - "rules/first.rules"
  # - "second.rules"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'mysql'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9104']
        labels:
          instance: mysql

  - job_name: 'node'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9100']
        labels:
          instance: node


  - job_name: 'nginx'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9145'] #,'localhost:3003']
        labels:
          instance: nginx
          
  - job_name: 'owndefine'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:8000'] #,'localhost:3003']
        labels:
          instance: owndefine
          group: 自定义exporter监控
  
  - job_name: 'owndefine2'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:3003']
        labels:
          instance: owndefine2
          group: 自定义exporter监控2
```

由上图可知，只需要在prometheus的监控机器上配置受监控机器的主机和端口就ok了,对监控队主机的情况下，是如何进行区分的呢，比如同时监控机器A的mysql和机器B的mysql，这两者是如何在主监控机器上进行区分展示的

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
> # 创建用户并赋予用户权限
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

## Ganglia 

易于扩展的监控系统，使用它可以实时查看Linux服务器和集群（图形化展示）中的各项性能指标

###  基础

#### 安装配置

在主节点服务器安装监控工具

```shell
yum update && yum install epel-release
yum install ganglia rrdtool ganglia-gmetad ganglia-gmond ganglia-web
#其中rrdtool、ganglia-gmetad、ganglia-gmond都是基于ganglia的一些应用，ganglia-web提供ganglia的web服务
```

## nmon

通过nmon可以获取的信息有：处理器利用率、内存利用率、运行队列信息、磁盘I/O统计和网络I/O统计、进程指标等

nmon可定时间隔采集数据然后生成报告，在本地使用nmon_analyser工具进行查看和分析

缺点是没有网络访问，不能实时方便的查看.

独特的数据格式，只能在excel里自动绘图和查看

## Glances

Glances用各个分离的表列展示了你机器当前正运行的各种有用的实时数据。Glances旨在用最小的空间显示尽可能多的信息，我认为它的目标完全达到了。Glances用有限的交互可能性和更深层的信息监控PerCPU, Load, Memory, Swap, Network, Disk i/O, Mount data 和processes，但对于获得一个整体概貌绝对是完美的。有以下特点：

- 使用Python开发基于psutil
- 实时动态显示（CPU、内存、磁盘、网络使用等情况，内核、运行队列、负载、IO状态、消耗资源最多的进程等）
- 提供了基于XML/RPC的API便于编程使用
- 可将数据导出成csv或html格式，方便其它程序处理

![glances数据视图](https://raw.githubusercontent.com/nicolargo/glances/develop/docs/_static/glances-summary.png)

### 基础

#### 安装

```shell
sudo apt-get install glances
# 或者
pip install glances
```

> 安装注意事项（从日志的中发现的问题）

```shell
#WARNING -- PyStache lib not installed (action script with mustache will not work)
#ERROR -- Scandir not found. Please use Python 3.5+ or install the scandir lib

#因此需要额外安装两个python包
pip install PyStache
pip install scandir   #folder插件要用
```

> glances依赖psutil,bottle,jinja

#### 配置

配置文件

```shell
# 若使用yum安装
vim /etc/glances/glances.conf

# 若使用pip安装
/usr/local/share/doc/glances/glances.conf，需要将该文件移动到以下的目录
```

You can put your own `glances.conf` file in the following locations:

| 平台               | 配置文件位置                                   |
| ---------------- | ---------------------------------------- |
| `Linux`, `SunOS` | ~/.config/glances/, /etc/glances/        |
| `*BSD`           | ~/.config/glances, /usr/local/etc/glances |

> 注：本机使用的是~/.config/glances/这个目录

运行模式

```shell
# 单机模式
$ glances

# 客户端-服务器模式
step1：首先在服务器端（ip:192.168.2.2）运行
glances -s （可以使用-B来绑定服务器端的端IP，-p绑定端口）

step2:然后在客户端连接：
glances -c 192.168.2.2

# web服务模式
$glances -w   
and enter the URL http://<ip>:61208 in your favorite web browser.
# 使用`glances -w 2>&1 &` 让服务在后台运行 
```

服务发现

```shell
You can also detect and display all Glances servers available on your network or defined in the configuration file:

$ glances --browser
```

结果输出

```shell
# 可以查看glances.conf配置文件，可以将结果输出到elasticsearch等
glances --export-elasticsearch
```

> 导出到elastcsearch的过程中发现要账号密码，这个未解决

结果导出

```shell
glances -o CSV -f /home/cjh/glances.csv
glances -o HTML -f /var/www/glances.html  #可能需要先pip install Jinja2
```

可以通过AMP等进行扩展，包括nginx的状态页

### 接口编程

#### xml-rpc协议

​	在系统的80端口提供RPC的服务，而又不影响正在执行的WEB服务，而采用HTTP协议传输RPC包的办法，但http协议本身是用于传输文本的，要在其上传输RPC封包，最方便的方法莫过于把RPC封包编码成文本的形式（例如XML文件）。

​	XML- RPC（http://www.xml-rpc.com）是由美国UserLand公司指定的一个RPC协议。它将RPC信息封包编码为XML，然后通过 HTTP传输封包；

简单的理解：将数据定义为xml格式，通过http协议进行远程传输。

**配置**

服务器端配置成:`glances -s`

客户端通过编程访问

```python
import xmlrpclib
s = xmlrpclib.ServerProxy('http://192.168.2.22:61209')
print s.getCpu()
```

> 调用不同的api，返回响应的json数据

参考:[glances中使用xml-rpc](https://github.com/nicolargo/glances/wiki/The-Glances-2.x-API-How-to)

#### 	Restful Json 

服务器端配置成:`glances -w`

客户端访问url:`http://{glances server IP@}:61208/api/2/xxx`

使用url配置的方式进行数据访问，返回json数据

参考:[glances中使用restfull json](https://github.com/nicolargo/glances/wiki/The-Glances-RESTFULL-JSON-API)

## netdata

Netdata 是一款 Linux 性能实时监测工具.。以web的可视化方式展示系统及应用程序的实时运行状态（包括cpu、内存、硬盘输入/输出、网络等linux性能的数据）

![可视化的图形指标窗口](http://dl2.iteye.com/upload/attachment/0116/6734/34c5753d-0ce6-3058-b80f-ce5f9ee2c417.gif)

主要功能发现：

1. 可以实时监控主机各项信息：包括CPU，内存，网络，磁盘，整体负载等等。
2. 可以拖动各个监控图表，查看历史信息
3. 发报警邮件
4. 更多的功能等待发掘，查看[官方的文档](https://github.com/firehol/netdata/wiki)

###  基础

#### 安装

```shell
# 可能需要事先安装依赖项
yum install zlib-devel gcc make git autoconf autogen automake pkgconfig

# 从git clone 
git clone git@github.com:firehol/netdata.git
cd netdata
./netdata-installer.sh   
```

> 注意安装过程的修改项,可查看有道云笔记的记录

自启动

```
Netdata安装完后，被配置成自动启动了systemctl enable netdata,如需要关闭开机启动
systemctl disable netdata
```

手动启动

```
开启: /usr/sbin/netdata 或者 service netdata restart
关闭：killall netdata 或者 service netdata stop
```

测试访问

```
直接用浏览器访问：`http://127.0.0.1:19999 `即可进入主界面。(19999是软件默认的端口，在配置文件中配置)
```

> 更多的安装信息请参考有道云笔记中的`Fedroa下源码编译安装netdata`文章

#### 配置

``` shell
vim /etc/netdata/netdata.conf
# 更详细的配置参考等待以后发现
```

## linfo

Linfo 是一个自由开源的跨平台的服务器统计 UI 或库，它可以显示大量的系统信息。Linfo 是可扩展的，通过 composer，很容易使用 PHP5 库以程序化方式获取来自 PHP 应用的丰富的系统统计数据。它有 Web UI 及其Ncurses CLI 视图，在 Linux、Windows、BSD、Darwin/Mac OSX、Solaris 和 Minix 系统上均可用。

Linfo 显示的系统信息包括 CPU 类型/速度[1]、服务器的体系结构、挂载点用量、硬盘/光纤／Flash 驱动器、硬件设备、网络设备和统计信息、运行时间／启动日期、主机名、内存使用量（RAM 和 swap）、温度/电压/风扇速度和 RAID 阵列等。

### 基础

#### 安装

```shell
git clone https://github.com/jrgp/linfo.git
cd linfo
cp sample.config.inc.php config.inc.php
```

##### 使用

浏览器打开 http://SERVER_IP/linfo，界面展示如下：

![linfo监控界面](https://camo.githubusercontent.com/55148adb650735288e569e43f0c13c1f1e10e06e/687474703a2f2f6a7267702e75732f6d6973632f6c696e666f2e706e67)

# 参考

- **Ansible**

  [Python自动化运维之ansible的介绍以及运行原理](http://www.toutiao.com/a6363987359403344130/)

  [CentOS7 安装Ansible](https://my.oschina.net/wangchongya/blog/752027)

  [官方参考手册](http://docs.ansible.com/ansible-tower/3.0.3/html/installandreference/requirements_refguide.html#ansible-software-requirements)

  [在 CentOS 7 中安装并使用自动化工具 Ansible](http://www.linuxidc.com/Linux/2015-10/123801.htm)

  [IT武林的小无相功：Ansible](http://www.toutiao.com/a6353964130168602882/)

  [Ansible-tower学习配置博客园](http://www.cnblogs.com/luojie89757/)（官方软件参考安装教程）

  [Ansible-tower官网申请](https://www.ansible.com/tower-trial)

- **SaltStack**

  待定

- **Prometheus**

  [官方文档参考](https://prometheus.io/docs/querying/basics/)

  [Prometheus监控 - 简介、架构及基本环境配置](http://blog.csdn.net/y_xiao_/article/details/50816248)

  [使用Prometheus和Grafana监控Mysql服务器性能](http://www.tuicool.com/articles/fiYZriE)

  [采用prometheus 监控mysql](http://www.cnblogs.com/hf-cherish/p/6016374.html)

  [Prometheus监控 - 查询表达式篇](http://blog.csdn.net/y_xiao_/article/details/50820225)

  [Fedroa安装Docker](https://docs.docker.com/engine/installation/linux/fedora/)

- **Ganglia**

  [使用 Ganglia 对 Linux 网格和集群服务器进行实时监控](http://www.toutiao.com/i6381744290002895362/)

  [Prometheus 和 Grafana 监控系统指南](https://blog.eood.cn/prometheus-grafana-monitoring?utm_source=tuicool&utm_medium=referral)（这个讲到mysql的配置）

- **nmon**

  [监控Linux系统性能的工具--nmon(一)](http://toutiao.com/user/3163731884/pin/)

- **glances**

  [四个Linux服务器监控工具htop,iotop,apachetop,glances](http://blog.jobbole.com/58003/)

  [Linux下安装和使用glances系统监控工具](http://www.tuicool.com/articles/rMjIju)

  [glances官方文档](https://github.com/nicolargo/glances)

  [使用资源监控工具glances(推荐)](https://www.ibm.com/developerworks/cn/linux/1304_caoyq_glances/)

  [系统监控glances以及其中用到的python](http://www.toutiao.com/a6358639873155219714/)

- **netdata**

  [Netdata安装和使用（Linux 性能实时监测工具）](http://soluck.iteye.com/blog/2291618)

- **linfo**

  [Linfo：实时显示你的 Linux 服务器运行状况](http://www.toutiao.com/i6425010590959272449/)

  [PHP端的linfo](https://github.com/jrgp/linfo)

  [Shell端的linfo](https://github.com/vigeek/linfo)