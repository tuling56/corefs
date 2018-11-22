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

if not hasattr(sys, 'argv'):
    sys.argv  = ['']


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

# 参数调用
def fun_para(name):
	print name
	

# 单参数调用并有返回值
def fun_para_return(name):
	print "hello "+name+"!"
	return "[Return]:hello "+name+"!"


# 多参数调用并有返回值
def fun_paras_return(name,age,city):
	print "your name is: "+ name
	print "your age  is: "+ str(age)
	print "your city is: "+ city
	return "[Return]:hello:"+name+age+city+"!"


if __name__ == "__main__":
	para1,para2,para3="para1","para2","para3"
	fun_para(para1)
	print fun_para_return(para1)
	print fun_paras_return(para1,para2,para3)


	stu=Student()
	stu.SetName("xiaowang")
	stu.PrintName()
	print stu.GetName()