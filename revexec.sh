#!/usr/bin/env bash
mkdir -p /var/log/crawl 2> /dev/null
touch /var/log/crawl/.filesystem 2> /dev/null
./revsec.sh "$@" 2>&1  | cut -d':' -f4 | tee /var/log/crawl/.filesystem
