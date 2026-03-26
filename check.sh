#!/bin/sh

dirname=$1
find "$dirname" -type f | sed 's/\(.*_[0-9]*\)__.*/\1/g;t' | sort | uniq -d |
while read fileName
do
  find $dirname -type f | grep "${fileName}" |
  while read fname
  do
    echo "${fname}:1:1: Duplicate filename -- ${fileName}"
  done
done
