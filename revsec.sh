#!/bin/bash

# Crawl internal file system for changes.



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
echo /var/log/crawl/low"$diffdir" | xargs mkdir -p
touch /var/log/crawl/low"$diffdir"/data.larth.prev
touch /var/log/crawl/low"$diffdir"/data.larth
ls -larth > /var/log/crawl/low"$diffdir"/data.larth
diff /var/log/crawl/low"$diffdir"/data.larth /var/log/crawl/low"$diffdir"/data.larth.prev > /var/log/crawl/low"$diffdir"/data."$DATESTAMP".diff &&
yes | cp /var/log/crawl/low"$diffdir"/data.larth /var/log/crawl/low"$diffdir"/data.larth.prev
echo "$diffdir" >> /var/log/crawldiff.log;
date >> /var/log/crawldiff.log;
cat /var/log/crawl/low"$diffdir"/data."$DATESTAMP".diff >> /var/log/crawldiff.log
}

function lsdirs {
touch /var/log/crawl/low"$diffdir"/data.ls
date > /var/log/crawl/low"$diffdir"/data.ls
ls > /var/log/crawl/low"$diffdir"/data.ls
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
