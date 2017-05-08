#!/bin/bash
cd `dirname $0`

function t1()
{
     echo "函数t1外围"

     {
         echo "组命令1";
         echo "组命令2";
         echo "组命令3";
         echo "组命令4";
         echo "组命令5";
         echo "组命令6";
     }>> group_res
}

t1
