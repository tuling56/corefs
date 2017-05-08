#!/bin/bash
# 20130913
if [ $# -ne 1 ] ; then
    echo "usage: $0 <host>"
    exit 1
fi

dir="/usr/local/monitor-base"
shfile="$dir/bin/check_file.sh"
host=$1

list="$dir/upfile/$host.list"
rcenter=""

m_new="$dir/upfile/modify.new"
m_old="$dir/upfile/modify"

auto_update()
{
    if [ ! -f "$list" ]
    then
        ifcenter
        $dir/bin/rsync_get.sh /$host.list $dir/upfile/ $rcenter
        return 0
    fi

    cmd=`$dir/bin/getcmd.sh check_file 1`

    if [ "$cmd" == "noopt" ]
    then
        return 0
    fi
    if [ "$cmd" == "clear" ]
    then
        echo "" > $m_old
        return 0
    fi

    if [ "$cmd" == "upfile" ]
    then
        ifcenter
        $dir/bin/rsync_get.sh /$host.list $dir/upfile/ $rcenter
        return 0
    fi
}


ifcenter()
{
    rcenter=`$dir/bin/getcmd.sh rsync 1`
    sz=`rsync --timeout=30 ccrsync@$rcenter:: | grep CCUPLOAD | wc -l`
    if [ $sz -lt 1 ]
    then
        sed -i "/center/d" $dir/conf/on.conf   #research center addres.
        exit 1
    fi
}

upload_file()
{
    file=$1
    new=`ls -l $file|grep "$file"`
    old=`cat $m_old | grep "$file"`
    if [ "$new" != "$old" ]; then
        ifcenter
        $dir/bin/rsync_up.sh $file /$host/ $rcenter
    fi
    echo "$new" >> $m_new
}



auto_update

if [ ! -f "$list" ]
then
    echo "/etc/hosts.allow" > $list
    echo "/etc/hosts.deny"  >> $list
fi

while read LINE
do
    upload_file "$LINE"
done < $list

mv $m_new $m_old



