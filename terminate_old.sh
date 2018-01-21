#!/bin/bash
STATUS=1
while [ $STATUS -eq 1 ]; do
#    echo $STATUS
    sleep 5
    STATUS=$(pgrep run.sh | wc -l)
done

