#!/bin/bash
cd `dirname $0`

gcc -w -o main main.cpp -lpython2.7
echo "运行结果是:"
./main


exit 0
