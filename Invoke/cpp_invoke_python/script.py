#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Date:
	Author:tuling56
'''
import os
import sys
#print sys.getdefaultencoding()
reload(sys)
sys.setdefaultencoding('utf-8')


# 类调用
class Student:
	def __init__(self):
		print "init Student Class"
	def SetName(self,name):
		self._name=name
	def PrintName(self):
		print self._name
	def GetName(self):
		return "[Return]:",self._name

# 参数调用并有返回值
def fun_para_return(name):
	print "hello "+name+"!"
	return "[Return]:hello "+name+"!"

# 参数调用
def fun_para(name):
	print name
	
	
if __name__ == "__main__":
	para="para1"
	fun_para(para)
	print fun_para_return(para)

	stu=Student()
	stu.SetName("xiaowang")
	stu.PrintName()
	print stu.GetName()