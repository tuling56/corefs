#!/bin/bash
cd $(dirname $0)

sed -i 's/    /\t/g' tabspace.data

exit 0
