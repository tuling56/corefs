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


if __name__ == "__main__":
	print "main"

class Student:
	def SetName(self,name):
		self._name=name
	def PrintName(self):
		print self._name
def hello():
	print "hello world\n"
        return "this is return value"

def world(name):
	print name
	
	
	
