#!/bin/bash

if [ $# -ne 3 ] ; then
    echo "usage: rsync_get.sh src dest center"
    exit 1
fi
src=$1
dest=$2
host=$3

echo "begin..."
echo "src=$src"
echo "dest=$dest"

rsync -avzL --timeout=120 ccrsync@$host::ONCENTER/$src $dest

echo "finish..."
