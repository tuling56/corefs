#########################################################################
# File Name: mpaste.sh
# Description:paste命令学习 
# Author:tuling56
# State:
# Created_Time: 2017-11-02 13:01
# Last modified: 2017-11-02 03:15:39 PM
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
cd $dir

inputf=$1

inseq="\t"
outseq="\t"

# 内存超过(列超长)
function mpaste()
{

    headrow=($(head -1 $inputf))
    colnum=${#headrow[*]}
    for c in $(seq 1 $colnum);do
        if [ "$inseq" = "\t" ];then
            #cut -f$c $inputf |paste -d"$outseq" -s
            cut -f$c $inputf |tr '\n' ' '
        else
            #cut -d"$inseq" -f$c $inputf |paste -d"$outseq" -s
            cut -d"$inseq" -f$c $inputf |tr '\n' ' '
        fi
    done
}

# 输出不对
function mpaste2()
{
    #awk 'BEGIN{while(i<=NF){"col"i="";}}{while(i<=NF){"col"i="col"i" "$i;}}END{while(i<=NF){print "col"i"\n";}}' file.txt
    awk '{i=1;
          while(i<=NF){
            col="col"i;
            a[col]=a[col]" "$i;
            i=i+1;
            }
         }
         END{
            for(v in a){
                print substr(a[v],2);
            }
        }' $inputf
}


function mpaste3()
{

    return 
}



mpaste

