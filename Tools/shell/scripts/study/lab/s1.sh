#!/bin/bash

set -e

cnt=`grep -c -s -q info upload.log`
echo "结果:"$cnt

exit 0
