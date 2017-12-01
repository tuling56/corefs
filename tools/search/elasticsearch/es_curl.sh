#!/bin/bash
cd `dirname $0`
url=$1
pbody=$2

# echo -e "\033[1;31murl\033[0m" $url

# 创建元素的文档数据
function create_data()
{
	curl -XPUT 'http://localhost:9200/iteblog_book_index' -d '{ "settings": { "number_of_shards": 1 }}'
	# [返回结果]:{"acknowledged":true}

	curl -XPOST 'http://localhost:9200/iteblog_book_index/book/_bulk' -d '
	{ "index": { "_id": 1 }}
	{ "title": "Elasticsearch: The Definitive Guide", "authors": ["clinton gormley", "zachary tong"], "summary" : "A distibuted real-time search and analytics engine", "publish_date" : "2015-02-07", "num_reviews": 20, "publisher": "oreilly" }
	{ "index": { "_id": 2 }}
	{ "title": "Taming Text: How to Find, Organize, and Manipulate It", "authors": ["grant ingersoll", "thomas morton", "drew farris"], "summary" : "organize text using approaches such as full-text search, proper name recognition, clustering, tagging, information extraction, and summarization", "publish_date" : "2013-01-24", "num_reviews": 12, "publisher": "manning" }
	{ "index": { "_id": 3 }}
	{ "title": "Elasticsearch in Action", "authors": ["radu gheorge", "matthew lee hinman", "roy russo"], "summary" : "build scalable search applications using Elasticsearch without having to do complex low-level programming or understand advanced data science algorithms", "publish_date" : "2015-12-03", "num_reviews": 18, "publisher": "manning" }
	{ "index": { "_id": 4 }}
	{ "title": "Solr in Action", "authors": ["trey grainger", "timothy potter"], "summary" : "Comprehensive guide to implementing a scalable search engine using Apache Solr", "publish_date" : "2014-04-05", "num_reviews": 23, "publisher": "manning" }
	'
	# [返回结果]
	#
	# {
	#     "took": 33,
	#     "errors": false,
	#     "items": [
	#         {
	#             "index": {
	#                 "_index": "iteblog_book_index",
	#                 "_type": "book",
	#                 "_id": "1",
	#                 "_version": 1,
	#                 "_shards": {
	#                     "total": 2,
	#                     "successful": 1,
	#                     "failed": 0
	#                 },
	#                 "status": 201
	#             }
	#         },
	#         {
	#             "index": {
	#                 "_index": "iteblog_book_index",
	#                 "_type": "book",
	#                 "_id": "2",
	#                 "_version": 1,
	#                 "_shards": {
	#                     "total": 2,
	#                     "successful": 1,
	#                     "failed": 0
	#                 },
	#                 "status": 201
	#             }
	#         },
	#         {
	#             "index": {
	#                 "_index": "iteblog_book_index",
	#                 "_type": "book",
	#                 "_id": "3",
	#                 "_version": 1,
	#                 "_shards": {
	#                     "total": 2,
	#                     "successful": 1,
	#                     "failed": 0
	#                 },
	#                 "status": 201
	#             }
	#         },
	#         {
	#             "index": {
	#                 "_index": "iteblog_book_index",
	#                 "_type": "book",
	#                 "_id": "4",
	#                 "_version": 1,
	#                 "_shards": {
	#                     "total": 2,
	#                     "successful": 1,
	#                     "failed": 0
	#                 },
	#                 "status": 201
	#             }
	#         }
	#     ]
	# }
	#

}


# 创建索引
function create_index()
{

	curl -XPUT  'http://localhost:9200/indexdb'

}


function mapping_doc()
{

	curl -XPOST 'http://localhost:9200/indexdb/fulltext/_mapping' -d '
	{
	    "fulltext": {
	       "_all": {
	      "analyzer": "ik"
	     },
	     "properties": {
	      "content": {
		"type" : "string",
		"boost" : 8.0,
		"term_vector" : "with_positions_offsets",
		"analyzer" : "ik",
		"include_in_all" : true
	      }
	    }
	  }
	}'

}



# 查询title中包含我的文档
function index_doc()
{
	curl –XPUT/POST  'http://localhost:9200/indexdb/doctype/1?pretty' -d '
	{
	  "title": "我的标题",
	  "content": "我的内容"
	}'
}

function search_doc()
{
	curl -XGET 'http://localhost:9200/indexdb/doctype/_search?pretty=true' -d '
	{
	    "query":{
	        "query_string":{"title":"我的"}
	    }
	}'
}

function word_seg()
{
	curl 'http://localhost:9200/indexdb/_analyze?analyzer=ik_max_word&pretty=true' -d'
	{
	    "text":"中华人民共和国国歌"
	}'

}


create_data
# mapping_doc
# word_seg