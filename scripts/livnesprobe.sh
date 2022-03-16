#!/bin/bash
if [[ ! -e old_head.txt  ]]; then
  curl localhost:9090/metrics | grep '^sqd_archive_processed_events' | awk '{print $2}' > old_head.txt
  result=1
else
  current=$(curl localhost:9090/metrics | grep '^sqd_archive_processed_events' | awk '{print $2}')
  result=$current-$(cat old_head.txt)
  echo "$current" > old_head.txt
fi
if [[ $result -gt 0 ]]; then
  exit 0
else
  echo "Head block of not changed after previous start"
  exit 1
fi
