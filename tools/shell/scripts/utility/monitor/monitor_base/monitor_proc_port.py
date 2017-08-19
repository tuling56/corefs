#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
	Date:20160408
	Author:tuling56
	Fun:进程和端口监控
'''

import sys
import os.path as op
#print sys.getdefaultencoding()
#reload(sys)
#sys.setdefaultencoding('utf-8')

import subprocess
import socket

def this_abs_path(script_name):
    return op.abspath(op.join(op.dirname(__file__), script_name))

# 监控进程
def monitor_process(key_word, cmd):
    p1 = subprocess.Popen(['ps', '-ef'], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(['grep', key_word], stdin=p1.stdout, stdout=subprocess.PIPE)
    p3 = subprocess.Popen(['grep', '-v', 'grep'], stdin=p2.stdout, stdout=subprocess.PIPE)

    lines = p3.stdout.readlines()
    if len(lines) > 0:
        return

    sys.stderr.write('process[%s] is lost, run [%s]\n' % (key_word, cmd))
    subprocess.call(cmd, shell=True)

# 监控端口
def monitor_port(protocol, port, cmd):
    address = ('127.0.0.1', port)
    socket_type = socket.SOCK_STREAM if protocol == 'tcp' else socket.SOCK_DGRAM
    client = socket.socket(socket.AF_INET, socket_type)

    try:
        client.bind(address)
    except Exception, e:
        pass
    else:
        sys.stderr.write('port[%s-%s] is lost, run [%s]\n' % (protocol, port, cmd))
        subprocess.call(cmd, shell=True)
    finally:
        client.close()

# 主程序
if __name__ == '__main__':
    cmd = '%s start' % this_abs_path('gun.sh')
    #monitor_process('\[yuanzhaopin\]', cmd)
    monitor_port('tcp', 8635, cmd)