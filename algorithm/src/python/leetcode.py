#!/usr/bin/env python
#-*-coding:utf-8-*-
'''
    Fun:leetcode题目的python解法
    Ref:http://blog.csdn.net/column/details/leetcode-with-python.html
    Author:tuling56
    Date:2017年11月5日
'''

import os
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
        for i in range(lmin):
            curil=set([ p[i] for p in strs])
            if len(curil)!=1 or i==lmin:
                return strs[0][0:i]
        return ''    




if __name__ == '__main__':
    ms=Solution()
    #print ms.reverse(1534236469)
    #print ms.isPalindrome(121)
    #print ms.roman2int('XI')
    print ms.longcommprefix(['cdx','cd'])