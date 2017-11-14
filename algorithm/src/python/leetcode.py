#!/usr/bin/env python
#-*-coding:utf-8-*-
'''
    Fun:leetcode题目的python解法
    Ref:http://blog.csdn.net/column/details/leetcode-with-python.html
    Author:tuling56
    Date:2017年11月5日
'''

import os
import hues
import sys

reload(sys)
sys.setdefaultencoding('utf-8')


class Solution(object):
    # 字符串反转
    def reverse(self,x):
        '''
        :type x: int
        :rtype:int
        '''

        xs=str(x)
        if xs.startswith('-'):
            xr='-'+xs[1:][::-1]
        elif xs[-1]=='0':
            xr=xs[:-1][::-1]
        else:
            xr=xs[::-1]
        try:
            xri=int(xr)
        except Exception,e:
            return 0
        if xri>pow(2,31) or xri<-pow(2,31):
            return 0    
        return xri
    
    # 回文数判断
    def isPalindrome(self,x):
        '''
        :type x: int
        :rtype:bool
        '''
        if x<0:
            return False
        if str(x)==str(x)[::-1]:
            return True
        return False

    # 罗马字符转整型
    def roman2int(self,x):
        '''
        :type s: str
        :rtype:int
        ''' 
        pass
    
    # 最长公共前缀
    def longcommprefix(self,strs):
        '''
        :type strs:List[str]
        :rtype:str
        '''
        if not strs:
            return ''
        if len(strs)==1:
            return strs[0]

        lmin=min(map(lambda x:len(x),strs))
        cflag=True
        for i in range(lmin):
            curil=set([ p[i] for p in strs])
            if len(curil)!=1 or (len(curil)==1 and i==lmin-1):
                cflag=False
            if not cflag:    
                return strs[0][0:i+1]
        return ''    

    # 删除排序数组的重复数据

    # 移除重复元素
    def removeDupilcates(self,nums):
        '''
        :type nums:List[int]
        :rtype: int(去重后的数组长度)
        '''
        num=1
        for i in range(len(nums)-1):
            if nums[i+1]!=nums[i]:
                num+=1
        
        return num

    # 删除指定的元素
    def removeElement(self,nums,x):
        '''
        :type nums:List[int]
        :type x: int
        :rtype: int(去重后的数组长度)
        '''
        return sum(map(lambda v:0 if x==v else 1,nums))

     # 实现索引(子字符串的查找)

    # 字符串索引(查找子字符串是否包含，若有，返回包含位置)
    def strFind(self,haystack,needle):
        if not needle or not haystack:
            return -1
        for k,v in enumerate(haystack):
            try:
                if needle[k]==v:
                    if len(needle)==1:
                        return 0
                    for i in range(1,len(needle)):
                        if needle[i]!=haystack[k+1]:
                            break
                        elif i==len(needle)-1:
                            return k
                        else:
                            return -1
            except Exception,e:
                print str(e)

        return -1

    # 寻找插入位置
    def searchInsertPos(self,nums,target):
        '''
        :type nums: List[int]
        :type target:int
        :rtype: int
        '''

        conflag=True
        insertpos=0
        for k,v in enumerate(nums):
            if target<v and conflag:
                insertpos=k+1
            elif target==v:
                insertpos=k
                conflag=False
            else:
                return insertpos+1

        return insertpos

    # excel列翻译
    def excelColTitle2Num(self,s):
        '''
        :type s:str
        :rtype: int
        '''
        slen=len(s)
        numsum=0
        for k,v in enumerate(s):
            print k,v
            numstr=ord(v)-ord('A')+1
            if k!=slen-1:
                numint=numstr*pow(26,(slen-k-1))
            else:
                numint=ord(v)-ord('A')+1
            numsum+=numint
        return numsum

    # 范围搜寻(二分查找)
    def searchInRange(self,inlist,target):
        if target>inlist[-1] or target<inlist[0]:
            return -1

        low,high=0,len(inlist)-1  # 以数组的位置下标为索引
        while True:
            mpos=(low+high)/2
            mv=inlist[mpos]
            if target<mv:
                high=len(inlist)/2
            elif target>mv:
                low=len(inlist)/2
            else:
                return mpos
            hues.info(low,high)

    # 最大矩形面积
    def maxRectArea(self):
        pass
    
    # 最长子序列（此处是连续上升，需要使用到动态规划的思想）
    def maxLongSeq(self):
        pass


# 程序入口
if __name__ == '__main__':
    ms=Solution()
    #print ms.reverse(1534236469)
    #print ms.isPalindrome(121)
    #print ms.roman2int('XI')
    #print ms.longcommprefix(['d','c'])
    #print ms.removeDupilcates([1,1,2,2,3])
    #print ms.removeElement([3,2,2,3],3)
    #print ms.strStr("aaabb","baba")
    #print ms.searchInsertPos([1,3,5,6],7)
    #print ms.excelColTitleNum('AAA')
    print ms.searchInRange([1,3,3,4,5],2)