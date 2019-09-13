#!/bin/python
#coding:utf8
import os,sys
from urllib import quote,unquote

reload(sys)
sys.setdefaultencoding('utf-8')


def hex2str(hexstr):
	hexstr=hexstr.replace('%','')
	#print "剔除%:",hexstr
	unhexstr=hexstr.decode('hex')
	print unhexstr
	return unhexstr

def munquote(hexstr):
	unhexstr=unquote(hexstr)
	#print "反hex:",unhexstr
	return unhexstr


if __name__ == "__main__":
	input=sys.argv[1]
	hex2str(input)
