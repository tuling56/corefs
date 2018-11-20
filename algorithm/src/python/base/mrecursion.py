#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Fun:递归
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
    # 递归解决字符串反转
    def strReverse(self,s):
        if len(s)<1:
            return s
        print self.strReverse(s[1:])+s[0]
        return self.strReverse(s[1:])+s[0]


if __name__ == "__main__":
    s = Solution()
    print s.strReverse('acdwe')