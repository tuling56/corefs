#!/bin/bash
cd `dirname $0`
url=$1
pbody=$2

# echo -e "\033[1;31murl\033[0m" $url


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


# mapping_doc
word_seg