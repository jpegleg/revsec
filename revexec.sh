/revsec.sh "$@" 2>&1  | cut -d':' -f4 | tee /var/log/crawl/.filesystem
