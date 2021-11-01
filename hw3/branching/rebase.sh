#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "Next param: $param"
    count=$(( $count + 1 ))
done

echo "====="
