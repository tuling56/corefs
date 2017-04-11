## ES学习笔记

[TOC]

### 安装

下载

https://github.com/medcl/

`git clone git://github.com/medcl/elasticsearch-rtf.git -b master --depth 1`

启动

```shell
cd elasticsearch/bin
./elasticsearch

# 或者
sudo -u ops ES_JAVA_OPTS="-Xms2024m -Xmx2024m"  ./bin/elasticsearch  -d

# 或者
# /usr/local/elasticsearch-1.7.2/bin/elasticsearch     # 日志会输出到stdout
# /usr/local/elasticsearch-1.7.2/bin/elasticsearch -d  # 表示以daemon的方式启动
# nohup /usr/local/elasticsearch-1.7.2/bin/elasticsearch > /var/log/logstash.log 2>&1 &
```

测试

```shell
#创建索引indexdb
curl -XPUT  'http://localhost:9200/indexdb'

# 添加文档到索引(添加文档到customer索引、external类型中，其ID是1)
curl -XPUT 'http://localhost:9200/indexdb/external/1?pretty' -d '
{
  "name": "John Doe"
}'

# 查询是否添加成功
curl -XGET/POST 'http://localhost:9200/indexdb/external/_search?q=guide'  #或者

curl -XGET/POST 'http://localhost:9200/indexdb/external/_search' -d '
{
  {
   "query":
  	{
  		"match_all":{}
  	}
  }
}
'

```

### 查询

//查询是大头



## 参考

[Elasticsearch系列文章](https://www.iteblog.com/archives/tag/elasticsearch)

[Elasticsearch5.0系统服务安装](http://www.07net01.com/2016/11/1728006.html)

[ELK日志分析系统](http://467754239.blog.51cto.com/4878013/1700828)(其中有redis数据的读取)

[glances数据导入Elasticsearch](https://glances.readthedocs.io/en/stable/gw/elastic.html)

[Python操作Elasticsearch](http://www.cnblogs.com/yxpblog/p/5141738.html)

[elasticsearch 配置 JDBC数据源 与IK 中文分词插件](http://blog.mreald.com/160)