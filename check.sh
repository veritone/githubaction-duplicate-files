#!/bin/sh

INPUT_DIRECTORY=$1
INPUT_FILE_FIND_PATTERN=${2:-"*.sql"}

echo Scanning ${INPUT_DIRECTORY}

find "${INPUT_DIRECTORY}" -type f -name "${INPUT_FILE_FIND_PATTERN}" | sed 's!.*/!!' | sed 's/\(.*_[0-9]*\)__.*/\1/g;t' | sort | uniq -d |
while read prefix
do
  find "${INPUT_DIRECTORY}" -type f -name "${INPUT_FILE_FIND_PATTERN}" | grep "${prefix}" |
  while read fileName
  do
    echo "${fileName}:1:1: Duplicate filename -- ${prefix}"
  done
done

find ${INPUT_DIRECTORY} -type f -name "\"${INPUT_FILE_FIND_PATTERN}\"" | sed 's_.*/__' | awk -F"__" '{print $1}' | sort | grep '\.' |
while read fileName
do
  echo "${fileName}: Invalid version format" >> .dupe.out
done
