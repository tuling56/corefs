#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Fun:数组相关题
	Ref:
	State：
	Date:2017/5/17
	Author:tuling56
'''
import re, os, sys
import hues

reload(sys)
sys.setdefaultencoding('utf-8')


class Solution():
    # 问题是时间复杂度太高，O(n^2)
    def maxArea(self,height):
        '''
        :ref :https://leetcode-cn.com/problems/container-with-most-water/
        :param int[] height
        :return: int
        '''
        area=0
        maxi,maxj,max_vheight,max_vwidth = 0,0,0,0

        for i, v1 in enumerate(height):
            for j, v2 in enumerate(height[i+1:]):
                vheight = min(v1, v2)
                vwidth = 1 if j+i==0 else j+1
                #area = vheight * vwidth if vheight * vwidth > area else area
                if vheight*vwidth>area:
                    maxi=i
                    maxj=j+maxi+1
                    max_vheight=vheight
                    max_vwidth=vwidth
                    area=vheight*vwidth

        print "maxi:{},{}\nmaxj:{},{}" .format(maxi,height[maxi],maxj,height[maxj])
        print "max_vheight:{}\nmax_vwidth:{}".format(max_vheight,max_vwidth)

        return area

    # 如何降低时间复杂度
    def maxArea2(self,height):
        maxArea=0
        for i, v1 in enumerate(height):
            for j, v2 in enumerate(height[i+1:]):
                if v1+(j+1)*abs(v2-v1)<0:
                    continue
                else:
                    pass

    # 括号正确匹配
    def brackeMatch(self,s):
        '''
        ：ref：https://leetcode-cn.com/problems/valid-parentheses/
        :param s:str
        :return:boolen
        '''

        m1,m2,m3=0,0,0
        t1,t2,t3=0,0,0

        for item in s:
            if item=='(':
                m1+=1
            elif item=='{':
                m2+=1
            elif item=='[':
                m3+=1
            elif item==')' and m1>=1 and t2+t3==0:
                m1-=1
            elif item=='}' and m2>=1 and t1+t3==0:
                m2-=1
            elif item==']' and m3>=1 and t1+t2==0:
                m3-=1
            elif item in (')','}',']'):
                return False
            else:
                continue

        print m1,m2,m3

        if m1+m2+m3==0:
            return True
        return False

    # 生成所有的匹配括号
    def genBractAllMatched(self,n):
        '''
        :ref:https://leetcode-cn.com/problems/generate-parentheses/
        :param n: int
        :return: list[str]
        '''
        pass


if __name__ == "__main__":
    s = Solution()
    #print s.maxArea([1,8,6,2,5,4,8,3,7])
    #print s.maxArea([1, 1])
    #print s.maxArea([1,2,1])
    print s.brackeMatch("([)]")
    #print s.brackeMatch("(){[]}")