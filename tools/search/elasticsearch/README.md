## ES笔记

[TOC]

### 基础

elasticsearch和mysql的映射关系:E

| Mysql | Elasticsearch | 备注   |
| ----- | ------------- | ---- |
| db    | Index索引       |      |
| table | 文档类型          |      |
| id    | 一条 记录         |      |
| field | Json的key      |      |

####  安装

下载

```shell
https://github.com/medcl/
git clone git://github.com/medcl/elasticsearch-rtf.git -b master --depth 1
```

启动

```shell
cd elasticsearch/bin
./elasticsearch

# 或者
sudo -u ops ES_JAVA_OPTS="-Xms2024m -Xmx2024m"  ./bin/elasticsearch  -d

# 或者
/usr/local/elasticsearch-1.7.2/bin/elasticsearch     # 日志会输出到stdout
/usr/local/elasticsearch-1.7.2/bin/elasticsearch -d  # 表示以daemon的方式启动
nohup /usr/local/elasticsearch-1.7.2/bin/elasticsearch > /var/log/logstash.log 2>&1 &
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


#### 元数据

身份元数据:

```shell
身份元数据顾名思义就是能够唯一标识Document的，Elasticsearch中主要有四个身份元数据：

1、_index：文档所属的index，这个index相当于关系型数据库中的数据库概念，它是存储和索引关联数据的地方；

2、_uid：其由_type和_id组成；

3、_type：文档所属的mapping type，相当于关系型数据库中的表的概念；

4、_id：文档的id，这个可以由Elasticsearch自动生成，也可以在写入Document的时候由程序指定。它与_index和_type组合时，就可以在Elasticsearch中唯一标识一个文档。
```

文档元数据:

```
文档源元数据主要有两个：
1、_source：这个字段标识文档的主体信息，也就是我们写入在ElasticSearch中的数据；

2、_size：这个字段存储着_source字段中信息的大小，单位是byte；不过这需要我们安装mapper-size插
```

索引元数据:

```
1、_all：这个字段索引了所有其他字段的值；

2、_field_names：存储着文档中所有值为非空的字段信息，这在快速查找/过滤值存在或者值为空的情况下非常有用；

3、_timestamp：存储着当前文档的时间戳信息，可以由程序指定，也可以由ElasticSearch自动生成，其值会影响文档的删除（如果启用了TTL机制）；

4、_ttl：标识着当前文档存储的时长，超过了这个时长文档将会被标识为delete，之后会被ElasticSearch删除。
```

路由元数据:

```
1、_parent：用于创建两个映射的父子之间的关系；
2、_routing：自定义路由值，可以路由某个文档到具体的分片(shard)。
```

其它元数据:

```
_shareds 分片
_version 版本
```

### 查询

#### 单匹配查询

基础版

```shell
# 查询所有字段中出现guide的文档
http://localhost:9200/iteblog_book_index/book/_search?q=guide

# 查询指定字段中出现guide的文档
http://localhost:9200/iteblog_book_index/book/_search?q=title:guide
```

DSL版

```shell
# 查询所有字段中出现guide的文档
curl -XGET 'http://localhost:9200/iteblog_book_index/book/_search' -d '
{
    "query": {
        "multi_match" : {
            "query" : "guide",
            "fields" : ["_all"]
        }
    }
}'

# 查询指定字段title中出现guide的文档
curl -XGET 'http://localhost:9200/iteblog_book_index/book/_search' -d '
{
    "query": {
        "match" : {
            "title" : "in action"
        }
    },
    "size": 2,  #指定需要返回结果的数量
    "from": 0,  #指定开始的偏移量
    "_source": [ "title", "summary", "publish_date" ],　#指定返回哪些字段
    "highlight": {
        "fields" : {
            "title" : {}    # 高亮关键字
        }
    }
}'
```

其中muti_mathc关键字在查询多个field的时候作为match关键字的简写方式，`fields`属性指定需要查询的字段，如果我们想查询所有的字段，这时候可以使用`_all`关键字.****

##### boosting

在请求多个field的查询中，若想提高某个field的查询权重，这样就提高了其在结果中的权重，该文档的相关性大大提高

```json
{
    "query": {
        "multi_match" : {
            "query" : "elasticsearch guide",
            "fields": ["title", "summary^3"]
        }
    },
    "_source": ["title", "summary", "publish_date"]
}'
```

##### 查询条件的bool组合

我们可以在查询条件中使用AND/OR/NOT操作符，这就是布尔查询(Bool Query)。布尔查询可以接受一个`must`参数(等价于AND)，一个`must_not`参数(等价于NOT)，以及一个`should`参数(等价于OR)。比如，我想查询title中出现`Elasticsearch`或者`Solr`关键字的图书，图书的作者是`clinton gormley`，但没有`radu gheorge`，我们可以这么来查询：

```json
{
    "query": {
        "bool": {
            "must": {
                "bool" : { "should": [
                      { "match": { "title": "Elasticsearch" }},
                      { "match": { "title": "Solr" }} ] }
            },
            "must": { "match": { "authors": "clinton gormely" }},
            "must_not": { "match": {"authors": "radu gheorge" }}
        }
    }
}'
```



## 参考

- 基础

  [Elasticsearch系列文章](https://www.iteblog.com/archives/tag/elasticsearch)

  [Elasticsearch5.0系统服务安装](http://www.07net01.com/2016/11/1728006.html)

  [elasticsearch 配置 JDBC数据源 与IK 中文分词插件](http://blog.mreald.com/160)

  [head插件安装](http://www.sojson.com/blog/85.html)

- 进阶

  [ELK日志分析系统](http://467754239.blog.51cto.com/4878013/1700828)(其中有redis数据的读取)

  [glances数据导入Elasticsearch](https://glances.readthedocs.io/en/stable/gw/elastic.html)

  [Python操作Elasticsearch](http://www.cnblogs.com/yxpblog/p/5141738.html)

