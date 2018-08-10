#!/bin/bash

git clone https://github.com/UniversalDependencies/UD_English-EWT --branch=r2.2
pip install -U semstr udapi

# Extract all UD-annotated docs for which we also have UCCA annotations
ls xml | sed 's/\..*/$/' | grep -f- streusle2ucca.txt | awk '/./{print "reviews-"$1}' | xargs python -m semstr.scripts.split UD_English-EWT/*.conllu -o ud --doc-ids

# Rename UD files and in-file IDs to match UCCA IDs
TOTAL=`cat streusle2ucca.txt | wc -l`
i=0
while read -r ud_id ucca_id; do
  [ -n "$ud_id" ] || continue
  if compgen -G "ud/reviews-$ud_id.reviews-$ud_id*" > /dev/null; then
    i=$((i+1))
    echo $i/$TOTAL $ud_id "->" $ucca_id
    perl -i -lpe "s/reviews-$ud_id-(\d+)/'$ucca_id'.sprintf('%03d',\$1-1)/e" ud/reviews-$ud_id.reviews-$ud_id*
    rename "s/reviews-$ud_id.reviews-$ud_id-(\d+)/'$ucca_id'.sprintf('%03d',\$1-1)/e" ud/reviews-$ud_id.reviews-$ud_id*
  else
    echo $ud_id $ucca_id >> missing.txt
  fi
done <streusle2ucca.txt

# Split the UCCA passages to sentences exactly like the UD documents are split
sed 's/SpaceAfter=No/_/;/^# text = /d' ud/*.conllu | udapy write.Sentences > ud.txt
python -m scripts.standard_to_sentences xml --sentences ud.txt -o sentences_by_ud -b

