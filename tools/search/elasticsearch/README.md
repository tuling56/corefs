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
#创建索引company
curl -XPUT  'http://localhost:9200/company'

# 添加文档到索引(添加文档到company索引、employee类型中，其ID是1)
curl --user 'elastic':'elastic' -XPUT 'http://localhost:9200/company/employee/1?pretty' -d '
{
  "name": "John Doe"
}'

curl --user 'elastic':'elastic' -XPUT "http://localhost:9200/company/employee/2" -H 'Content-Type: application/json' -d'{"name":"忘打个"}'

# 查询是否添加成功
curl --user 'elastic':'elastic' -XGET/POST 'http://localhost:9200/company/employee/_search'  
# 或者
curl --user 'elastic':'elastic' -XGET/POST 'http://localhost:9200/company/employee/_search' -d '
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

##### 插件安装

插件的标准安装方式是：

```shell
./elasticsearch/bin/plugin [github-name]/[repo-name]
```

默认的插件安装目录是：/usr/share/elasticsearch/plugins/

###### [head](http://mobz.github.io/elasticsearch-head/)

可以查看索引情况，搜索索引，查看集群状态和分片分布等

插件形式

```shell
./elasticsearch/bin/plugin install mobz/elasticsearch-head
open http://localhost:9200/_plugin/head/
```

独立webapp形式(存在问题)

```shell
1. git clone git://github.com/mobz/elasticsearch-head.git
2. Open index.html in a browser. A modern browser is required to use es-head
3. By default es-head will immediately attempt to connect to a cluster node at http://localhost:9200/.Enter a different node address in the connect box and click 'Connect' if required.
```

> es5版本的head插件的安装方式改变了，需要先clone下源码库，然后使用
>
> - npm install
> - npm run start

###### [http-basic](https://github.com/Asquera/elasticsearch-http-basic)

参见授权->密码授权

###### [BigDesk](https://github.com/lukas-vlcek/bigdesk)

该插件可以查看集群的jvm信息，磁盘IO，索引创建删除信息等，适合查找系统瓶颈，监控集群状态等，可以执行如下命令进行安装

```shell
./elasticsearch/bin/plugin install lukas-vlcek/bigdesk
```

