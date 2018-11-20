#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Fun:单向链表生成
	Ref:http://mp.weixin.qq.com/s/Ru_TpOnelMXPzH-1o34oZw
	State：
	Date:2017/5/17
	Author:tuling56
'''

import random

# Definition for singly-linked list.
class ListNode(object):
     def __init__(self, x):
         self.val = x
         self.next = None

class Sample(object):
    #构建测试用例
    def gen_example1(self):
        s0=ListNode(99)
        s1=ListNode(12)
        s2=ListNode(1)
        s3=ListNode(20)
        s4=ListNode(4)
        s5=ListNode(6)
        s0.next=s1
        s1.next=s2
        s2.next=s3
        s3.next=s4
        s4.next=s5

        return s0

    # 链表生成
    def gen_example(self,listLength):
        s=[]
        for i in range(0,listLength):
            v1=random.randint(1,9)*2+random.randint(1,9)
            v2=random.randint(1,9)*3+random.randint(1,9)
            s.append(ListNode(v1))
            s.append(ListNode(v2))
            s[i].next=s[i+1]
            s[i+1].next=None
        return s[0]

    # 链表遍历
    def visit_example(self,head):
        while head.next is not None:
            print(str(head.val)+" "),
            head=head.next
        print head.val
