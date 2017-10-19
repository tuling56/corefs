#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
    Fun:最长连续子序列
    Ref:
    State：
    Date:2017/4/26
    Author:tuling56
'''
import re, os, sys
import hues

reload(sys)
sys.setdefaultencoding('utf-8')


def fun():
    inputl = [1, 2, 4, 5, 7, 9, 12, 13, 14]
    startpos = 0
    endpos = 0
    end = False

    # 先求所有的子序列
    allser = []
    for pos in range(len(inputl)):
        if pos != len(inputl) - 1:
            nowv = inputl[pos]
            if inputl[pos + 1] - inputl[pos] == 1:
                end = False
                endpos = pos + 1
            else:
                end = True

            # 记录子序列
            if end:
                print u'当前最长连续子序列为：', inputl[startpos:endpos + 1]
                allser.append(inputl[startpos:endpos + 1])
                startpos = pos + 1  # 更新子序列的起始位置
                endpos = startpos

    # 子序列长度列表
    lenl = map(lambda x: len(x), allser)

    # 最长子序列的位置
    maxl = max(lenl)
    maxpos = []
    for i in range(len(lenl)):
        if lenl[i] == maxl:
            maxpos.append(i)

    # 输出所有的最长子序列
    print u"整体最长连续子序列是:"
    for v in maxpos:
        print allser[v]


# 测试入口
if __name__ == "__main__":
    fun()
