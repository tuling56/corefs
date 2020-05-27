#!/bin/bash
cd $(dirname $0)

# method1
#sed -i 's/\t/    /g' tabspace.data

# method2
cat tabspace.data|tr "\t" "    " >tabspace.data

# method3
#cat tabspace.data| col -x > tabspace.data

exit 0
