#!/bin/bash

if [ $# -ne 3 ] ; then
    echo "usage: rsync_up.sh src dest cente"
    exit 1
fi
src=$1
dest=$2
host=$3

echo "begin..."
echo "src=$src"
echo "dest=$dest"
echo "host=$host"

rsync -avzL --timeout=120 $src ccrsync@$host::CCUPLOAD/$dest

echo "finish..."
