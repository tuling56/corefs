#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Fun     : Python实现链表
# @Ref     : http://blog.csdn.net/dinnerhowe/article/details/58191823
# @State   :
# @Author  : tuling56
# @Date    : 2017-11-05 18:12:53

import os
import sys

reload(sys)
sys.setdefaultencoding('utf-8')


'''
    定义数据结构
'''
class ListNode(object):
    def __init__(self):
        self.val=None
        self.next=None

'''
    实现数据结构的运算
'''
class Solution(object):
    def __init__(self)：
        self.node=None

    # 新加节点
    def add(self,x):
        node=ListNode() # 添加一个新节点
        node.val=x
        node.next=self.node

        self.node=node

        return node
    # 节点遍历
    def visit(self,ListNode)


if __name__ == '__main__':
    ms=Solution()
    ms.