#!/bin/bash
cd `dirname $0`

g++ -w -o main main.cpp -lpython2.7 -Istdc++
echo "运行结果是:"
./main


exit 0