> 说明：[ElasticSearch HQ](https://github.com/royrusso/elasticsearch-HQ)功能跟这个插件也很强大。



######  中文分词插件

官方的中文分词插件：[Smart Chinese Analysis Plugin](https://github.com/elasticsearch/elasticsearch-analysis-smartcn)

Medcl开发的中午分词插件： [IK Analysis Plugin](https://github.com/medcl/elasticsearch-analysis-ik)  以及 [Pinyin Analysis Plugin](https://github.com/medcl/elasticsearch-analysis-pinyin)

######  [ZooKeeper Discovery](https://github.com/sonian/elasticsearch-zookeeper)

elasticsearch 默认是使用Zen作为集群发现和存活管理的，ZooKeeper作为一个分布式高可用性的协调性系统，在这方面有着天然的优势，如果你比较信任zookeeper，那么你可以使用这个插件来替代Zen。

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

#### 配置

##### 访问

在一台机器上运行elasticsearch，然后在另一台机器上通过[浏览器访问](http://www.jianshu.com/p/658961f707d8)

```shell
vim elasticsearch.yml
修改为 network.host:0.0.0.0
```

##### 授权

###### xpack-授权

在安装x-pack插件之后的密码更改：

```shell
curl -XPUT "http://localhost:9200/_xpack/security/user/kibana/_password" -H 'Content-Type: application/json' -d'
{
  "password": "kibana"
}'
```

再次操作的时候需要制定用户名和密码：

```shell
curl --user 'elastic':'elastic'  -XPUT 'localhost:9200/company1?pretty'
```

###### [密码授权](http://blog.csdn.net/hereiskxm/article/details/47396045)

安装[elasticsearch-http-basic](https://github.com/Asquera/elasticsearch-http-basic)插件

```shell
#Download the desired version from https://github.com/Asquera/elasticsearch-http-basic/releases and copy it to plugins/http-basic.
mkdir -p plugins/http-basic;
mv elasticsearch-http-basic-x.x.x.jar plugins/http-basic
```

添加如下的配置：

```
http.basic.enabled: true
http.basic.user: "yjm"
http.basic.password: "123"
http.basic.ipwhitelist: [ "localhost","127.0.0.1" ]
http.basic.trusted_proxy_chains: []
http.basic.log: false
http.basic.xforward: ""
```

备注：

> 可能由于版本问题，插件安装之后不能启动elasticsearch

### 进阶

#### 基础

##### 信息查看

```shell
curl -X<REST Verb> <Node>:<Port>/<Index>/<Type>/<ID>
# 查看集群健康状态
curl 'localhost:9200/_cat/health?v'

# 获取集群的节点列表
curl 'localhost:9200/_cat/nodes?v'

# 查看所有索引
curl 'localhost:9200/_cat/indices?v'

# 查看插件列表(同时也是查看所有节点的信息)
curl 'localhost:9200/_nodes/plugins?pretty=true'
```

##### 创建和插入

创建索引

``` shell
# 创建普通索引
curl -XPUT 'localhost:9200/company1?pretty'

# 创建map索引
curl -XPUT 'localhost:9200/company2?pretty' -d '
{
    "settings":{
        "number_of_shards":3,
        "number_of_replicas":1
    },
    "mappings":{
        "person":{
            "properties":{
                "name":{
                    "type":"text"
                },
                "age":{
                    "type":"integer"
                },
                "author":{
                    "type":"keyword"
                },
                "date":{
                    "type":"date",
                    "format":"yyyy-MM-dd:HH:mm:ss||yyyy-MM-dd"
                }
            }
        }
    }
}
'
```

索引文档

```shell
# 创建索引并索引文档(并设置文档id为1)
curl -XPUT 'localhost:9200/company1/external/1?pretty' -d '
{
  "name": "John Doe"
}'

# 自动分配id
curl -XPOST 'localhost:9200/company1/external/?pretty' -d '
{
  "name": "John Doe AutoID"
}'
```

> 查询创建的文档进行验证
>
> ```
> curl -XGET  'http://localhost:9200/company1/_search?pretty'
> ```

##### 修改数据

```shell
curl -XPUT 'localhost:9200/customer/external/1?pretty' -d '
{
　 "name": "John Doe"
}'
curl -XPUT 'localhost:9200/customer/external/1?pretty' -d '
{
　 "name": "Jane Doe"
}'
#上述命令语句是：先新增id为1，name为John Doe的数据，然后将id为1的name修改为Jane Doe。
```

更新数据

```shell
# 这个例子展示如何将id为1文档的name字段更新为Jane Doe：
curl -XPOST 'localhost:9200/customer/external/1/_update?pretty' -d '
{
　 "doc": { "name": "Jane Doe" }
}'


# 这个例子展示如何将id为1数据的name字段更新为Jane Doe同时增加字段age为20:
curl -XPOST 'localhost:9200/customer/external/1/_update?pretty' -d '
{
　 "doc": { "name": "Jane Doe", "age": 20 }
}'

# 也可以通过一些简单的scripts来执行更新。一下语句通过使用script将年龄增加5:
curl -XPOST 'localhost:9200/customer/external/1/_update?pretty' -d '
{
  "script" : "ctx._source.age += 5"
}'

curl -XPOST 'localhost:9200/customer/external/1/_update?pretty' -d '
{
  "script" :{
  	"lang":"painless",
  	"inline":"ctx._source.age += 5"
  	//"inline":"ctr._source.age=params.age"
  	"params":{
      "age":100
  	}	
}'
```

##### 删除数据

```shell
# 删除索引(注意支持通配删除,同时删除了下面的文档)
curl -XDELETE 'localhost:9200/logstash-arthas-access-2017*?pretty'

# 删除数据(下面的语句将执行删除Customer中ID为2的数据)：
curl -XDELETE 'localhost:9200/customer/external/2?pretty'
```

##### 批处理

```shell
#下面语句将在一个批量操作中执行创建索引：
curl -XPOST 'localhost:9200/customer/external/_bulk?pretty' -d '
{"index":{"_id":"1"}}
{"name": "John Doe" }
{"index":{"_id":"2"}}
{"name": "Jane Doe" }
'

#下面语句批处理执行更新id为1的数据然后执行删除id为2的数据
curl -XPOST 'localhost:9200/customer/external/_bulk?pretty' -d '
{"update":{"_id":"1"}}
{"doc": { "name": "John Doe becomes Jane Doe" } }
{"delete":{"_id":"2"}}
```

验证插入的数据:

```shell
#匹配所有数据，但只返回1个:(如果size不指定，则默认返回10条数据)
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　"query": { "match_all": {} },
  "size": 1
}'


# 返回从11到20的数据。（索引下标从0开始）
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　"query": { "match_all": {} },
  "from": 10,
　 "size": 10
}'


# 排序 （返回前10条,如果不指定size，默认最多返回10条）。
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　 "query": { "match_all": {} },
 　"sort": { "balance": { "order": "desc" } }
}'

# 返回部分字段
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　 "query": { "match_all": {} },
　 "_source": ["account_number", "balance"]
}'
```

#### 查询

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

其中muti_match关键字在查询多个field的时候作为match关键字的简写方式，`fields`属性指定需要查询的字段，如果我们想查询所有的字段，这时候可以使用`_all`关键字.

更多例子：

```shell
#返回account_number 为20 的数据:
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　 "query": { "match": { "account_number": 20 } }
}'


#返回address中包含mill的所有数据：:
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　 "query": { "match": { "address": "mill" } }
}'

#返回地址中包含mill或者lane的所有数据：
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　"query": { "match": { "address": "mill lane" } }
}'
#和上面匹配单个词语不同，下面这个例子是多匹配（match_phrase短语匹配），返回地址中包含短语 “mill lane”的所有数据：
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　 "query": { "match_phrase": { "address": "mill lane" } }
}'
```

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

##### bool条件组

我们可以在查询条件中使用AND/OR/NOT操作符，这就是布尔查询(Bool Query)。

- 布尔查询可以接受一个`must`参数(等价于AND)，
- 一个`must_not`参数(等价于NOT)，
- 以及一个`should`参数(等价于OR)。

比如，我想查询title中出现`Elasticsearch`或者`Solr`关键字的图书，图书的作者是`clinton gormley`，但没有`radu gheorge`，我们可以这么来查询：

```json
{
    "query":{
        "bool":{
            "must":{
                "match":{
                    "authors":"clinton gormely"
                }
            },
            "must_not":{
                "match":{
                    "authors":"radu gheorge"
                }
            }
        }
    }
}
```

##### filter过滤

```shell
#下面这个例子使用了布尔查询返回balance在20000到30000之间的所有数据
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
	"query": {
		"bool": {
			"must": { "match_all": {} },
			"filter": {
				"range": {
					"balance": {
						"gte": 20000,
						"lte": 30000
		　　		}
				}
			}
　　	}
	}
}'
```

##### aggr聚合

```shell
#下面这个例子： 将所有的数据按照state分组（group），然后按照分组记录数从大到小排序，返回前十条（默认）：
# 注意：我们设置size=0，不显示查询hits，因为我们只想看返回的聚合结果。
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
	"size": 0,
	"aggs": {
		"group_by_state": {
			"terms": {
				"field": "state"
			}
		}
	}
}'


# 下面这个实例按照state分组，降序排序，返回balance的平均值：
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
	"size": 0,
	"aggs": {
		"group_by_state": {
			"terms": {
				"field": "state"
			},
			"aggs": {
				"average_balance": {
					"avg": {
						"field": "balance"
					}
				}
			}
		}
	}
}'


```

### 备份

#### 导入和导出

##### 文件导入

示例：data/accounts.json数据集，其中每个数据都是如下的格式

```json
{
	"index":{"_id":"1"}
}
{
	"account_number": 0,
	"balance": 16623,
	"firstname": "Bradshaw",
	"lastname": "Mckenzie",
	"age": 29,
	"gender": "F",
	"address": "244 Columbus Place",
	"employer": "Euron",
	"email": "bradshawmckenzie@euron.com",
	"city": "Hobucken",
	"state": "CO"
}

```

导入命令

```shell
curl -XPOST 'localhost:9200/bank/account/_bulk?pretty' --data-binary "@accounts.json"

# 查询导入是否成功
curl 'localhost:9200/bank/_search?q=*&pretty' # 其中q=*表示匹配索引中的所有数据，等价于：
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
　　  "query": { "match_all": {} }
}'
```

##### logstash导入

```
待补充
```

## 参考

- 基础

  [Elasticsearch6官方安装教程](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/rpm.html)

  [Elasticsearch系列文章](https://www.iteblog.com/archives/tag/elasticsearch)

  [Elasticsearch5.0系统服务安装](http://www.07net01.com/2016/11/1728006.html)

  [elasticsearch 配置 JDBC数据源 与IK 中文分词插件](http://blog.mreald.com/160)

  [head插件安装](http://www.sojson.com/blog/85.html)

  [ElasticSearch集群和索引常用命令](https://www.cnblogs.com/pilihaotian/p/5846173.html)

- 进阶

  [ELK日志分析系统](http://467754239.blog.51cto.com/4878013/1700828)(其中有redis数据的读取)

  [glances数据导入Elasticsearch](https://glances.readthedocs.io/en/stable/gw/elastic.html)

  [Python操作Elasticsearch](http://www.cnblogs.com/yxpblog/p/5141738.html)

  [ElasticSearch 索引查询使用指南——详细版（推荐）](https://www.cnblogs.com/pilihaotian/p/5830754.html)

- 备份

  ​

