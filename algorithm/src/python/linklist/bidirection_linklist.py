#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Fun:双向链表生成
	Ref:
	State：
	Date:2017/5/17
	Author:tuling56
'''

import random

# Definition for bidirection-linked list.
class ListNode(object):
     def __init__(self, x):
         self.val = x
         self.prev = None
         self.next = None

class Sample(object):
    # 链表生成
    def gen_example(self):
        s=[]
        for i in range(0,10):
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
