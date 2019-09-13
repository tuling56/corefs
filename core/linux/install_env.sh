#!/bin/bash
cd `dirname $0`

sudo apt-get update

function install_basic()
{
	sudo apt-get install -y wget python
	wget https://bootstrap.pypa.io/get-pip.py && sudo python get-pip.py
}



exit 0
