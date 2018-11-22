#!/bin/bash
cd `dirname $0`

function f1 ()
{
    echo "f1 retrun 前"
    return 1
    echo "f1 return 后"
}



function f2 ()
{
    echo "f2 retrun 前"
    return 1
    echo "f2 return 后"
}


f1
f2
