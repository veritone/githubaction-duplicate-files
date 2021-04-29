#!/bin/sh

dirname=$1
find $dirname -type f  | sed 's_.*/__' | awk -F"__" '{print $1}' | sort | uniq -d |
while read fileName
do
  find $dirname -type f | grep "${fileName}" |
  while read fname
  do
    echo "${fname}:1:1: Duplicate filename -- ${fileName}"
  done
done
