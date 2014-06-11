#!/bin/bash

# Crawl internal file system for changes.
# Usage:
# make the scripts executable: chmod +x rev*sh
# set the $target after the exec script like this to catalog /tmp
# ./revexec.sh /tmp
# Then visit /var/low/crawl for your data.

# Import the "strip" from my CryptoCore .bashrc but as stripdown

stripdown () {
tr -d '\040\011\012\015'
}

mkdir /var/log/crawl 2> /dev/null
mkdir /var/log/crawl/low 2> /dev/null
chown 755 /var/log/crawl/low
diffdir=$(pwd | cut -f2-999)

DATESTAMP=$(date | stripdown )
cd /
chmod 777 /var/log/crawl/*

function larthdiff {
diffdir=$(pwd | cut -c2-999)
difffile="data""$DATESTAMP"
echo /var/log/crawl/low"$diffdir" | xargs mkdir -p
touch /var/log/crawl/low"$diffdir"/"$difffile".larth.prev
touch /var/log/crawl/low"$diffdir"/"$difffile".larth
cp /var/log/crawl/low"$diffdir"/"$difffile".larth /var/log/crawl/low"$diffdir"/"$difffile".larth.prev
touch /var/log/crawl/low"$diffdir"/"$difffile".larth
date >> /var/log/crawl/low"$diffdir"/"$difffile".larth
ls -larth >> /var/log/crawl/low"$diffdir"/"$difffile".larth
diff /var/log/crawl/low"$diffdir"/"$difffile".larth /var/log/crawl/low"$diffdir"/"$difffile".larth.prev > /var/log/crawl/low"$diffdir"/"$difffile"."$DATESTAMP"diff
cat /var/log/crawl/low"$diffdir"/"$difffile"."$DATESTAMP"diff >> /var/log/crawldiff.log
}

function lsdirs {
touch /var/log/crawl/low"$diffdir"/"$difffile".ls
date >> /var/log/crawl/low"$diffdir"/"$difffile".ls
ls > /var/log/crawl/low"$diffdir"/"$difffile".ls
}
larthdiff
lsdirs

# Crawl the system in a loop.

function runit {
    larthdiff;
    lsdirs;
}

# Clean up.
cp /dev/null /var/log/crawl/.pwd
# Main loop.
for target in "$@"; do
find "$target"  >> /var/log/crawl/.pwd
runit
done

for y in $(cat /var/log/crawl/.pwd); do
    cd /"$y"
    runit 
done
