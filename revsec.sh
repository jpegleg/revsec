#!/bin/bash

# Crawl internal file system for changes.

mkdir -p /var/log/crawl/low 2> /dev/null
touch /var/log/crawl/.pwd

diffdir=$(pwd | cut -f2-999)

DATESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
cd /
larthdiff() {
    diffdir=$(pwd | cut -c2-999)
    mkdir -p /var/log/crawl/low"$diffdir" 
    touch /var/log/crawl/low"$diffdir"/data.larth.prev
    touch /var/log/crawl/low"$diffdir"/data.larth
    ls -larth > /var/log/crawl/low"$diffdir"/data.larth
    diff /var/log/crawl/low"$diffdir"/data.larth /var/log/crawl/low"$diffdir"/data.larth.prev > /var/log/crawl/low"$diffdir"/data."$DATESTAMP".diff &&
    yes | cp /var/log/crawl/low"$diffdir"/data.larth /var/log/crawl/low"$diffdir"/data.larth.prev
    echo "$diffdir" >> /var/log/crawldiff.log;
    date >> /var/log/crawldiff.log;
    cat /var/log/crawl/low"$diffdir"/data."$DATESTAMP".diff >> /var/log/crawldiff.log
}

larthdiff

# Crawl the system in a loop.

# Clean up.
cp /dev/null /var/log/crawl/.pwd
# Main loop.
for target in "$@"; do
    find "$target"  >> /var/log/crawl/.pwd
    larthdiff
done

for rdir in $(cat /var/log/crawl/.pwd); do
    cd /"$rdir"
    larthdiff
done
