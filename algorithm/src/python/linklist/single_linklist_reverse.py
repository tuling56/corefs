#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Fun:单链表反转
	Ref:https://blog.csdn.net/u011452172/article/details/78127836?locationNum=1&fps=1
	State：
	Date:2017/5/17
	Author:tuling56
'''
import re, os, sys
import hues

reload(sys)
sys.setdefaultencoding('utf-8')

from single_linklist import Sample

class Solution():

    # 辅助数组O(n,n)
    def reverseList_arr(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        if head is None or head.next is None:
            return head

        # 辅助数组(主要是为了利用数组的倒序遍历)
        res = []
        item = head
        while item.next is not None:
            res.append(item)
            item = item.next
        res.append(item)

        #链表转换成列表之后即可按列表操作
        rstart = res[-1]        # 反转之后的链表头
        item=rstart
        for i in res[::-1][1:]:  # 链表反转
            item.next=i
            item = i
        item.next=None

        return rstart

    # 新建表头O(n,1)
    def reverseList_newHead(self,head):
        if head is None or head.next is None:
            return head
        cur=head
        tmp=None
        newhead=None
        while cur:
            tmp=cur.next      # 保存下一个
            cur.next=newhead  # 本来指向下一个的直线新表头
            newhead=cur       # 更新当前元素为新表头（新表头是在不断更新的）
            cur=tmp           # 循环下一个
        return newhead


    # 就地反转O(n,1)
    def reverseList_inplace(self,head):
        if head==None or head.next==None:
            return head
        p1=head
        p2=head.next
        tmp=None
        while p2:
            tmp=p2.next
            p2.next=p1
            p1=p2
            p2=tmp
        head.next=None
        return p1

    # 递归反转O(n,1)
    def reverseList_recursion(self,head):
        if head is None or head.next is None:
            return head
        else:
            newhead = self.reverseList_recursion(head.next)
            head.next.next = head
            head.next = None
        return newhead


if __name__ == "__main__":
    s=Solution()
    ex=Sample()
    l1=ex.gen_example(3)
    ex.visit_example(l1)

    #rl1=s.reverseList_arr(l1)
    #rl1=s.reverseList_newHead(l1)
    rl1=s.reverseList_inplace(l1)
    #rl1=s.reverseList_recursion(l1)
    ex.visit_example(rl1)

    print('------')
