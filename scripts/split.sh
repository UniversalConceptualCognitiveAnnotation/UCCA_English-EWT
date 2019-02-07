#!/bin/bash

for div in train dev test; do
  subdirs="ud/$div sentences/$div"
  rm -rf $subdirs
  mkdir -p $subdirs
  grep 'doc id.*reviews' UD_English-EWT/en_ewt-ud-$div.conllu | sed 's/.*-//' |
    while read docid; do
      compgen -G "sentences/$docid*.pickle" |
        while read sentfile; do
          sentfile=${sentfile#*/}
          cd sentences/$div
          ln -s ../$sentfile ./
          cd ../../ud/$div
          ln -s ../${sentfile%.*}.conllu ./
          cd ../..
        done || exit 1
    done || exit 1
  for subdir in $subdirs; do
    echo -ne "$subdir\t"
    ls $subdir | wc -l
  done
done

