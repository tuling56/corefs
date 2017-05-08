#!/bin/bash
cd `dirname $0`
url=$1
pbody=$2

echo -e "\033[1;31murl\033[0m" $url
echo -e "\033[1;31mpbody\033[0m" $pbody

echo "curl '$1' -d '$2'"
curl "$1" -d "$2"

exit 0



curl 'http://longtail.v.xunlei.com/like?userid=123456&sessionid=xxx&bussinessid=-1' -d 'uid=123456&lid=123&opt=1&t1482250508'
