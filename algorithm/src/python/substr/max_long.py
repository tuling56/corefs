#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
    Fun:最长连续子串
    Ref:
    State：存在问题
    Date:2017/4/26
    Author:tuling56
'''
import re, os, sys
import hues

reload(sys)
sys.setdefaultencoding('utf-8')


class MaxLong(object):
    def __init__(self):
        pass

    # 最长数字连续子串    
    def max_long_continous(self,inputl):
        startpos,endpos = 0,0
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


    # 最长连续相同
    def max_long_same(self,inlist):
        if not inlist or len(inlist)==1:
            return inlist

        lstr=[]
        startpos,endpos=0,0
        for k,v in enumerate(inlist[:-1]):
            if inlist[k+1]==v:
                endpos+=1
            else:
                lstr.append((v,(startpos,endpos)))
                startpos,endpos=k+1,k+1

        if inlist[-1]==inlist[-2]:
            lstr.append((inlist[-1],(startpos,endpos)))

        if inlist[-1]!=inlist[-2]:
            lstr.append((inlist[-1],(len(inlist)-1,len(inlist)-1)))

        lres=[]
        for v,se in lstr:
            llen=se[1]-se[0]+1
            if llen>2:
                hues.warn(v,se)
                lres.append((v,llen))
            else:
                hues.warn(v,se)

        return lres


# 测试入口
if __name__ == "__main__":
    maxl=MaxLong()
    maxl.max_long_continous([1,2,3,3,3,4,5,6,7,8,9,2,2,2,3])
    #hues.success(maxl.max_long_same([1,1,1,2,3,2,2,3,2,2,2,3,2,2,2,2]))