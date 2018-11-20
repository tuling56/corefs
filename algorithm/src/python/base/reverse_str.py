#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Fun:字符串反转
	Ref:
	State：
	Date:2017/5/17
	Author:tuling56
'''
import re, os, sys
import hues

reload(sys)
sys.setdefaultencoding('utf-8')


class Solution(object):
    def reverseStr(self, s, k):
        """
        :ref:https://leetcode-cn.com/problems/reverse-string-ii/
        :type s: str
        :type k: int
        :rtype: str
        """
        s=list(s)
        num=0
        for i in range(0,len(s)/(2*k)):
            num=i+1
            s[2 * k * i:2 * k * i + k] = s[2 * k * i:2 * k * i + k][::-1]

        if 2*k*num+k<len(s):
            s[2 * k * num:2 * k * num + k] = s[2 * k * num:2 * k * num + k][::-1]
        else:
            s[2 * k * num:len(s)] = s[2 * k * num:len(s)][::-1]

        return ''.join(s)

    def reverseOnlyLetter(self,S):
        '''
        :ref:  https://leetcode-cn.com/problems/reverse-only-letters/
        :param s:
        :return: str
        '''
        ls = filter(lambda x: x.isalpha(), list(S))
        ls.reverse()

        i = 0
        lres = list(S)
        for k, v in enumerate(lres):
            if v.isalpha():
                lres[k] = ls[i]
                i = i + 1
        return ''.join(lres)

    def reverseOnlyLetter2(self,S):
        S=list(S)
        i,j=0,len(S)-1
        while i<j:
            if S[i].isalpha() and S[j].isalpha():
                S[j],S[i]=S[i],S[j]
                i+=1
                j-=1
            elif not S[i].isalpha():
                i+=1
            elif not S[j].isalpha():
                j-=1
            else:
                i+=1
                j-=1
        return ''.join(S)




if __name__ == "__main__":
    s = Solution()
    #print s.reverseStr('abcdefghkl',4)
    #print s.reverseOnlyLetter("a-bC-dEf-ghIj")
    print s.reverseOnlyLetter2("a-bC-dEf-ghIj")