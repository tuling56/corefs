#!/bin/bash

# 多列排序
awk '{print $2"\t"$3"\t"$1}' uniq.data |uniq -f2 -d

# 只选出重复列（可能选出的是重复列的第一列）
cut -f1 uniq.data |sort |uniq -d


exit 0

