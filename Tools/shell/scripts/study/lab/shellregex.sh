#!/bin/bash
cd $(dirname $0)

str1="233201702323"
if [[ "$str1" =~ "2017" ]];then
    echo ${str1}匹配到2017
else
    echo ${str1}不匹配2017
fi

